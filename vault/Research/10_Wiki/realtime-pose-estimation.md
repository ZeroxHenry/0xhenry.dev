---
title: Realtime Pose Estimation
created: 2026-04-13
updated: 2026-04-15
sources: []
tags: [pose-estimation, zed-camera, yolo, tensorrt, jetson, perception, pipeline]
summary: ZED X Mini + YOLO26s-lower6 6kpt TRT FP16 실시간 포즈 추정. 16.4ms/61fps(verify), 17ms/60fps(pipeline) 달성.
confidence_score: 0.95
---

# [[Realtime Pose Estimation]]

## 시스템 구성

| 항목 | 스펙 |
|------|------|
| 카메라 | ZED X Mini (S/N 52277959), SVGA 960x600, 120fps, Global Shutter |
| 모델 | yolo26s-lower6-v2 (6 keypoints: hip/knee/ankle 좌우) |
| 추론 | TensorRT FP16, imgsz=640, DirectTRT (Ultralytics 우회) |
| 플랫폼 | Jetson Orin NX 16GB, MAXN + jetson_clocks, GPU 918MHz |
| 통신 | POSIX SHM → C++ 100Hz → Teensy USB serial |

## 최종 성능 (2026-04-15)

### verify_geometry (인식 검증)
```
no-display, DirectTRT:
  fetch      0.0ms  (PipelinedCamera)
  predict   13.7ms  (DirectTRT GPU output 파싱)
  2d_to_3d   2.0ms  (C++ 확장)
  총        16.4ms = 61fps
```

### pipeline_main (제어용)
```
no-display, DirectTRT, Safety/KF 제거:
  fetch      5.7ms  (PipelinedCamera — release 타이밍 문제)
  predict    9.3ms
  depth_3d   2.1ms
  shm        0.5ms
  총        17.7ms = 56fps
  → release 즉시 호출 버전 push 완료 (미테스트, 예상 ~15ms)
```

### 성능 변화 히스토리
```
33.4ms (30fps) → 이전 (동기, Ultralytics, 640)
24.3ms (41fps) → PipelinedCamera + 동기 depth
21.6ms (46fps) → DirectTRT + BGRA pass-through
20.2ms (50fps) → DirectTRT + 3D EMA
16.4ms (61fps) → --no-display (verify_geometry 최종)
17.7ms (56fps) → pipeline_main (Safety/KF 제거, sleep 제거)
~15ms  (67fps) → pipeline release 즉시 호출 (미테스트)
```

---

## 오늘 한 것 (2026-04-15 전체)

### 성공한 최적화

| # | 최적화 | 이전 | 이후 | 효과 |
|---|--------|------|------|------|
| 1 | PipelinedCamera (Double Buffer + Event) | fetch 9.4ms | fetch 0.0ms | grab을 predict 뒤에 숨김 |
| 2 | DirectTRT (Ultralytics 우회) | predict 16ms | predict 13ms | torch GPU 전처리 + GPU output 파싱 |
| 3 | GPU output 파싱 | 7200개 CPU 복사 | 18개만 CPU 복사 | -2ms |
| 4 | BGRA raw 전달 | BGR 변환 2회 | BGRA→RGB 1회 | 색변환 1회 절약 |
| 5 | C++ 후처리 빌드 (postprocess_accel) | Python 10ms | C++ 2ms | pybind11 |
| 6 | Safety/KF 제거 (pipeline_main) | 22ms | 17ms | C++가 제어 담당 |
| 7 | sleep 제거 (pipeline_main) | rate limiting | 최대 속도 | C++가 타이밍 담당 |
| 8 | ONNX→TRT 자동 빌드 | 수동 | .direct.engine 자동 | 버전 불일치 해결 |
| 9 | detection 실패 시 fallback | 끊김 | 이전 프레임 유지 | prev_kpts_2d |
| 10 | Sagittal plane 시각화 | 없음 | Y-Z 측면뷰 창 | 별도 cv2 window |
| 11 | 3D EMA smoothing | raw (떨림) | alpha=0.8 | depth 떨림 감소 |
| 12 | BONE_RANGES 완화 | thigh 0.33-0.52 | 0.25-0.55 | 불필요 OUT OF RANGE 감소 |
| 13 | 캘리브 중 E_STOP 방지 | E_STOP 즉시 발동 | 캘리브 중 리셋 | 닭/달걀 문제 해결 |

### 실패한 것 + 원인

| # | 시도 | 결과 | 원인 |
|---|------|------|------|
| 1 | AsyncCamera (기존) | segfault | ZED SDK thread-unsafe: grab+get_depth 동시 호출 |
| 2 | AsyncCamera + _zed_lock | depth 10ms→17ms | lock contention: main이 depth 가져올 때 grab 대기 |
| 3 | AsyncCamera (capture_depth=True) | predict 21→25ms | GPU 경합: grab depth + TRT 동시 |
| 4 | SegmentLengthConstraint | Joints 0/6 | 피드백 루프: 왼쪽 캘리브 부족→ref 9px→keypoint 강제 이동→고착 |
| 5 | One Euro Filter (모델 내부, smoothing=1.0) | Joints 0/6 | 워밍업 중 필터 초기화→잘못된 위치 고착 |
| 6 | One Euro Filter (외부 적용) | Joints 0/6 | 2D keypoint 이동→이동 위치에서 depth=NaN→3D 실패 |
| 7 | EMA on 2D keypoints (smoothing=0.3~0.5) | Joints 0/6 | 동일: 2D 이동→depth NaN |
| 8 | zero-copy (copy=False) | 불안정 | ZED 버퍼 직접 참조→다음 grab에서 덮어씌워짐 |
| 9 | get_3d_coords() | 뼈 길이 122m | camera intrinsics 미연동→pixel 좌표가 3D로 직접 |
| 10 | cv2.cuda | 비활성화 (0 devices) | JetPack OpenCV가 CUDA 없이 빌드됨 |
| 11 | imgsz 480 ONNX→640 TRT | 빌드 실패 | ONNX 입력이 480 고정→640 profile 불일치 |
| 12 | 관절 각도 setattr smoothing | AttributeError | left_knee_angle이 @property라 setattr 불가 |

### 핵심 교훈 (확정)

1. **2D keypoint를 건드리면 depth가 깨진다** — smoothing은 반드시 3D 좌표 또는 최종 출력에 적용
2. **ZED SDK는 thread-unsafe** — grab/retrieve 동시 호출 시 segfault. Event 동기화 필수
3. **GPU 경합 vs fetch 절약 트레이드오프** — 경합(+5ms) < fetch 절약(-9ms) = 파이프라인이 이득
4. **sleep이 파이프라인을 방해** — Python sleep이 grab overlap 시간을 낭비. 제거해야 함
5. **Ultralytics 우회 효과는 제한적** — torch upload 오버헤드 존재 (13ms vs 16ms, 3ms 절약)
6. **C++이 RT 타이밍 담당** — Python GC/sleep 지터로 정시성 보장 불가. C++ clock_nanosleep 사용
7. **ONNX→엔진 빌드는 imgsz 고정** — imgsz 변경 시 해당 크기 ONNX를 먼저 export해야 함

---

## Teensy 연결 (2026-04-15)

### 완료
- PlatformIO 설치 (Jetson)
- Teensy 4.1 펌웨어 빌드 + 업로드 성공 (readLoadcell→readLoadcellForceN 수정)
- /dev/ttyACM0 확인
- C++ main_control_loop 빌드 성공 (goto scope 수정)
- SHM 통신 확인: F_total 값 출력됨

### 미완료
- pipeline_main.py release 즉시 호출 버전 테스트
- C++ 제어 루프 장시간 안정성 확인
- Teensy에서 실제 모터 구동 확인

---

## 현재 아키텍처

```
ZED X Mini (SVGA@120fps, PERFORMANCE depth)
  │
  ├── PipelinedCamera (Double Buffer + Event)
  │     캡처 스레드: grab → get_rgb(BGRA) → get_depth → get_gravity → ready
  │     main: get(rgb,depth,gravity) → release() 즉시 → predict 시작
  │     다음 grab이 predict와 파이프라인 (GPU 경합 허용)
  │
  ├── DirectTRT (trt_pose_engine.py)
  │     torch GPU: BGRA→RGB + resize + normalize + letterbox
  │     TRT: execute_async_v3 (사전 바인딩 버퍼)
  │     GPU output 파싱: top-1 conf만 CPU 복사 (18개)
  │
  ├── batch_2d_to_3d (C++ 확장)
  │     + 3D EMA smoothing (alpha=0.8)
  │
  ├── compute_joint_state → SHM (/hwalker_pose, 36 bytes)
  │
  └── C++ main_control_loop (100Hz, clock_nanosleep)
        SHM read → GaitReference → ImpedanceController → ILC
        → SerialComm → /dev/ttyACM0 → Teensy 4.1 (111Hz)
```

## 파일 구조

```
h-walker-ws/src/hw_perception/
  benchmarks/
    trt_pose_engine.py      -- DirectTRT + GPU output 파싱 + get_3d_coords
    zed_camera.py           -- ZEDCamera, PipelinedCamera, GPUPreprocessor
    pose_models.py          -- LowerBodyPoseModel (Ultralytics 경유)
    postprocess_accel.py    -- C++ 확장 래퍼
    cpp_ext/                -- pybind11 후처리 모듈
  realtime/
    verify_geometry.py      -- 인식 검증 + sagittal view
    pipeline_main.py        -- 제어용 (Safety/KF 제거, 최소화)
    joint_3d.py             -- JointState3D, BONE_RANGES
    calibration.py          -- StandingCalibration, ZEDIMUWorldFrame
    shm_publisher.py        -- POSIX SHM
  models/
    yolo26s-lower6-v2.pt / .onnx / .engine
    yolo26s-lower6-v2-640.direct.engine

h-walker-ws/src/hw_control/cpp/
  src/main_control_loop.cpp -- 100Hz 제어 + CSV 로깅
  include/
    pose_shm.h              -- SHM 레이아웃 (36 bytes)
    shm_reader.hpp          -- POSIX SHM 읽기
    impedance_controller.hpp
    ilc_controller.hpp
    serial_comm.hpp         -- Teensy USB serial

h-walker-ws/firmware/
  src/Treadmill_main.ino    -- Teensy 4.1 펌웨어
```

## 내일 할 것

1. **pipeline release 즉시 호출 테스트** — fetch 6ms→0ms 확인
2. **C++ 제어 루프 + Teensy 장시간 안정성 확인**
3. **실제 모터 구동 테스트** (impedance only, ILC 없이)
4. **Sagittal view 확인**
5. **학습 데이터 보강 계획** (swing phase, occlusion)

## 미해결 이슈

1. **One Euro Filter 적용 불가** — 2D keypoint 이동 시 depth NaN. 3D/각도 레벨에서만 가능
2. **한쪽 다리 가림 시 인식 실패** — 학습 데이터 부족
3. **cv2.cuda 비활성화** — OpenCV CUDA 빌드 필요
4. **PERFORMANCE depth deprecated** — ZED SDK가 NEURAL 권장
5. **fetch 6ms 잔존** (pipeline) — release 즉시 호출로 해결 예정 (미테스트)

## Knowledge Connections
- **Related:** [[h-walker]], [[gait-analysis]], [[jetson-orin-nx]], [[zed-x-mini]], [[teensy-4-1]]
- **Paper:** Vision-Based Impedance Control (RA-L)

---
*Last updated: 2026-04-15*
