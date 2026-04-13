---
title: "에이전트 트레이싱 — 복잡한 멀티스텝 오류를 추적하는 법"
date: 2026-04-14
draft: false
tags: ["AI 에이전트", "Observability", "트레이싱", "LangSmith", "에이전트디버깅", "분산시스템"]
description: "여러 단계의 생각을 거치는 AI 에이전트가 중간에 왜 길을 잃었는지 어떻게 알 수 있을까요? 분산 시스템의 트레이싱 기법을 에이전트에 도입하여 '추론의 미로'를 시각화하고 디버깅하는 법을 배웁니다."
author: "Henry"
categories: ["에이전트 신뢰성"]
series: ["에이전트 신뢰성 시리즈"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A complex neon maze representation of an AI's thought process. A glowing thread (the trace) is woven through the maze, pinpointing exactly where an error occurred with a red pulse. Dark technical aesthetic #0d1117, teal and magenta accents, 16:9"
    file: "images/A/agent-distributed-tracing-hero.png"
  - position: "diagram"
    prompt: "Trace waterfall diagram: Root Span (User Question) -> Span 1 (Planning) -> Span 2 (Tool Call: Search) -> Span 3 (Reasoning: Fail). Each span showing time and tokens. 16:9"
    file: "images/A/agent-trace-waterfall.png"
---

이 글은 **에이전트 신뢰성 시리즈** 6편입니다.
→ 5편: [AI 에이전트의 무한 루프 — 비용 폭탄 방지 설계](/ko/study/A_agent-reliability/agent-infinite-loop-prevention)

---

AI 에이전트 개발 중 가장 고통스러운 순간은 사용자가 "답변이 이상해요"라고 할 때입니다. 

단순한 챗봇이라면 프롬프트만 보면 됩니다. 하지만 에이전트는 다릅니다.
1. 질문을 분석하고 (Step 1)
2. 검색 쿼리를 만들고 (Step 2)
3. 외부 도구를 호출하고 (Step 3)
4. 그 결과를 다시 분석해서 (Step 4)...

이 10단계의 과정 중 어디서 AI의 '첫 단추'가 잘못 끼워졌는지 찾는 것은 모래사장에서 바늘 찾기보다 어렵습니다. 오늘은 이 문제를 해결하기 위해 필수적인 **에이전트 트레이싱(Agent Tracing)** 기법을 다룹니다.

---

### 에이전트는 분산 시스템이다

전통적인 소프트웨어 공학에서 여러 서버를 거치는 요청을 추적할 때 `Trace ID`와 `Span ID`를 사용합니다. 에이전트도 똑같습니다. 한 번의 사용자 질문이 수많은 LLM 호출과 API 호출(Spans)로 쪼개지기 때문입니다.

우리는 각 단계마다 다음 세 가지를 반드시 기록해야 합니다.
1. **Input/Output**: 무엇을 받고 무엇을 내뱉었나?
2. **Metadata**: 어떤 모델을 썼고, 토큰은 얼마나 썼나?
3. **Execution Context**: 당시 에이전트의 '기분(프롬프트 버전)'과 '기억(메모리)' 상태는 어떠했나?

---

### 트레이싱 로그 설계하기

단순한 `print()`로는 부족합니다. 계층 구조가 있는 로그가 필요합니다.

```python
# Trace 구조 예시 (JSON)
{
  "trace_id": "966b33f8",
  "spans": [
    {
      "name": "Planner",
      "status": "SUCCESS",
      "input": "로봇 연구 논문 요약해줘",
      "output": "Action: Search_Arxiv(query='robotics research')"
    },
    {
      "name": "Tool: Search_Arxiv",
      "parent": "Planner",
      "status": "ERROR",
      "error_message": "Rate limit exceeded"
    }
  ]
}
```

이렇게 기록하면 "아, 도구 호출에서 에러가 났고, 그것 때문에 뒤의 단계들이 꼬였구나!"라고 즉시 진단할 수 있습니다.

---

### 추천 도구: LangSmith와 Arize Phoenix

이걸 직접 구현하기엔 인생이 너무 짧습니다. 오픈소스 및 상용 도구들을 활용하세요.

1. **LangSmith**: LangChain을 쓴다면 필수입니다. 추론 과정을 멋진 트리 구조로 시각화해 줍니다.
2. **Arize Phoenix**: 오픈소스 모델 관찰 플랫폼입니다. 로컬에서도 쉽게 돌릴 수 있으며, OpenTelemetry 표준을 지원합니다.
3. **Brainglue**: 에이전트의 '생각의 흐름'을 시각화하는 데 특화된 신생 툴입니다.

---

### Henry의 팁: "실패한 Trace를 테스트 케이스로 바꿔라"

트레이싱의 진짜 가치는 디버깅에만 있지 않습니다.
- 에러가 발생한 지점의 **Input**과 당시의 **Prompt**를 그대로 복사하세요.
- 이를 **평가 데이터셋(Eval Dataset)**에 추가하세요.
- 프롬프트를 수정한 후, 이 특정 '실패 사례'만 다시 통과하는지 확인하는 **회귀 테스트(Regression Test)**를 자동화하세요.

---

### 결론

트레이싱이 없는 에이전트는 블랙박스입니다. 하지만 트레이싱을 갖춘 에이전트는 투명한 유리 상자입니다. 복잡한 멀티스텝 에이전트를 프로덕션에 올릴 계획이라면, 첫 번째 코드를 짜기 전에 **'어떻게 들여다볼 것인가'**를 먼저 결정하세요.

---

**다음 글:** [Human-in-the-Loop의 진짜 구현법 — 단순 승인 버튼이 아니다](/ko/study/A_agent-reliability/human-in-the-loop-design)
