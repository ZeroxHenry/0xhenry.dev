---
title: "Realtime Pose Estimation: ZED X Mini와 TensorRT로 16ms(61fps) 파이프라인 구축하기"
date: 2026-04-15
draft: false
tags: ["pose-estimation", "zed-camera", "yolo", "tensorrt", "jetson", "robotics"]
description: "ZED X Mini 카메라와 Jetson Orin NX를 사용하여 하드웨어 제어용 실시간 자세 추정 파이프라인을 구축한 과정을 상세히 기록합니다. PipelinedCamera, DirectTRT 등 16ms(61fps) 달성을 위한 최적화 기법을 포함합니다."
author: "Henry"
categories: ["Robotics & Edge AI"]
series: ["Exosuit 하드웨어 개발기"]
series_order: 3
---

로보틱스, 특히 외골격 로봇(Exosuit)이나 보행 보조 로봇에서 '인지-판단-제어' 루프의 지연시간(Latency)은 시스템의 안정성과 직결됩니다. 이번 글에서는 **[ZED X Mini 카메라](/ko/study/hw/zed-x-mini-jetson-setup)와 YOLO 모델, 그리고 TensorRT를 활용하여 16ms(61fps)의 초저지연 실시간 포즈 추정 파이프라인을 구축한 과정**을 공유합니다.

![실험실에서의 연구 개발 모습 — 우리의 시도는 멈추지 않는다](../../images/realtime-pose-estimation/Lab.jpg)

---

## 1. 시스템 구성 요약

실시간 제어를 위해 고성능 엣지 컴퓨팅 디바이스와 통신 인터페이스를 다음과 같이 구성했습니다.

| 항목 | 스펙 |
|------|------|
| **카메라** | ZED X Mini (S/N 52277959), SVGA 960x600, 120fps, Global Shutter |
| **모델** | `yolo26s-lower6-v2` (6 keypoints: hip/knee/ankle 좌우 하체 특화) |
| **추론 엔진** | TensorRT FP16, imgsz=640, **DirectTRT** (Ultralytics 우회, 자체 구현) |
| **플랫폼** | Jetson Orin NX 16GB, MAXN 모드 + `jetson_clocks`, GPU 918MHz 고정 |
| **통신 아키텍처** | Python ↔ C++ 간 POSIX SHM (공유 메모리) → C++ 100Hz 루프 → Teensy USB serial |

---

## 2. 최종 성능 및 프로파일링 결과 (2026-04-15 기준)

반복적인 최적화 끝에, 제어용 파이프라인에서 **15~17ms**의 총 지연시간을 달성했습니다.

### verify_geometry (인식 검증용, 61fps)
비전 전용 검증 스크립트(`--no-display`, DirectTRT 사용) 실행 시:
- `fetch`: **0.0ms** (PipelinedCamera 도입으로 grab을 predict 뒤에 숨김)
- `predict`: **13.7ms** (DirectTRT 버퍼 바인딩 및 GPU output 파싱)
- `2d_to_3d`: **2.0ms** (C++ 확장 후처리)
- **총합: 16.4ms = 61fps**

### pipeline_main (오프라인 제어용, 56fps)
실제 제어 루프와 결합된 메인 파이프라인(Safety/Kalman Filter는 제어부로 이관):
- `fetch`: **5.7ms** (release 타이밍 최적화 이전)
- `predict`: **9.3ms**
- `depth_3d`: **2.1ms**
- `shm`: **0.5ms** (공유 메모리 쓰기)
- **총합: 17.7ms = 56fps**
*(현재 `release()` 즉시 호출 버전을 푸시했으며, 적용 시 약 ~15ms(67fps) 달성 예상)*

### 극한 최적화 히스토리
- **33.4ms (30fps)** → 초기 버전 (순차 동기화, Ultralytics 프레임워크 그대로 사용)
- **24.3ms (41fps)** → PipelinedCamera 패턴 도입
- **21.6ms (46fps)** → DirectTRT + BGRA pass-through 색변환 최적화
- **20.2ms (50fps)** → DirectTRT + 3D EMA 스무딩 추가
- **16.4ms (61fps)** → `verify_geometry` 렌더링 끄기 최종 버전 달성

---

![파이프라인 병목 해결 및 프레임 렌더링 과정](../../images/realtime-pose-estimation/Main.jpg)

## 3. 지연시간 16ms를 만든 7가지 성공적 최적화

이번 최적화의 핵심은 **"Python의 오버헤드를 우회하고, GPU 스케줄링을 겹치게(Overlap) 만드는 것"**이었습니다.

### ① PipelinedCamera (Double Buffer + Event)
카메라 이미지 그랩(`fetch` 9.4ms) 시간을 `0.0ms`로 줄였습니다. 비동기 캡처 스레드가 `grab → BGRA 추출 → 뎁스 추출`을 수행하여 버퍼에 담아두고, 메인 스레드는 `predict` 연산이 도는 동안 다음 프레임을 미리 가져오게 만들었습니다.

### ② DirectTRT (Ultralytics 우회)
Ultralytics 패키지의 무거운 전/후처리를 걷어냈습니다. `execute_async_v3`를 통해 사전 바인딩된 버퍼에 텐서를 밀어넣고(16ms → 13ms), GPU output을 CPU로 복사할 때 **7200개 전체를 복사하는 대신 Top-1 confidence 값만 18개 복사**하여 2ms를 추가로 아꼈습니다.

### ③ BGRA Raw 전달 (색변환 1회 절약)
ZED 카메라는 기본적으로 BGRA를 뱉습니다. 기존엔 `BGRA → BGR → RGB`로 변환했지만, TRT 전처리 단의 CUDA 커널에서 한 번에 `BGRA → RGB` 리사이즈/정규화를 수행하도록 변경했습니다.

### ④ C++ 후처리 빌드 (pybind11)
2D 픽셀 좌표를 3D 공간 좌표로 매핑하는 코드는 Python 루프에서 10ms가 걸렸습니다. 이를 C++ 확장 모듈(`postprocess_accel.py` 래퍼)로 만들어 **2ms**로 줄였습니다.

### ⑤ 제어 루프(C++)로 책임 이관
Safety Limit 검사나 Kalman/One-Euro 필터링 같은 무거운 로직을 Python 비전 코드에서 전부 제거했습니다. Python의 Garbage Collection이나 `sleep()` 지터 때문에 실시간성을 보장할 수 없으므로, 100Hz로 도는 C++ 제어 코드(`clock_nanosleep` 사용)가 이 책임을 지게 했습니다.

### ⑥ 3D EMA Smoothing 도입
처음엔 2D 픽셀 레벨에 필터(EMA나 One-Euro)를 적용했습니다. 하지만 2D 픽셀을 강제로 부드럽게 이동시키면, 그 이동된 픽셀 위치의 뎁스맵 값이 `NaN`이 되거나 객체 경계선을 벗어나는 치명적 문제(Depth 파괴 현상)가 발생했습니다. 이를 깨닫고 스무딩은 **반드시 3D 변환이 끝난 결과 좌표계**에 적용하도록 구조(3D EMA alpha=0.8)를 바꿨습니다.

### ⑦ ZED SDK의 Thread-Safety 문제 우회
`AsyncCamera`를 시도하다 계속 Segmentation Fault가 났습니다. 원인은 ZED SDK가 내부적으로 thread-unsafe해서, 한 스레드에서 `grab`하는 도중 다른 스레드에서 `get_depth`를 부르면 크래시가 났기 때문입니다. Event 객체로 동기화를 강제하여 해결했습니다.

---

![로봇의 전체적인 하드웨어 설계 — 여기서부터 비전 처리가 시작된다](../../images/realtime-pose-estimation/Whole-Body.jpg)

## 4. 로봇 제어를 위한 전체 아키텍처

우리의 최종 시스템 구조입니다:

```text
ZED X Mini (SVGA@120fps, PERFORMANCE depth)
  │
  ├── 1. PipelinedCamera (Double Buffer + Event 방어막)
  │     - 캡처 스레드: grab → get_rgb(BGRA) → get_depth → ready
  │     - 제어 스레드: get(버퍼) → release() 즉시 호출 → GPU predict 시작
  │
  ├── 2. DirectTRT (trt_pose_engine.py)
  │     - Torch GPU: BGRA→RGB + resize + normalize를 한 방에
  │     - TensorRT: execute_async_v3로 백그라운드 추론
  │     - Parsing: GPU에서 CPU로 Top-1 데이터만 아주 얇게 복사
  │
  ├── 3. batch_2d_to_3d (C++ 확장 Pybind11)
  │     - 2D 픽셀 → 3D 공간 매핑 + 3D EMA 스무딩 (알파 0.8)
  │
  ├── 4. POSIX SHM (Shared Memory)
  │     - Python이 36바이트의 /hwalker_pose 바이너리 데이터 기록
  │
  └── 5. C++ main_control_loop (100Hz 락스텝 보장)
        - SHM 읽기 → 보행 레퍼런스 생성 → ImpedanceController 
        - SerialComm → /dev/ttyACM0 번개 통신 → Teensy 4.1 구동 (111Hz)
```

---

## 5. 결론 및 향후 계획

Python과 GPU를 쓰면서 16ms에 도달하는 건 쉽지 않았습니다. 특히 제일 뼈아팠던 교훈은 **"비전 파이프라인에서 Python의 sleep이나 rate limiting을 쓰면 GPU 오버랩 스케줄링을 다 망친다"**는 사실이었습니다. 파이프라인은 멈추지 않고 데이터를 밀어내고, 타이밍 제어는 철저하게 실시간 OS 레벨 언어(C++)에 맡겨야 합니다.

![성과 달성 후 가벼워진 마음 — 최적화의 묘미](../../images/realtime-pose-estimation/Expression.jpg)

**다음 단계 과제:**
1. 제어단 C++ 루프와 Teensy 하드웨어 간의 장시간(수 시간) 안정성 검증.
2. 실제 ILC(Iterative Learning Control) 없이 임피던스 제어만으로 모터(AK60-6) 구동 테스트.
3. 걷는 도중 한쪽 다리가 완전히 가려졌을 때(Occlusion)의 추론 안정성을 위한 데이터 증강 훈련.

제어 주기 확보를 위해 피말리게 프레임 속도를 깎아나갔던 삽질의 영광을 이 글에 바칩니다.
_ZED SDK 5.2 셋업 과정은 [이전 글](/ko/study/hw/zed-x-mini-jetson-setup)을 참고하세요._
