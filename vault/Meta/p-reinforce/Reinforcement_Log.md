---
title: Reinforcement Log (Raw Memory)
updated: 2026-04-15
tags: [p-reinforce, memory, raw-data]
---

# 📥 사용자 피드백 로그 (Manual Feedback)

> AI가 작업한 결과에 대해 사용자가 직접 남긴 피드백입니다.
> `p_reinforce_analyzer.py`가 이 파일을 읽고 규칙 패턴을 도출하여 `Reinforcement_Insights.md`에 기록합니다.

## 작성 규칙
- 형식: `- [도메인] [신호]: [피드백 내용]`
- 도메인: `Research`(연구, 코딩) 또는 `Life`(블로그, 콘텐츠)
- 신호: `Reward`(보상, 잘한 점) 또는 `Punish`(처벌, 잘못된 점)

---
### 📝 피드백 기록 시작

- [Research] Reward: 로봇 모터 제어 코드 작성 시, 하드코딩된 값 대신 설정 파일(config)을 사용하도록 설계한 점이 유연하고 좋았음.
- [Life] Punish: 네이버 블로그 자동화 포스트에서 "결론적으로 말씀드리자면" 등 AI 특유의 인위적인 번역투 문장을 사용하여 사람이 쓴 글 같지 않았음. 삭제 요망.
