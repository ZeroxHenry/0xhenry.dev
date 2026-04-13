---
title: "Confidence-Based 라우팅 — 싸고 작은 모델과 비싸고 큰 모델을 동시에"
date: 2026-04-14
draft: false
tags: ["LLMOps", "모델라우팅", "비용최적화", "GPT-4o", "GPT-4o-mini", "ConfidenceScore"]
description: "모든 질문에 비싼 GPT-4o를 쓸 필요가 있을까요? AI가 스스로 판단하여 쉬운 건 싼 모델에게, 어려운 건 비싼 모델에게 보내는 지능형 라우팅 기술을 소개합니다."
author: "Henry"
categories: ["LLMOps"]
series: ["LLMOps 실전"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A futuristic traffic controller AI directing data packets. Simple packets are sent to a small, fast drone (Mini model), while complex holographic gears are sent to a massive supercomputer (Pro model). Dark mode #0d1117, neon blue and gold, 16:9"
    file: "images/O/confidence-based-routing-hero.png"
  - position: "logic"
    prompt: "Flowchart: 1. Request -> 2. Mini Model (Check Confidence). 3. If confidence > 0.8 -> Fast Answer. 4. If confidence <= 0.8 -> Route to Pro Model. 16:9"
    file: "images/O/confidence-routing-logic.png"
---

이 글은 **LLMOps 실전 시리즈** 6편입니다.
→ 5편: [Shadow 환경에서 LLM 성능 검증하기 — Silent Test 패턴](/ko/study/O_llmops/llm-shadow-testing)

---

우리는 욕심쟁이입니다. 성능은 최고(GPT-4o, Claude 3.5)이길 원하면서, 비용은 최저(GPT-4o-mini, Llama 3)이길 바랍니다. 

이 모순을 해결하는 방법이 바로 **Confidence-Based Routing(신뢰도 기반 라우팅)**입니다. "똑똑한 모델에게만 어려운 일을 맡기자"는 지극히 상식적인 접근법을 자동화하는 것이죠.

---

### 왜 라우팅이 필요한가?

조사 결과, 실서비스 요청의 약 **70~80%는 사실 소형 모델(Mini)로도 충분히 해결 가능**한 수준입니다. 하지만 나머지 20%의 복잡한 질문 때문에 우리는 모든 요청에 비싼 모델을 사용하고 있습니다. 

라우팅 시스템을 구축하면 성능은 그대로 유지하면서 **비용을 50% 이상 절감**할 수 있습니다.

---

### 라우팅 구현을 위한 3가지 전략

#### 전략 1: Logprobs 기반 신뢰도 측정
소형 모델에게 먼저 답변을 시키되, 각 단어를 생성할 때의 확률값(Logprobs)을 체크합니다. 만약 모델이 답변을 생성하면서 확신이 없다면(확률이 낮다면), 즉시 대형 모델에게 작업을 넘깁니다.

#### 전략 2: 분류기(Classifier) 선행 배치
질문이 오자마자 "이거 어려운 질문이야?"를 판단하는 아주 가벼운 분류기(BERT나 소형 파인튜닝 모델)를 먼저 통과시킵니다.
- "안녕?" → **EASY** (Mini 모델로 전송)
- "최신 양자 역학 논문 3개를 비교 요약해줘" → **HARD** (Pro 모델로 전송)

#### 전략 3: 셀프 평가(Self-Correction) 패턴
소형 모델이 답변을 낸 뒤, 스스로 "내가 이 질문에 완벽히 답했는가?"를 평가하게 합니다. 여기서 "아니오"가 나오면 대형 모델이 구원투수로 등판합니다.

---

### 코드 예시: 하이브리드 라우팅 파이프라인

```python
async def smart_route_request(user_input):
    # 1. 소형 모델로 시도
    initial_output = await mini_model.generate(user_input, logprobs=True)
    
    # 2. 신뢰도 체크 (예: 평균 확률 85% 미만이면 탈락)
    if initial_output.confidence_score < 0.85:
        print("Routing to Pro Model...")
        # 3. 대형 모델로 재요청
        return await pro_model.generate(user_input)
    
    return initial_output.text
```

---

### 주의사항: 레이턴시(Latency)의 함정

라우팅은 비용을 아끼지만, **실패했을 경우 레이턴시를 2배**로 만듭니다 (소형 모델 시도 + 대형 모델 시도). 

따라서 다음과 같은 튜닝이 필수입니다.
1. **분류 정확도**: 소형 모델이 '못 풀 문제'인데 풀 수 있다고 착각하는 경우(False Positive)를 최소화해야 합니다.
2. **스트리밍 결합**: 소형 모델이 확신 없이 스트리밍을 시작했다면, 즉시 끊고 대형 모델의 스트리밍으로 전환하는 매끄러운 UX 처리가 필요합니다.

---

### Henry의 결론

가장 똑똑한 에이전트는 모든 지식을 가진 에이전트가 아니라, **"이건 내가 풀기엔 너무 버거워"라고 말하며 적절한 도구(혹은 모델)를 고를 줄 아는 에이전트**입니다. 

여러분의 지갑을 지키고 싶다면, 모든 요청에 무기를 들게 하지 말고 먼저 '적의 체급'을 확인하게 만드세요.

---

**다음 글:** [LLM 버전 업데이트가 프로덕션을 망치는 방법 — 모델 드리프트 대응](/ko/study/O_llmops/llm-version-drift-production)
