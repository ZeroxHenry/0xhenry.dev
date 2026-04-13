---
title: "Groundedness, Faithfulness, Relevance — RAG 평가 지표 실전"
date: 2026-04-13
draft: false
tags: ["RAG", "LLMOps", "RAG평가", "Groundedness", "Faithfulness", "Relevance", "RAGAS"]
description: "RAG 답변이 '좋다'의 기준은 무엇일까요? 느낌적인 평가를 넘어 Groundedness, Faithfulness, Relevance라는 3대 지표를 어떻게 정의하고 소스 코드로 자동 측정하는지 실전 가이드를 제공합니다."
author: "Henry"
categories: ["LLMOps"]
series: ["RAG 실패 분석"]
series_order: 2
images_needed:
  - position: "hero"
    prompt: "A sophisticated laboratory scale balancing an AI answer on one side and a source document on the other. Digital metrics (0.98, 0.85, 0.92) floating in the air. Dark background #0d1117, clean UI style, cyan and white glowing elements, 16:9"
    file: "images/O/rag-evaluation-metrics-hero.png"
  - position: "triad"
    prompt: "Venn diagram of RAG Triad: Faithfulness, Answer Relevance, Context Relevance. Central intersection labeled 'High Quality RAG'. Minimalist design with soft gradients, 16:9"
    file: "images/O/rag-evaluation-triad.png"
  - position: "code-metrics"
    prompt: "Data dashboard showing bar charts for Groundedness vs Faithfulness across different LLM versions. Modern tech aesthetic, dark mode, 16:9"
    file: "images/O/rag-evaluation-dashboard.png"
---

이 글은 **LLMOps 실전 시리즈** 2편입니다.
→ 1편: [HTTP 200인데 비즈니스가 망가졌다 — AI 품질 KPI 설계법](/ko/study/O_llmops/llm-quality-kpi)

---

RAG(Retrieval-Augmented Generation) 시스템을 만들면 반드시 듣게 되는 말입니다.

"음... 답변이 좀... 아쉬운데요?"

여기에 "임베딩 모델을 바꿔봤습니다"라거나 "프롬프트를 다듬었습니다"라고 답하는 건 아마추어의 방식입니다. 프로는 **숫자**로 답해야 합니다. 문제는 RAG의 '품질'이라는 게 지극히 주관적이라는 것이죠.

이 주관을 객관으로 바꾸기 위해 업계에서 표준처럼 사용하는 **RAG Triad(3대 지표)**를 소스 코드와 함께 살펴봅시다.

---

### RAG 평가의 3대 핵심 지표 (RAG Triad)

TruLens와 Ragas 같은 프레임워크에서 정의한 이 지표들은 RAG의 핵심 단계인 **'검색(Retrieval)'**과 **'생성(Generation)'**을 각각 평가합니다.

#### 1. Faithfulness (충실도)
- **질문**: AI의 답변이 **검색된 문서(Context)**에만 기반하고 있는가?
- **체크포인트**: AI가 자기 머릿속 지식을 섞거나(Hallucination), 문서에 없는 내용을 지어내면 이 점수가 낮아집니다.

#### 2. Answer Relevance (답변 관련성)
- **질문**: AI의 답변이 **사용자의 질문**에 적절히 답하고 있는가?
- **체크포인트**: 문서는 잘 찾았고 사실관계도 맞지만, 질문과 상관없는 엉뚱한 소리를 하면 점수가 낮아집니다.

#### 3. Context Relevance (컨텍스트 관련성)
- **질문**: 검색된 문서들이 **사용자의 질문**에 답하는 데 정말 필요한 내용인가?
- **체크포인트**: 검색 엔진이 쓰레기 문서를 가져왔다면, 생성 단계가 아무리 뛰어나도 최종 답변은 나빠질 수밖에 없습니다.

---

### 지표 측정하기 (LLM-as-a-Judge)

이 지표들을 사람이 일일이 채점할 순 없습니다. 그래서 **'평가용 LLM'**에게 채점을 시킵니다.

#### Faithfulness 측정 코드 예시 (Python)

```python
def check_faithfulness(question, context, answer, judge_llm):
    prompt = f"""
    당신은 엄격한 사실 확인 전문가입니다.
    다음 제공된 [문서]만을 바탕으로 [AI 답변]의 주장이 정당한지 평가하세요.

    [문서]: {context}
    [AI 답변]: {answer}

    평가 단계:
    1. AI 답변에서 개별적인 주장(Claims)들을 추출하세요.
    2. 각 주장이 [문서]에 명시적으로 포함되어 있는지 확인하세요.
    3. (근거 있는 주장의 수) / (전체 주장의 수) 비율을 0에서 1 사이의 점수로 계산하세요.

    결과를 반드시 JSON 형식으로 출력하세요:
    {{"score": 0.0~1.0, "reason": "이유 요약", "unsupported_claims": []}}
    """
    response = judge_llm.complete(prompt)
    return json.loads(response.text)
```

---

### Groundedness vs Faithfulness: 뭐가 다른가요?

사실 현업에서는 두 단어를 혼용해서 씁니다. 하지만 미세한 차이가 있습니다.

- **Faithfulness**: "너 답변이 소스(문서)에 충실하니?" (거짓말 안 했니?)
- **Groundedness**: "너 답변의 근거가 지면에 붙어있니?" (근거가 문서 어디에 있는지 콕 집을 수 있니?)

주로 **Groundedness**는 답변의 각 문장마다 "이건 문서의 몇 번째 단락에서 가져온 거야"라는 **인용(Citation)**이 가능한지를 평가할 때 더 강조됩니다.

---

### 실제 벤치마킹 데이터 예시

새로운 리트리버 알고리즘을 도입했을 때, 대시보드는 다음과 같이 보여야 합니다.

| 지표 | 기존 (Base RAG) | 개선 (Hybrid Search) | 변화 |
|------|-----------------|---------------------|------|
| **Context Relevance** | 0.65 | 0.82 | +26% 🟢 |
| **Faithfulness** | 0.88 | 0.85 | -3% 🟡 |
| **Answer Relevance** | 0.72 | 0.81 | +12% 🟢 |

**분석**: Hybrid Search 도입으로 검색 품질(Context Relevance)은 크게 좋아졌습니다. 하지만 검색 결과가 많아지다 보니 AI가 정보를 섞으면서 충실도(Faithfulness)가 아주 미세하게 떨어졌네요. 전체적인 답변 질(Answer Relevance)은 상승했습니다.

---

### 추천 도구

직접 구현하는 것도 좋지만, 다음 라이브러리들을 활용하면 훨씬 체계적인 관리가 가능합니다.

1. **Ragas**: 가장 유명한 RAG 평가 라이브러리. NLI(Natural Language Inference) 기반 측정.
2. **TruLens**: RAG Triad 개념을 처음으로 대중화한 시각화 도구.
3. **DeepEval**: 유닛 테스트(Pytest) 스타일로 AI 품질을 검증.

---

### 결론: 느낌에서 지표로

"제 AI는 꽤 잘 대답해요"라는 말은 엔지니어링의 언어가 아닙니다.

"저희 시스템은 **Faithfulness 0.92, Context Relevance 0.85**를 기록하고 있으며, 이는 업계 평균보다 15% 높은 수치입니다"라고 말해야 합니다.

오늘부터 여러분의 RAG 로그에 이 3대 지표를 남겨보세요. 개선의 방향이 명확해질 것입니다.

---

**다음 글:** [GPT API 비용 계산서 공개 — 3개월 프로덕션 실제 청구 내역](/ko/study/O_llmops/llm-api-cost-breakdown)
