---
title: "Human-in-the-Loop의 진짜 구현법 — 단순 승인 버튼이 아니다"
date: 2026-04-14
draft: false
tags: ["AI 에이전트", "HITL", "Human-in-the-loop", "에이전트 설계", "UX", "에이전트 신뢰성"]
description: "AI 에이전트에게 중대한 결정을 맡길 때 단순히 '승인하시겠습니까?'라는 버튼만 만드는 것은 부족합니다. 에이전트가 사람과 협력하여 신뢰를 쌓는 4가지 HITL 설계 패턴을 소개합니다."
author: "Henry"
categories: ["에이전트 신뢰성"]
series: ["에이전트 신뢰성 시리즈"]
series_order: 7
images_needed:
  - position: "hero"
    prompt: "A human hand and a robotic hand co-signing a digital document. Multiple floating UI panels show 'Plan Review' and 'Outcome Simulation'. High-tech aesthetic, dark mode #0d1117, clean interface design, 16:9"
    file: "images/A/human-in-the-loop-design-hero.png"
  - position: "patterns"
    prompt: "Grid of 4 patterns: 1. Approval (Checkmark), 2. Correction (Edit icon), 3. Clarification (Question mark), 4. Simulation (Crystal ball). Labeled in Korean. 16:9"
    file: "images/A/hitl-patterns-grid.png"
---

이 글은 **에이전트 신뢰성 시리즈** 7편입니다.
→ 6편: [에이전트 트레이싱 — 복잡한 멀티스텝 오류를 추적하는 법](/ko/study/A_agent-reliability/agent-distributed-tracing)

---

AI 에이전트가 "백업 데이터를 전부 삭제할까요?"라고 물었을 때, 여러분은 [예/아니오] 버튼 하나만으로 안심할 수 있나요?

대부분의 HITL(Human-in-the-Loop) 구현은 단순히 실행 직전에 멈춰 서서 승인을 기다리는 '체크포인트' 역할에 그칩니다. 하지만 진짜 HITL은 AI와 사람이 지식을 공유하고, 오류를 공동으로 수정하며, 최종 결과에 대해 상호 신뢰를 쌓는 과정이어야 합니다.

오늘은 에이전트의 완성도를 결정짓는 4가지 HITL 설계 패턴을 분석해 봅니다.

---

### 패턴 1: 계획 승인 (Plan Review)
에이전트가 도구를 호출하기 전에, 자신의 **'전략'**을 먼저 브리핑하게 하는 것입니다.

- **나쁜 예**: "예매해드릴까요?" [승인]
- **좋은 예**: "총 3단계를 거칩니다. 1) 잔여 좌석 확인, 2) 7만원 이하 티켓 선별, 3) 회사 카드로 결제. 이 전략으로 진행할까요?"

사용자는 AI가 '어떻게' 생각하는지를 보고 신뢰를 결정할 수 있습니다.

---

### 패턴 2: 부분 수정 및 가이드 (Active Correction)
승인 혹은 거절이라는 이분법을 넘어, 사용자가 에이전트의 생각을 **'중간에 수정'**할 수 있게 하는 패턴입니다.

에이전트가 제안한 계획 중 2번 단계가 맘에 들지 않는다면, 사용자가 "2번은 법인카드 대신 내 개인카드로 해줘"라고 수정하고 다시 실행하게 합니다. AI 에이전트 프레임워크인 **LangGraph**의 'Checkpointer' 기능이 이를 위해 존재합니다.

---

### 패턴 3: 불확실성 기반 질문 (Threshold-based Intervention)
에이전트가 항상 물어보는 게 아니라, 스스로 **'자신감(Confidence)'**이 낮을 때만 물어보게 하는 지능형 HITL입니다.

- **로직**: `if agent_confidence < 0.8: trigger_hitl_request()`
- **효과**: 사용자는 AI가 정말 헷갈려 하는 중요한 순간에만 개입하면 되므로 피로도가 줄어듭니다.

---

### 패턴 4: 결과 시뮬레이션 (Outcome Simulation)
결정을 내리기 전에 "만약 이렇게 된다면(What-if)"의 결과를 미리 보여주는 것입니다.

"이 스크립트를 실행하면 서버 3대의 데이터가 삭제되고 50GB의 여유 공간이 확보됩니다. 실행하시겠습니까?" 

단순히 명령어를 보여주는 대신, **예상되는 변화(Side Effects)**를 요약해 보여주는 것이 사고를 막는 핵심입니다.

---

### Henry의 구현 제안: HITL은 '인터럽트'가 아니다

많은 개발자가 HITL을 `input()` 함수와 같은 '흐름 중단'으로 처리합니다. 하지만 현대적인 에이전트 아키텍처에서는 **'상태 저장소(State Store)'**에 현재 상태를 저장하고 에이전트 프로세스를 종료(Wait)한 뒤, 사용자의 입력이 오면 다시 깨어나는(Resume) 비동기 방식으로 설계해야 합니다.

```python
# LangGraph Style HITL
def call_tool_step(state):
    if state["requires_approval"]:
        return "human_review_node" # 여기서 상태가 저장되고 대기함
    return "execute_node"
```

---

### 결론

HITL은 AI의 자율성을 억압하는 장치가 아니라, **AI가 더 큰 권한을 가질 수 있게 해주는 안전벨트**입니다. 사용자가 에이전트의 손을 잡고 함께 걷는다는 느낌을 줄 때, 기술은 비로소 실전에서 쓰일 수 있습니다.

---

**다음 글:** [멀티 에이전트 충돌 — 두 에이전트가 같은 DB를 동시에 수정할 때](/ko/study/A_agent-reliability/multi-agent-conflict)
