# RAG 평가: RAGAS를 이용한 답변의 정확도 측정

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


### 서론

"답변이 그럴듯하다"는 것은 상용 AI 시스템의 올바른 평가 기준이 될 수 없습니다. 청크 크기를 바꾸거나, 임베딩 모델을 교체하거나, 프롬프트를 수정할 때마다 여러분은 시스템이 실제로 나아졌는지 아니면 나빠졌는지 **측정**할 수 있어야 합니다.

이때 필요한 것이 바로 **RAGAS**(RAG Assessment)입니다. RAGAS는 LLM을 판판관으로 사용하여 여러분의 RAG 파이프라인을 4가지 핵심 지표로 평가하는 프레임워크입니다. 이를 흔히 **RAGAS Rag Triad**라고 부릅니다.

---

### RAGAS 핵심 지표

RAGAS는 단순히 최종 답변의 정답 여부만 확인하는 것이 아니라, **질문(Query)**, **컨텍스트(Context)**, **답변(Answer)** 사이의 관계를 평가합니다.

1.  **신뢰성 (Faithfulness, 답변 vs 컨텍스트)**: 생성된 답변에 검색된 컨텍스트에 없는 내용이 포함되어 있지는 않은가? (할루시네이션 방지 지표)
2.  **답변 관련성 (Answer Relevance, 답변 vs 질문)**: 답변이 사용자의 실제 질문에 적절히 응답하고 있는가?
3.  **컨텍스트 정밀도 (Context Precision, 컨텍스트 vs 질문)**: 검색된 조각들이 사용자의 질문에 얼마나 밀접하게 관련되어 있는가?
4.  **컨텍스트 재현율 (Context Recall, 컨텍스트 vs 정답)**: 검색된 컨텍스트 속에 정답을 내기 위해 필요한 모든 정보가 포함되어 있는가?

---

### 왜 LLM을 평가하기 위해 또 다른 LLM을 쓰나요?

사람이 직접 수천 개의 답변을 평가하는 것은 너무 느리고 비용이 많이 듭니다. RAGAS는 성능이 뛰어난 모델(예: GPT-4o)을 '판사'로 활용하여 데이터 포인트 간의 의미론적 일치도를 분석합니다. 100% 완벽하진 않더라도, 코드를 수정할 때마다 일관되게 적용할 수 있는 자동화된 벤치마크를 제공한다는 점에서 매우 강력합니다.

---

### 구현 예시 (Python)

RAGAS는 LangChain과 완벽하게 통합되며, 필요한 경우 평가 모델로 로컬 모델을 사용할 수도 있습니다.

```python
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevance, context_precision
from datasets import Dataset

# 1. 테스트 데이터 준비
data = {
    "question": ["ChromaDB를 어떻게 설치하나요?"],
    "answer": ["pip install chromadb 명령어로 설치할 수 있습니다."],
    "contexts": [["ChromaDB는 벡터 DB입니다. pip install chromadb를 통해 설치하세요."]],
    "ground_truth": ["터미널에서 'pip install chromadb'를 실행하세요."]
}

dataset = Dataset.from_dict(data)

# 2. 평가 실행
result = evaluate(
    dataset,
    metrics=[faithfulness, answer_relevance, context_precision]
)

print(result)
```

---

### 요약

RAGAS는 RAG 개발을 '느낌(Vibe) 기반 엔지니어링'에서 '데이터 기반 과학'으로 전환합니다. 이러한 지표들을 지속적으로 추적함으로써, 여러분은 자신의 시스템이 어디가 강하고 어디를 보완해야 하는지 정확히 알고 자신 있게 개선해 나갈 수 있습니다.

다음 세션에서는 평가를 넘어 실시간 운영 단계의 필수 기술, **LangSmith를 이용한 RAG 모니터링**에 대해 알아보겠습니다.

---

**다음 주제:** [RAG 모니터링: LangSmith를 활용한 실시간 가시성 확보](/ko/study/monitoring-langsmith)