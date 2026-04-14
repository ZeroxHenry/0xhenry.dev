---
title: "함수로서의 UI: LLM이 인터페이스를 반환하는 원리"
date: 2026-04-12
draft: false
tags: ["생성형UI", "React", "상태관리", "LLM", "Vercel-AI-SDK", "프론트엔드아키텍처"]
description: "React는 우리에게 'UI는 상태(State)의 함수'라는 것을 가르쳐주었습니다. 이제 우리는 LLM을 궁극의 상태 관리자로 만드는 방법을 배우고 있습니다."
author: "Henry"
categories: ["AI 엔지니어링"]
---

### 서론

React 생태계를 지배해 온 핵심 철학은 바로 `UI = f(state)`입니다. 즉, 인터페이스는 기저에 깔린 데이터(상태)를 시각적으로 표현한 것에 불과하다는 뜻입니다. 데이터가 변하면 인터페이스는 자동으로 업데이트됩니다.

생성형 UI 시대에 접어들며 우리는 이 공식을 이렇게 확장하고 있습니다: **`UI = f(LLM(Prompt))`**. 대형 언어 모델(LLM)이 상태를 결정하고, 프레임워크가 그에 맞춰 인터페이스를 렌더링하는 구조입니다.

---

### 상태 관리(State Management)의 패러다임 전환

전통적으로 상태 관리라 함은 데이터베이스에서 데이터를 가져와 Redux, Zustand, 혹은 React Context에 쑤셔 넣는 것을 의미했습니다. 개발자는 모든 버튼 클릭이 상태 변이(Mutation)로 이어지도록 명시적으로 배선 작업을 해야만 했습니다.

하지만 AI 기반 인터페이스에서 '상태'란 곧 **대화 기록(Conversation History)**과 **도구 호출(Tool Calls)**입니다.

1.  **프롬프트**: 사용자가 묻습니다. *"iPhone 15와 Galaxy S24의 배터리 수명을 비교해 줘."*
2.  **LLM 상태**: LLM이 특정 데이터 매개변수를 사용하여 `<ProductComparisonTable />` 컴포넌트를 호출하고 싶다는 구조화된 JSON 객체를 스트리밍으로 보냅니다.
3.  **렌더링**: 프레임워크가 이 JSON을 낚아채어 React Server Component를 인스턴스화하고, 데이터를 주입(Hydration)한 뒤, 완성된 HTML을 클라이언트(브라우저)로 밀어냅니다.

실질적으로 LLM이 가장 강력하고 광범위한 Redux 리듀서(Reducer) 역할을 수행하는 셈입니다.

---

### Vercel AI SDK 활용법 (`useUIState`)

Vercel AI SDK와 같은 프레임워크는 이러한 복잡한 안무를 관리하기 위해 `useUIState`와 `useAIState` 같은 특수한 훅(Hook)을 제공합니다.

-   **`AIState` (뇌)**: 대화의 가공되지 않은 JSON 형태입니다. 여기에는 시스템 프롬프트, 사용자 메시지, 함수 호출 내역이 모두 포함됩니다. 이것이 OpenAI나 Anthropic 서버와 주고받는 실제 데이터입니다.
-   **`UIState` (눈)**: 사용자가 실제로 보는 화면입니다. 날것의 `AIState`를 React Node로 변환합니다. 만약 `AIState`에 `{ type: 'tool_call', name: 'weather', data: '24C' }`라고 적혀 있다면, `UIState` 배열은 이를 시각적으로 아름다운 `<WeatherCard temp="24" />`로 바꿔치기합니다.

---

### 결정성(Determinism)의 과제

LLM은 본질적으로 비결정론적(Non-deterministic)입니다. 환각(Hallucination)을 일으키거나, 대답할 때마다 마음을 바꿀 수도 있죠. 이런 불안정한 기반 위에 어떻게 신뢰할 수 있는 UI를 구축할 수 있을까요?

그 해답은 바로 **엄격한 구조화된 출력 (Strict Structured Outputs, JSON Mode)**에 있습니다.
Zod와 같은 스키마(Schema) 도구를 사용하여 LLM이 무조건 지정된 JSON 형식으로만 대답하도록 강제함으로써, React 컴포넌트에 전달되는 데이터에 필수 Prop이 누락되는 일이 없도록 보장합니다. 만약 숫자가 와야 할 자리에 LLM이 문자열을 보내려고 시도하면, 파싱(Parsing) 라이브러리가 이를 즉시 적발하여 UI가 뻗어버리기 전에 LLM에게 재시도를 요청합니다.

---

### 요약

LLM을 애플리케이션 상태를 생성하는 '엔진'으로 취급함으로써, 우리는 사용자의 의도에 물 흐르듯 적응하는 인터페이스를 구현할 수 있게 되었습니다. 이제 프론트엔드 개발자의 역할은 사용자의 '여정(User Journey)'을 딱딱하게 하드코딩하는 것이 아니라, AI가 동적으로 조립할 수 있는 풍부하고 질 좋은 컴포넌트 라이브러리를 구축하는 것으로 옮겨가고 있습니다.

다음 세션에서는 이러한 동적 생성이 웹의 가장 오래된 숙제 중 하나인 **접근성(a11y)** 문제를 어떻게 해결하는지 알아보겠습니다.

---

**다음 주제:** [AI 기반 접근성: 명도 대비와 ARIA 속성 자동 수정하기](/ko/study/ai-driven-accessibility)
