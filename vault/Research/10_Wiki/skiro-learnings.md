---
title: Skiro Learnings
created: 2026-04-15
updated: 2026-04-15
tags: [skiro, h-walker, exosuit, hardware, safety, control, pose-estimation]
summary: 로봇 개발 문제-해결 교훈. Single Source of Truth. skiro-vault-sync로 자동 생성.
---

# Skiro Learnings

> 자동 생성: `skiro-vault-sync` (2026-04-15)
> 원본: `~/.skiro/learnings.jsonl` (14 entries)


## Hardware

### [CRITICAL] AP62200WU VIN 최대 24V, 6S LiPo 완충 25.2V → 정격 초과, AP63205WU-7로 교체 필요
- **상태:** 미해결
- **컨텍스트:** 2026-04-12 stm_board 보드 설계 검토

### [CRITICAL] INA333(3.3V 단전원) + 5V 여기 로드셀 조합 → VCM=2.5V가 허용 2.1V 초과, 측정 불가
- **상태:** 미해결
- **컨텍스트:** 2026-04-12 stm_board 아날로그 신호 체인 검토

### [CRITICAL] ADS1234 AVDD 최소 4.75V 요구인데 3.3V 공급 계획 → ADC 미동작
- **상태:** 미해결
- **컨텍스트:** 2026-04-12 stm_board 아날로그 신호 체인 검토


## Safety

### [CRITICAL] hw_perception/realtime/pipeline_main
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [SOLVED] Hip angle과 Knee angle은 동일한 3점(hip, knee, ankle)에서 나옵니다
- **해결:** 외골격 보드 파손 원인: 4모터 동시 회생 1J → 버스 캐패시터 부족 시 V=143V 폭주. 대책: 11,280μF 벌크 + 26.5V 제동저항 + ISO1050 격리 CAN
- **해결일:** 2026-04-12


## Control

### [WARNING] Kd가 필요한 상황이 되면 (실험에서 진동 발생 시) 그때 유한차분으로
- **상태:** 미해결
- **컨텍스트:** 2026-04-11 hook-prompt

### [WARNING] 오늘 작업을 하다가 skiro learnings가 작동한 것 같은데 이게 나는 앞으로 계속해서 외부 뇌를 가져와서 하는 식으로 하는 게 맞는 것
- **상태:** 미해결
- **컨텍스트:** 2026-04-15 hook-prompt

### [SOLVED] error 발생했는데  도중에 일단 꺼져서 이거는 내일 이어서 해보자
- **해결:** SegmentConstraint OFF + smoothing OFF + AsyncCamera 제거 → 동기 모드로 인식 정상화. pipeline_main.py 캘리브 중 safety guard 리셋으로 E_STOP 방지
- **해결일:** 2026-04-14


## Software

### [WARNING] fetch    10ms (grab 동기 대기) 여기속도 줄이게 해주고
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [SOLVED] yolo26s-lower6-v2 모델 왼쪽 하체 keypoint 인식 불량 — left_hip→left_knee 9px vs right 31px
- **해결:** cd ~/RealTime_Pose_Estimation
- **해결일:** 2026-04-14


## Process

### [WARNING] obsidian에 모두 정리해서 이거 앞으로 두 번 다시 말하게 하지마
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [WARNING] 1) 지금 현재 제일 안되는 건 이전의 내역들을 기억을 못한다는 거야
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [WARNING] 수정: GPU에서 직접 torch tensor로 변환하면 왕복 제거 좋다 그렇게 나도 복붙 + 중복 이런 건 제일 싫어
- **상태:** 미해결
- **컨텍스트:** 2026-04-14 hook-prompt

### [SOLVED] 오차 -> 토크 -> F_desired로 가는 거를 정확하게 이해가 안돼 우리는 그냥 Force 를 때려버리잖아 기존의 시스템에서는 말이야
- **해결:** MIT 모드: τ = KP*(p_des-p) + KD*(v_des-v) + T_ff. 순수 토크는 KP=0, KD=0.1, T_ff=원하는값. 어드미턴스 출력은 p_des에 연결하고 KP=30~50, KD=0.5~1.0. 토크를 직접 계산할 필요 없음
- **해결일:** 2026-04-12

---

## Related
- [[h-walker]]
- [[exosuit-safety]]
- [[ak60-motor]]
- [[realtime-pose-estimation]]
- [[can-communication]]
- [[admittance-control]]
