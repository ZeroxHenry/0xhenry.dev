---
title: Skiro Learnings — 해결된 문제 + 미해결 CRITICAL
created: 2026-04-15
updated: 2026-04-15
tags: [skiro, h-walker, exosuit, hardware, safety, pose-estimation]
summary: skiro에서 기록된 교훈들. 하드웨어 파손, 제어 로직, 포즈 추정 관련.
---

# Skiro Learnings

## 해결된 문제

### MIT 모드 토크 제어 이해
- **문제:** 오차 → 토크 → F_desired 변환이 헷갈림
- **해결:** MIT 모드: `τ = KP*(p_des-p) + KD*(v_des-v) + T_ff`
  - 순수 토크: KP=0, KD=0.1, T_ff=원하는값
  - 어드미턴스 출력: p_des에 연결, KP=30~50, KD=0.5~1.0
  - 토크를 직접 계산할 필요 없음

### 보드 파손 원인 (회생 에너지)
- **문제:** Hip/Knee angle이 동일 3점(hip, knee, ankle)에서 나옴 → 보드 파손
- **해결:** 4모터 동시 회생 1J → 버스 캐패시터 부족 시 V=143V 폭주
  - 대책: 11,280μF 벌크 + 26.5V 제동저항 + ISO1050 격리 CAN

### YOLO 왼쪽 하체 인식 불량
- **문제:** yolo26s-lower6-v2 모델 left_hip→left_knee 9px vs right 31px
- **원인:** SegmentConstraint 피드백 루프 의심
- **해결:** cd ~/RealTime_Pose_Estimation 에서 모델 재훈련/조정

### 파이프라인 인식 오류
- **문제:** pipeline_main 실행 중 에러 발생
- **해결:** SegmentConstraint OFF + smoothing OFF + AsyncCamera 제거 → 동기 모드로 인식 정상화
  - pipeline_main.py 캘리브 중 safety guard 리셋으로 E_STOP 방지

---

## 미해결 CRITICAL

### AP62200WU 전압 초과
- **문제:** VIN 최대 24V인데 6S LiPo 완충 25.2V → 정격 초과
- **해결 방향:** AP63205WU-7로 교체 필요

### INA333 + 로드셀 전압 불일치
- **문제:** INA333(3.3V 단전원) + 5V 여기 로드셀 → VCM=2.5V가 허용 2.1V 초과
- **결과:** 측정 불가

### ADS1234 전원 부족
- **문제:** AVDD 최소 4.75V 요구인데 3.3V 공급 계획 → ADC 미동작

### 카메라 배치
- **문제:** 워커에서 하지가 다 보이도록 하는 높이 + 아래로 틸트 필요
- **상태:** 정확한 높이/각도 미결정

---

## Related
- [[h-walker]]
- [[exosuit-safety]]
- [[ak60-motor]]
- [[realtime-pose-estimation]]
- [[can-communication]]
