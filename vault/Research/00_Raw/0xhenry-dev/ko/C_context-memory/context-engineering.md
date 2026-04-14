---
title: "프롬프트 엔지니어링은 죽었다 — Context Engineering이 AI의 새 패러다임인 이유"
date: 2026-04-13
draft: false
tags: ["Context Engineering", "LLM", "AI아키텍처", "프롬프트엔지니어링", "2026트렌드"]
description: "2026년, AI 엔지니어링의 패러다임이 바뀌었습니다. '어떻게 물어볼까'를 고민하던 시대는 끝났고, '무엇을 보여줄까'를 설계하는 시대가 왔습니다. Context Engineering이 무엇인지, 왜 지금 당장 알아야 하는지 설명합니다."
author: "Henry"
categories: ["AI 엔지니어링"]
---

저는 GPT-4o를 프로덕션 환경에서 약 4개월 동안 운영한 적이 있습니다. 그러다 이상한 걸 발견했습니다.

시스템 초반에는 AI가 꽤 잘 답변했습니다. 그런데 대화가 길어지면 길어질수록 — 그러니까 컨텍스트가 쌓이면 쌓일수록 — AI가 **오히려 더 멍청해지고** 있었습니다. 질문에 엉뚱한 대답을 하거나, 앞서 말한 내용을 무시하거나, 가이드라인을 슬쩍 어기기 시작했어요.

처음엔 프롬프트 문제라고 생각했습니다. 며칠 동안 문장을 다듬고, 순서를 바꾸고, 예시를 추가했습니다. 하지만 별 효과가 없었습니다.

원인은 프롬프트가 아니었습니다. 문제는 **컨텍스트**(Context) 자체였습니다.

---

### 프롬프트 엔지니어링의 한계

2023~2024년, "프롬프트 엔지니어링"은 가장 핫한 기술이었습니다. AI에게 더 똑똑하게 질문하는 법을 익히면 더 좋은 답을 얻을 수 있다고 했죠. 실제로 효과도 있었습니다.

하지만 2026년인 지금, 이 접근법에는 근본적인 한계가 있다는 게 드러났습니다.

프롬프트 엔지니어링은 **"AI에게 무엇을 말할까"**를 고민합니다. 반면 실제 프로덕션 AI 시스템의 실패 원인 대부분은 말하는 방식이 아니라 **"AI가 무엇을 보고 있느냐"**에서 비롯됩니다.

AI의 답변 품질을 결정하는 건 지시문(prompt)이 아니라, 그 AI가 그 순간 처리하는 **전체 정보의 질과 구조**입니다.

---

### Context Engineering이란 무엇인가?

**Context Engineering**은 LLM이 추론하는 순간 "보게 되는" 전체 정보 환경을 체계적으로 설계하는 기술입니다.

Anthropic의 정의를 빌리면:

> "The practice of curating, structuring, and managing the entire set of data — instructions, history, retrieved documents, tool outputs, and user metadata — that the model sees during inference."

쉽게 말해, 좋은 비유가 있습니다.

> **LLM이 CPU라면, Context Window는 RAM입니다.**

당신은 이제 단순히 질문을 쓰는 사람이 아닙니다. **AI가 사용할 RAM의 내용물을 설계하는 운영 체제**가 되어야 합니다.

---

### Context Rot: 컨텍스트가 길어지면 AI가 멍청해지는 이유

연구자들이 "Lost in the Middle"이라고 부르는 현상이 있습니다.

LLM은 입력 데이터의 **앞부분**과 **끝부분**에 집중하는 경향이 있습니다. 중간에 있는 정보는 상대적으로 무시됩니다. 컨텍스트 윈도우가 1백만 토큰으로 늘어났다고 해서 이 문제가 사라지지 않습니다.

오히려 더 심해집니다.

컨텍스트를 쌓아두는 것 자체가 문제가 됩니다. 오래된 대화 이력, 불필요한 도구 설명, 중복된 지시문이 컨텍스트를 오염시킵니다. 저는 이걸 **Context Rot(컨텍스트 썩음 현상)**이라고 부릅니다.

```
[잘못된 방식]
System Prompt (2,000 tokens)
+ 지난 20턴 대화 이력 (8,000 tokens)
+ 검색된 문서 10개 전문 (15,000 tokens)
+ 도구 설명 전체 (3,000 tokens)
= 28,000 tokens → AI 성능 저하 시작
```

```
[Context Engineering 방식]
System Prompt (압축, 500 tokens)
+ 최근 3턴 대화 이력 (요약 포함, 1,200 tokens)
+ 이 질문에 관련된 문서 2개만 선별 (3,000 tokens)
+ 이 작업에 필요한 도구 2개만 (400 tokens)
= 5,100 tokens → 정확도, 속도 모두 향상
```

---

### Context Engineering의 핵심 기법 4가지

#### 1. 동적 컨텍스트 조립 (Dynamic Assembly)

매 LLM 호출 전에 컨텍스트를 **새로 조립**합니다. 정적인 시스템 프롬프트에 모든 것을 넣어두는 방식은 이제 구식입니다.

```python
def build_context(user_query: str, conversation_history: list) -> str:
    # 이 쿼리에 관련된 문서만 검색
    relevant_docs = retriever.search(user_query, top_k=2)
    
    # 대화 이력은 최근 3턴만 + 나머지는 요약으로 압축
    compressed_history = compress_history(conversation_history, keep_last=3)
    
    # 이 작업에 필요한 도구만 선택 (전체 도구 목록 X)
    relevant_tools = tool_router.select(user_query)
    
    return assemble_prompt(
        instructions=CORE_INSTRUCTIONS,  # 핵심 지시 최소화
        history=compressed_history,
        docs=relevant_docs,
        tools=relevant_tools
    )
```

#### 2. 컨텍스트 압축 (Context Compression)

대화 이력이 길어지면, 오래된 부분을 요약으로 대체합니다.

```python
def compress_history(history: list, keep_last: int = 3) -> dict:
    if len(history) <= keep_last:
        return {"recent": history, "summary": None}
    
    old_turns = history[:-keep_last]
    recent_turns = history[-keep_last:]
    
    # 오래된 대화를 LLM으로 요약
    summary = summarizer.run(old_turns)
    
    return {
        "summary": summary,  # "사용자는 결제 오류를 문의했고, 환불 처리가 완료됨"
        "recent": recent_turns
    }
```

#### 3. 도구 라우팅 (Tool Routing)

모든 도구 설명을 항상 컨텍스트에 넣지 마세요. 쿼리를 분석하여 **이 작업에 필요한 도구만** 골라줍니다.

```python
# 나쁜 방식: 50개 도구 설명을 항상 포함
context = f"{ALL_50_TOOLS_DESCRIPTION}\n\nUser: {query}"

# 좋은 방식: 관련 도구 2-3개만 선택
relevant_tools = tool_router.classify_and_select(query, max_tools=3)
context = f"{relevant_tools}\n\nUser: {query}"
```

#### 4. 컨텍스트 격리 (Context Isolation)

멀티 에이전트 시스템에서는 에이전트별로 컨텍스트를 **격리**합니다. 한 에이전트의 오염된 컨텍스트가 다른 에이전트로 전파되는 것을 막습니다.

```python
# 검색 에이전트와 작성 에이전트의 컨텍스트를 분리
search_agent_context = ContextWindow(max_tokens=4000)  # 검색 결과만
writer_agent_context = ContextWindow(max_tokens=8000)  # 구조화된 정보만

# 두 컨텍스트는 절대 직접 병합하지 않음
# 대신 검색 에이전트의 "요약 결과"만 작성 에이전트에게 전달
```

---

### 프롬프트 엔지니어링 vs Context Engineering

| 항목 | 프롬프트 엔지니어링 | Context Engineering |
|------|-------------------|---------------------|
| **관심사** | 지시문 작성 방식 | 전체 정보 환경 설계 |
| **범위** | 단일 호출 최적화 | 시스템 수준 아키텍처 |
| **효과** | 단편적 개선 | 시스템 전반 안정성 향상 |
| **난이도** | 낮음 | 높음 (아키텍처 사고 필요) |
| **2026년 가치** | 기본 소양 수준 | 핵심 엔지니어링 역량 |

---

### 결론: 이제 무엇을 준비해야 하는가?

2026년 AI 엔지니어링에서는 "프롬프트를 잘 쓰는 사람"이 아니라, **"AI가 최적의 판단을 내릴 수 있도록 정보 환경을 설계하는 사람"**이 가치를 인정받습니다.

당신의 AI 시스템이 자꾸 이상한 답변을 낸다면, 프롬프트를 다시 쓰기 전에 이 질문부터 해보세요.

> **"지금 이 AI는 무엇을 보고 있는가?"**

컨텍스트를 설계하세요. 그것이 2026년의 AI 엔지니어링입니다.

---

**다음 주제:** [LLM이 "멍청해지는" 이유: Context Rot 현상 완전 해부](/ko/study/context-rot-lost-in-middle)
