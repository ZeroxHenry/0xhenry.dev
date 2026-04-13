# 셀프 쿼리 검색(Self-Querying Retrievers): AI가 스스로 필터를 적용하는 법

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


### 서론

대부분의 RAG 시스템은 오직 **벡터 검색**에만 의존합니다. 사용자의 질문과 가장 비슷하게 '들리는' 텍스트를 찾는 것이죠. 하지만 만약 사용자가 이렇게 물으면 어떨까요? *"**2023년에** CEO가 매출에 대해 뭐라고 했어?"*

일반적인 벡터 검색기는 2021년, 2022년, 2024년의 매출 관련 내용들을 찾아낼 수 있습니다. 의미적으로는 유사하기 때문이죠. 하지만 '2023년'이라는 특정 날짜 필터를 적용할 줄은 모릅니다. **셀프 쿼리 검색(Self-Querying Retrievers)**은 LLM을 사용하여 자연어 질문을 벡터 검색과 메타데이터 필터가 결합된 구조적 쿼리로 변환하여 이 문제를 해결합니다.

---

### 구조: 쿼리 번역기

셀프 쿼리 검색기는 질문 번역기처럼 작동합니다:

1.  **입력**: "지난달에 올라온 RAG 관련 포스트 보여줘."
2.  **AI 분석**: LLM이 질문과 데이터베이스 스키마를 분석합니다.
3.  **구조적 출력**: 
    -   **벡터 검색**: "RAG"
    -   **필터**: `date > "2026-03-01"`
4.  **실행**: 벡터 데이터베이스는 한 번의 쿼리로 검색과 필터링을 동시에 수행합니다.

---

### 왜 일반 검색보다 좋은가요?

-   **정밀도**: 주제는 맞지만 제약 조건(시간, 카테고리, 작성자)이 틀린 결과들을 완벽히 배제합니다.
-   **자연스러운 인터페이스**: 사용자는 복잡한 상세 검색 폼을 채우거나 필터 버튼을 누를 필요 없이 그냥 말로 하면 됩니다.
-   **효율성**: LLM에게 전달되는 불필요한 정보량을 줄여 토큰 비용을 아끼고 결과의 정확도를 높입니다.

---

### LangChain에서의 구현

셀프 쿼리 검색기를 구축하려면 먼저 LLM에게 여러분의 메타데이터 컬럼들에 대해 설명해 주어야 합니다.

```python
from langchain.retrievers.self_query.base import SelfQueryRetriever
from langchain.chains.query_constructor.base import AttributeInfo

# 1. 메타데이터 스키마 정의
metadata_info = [
    AttributeInfo(name="date", description="포스트 작성 날짜", type="string"),
    AttributeInfo(name="category", description="'AI'나 '로봇공학' 같은 카테고리", type="string"),
]

# 2. 검색기 설정
retriever = SelfQueryRetriever.from_llm(
    llm=ChatOpenAI(temperature=0),
    vectorstore=vectorstore,
    document_contents="AI 관련 기술 블로그 포스트들",
    metadata_field_info=metadata_info,
    verbose=True
)

# 3. 필터가 포함된 질문하기
docs = retriever.get_relevant_documents("2026년 3월에 올라온 AI 포스트 찾아줘")
```

---

### 요약

셀프 쿼리 검색기는 벡터 데이터베이스를 의미와 구조를 동시에 이해하는 '스마트 데이터베이스'로 진화시킵니다. 사용자의 복잡한 지시사항을 실제로 '이해'하는 것처럼 느껴지는 RAG 시스템을 만드는 핵심 비결입니다.

다음 포스트에서는 AI가 읽기 전에 데이터를 한 번 더 정제하는 기술, **컨텍스트 압축(Contextual Compression)**에 대해 알아보겠습니다.

---

**다음 주제:** [컨텍스트 압축: 노이즈 속에서 핵심 신호만 추출하기](/ko/study/contextual-compression)