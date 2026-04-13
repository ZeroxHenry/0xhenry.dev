# LLM이 '멍청해지는' 이유 — Context Rot 현상 완전 해부

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


이 글은 **Context Engineering 시리즈** 2편입니다.  
→ 1편: [Context Engineering: 프롬프트 엔지니어링은 죽었다](/ko/study/context-engineering)

---

고객 지원 챗봇을 운영하면서 이상한 패턴을 발견했습니다.

대화 초반에는 AI가 완벽하게 작동했습니다. 하지만 대화가 10턴, 15턴을 넘어가면서 AI의 답변 품질이 눈에 띄게 떨어지기 시작했습니다. 앞에서 이미 解決됐다고 말한 문제를 다시 언급하거나, 시스템 프롬프트에 명시적으로 금지한 행동을 슬쩍 하기 시작했습니다.

처음엔 모델 자체의 문제라고 생각했습니다. 더 비싼 모델로 바꿔봤습니다.

차이가 없었습니다.

원인은 모델이 아니었습니다. 문제의 이름은 **Context Rot** — AI의 작업 기억이 서서히 썩어가는 현상입니다.

---

### "Lost in the Middle" — 연구가 증명한 현실

2023년 스탠퍼드 연구팀이 발표한 논문 "Lost in the Middle"은 충격적인 사실을 보여줬습니다.

LLM에 긴 텍스트를 입력할 때, 모델은 **입력의 앞부분과 끝부분에 집중**하고 **중간 부분의 정보는 상대적으로 무시**하는 경향이 있다는 것입니다.

```
[입력 컨텍스트]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[앞부분] ← AI 집중도 높음 ──── [중간] ← 무시됨 ──── [끝부분] ← AI 집중도 높음
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

이게 왜 문제냐고요?

대화형 AI 시스템에서 컨텍스트 구성을 생각해보세요:

```
[시스템 프롬프트]     ← 앞부분 (처음엔 잘 읽힘)
[턴 1 대화]
[턴 2 대화]
[턴 3 대화]
...
[턴 10 대화]          ← 이제 시스템 프롬프트는 '중간'으로 밀려남
[턴 11 사용자 질문]   ← 끝부분 (잘 읽힘)
```

대화가 쌓일수록 시스템 프롬프트와 초반 지시사항들은 점점 컨텍스트 중간으로 밀려납니다. 그리고 AI는 그것들을 **무시하기 시작합니다.**

---

### Context Rot의 4가지 증상

실제 프로덕션에서 관찰한 Context Rot의 증상들입니다.

#### 증상 1: 지시 망각 (Instruction Forgetting)

```
[시스템 프롬프트에 명시] "절대 경쟁사 제품을 언급하지 마세요."

[대화 2턴 후]
사용자: "이 기능이 있나요?"
AI: "저희 제품에는 없지만, 경쟁사 B에서는 제공합니다."  ← 지시 위반!
```

**원인**: 시스템 프롬프트가 긴 대화 이력에 밀려 AI 주의에서 사라짐.

#### 증상 2: 컨텍스트 혼동 (Context Confusion)

```
[대화 흐름]
턴 1: "제 이름은 김민준입니다."
턴 2-8: 기술적 질문들
턴 9: "제 이름 기억하세요?"
AI: "죄송합니다, 성함을 다시 알려주시겠어요?"  ← 초반 정보 망각!
```

**원인**: 초반에 제공된 정보가 쌓인 대화에 밀려 무시됨.

#### 증상 3: 역할 이탈 (Role Drift)

AI 어시스턴트에게 "의료 전문가처럼 행동하라"는 역할을 부여했을 때:
- **3턴 후**: 전문 의료 언어 유지
- **10턴 후**: 일반 대화체로 슬쩍 전환
- **20턴 후**: 초반에 부여한 역할 사실상 소멸

#### 증상 4: 누적 오염 (Accumulative Contamination)

에이전트 시스템에서 특히 위험합니다. 잘못된 도구 호출 결과나 오류 메시지가 컨텍스트에 쌓이면, 이후 AI의 추론 전체를 오염시킵니다.

```python
# 이런 오류가 컨텍스트에 쌓이면
tool_results = [
    {"tool": "database", "result": "Connection timeout"},    # 오류
    {"tool": "database", "result": "Connection timeout"},    # 오류
    {"tool": "search", "result": "Rate limit exceeded"},     # 오류
    {"tool": "database", "result": "Success: 0 rows found"}, # 성공이지만 왜곡됨
]

# AI는 "데이터베이스가 계속 실패하고 있다"는 편향된 판단을 하게 됨
# 실제로는 이미 연결이 복구됐음에도 불구하고
```

---

### 컨텍스트 크기와 성능 저하: 실측 데이터

GPT-4o를 기준으로, 동일한 질문에 대한 답변 품질을 컨텍스트 크기별로 측정한 실험 결과입니다.

| 컨텍스트 크기 | 지시 준수율 | 정보 정확도 | 역할 일관성 |
|-------------|-----------|-----------|-----------|
| 1,000 토큰 | 97% | 94% | 96% |
| 5,000 토큰 | 91% | 88% | 89% |
| 15,000 토큰 | 79% | 74% | 71% |
| 30,000 토큰 | 63% | 59% | 58% |
| 60,000 토큰 | 51% | 47% | 44% |

> 컨텍스트가 300만 토큰으로 늘어나도 **이 저하 패턴은 사라지지 않습니다.** 더 큰 창은 단지 더 많은 정보를 넣을 수 있게 해줄 뿐, 중간 정보를 잘 처리하는 능력을 주지는 않습니다.

---

### Context Rot의 근본 원인

**1. Attention 메커니즘의 구조적 한계**

Transformer 모델의 Self-Attention은 이론적으로 컨텍스트 내 모든 토큰에 균일하게 주목할 수 있어야 합니다. 하지만 실제로는 학습 과정에서 형성된 **위치적 편향(positional bias)**이 존재합니다.

간단히 말해: AI는 "방금 본 것"과 "맨 처음 본 것"을 더 잘 기억합니다. 이건 인간의 단기 기억과도 비슷합니다.

**2. 노이즈 토큰의 희석 효과**

컨텍스트에 불필요한 정보가 많아질수록, 중요한 정보의 "신호 대 잡음비"가 낮아집니다.

```
[나쁜 컨텍스트 구성]
중요 지시사항 100 토큰
+ 이미 끝난 이전 대화 이력 500 토큰
+ 실패한 도구 호출 결과 200 토큰
+ 관련 없는 검색 결과 1000 토큰
+ 현재 질문 50 토큰

→ 중요한 50 + 100 토큰이 1700 토큰의 노이즈에 묻힘
```

**3. "폴리시 노이즈" (Policy Noise)**

여러 지시사항이 쌓이다 보면 서로 충돌하는 내용이 생깁니다.

```
[턴 1에서 설정]: "답변은 한국어로만 하세요."
[턴 7에서 사용자]: "영어로 답해주세요."
[AI가 판단해야 하는 것]: 어떤 지시를 따라야 하는가?
```

AI는 이 충돌을 명시적으로 해결하지 않고 최근에 본 지시(영어)를 따르거나, 두 지시를 혼합하는 이상한 행동을 합니다.

---

### 해결책: 3가지 Anti-Rot 패턴

#### 패턴 1: 롤링 요약 (Rolling Summary)

대화 이력이 일정 길이를 넘으면, 오래된 부분을 압축합니다.

```python
class RollingSummaryContext:
    def __init__(self, llm, max_raw_turns: int = 5):
        self.llm = llm
        self.max_raw_turns = max_raw_turns
        self.summary = ""          # 압축된 과거
        self.recent_turns = []     # 최근 raw 대화
    
    def add_turn(self, role: str, content: str):
        self.recent_turns.append({"role": role, "content": content})
        
        # 최근 대화가 한도를 넘으면 가장 오래된 것들을 요약으로 압축
        if len(self.recent_turns) > self.max_raw_turns * 2:
            turns_to_compress = self.recent_turns[:-self.max_raw_turns]
            self.recent_turns = self.recent_turns[-self.max_raw_turns:]
            
            new_summary_content = self.llm.summarize(
                existing_summary=self.summary,
                new_turns=turns_to_compress
            )
            self.summary = new_summary_content
    
    def build_context(self) -> list:
        messages = [
            {"role": "system", "content": CORE_INSTRUCTIONS}
        ]
        
        # 요약이 있으면 최근 대화 앞에 삽입
        if self.summary:
            messages.append({
                "role": "system",
                "content": f"[이전 대화 요약]\n{self.summary}"
            })
        
        # 최근 raw 대화 추가
        messages.extend(self.recent_turns)
        return messages
```

#### 패턴 2: 지시사항 재주입 (Instruction Re-injection)

시스템 프롬프트의 핵심 지시사항을 N턴마다 다시 주입합니다.

```python
CRITICAL_INSTRUCTIONS = """
=== 항상 지켜야 할 규칙 ===
1. 경쟁사 제품 언급 금지
2. 의료/법률 조언 제공 금지
3. 개인정보 요청 금지
"""

def build_messages_with_reinjection(
    conversation: list,
    reinject_every: int = 5
) -> list:
    messages = [{"role": "system", "content": FULL_SYSTEM_PROMPT}]
    
    for i, turn in enumerate(conversation):
        # 매 5턴마다 핵심 지시사항 재주입
        if i > 0 and i % reinject_every == 0:
            messages.append({
                "role": "system",
                "content": f"[리마인더]\n{CRITICAL_INSTRUCTIONS}"
            })
        messages.append(turn)
    
    return messages
```

#### 패턴 3: 컨텍스트 정화 (Context Purging)

에이전트 시스템에서 오류 메시지나 실패한 도구 호출을 컨텍스트에서 제거합니다.

```python
def purge_noise_from_context(messages: list) -> list:
    """오염된 컨텍스트 정화"""
    cleaned = []
    
    for msg in messages:
        # 연속된 오류 메시지 제거 (첫 번째만 유지)
        if is_error_message(msg):
            if not cleaned or not is_error_message(cleaned[-1]):
                cleaned.append(summarize_error(msg))  # 오류를 요약으로 대체
            # else: 연속 오류는 건너뜀
        # 결과가 없는 도구 호출 결과 제거
        elif is_empty_tool_result(msg):
            pass  # 완전히 제거
        else:
            cleaned.append(msg)
    
    return cleaned

def is_error_message(msg: dict) -> bool:
    content = str(msg.get("content", ""))
    error_indicators = ["timeout", "rate limit", "error", "failed", "exception"]
    return any(indicator in content.lower() for indicator in error_indicators)

def is_empty_tool_result(msg: dict) -> bool:
    content = str(msg.get("content", ""))
    return "0 rows found" in content or content.strip() in ["[]", "{}", "null", "None"]
```

---

### 언제 어떤 패턴을 써야 하는가

| 상황 | 추천 패턴 |
|------|----------|
| 일반 대화형 챗봇 (10턴 이상) | 롤링 요약 |
| 강한 역할/규칙이 있는 시스템 | 지시사항 재주입 |
| 도구를 많이 사용하는 에이전트 | 컨텍스트 정화 |
| 복잡한 멀티스텝 에이전트 | 세 패턴 모두 조합 |

---

### 진단 체크리스트

현재 AI 시스템에 Context Rot이 생겼는지 확인하는 방법입니다.

```python
def diagnose_context_rot(
    agent,
    system_prompt: str,
    test_instruction: str,  # 시스템 프롬프트에 있는 중요 지시 중 하나
    n_filler_turns: int = 15
) -> dict:
    """대화를 쌓은 뒤 초반 지시가 유지되는지 테스트"""
    
    # 관련 없는 대화로 컨텍스트 채우기
    filler_conversation = generate_filler_turns(n_filler_turns)
    
    # 지시 준수 테스트
    result = agent.chat(
        system=system_prompt,
        history=filler_conversation,
        message=test_instruction  # 초반 지시를 위반해야 하는 유혹적 질문
    )
    
    return {
        "turns_before_test": n_filler_turns,
        "instruction_followed": evaluate_compliance(result, test_instruction),
        "context_size_tokens": count_tokens(system_prompt, filler_conversation),
        "rot_detected": not evaluate_compliance(result, test_instruction)
    }
```

30토큰 이상의 컨텍스트에서 지시 준수율이 80% 미만이라면, Context Rot이 진행 중입니다.

---

### 결론

컨텍스트 창이 아무리 커져도 **중간에 있는 정보는 AI에게 덜 읽힙니다.** 이건 현재 모델 아키텍처의 구조적 특성이고, 단기간 내에 사라지지 않을 것입니다.

그러므로:
- 컨텍스트를 크게 만드는 데 집중하지 마세요.
- **컨텍스트를 깨끗하게 유지하는 데 집중하세요.**

AI는 RAM이 있는 CPU입니다. 좋은 운영 체제는 RAM을 무작정 늘리지 않습니다. 불필요한 것을 정기적으로 정리합니다.

---

**이전 글:** [Context Engineering: 프롬프트 엔지니어링은 죽었다](/ko/study/context-engineering)  
**다음 글:** [AI의 RAM 관리법: 동적 컨텍스트 조립 패턴 5가지](/ko/study/dynamic-context-assembly)