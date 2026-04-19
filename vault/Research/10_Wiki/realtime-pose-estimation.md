---
title: Realtime Pose Estimation
created: 2026-04-13
updated: 2026-04-19
tags: [pose-estimation, zed-camera, yolo, tensorrt, jetson, perception, h-walker]
summary: ZED X Mini + YOLO26s-lower6 6kpt TRT FP16. 30fps → 61fps 최적화 완료. Teensy 연결 성공.
confidence_score: 0.95
---

# Realtime Pose Estimation — 종합 정리

## 최종 성능

| 모드 | 총 시간 | FPS | 용도 |
|------|---------|-----|------|
| verify_geometry --direct-trt --no-display | **16.4ms** | **61fps** | 인식 검증 |
| verify_geometry --direct-trt | 20.2ms | 50fps | 시각화 포함 |
| pipeline_main --no-display | 17.7ms | 56fps | 제어용 |

---

## 시스템 구성

| 항목 | 스펙 |
|------|------|
| 카메라 | ZED X Mini (S/N 52277959) |
| 해상도 | SVGA 960x600, 120fps, Global Shutter |
| 모델 | yolo26s-lower6-v2 (6 keypoints) |
| 추론 | TensorRT FP16, imgsz=640 |
| 플랫폼 | Jetson Orin NX 16GB, MAXN + jetson_clocks |
| 통신 | POSIX SHM → C++ 100Hz → Teensy USB serial |

### 6 Keypoints
- left_hip, right_hip
- left_knee, right_knee
- left_ankle, right_ankle

---

## 데이터 흐름

```
ZED X Mini (120fps)
  ↓
PipelinedCamera (Double Buffer + Event)
  캡처: grab → get_rgb(BGRA) → get_depth → get_gravity
  ↓
DirectTRT (Ultralytics 우회)
  torch GPU: BGRA→RGB + resize + normalize + letterbox
  TRT: execute_async_v3 (사전 바인딩 버퍼)
  GPU output 파싱: top-1 conf만 CPU 복사 (18개)
  ↓
batch_2d_to_3d (C++ 확장, pybind11)
  6 keypoints × depth → 3D 좌표
  3D EMA smoothing (alpha=0.8)
  ↓
compute_joint_state
  knee_flexion + thigh_inclination 계산
  ↓
SHM (/dev/shm/hwalker_pose, 36 bytes)
  ↓
C++ main_control_loop (100Hz, clock_nanosleep)
  SHM read → GaitReference → ImpedanceController → ILC
  → SerialComm → /dev/ttyACM0
  ↓
Teensy 4.1 (111Hz) → CAN → AK60 모터
```

---

## 성공한 최적화 (13가지)

| # | 최적화 | 이전 → 이후 | 효과 |
|---|--------|-----------|------|
| 1 | PipelinedCamera | fetch 9.4ms → 0.0ms | grab을 predict 뒤에 숨김 |
| 2 | DirectTRT | predict 16ms → 13ms | torch GPU 전처리 |
| 3 | GPU output 파싱 | 7200개 → 18개 CPU 복사 | -2ms |
| 4 | BGRA raw 전달 | BGR 변환 2회 → 1회 | 색변환 절약 |
| 5 | C++ 후처리 | Python 10ms → C++ 2ms | pybind11 |
| 6 | Safety/KF 제거 | 22ms → 17ms | C++가 제어 담당 |
| 7 | sleep 제거 | rate limit → 최대 속도 | 파이프라인 유지 |
| 8 | ONNX→TRT 자동 빌드 | 수동 → 자동 | 버전 불일치 해결 |
| 9 | detection 실패 fallback | 끊김 → 이전 프레임 | prev_kpts_2d |
| 10 | Sagittal plane 시각화 | 없음 → Y-Z 측면뷰 | 별도 cv2 window |
| 11 | 3D EMA smoothing | raw → alpha=0.8 | depth 떨림 감소 |
| 12 | BONE_RANGES 완화 | 0.33-0.52 → 0.25-0.55 | OUT OF RANGE 감소 |
| 13 | 캘리브 중 E_STOP 방지 | 즉시 발동 → 리셋 | 닭/달걀 해결 |

---

## 실패한 것 + 원인 (12가지)

| # | 시도 | 원인 |
|---|------|------|
| 1 | AsyncCamera (초기) | ZED SDK thread-unsafe → segfault |
| 2 | AsyncCamera + _zed_lock | lock contention → depth 17ms |
| 3 | capture_depth=True | GPU 경합 → predict +5ms |
| 4 | SegmentLengthConstraint | 피드백 루프 → 왼쪽 keypoint 고착 |
| 5 | One Euro Filter (모델 내부) | 워밍업 고착 → Joints 0/6 |
| 6 | One Euro Filter (외부) | 2D 이동 → depth NaN → 0/6 |
| 7 | EMA on 2D keypoints | 2D 이동 → depth NaN → 0/6 |
| 8 | zero-copy (copy=False) | ZED 버퍼 덮어씌워짐 |
| 9 | get_3d_coords() | camera intrinsics 없음 → pixel을 3D로 |
| 10 | cv2.cuda | JetPack OpenCV가 CUDA 없이 빌드 |
| 11 | imgsz 480 ONNX → 640 TRT | 입력 shape 고정 불일치 |
| 12 | setattr joint_angle | @property라 setattr 불가 |

---

## 핵심 교훈 (7가지)

1. **2D keypoint를 건드리면 depth가 깨진다** — smoothing은 3D/각도에만 적용
2. **ZED SDK는 thread-unsafe** — Event 동기화 필수
3. **GPU 경합 vs fetch 절약** — 경합(+5ms) < fetch 절약(-9ms) = 파이프라인 이득
4. **sleep이 파이프라인을 방해** — Python sleep 제거, C++가 타이밍 담당
5. **Ultralytics 우회 효과 제한적** — torch upload 오버헤드로 3ms만 절약
6. **C++이 RT 타이밍 담당** — Python GC/sleep 지터로 정시성 불가
7. **ONNX→엔진 imgsz 고정** — imgsz 변경 시 ONNX 재export 필요

---

## 미해결 이슈

| 이슈 | 해결 방향 |
|------|----------|
| One Euro Filter 적용 불가 | 3D/각도 레벨에서만 가능 |
| 한쪽 다리 가림 시 인식 실패 | 학습 데이터 보강 (swing phase, occlusion) |
| thigh 길이 간헐적 OUT OF RANGE | depth 노이즈 — patch sampling 강화 |
| cv2.cuda 비활성화 | OpenCV CUDA 빌드 (30분+) |
| PERFORMANCE depth deprecated | NEURAL 시도 후 GPU 부하 확인 |
| pipeline fetch 6ms 잔존 | sync 모드 전환 또는 release 타이밍 개선 |

---

## 파일 구조

```
h-walker-ws/src/hw_perception/
├── benchmarks/
│   ├── trt_pose_engine.py       ★ DirectTRT 핵심
│   ├── zed_camera.py            ★ PipelinedCamera
│   ├── pose_models.py           (Ultralytics 경유)
│   ├── postprocess_accel.py     (C++ 확장 래퍼)
│   └── cpp_ext/                 (pybind11)
├── realtime/
│   ├── verify_geometry.py       ★ 인식 검증 + sagittal
│   ├── pipeline_main.py         ★ 제어용
│   ├── joint_3d.py              (BONE_RANGES)
│   ├── calibration.py           (StandingCalibration)
│   └── shm_publisher.py         (POSIX SHM)
└── models/
    ├── yolo26s-lower6-v2.pt/.onnx/.engine
    └── yolo26s-lower6-v2-640.direct.engine  ★ DirectTRT용

h-walker-ws/src/hw_control/cpp/
├── src/main_control_loop.cpp    ★ 100Hz 제어
└── include/
    ├── pose_shm.h               (SHM 36 bytes)
    ├── shm_reader.hpp
    ├── impedance_controller.hpp
    ├── ilc_controller.hpp
    └── serial_comm.hpp

h-walker-ws/firmware/
└── src/Treadmill_main.ino       ★ Teensy 4.1 펌웨어
```

---

## 실행 방법

### 사전 설정 (Jetson 최초 1회)
```bash
# C++ 후처리 모듈 빌드
cd ~/h-walker-ws/src/hw_perception/benchmarks/cpp_ext
pip3 install pybind11
python3 setup.py build_ext --inplace
cp pose_postprocess_cpp*.so ../

# PlatformIO + Teensy UDEV
pip3 install platformio
export PATH="$HOME/.local/bin:$PATH"
sudo curl -o /etc/udev/rules.d/00-teensy.rules https://www.pjrc.com/teensy/00-teensy.rules
sudo udevadm control --reload-rules

# Teensy 펌웨어
cd ~/h-walker-ws/firmware
pio run -t upload

# C++ 제어 루프
cd ~/h-walker-ws/src/hw_control/cpp
cmake -B build && cmake --build build
```

### 실행
```bash
# 터미널 1: Python 파이프라인
cd ~/h-walker-ws/src/hw_perception/realtime
python3 pipeline_main.py --no-display

# 터미널 2: C++ 제어 + Teensy
cd ~/h-walker-ws/src/hw_control/cpp
./build/hw_control_loop /dev/ttyACM0

# 검증만: verify_geometry
python3 verify_geometry.py --direct-trt --no-display
```

---

## 데이터 저장

| 위치 | 용도 |
|------|------|
| `/dev/shm/hwalker_pose` | Python → C++ SHM (36 bytes) |
| `hw_control_loop.csv` | C++ 100Hz 로그 (Jetson 디스크) |

CSV 컬럼: time, gait_phase, 관절각도, reference, force, Teensy feedback

---

## Teensy 연결 상태

### 완료
- ✅ PlatformIO 설치
- ✅ Teensy 4.1 펌웨어 빌드+업로드
- ✅ /dev/ttyACM0 확인
- ✅ UDEV 규칙 설치
- ✅ C++ main_control_loop 빌드
- ✅ SHM 통신 확인 (F_total 정상 출력)

### 미완료
- ⏸ pipeline release 즉시 호출 효과 검증
- ⏸ C++ 장시간 안정성
- ⏸ 실제 모터 구동 테스트
- ⏸ 3D 좌표 SHM 구조 확장

---

## 다음 스텝

1. **pipeline fetch 6ms 해결** — sync 모드 전환 실험
2. **SHM 구조 확장** — 3D 좌표 72 bytes 추가 (총 108 bytes)
3. **모터 안전 테스트** — Kp 낮게, impedance only
4. **Sagittal 데이터 로깅** — CSV에 3D 좌표 저장
5. **학습 데이터 보강** — swing phase, occlusion 케이스

---

## 성능 변화 히스토리

```
33.4ms (30fps) → 시작 (동기, Ultralytics, 640, Safety+KF+sleep)
24.3ms (41fps) → PipelinedCamera + 동기 depth
21.6ms (46fps) → DirectTRT + BGRA pass-through
20.2ms (50fps) → DirectTRT + 3D EMA
16.4ms (61fps) → --no-display (verify 최종)
17.7ms (56fps) → pipeline (Safety/KF 제거)
```

---

## Knowledge Connections

- [[h-walker]] — 전체 시스템
- [[gait-analysis]] — 보행 분석
- [[jetson-orin-nx]] — 하드웨어 플랫폼
- [[zed-x-mini]] — 카메라
- [[teensy-4-1]] — 펌웨어 플랫폼

**관련 논문:** Paper 1 - Vision-Based Impedance Control (RA-L)

---

*마지막 업데이트: 2026-04-19*
