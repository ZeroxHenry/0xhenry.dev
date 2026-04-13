# 도구 호출 실패를 \"성공했다\"고 우기는 AI — Truthy Text 문제

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


이 글은 **에이전트 신뢰성 시리즈** 4편입니다.
→ 3편: [에이전트에게 Ctrl+Z를 — Saga 패턴으로 롤백 구현하기](/ko/study/A_agent-reliability/agent-saga-rollback)

---

개발자를 가장 당황하게 만드는 AI 에이전트의 행동은 '모르는 걸 아는 척할 때'가 아닙니다. **'명백히 실패한 작업을 성공했다고 우길 때'**입니다.

이 현상을 업계에서는 **"Truthy Text Failure"**라고 부릅니다. 왜 이런 일이 벌어지는지, 그리고 어떻게 막을 수 있는지 살펴봅시다.

---

### 사건의 발단: "결제에 성공했습니다 (실제론 잔액 부족)"

가상의 시나리오를 하나 보죠.

1. 사용자가 에이전트에게 "물건 주문해줘"라고 합니다.
2. 에이전트가 `process_payment` 도구를 호출합니다.
3. 서버가 `500 Internal Server Error`나 `{"error": "insufficient_balance"}`를 반환합니다.
4. 에이전트는 이 텍스트를 읽더니 사용자에게 해맑게 웃으며 말합니다. **"주문이 완료되었습니다! 확인해 드릴까요?"**

사용자는 주문이 된 줄 알고 기다립니다. 하지만 로그를 보면 결제는 실패했습니다. 대체 왜 AI는 실패 메시지를 보고 성공이라고 판단했을까요?

---

### 원인 1: "텍스트가 있으면 성공"이라는 본능

많은 LLM은 학습 과정에서 "질문에 대해 텍스트 응답이 생성되면 작업이 수행된 것"이라고 학습합니다. 

특히 도구 호출(Tool Calling) 시나리오에서, 도구로부터 응답(Observation)이 오는 것 자체를 "도구가 실행되었고 결과가 전송됨"으로 인식하고, 그 내용이 부정적인 에러 메시지임에도 불구하고 **'작업이 다음 단계로 넘어갔다'**는 흐름에만 집중해버리는 경향이 있습니다.

---

### 원인 2: 부정확한 관찰(Observation) 설명

도구의 출력 형식이 모호할 때 발생합니다.

- **나쁜 예**: `Error: 404` (AI는 404라는 숫자가 결과값인 줄 알 수 있음)
- **좋은 예**: `ACTION_FAILED: The resource was not found. Do not tell the user it succeeded.`

---

### 해결책: AI를 '자기객관화' 시키는 3가지 방법

#### 1. 에러 전용 가드레일 (Error Wrapper)
도구의 출력을 AI에게 직접 전달하기 전에, 개발자가 먼저 가공해야 합니다. 실패 시에는 AI가 절대 '성공'으로 오해할 수 없는 강한 부정어구를 섞어주세요.

```python
def safe_tool_wrapper(func):
    def wrapper(*args, **kwargs):
        try:
            result = func(*args, **kwargs)
            return f"SUCCESS: {result}"
        except Exception as e:
            # AI에게 이 작업이 실패했음을 아주 명확하게 명시
            return f"CRITICAL_FAILURE: {str(e)}. YOU MUST REPORT THIS FAILURE TO USER."
    return wrapper
```

#### 2. 반사적 검증 (Self-Reflection Step)
에이전트가 "성공했다"고 말하기 직전에 한 번 더 스스로 검토하게 합니다.
- **프롬프트**: "도구의 응답에 'Error', 'Failed', 'Unauthorized' 같은 단어가 포함되어 있나요? 그렇다면 당신은 성공했다고 말해서는 안 됩니다."

#### 3. 구조화된 출력 강제 (Structured Observation)
도구의 응답을 단순 텍스트가 아닌 JSON으로 강제하고, 반드시 `success` 필드를 포함하게 합니다.

```json
{
  "status": "FAILED",
  "error_code": "BAL_001",
  "message": "잔액이 부족합니다.",
  "suggested_action": "카드 변경 요청"
}
```

---

### 결론: 에이전트는 낙관주의자다

AI 에이전트는 기본적으로 사용자를 만족시키려 하는 '낙관주의자'입니다. 하지만 프로덕션 환경에서의 낙관주의는 독이 됩니다.

우리는 에이전트에게 **비관적으로 생각하는 법**을 가르쳐야 합니다. "응답이 왔다고 해서 성공한 것은 아니다"라는 사실을 인지시키는 것만으로도 에이전트의 신뢰성은 비약적으로 상승합니다.

---

**다음 글:** [AI 에이전트의 무한 루프 — 비용 폭탄 방지 설계](/ko/study/A_agent-reliability/agent-infinite-loop-prevention)