---
title: Realtime Pose Estimation
created: 2026-04-13
updated: 2026-04-15
sources: []
tags: [pose-estimation, zed-camera, yolo, tensorrt, jetson, perception]
summary: ZED X Mini + YOLO26s-lower6 6kpt TRT FP16 실시간 포즈 추정. Jetson Orin NX에서 16ms/61fps 달성.
confidence_score: 0.9
---

# [[Realtime Pose Estimation]]

## 시스템 구성

| 항목 | 스펙 |
|------|------|
| 카메라 | ZED X Mini (S/N 52277959), SVGA 960x600, 120fps, Global Shutter |
| 모델 | yolo26s-lower6-v2 (6 keypoints: hip/knee/ankle 좌우) |
| 추론 | TensorRT FP16, imgsz=640 |
| 플랫폼 | Jetson Orin NX 16GB, MAXN + jetson_clocks |
| GPU | 918MHz, 4 TPC |

## 최종 성능 (2026-04-15)

```
[PROFILE] 120프레임 평균 (총 16.4ms/frame, no-display):
  fetch           0.0ms  (PipelinedCamera)
  predict        13.7ms  (DirectTRT)
  2d_to_3d        2.0ms  (C++ 확장)
  imu             0.1ms
  joint_state     0.5ms
= 61fps (no-display), 46fps (with display)
```

## 최적화 히스토리

### 성공한 최적화

| 최적화 | 이전 | 이후 | 효과 |
|--------|------|------|------|
| 17kpt -> 6kpt 커스텀 모델 | 44ms | 16.6ms | Pose Head 65% 축소 |
| TRT FP16 | PyTorch 56ms | TRT 20ms | 2.8배 |
| PipelinedCamera (Double Buffer) | fetch 9.4ms | fetch 0.0ms | grab을 predict 뒤에 숨김 |
| DirectTRT (Ultralytics 우회) | predict 16ms | predict 13ms | GPU output 파싱, torch 전처리 |
| BGRA raw 전달 | BGR 변환 2회 | BGRA->RGB 1회 | 색변환 1회 절약 |
| GPU 버퍼 사전 할당 | 매 프레임 malloc | 재사용 | 할당 오버헤드 제거 |
| C++ 후처리 빌드 | Python 폴백 10ms | C++ 2ms | postprocess_accel |
| depth 순서 변경 | predict 전 | predict 후 | GPU 경합 최소화 |

### 실패한 것들 + 원인

| 시도 | 결과 | 원인 |
|------|------|------|
| **AsyncCamera (기존)** | segfault 크래시 | ZED SDK thread-unsafe: grab + get_depth 동시 호출 |
| **AsyncCamera + _zed_lock** | 2d_to_3d 10ms -> 17ms | lock contention: main이 depth 가져올 때 grab 대기 |
| **AsyncCamera(capture_depth=True)** | predict 21->25ms | GPU 경합: grab depth 계산 + TRT 동시 실행 |
| **SegmentLengthConstraint** | Joints 0/6 | 피드백 루프: 왼쪽 캘리브 부족 -> ref_length 9px -> keypoint 강제 이동 -> 고착 |
| **One Euro Filter (모델 내부)** | Joints 0/6 | 워밍업 중 필터 초기화 -> 잘못된 위치로 고착 |
| **One Euro Filter (외부 적용)** | Joints 0/6 | 2D keypoint 이동 -> 이동된 위치에서 depth=NaN -> 3D 변환 실패 |
| **EMA on 2D keypoints** | Joints 0/6 (같은 원인) | 2D 위치 변경 -> depth NaN -> 3D 실패 |
| **zero-copy (copy=False)** | 불안정 | ZED 내부 버퍼 직접 참조 -> 다음 grab에서 덮어씌워질 위험 |
| **get_3d_coords()** | 뼈 길이 122m | camera intrinsics 미연동 -> pixel 좌표가 3D로 직접 들어감 |
| **cv2.cuda** | 비활성화 | JetPack 기본 OpenCV가 CUDA 없이 빌드됨 |
| **imgsz 480** | 정확도 부족 | thigh OUT OF RANGE 빈번 |

### 핵심 교훈

1. **2D keypoint를 건드리면 depth가 깨진다** - smoothing은 반드시 3D 좌표 또는 관절 각도에 적용
2. **ZED SDK는 thread-unsafe** - grab/retrieve를 여러 스레드에서 동시 호출하면 segfault
3. **PipelinedCamera의 핵심**: grab과 predict를 겹치되, depth를 predict 후 순차 호출 (release 패턴)
4. **Ultralytics 우회 효과는 제한적** - CPU 전처리 제거해도 torch upload 오버헤드 존재 (13ms vs 16ms)
5. **GPU 경합은 양날의 검** - AsyncCamera로 fetch 아끼지만 predict가 느려져서 순이득 제로

## 현재 아키텍처

```
ZED X Mini (SVGA@120fps, PERFORMANCE depth)
  |
  +-- PipelinedCamera (Double Buffer + Event)
  |     캡처 스레드: grab() -> get_rgb(copy=True, raw_bgra=True) -> ready.set()
  |     main: get() -> predict -> get_depth() -> release()
  |
  +-- DirectTRT (trt_pose_engine.py)
  |     torch GPU: BGRA->RGB + resize + normalize + letterbox
  |     TRT: execute_async_v3 (사전 바인딩 버퍼)
  |     GPU output 파싱: top-1 conf만 CPU 복사 (18개 값)
  |
  +-- batch_2d_to_3d (C++ 확장)
  |     6개 keypoint 2D -> depth lookup -> 3D 변환
  |
  +-- compute_joint_state
  |     knee_flexion, thigh_inclination 계산
  |     3D EMA smoothing (alpha=0.8)
  |
  +-- Sagittal View (Y-Z plane 스틱 피겨)
```

## 파일 구조

```
h-walker-ws/src/hw_perception/
  benchmarks/
    trt_pose_engine.py    -- DirectTRT: Ultralytics 우회, GPU 전처리
    zed_camera.py         -- ZEDCamera, PipelinedCamera, GPUPreprocessor
    pose_models.py        -- LowerBodyPoseModel (Ultralytics 경유)
    postprocess_accel.py  -- C++ 확장 래퍼 (batch_2d_to_3d)
    cpp_ext/              -- C++ pybind11 후처리 모듈
  realtime/
    verify_geometry.py    -- 인식 검증 + sagittal view
    pipeline_main.py      -- 제어용 파이프라인 (KF + SHM)
    joint_3d.py           -- JointState3D, compute_joint_state
    calibration.py        -- StandingCalibration, ZEDIMUWorldFrame
    safety_guard.py       -- DepthSafetyGuard (E_STOP)
    shm_publisher.py      -- POSIX SHM -> Teensy
  models/
    yolo26s-lower6-v2.pt / .onnx / .engine
    yolo26s-lower6-v2-640.direct.engine  -- DirectTRT용
```

## 미해결 이슈

1. **One Euro Filter 적용 불가** - 2D keypoint 이동 시 depth NaN 문제. 3D/각도 레벨에서 적용 필요
2. **한쪽 다리 가림 시 인식 실패** - 학습 데이터에 occlusion 케이스 부족
3. **thigh 길이 간헐적 OUT OF RANGE** - hip keypoint 위치 불안정 (depth 노이즈)
4. **PERFORMANCE depth mode deprecated** - ZED SDK가 NEURAL 권장. GPU 부하 증가 우려

## 다음 단계

1. Teensy 연결: PlatformIO -> 펌웨어 업로드 -> SHM -> serial
2. pipeline_main.py에 DirectTRT + PipelinedCamera 적용
3. 학습 데이터 보강 (swing phase, occlusion)
4. OpenCV CUDA 빌드 (cv2.cuda 활성화)

## Knowledge Connections
- **Related:** [[h-walker]], [[gait-analysis]], [[jetson-orin-nx]], [[zed-x-mini]], [[teensy-4-1]]
- **Paper:** Vision-Based Impedance Control (RA-L)

---
*Last updated: 2026-04-15*
