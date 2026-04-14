---
title: "도구 사용: AI 에이전트에게 '손'을 달아주는 법"
date: 2026-04-12
draft: false
tags: ["도구사용", "함수호출", "OpenAI함수", "LangChain도구", "API연동"]
description: "텍스트와 행동 사이의 간극을 메우는 기술: JSON과 Python 함수를 통해 LLM이 실제 세상상과 상호작용하게 하는 방법을 알아봅니다."
author: "Henry"
categories: ["AI 엔지니어링"]
---

### 서론

LLM 그 자체는 마치 '유리병 속의 뇌'와 같습니다. 생각하고 말할 수는 있지만, 무언가를 직접 움직일 수는 없죠. **도구 사용(Tool Use)** 혹은 **함수 호출(Function Calling)**은 AI에게 '손'을 달아주는 인터페이스입니다. 이를 통해 모델은 데이터베이스에서 정보를 가져오고, 이메일을 보내고, 심지어 하드웨어를 제어할 수도 있습니다.

물론 AI가 직접 버튼을 '클릭'하는 것은 아닙니다. 구조화된 데이터인 **JSON**을 매개체로 행동을 요청합니다.

---

### 도구 사용의 작동 원리: 디지털 악수

1.  **선언 (Declaration)**: 여러분이 가진 함수를 LLM에게 설명합니다. (예: "`get_weather(city)` 함수는 도시 이름을 받아서 현재 기온을 반환해.")
2.  **분석 (Analysis)**: 사용자가 "서울 날씨 어때?"라고 묻습니다. LLM은 자신이 답을 모르지만, 날씨 정보를 가져올 수 있는 도구가 있다는 것을 깨닫습니다.
3.  **호출 요청 (The Call)**: LLM은 답변 대신 **JSON 객체**를 출력합니다: `{"function": "get_weather", "args": {"city": "Seoul"}}`.
4.  **실행 (Execution)**: 여러분의 애플리케이션(LLM이 아님)이 이 JSON을 확인하고, 실제 Python 코드를 실행하여 결과("2°C")를 얻습니다.
5.  **최종 답변**: 결과를 모델에게 다시 전달하면, 모델은 비로소 "현재 서울의 기온은 2도입니다."라고 답변합니다.

---

### 왜 단순 텍스트보다 좋은가요?

-   **신뢰성**: 출력을 JSON 스키마로 강제함으로써, AI가 API 호출에 필요한 정확한 매개변수를 제공하도록 보장할 수 있습니다.
-   **보안**: LLM은 여러분의 데이터베이스나 OS에 직접 접근하지 않습니다. 오직 함수 호출을 '요청'할 뿐이며, 실제 실행 여부는 여러분의 코드가 결정합니다.
-   **확장성**: Python 함수로 작성할 수만 있다면 그 어떤 것이든 AI의 도구로 제공할 수 있습니다.

---

### 구현 예제 (LangChain)

LangChain은 `@tool` 데코레이터를 통해 이 과정을 매우 간단하게 만들어줍니다.

```python
from langchain.tools import tool

@tool
def get_stock_price(symbol: str) -> float:
    """주식 티커 심볼을 받아 현재 주가를 반환합니다."""
    # 실제 API 연동 로직
    return 150.25

# 도구를 LLM에 바인딩
llm_with_tools = llm.bind_tools([get_stock_price])

# 질문 던지기
response = llm_with_tools.invoke("AAPL 주가 알려줘")
print(response.tool_calls)
# 출력: [{'name': 'get_stock_price', 'args': {'symbol': 'AAPL'}}]
```

---

### 요약

도구 사용은 에이전틱(Agentic) 퍼즐의 마지막 조각입니다. 단순히 대화하는 파트너를 넘어, 실제 업무를 수행하는 운영체제로 AI를 변모시키기 때문입니다. 추론(ReAct) 및 기억(Memory)과 결합될 때, 비로소 실제 세상에서 복잡한 워크플로우를 완수할 수 있는 강력한 시스템이 탄생합니다.

이것으로 **Batch 2**를 마칩니다. 다음 배치에서는 **다중 에이전트 시스템과 고급 오케스트레이션**으로 규모를 키워보겠습니다.

---

**다음 주제:** [다중 에이전트 오케스트레이션: 가상 회사 설계하기](/ko/study/multi-agent-orchestration)
