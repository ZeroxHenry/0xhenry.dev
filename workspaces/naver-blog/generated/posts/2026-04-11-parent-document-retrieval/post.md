# 부모 문서 검색(Parent Document Retrieval): 정밀도와 문맥을 동시에 잡는 법

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


### 서론

RAG 시스템을 설계할 때 가장 고민되는 지점 중 하나는 바로 **청크 크기(Chunk Size)**입니다.
-   **작은 청크**: 검색 정밀도가 높습니다(벡터 모델이 특정 키워드의 위치를 정확히 찾기 좋음). 하지만 AI가 답변할 때 주변 문맥이 부족해 답변의 질이 떨어질 수 있습니다.
-   **큰 청크**: 문맥이 풍부합니다(AI가 페이지 전체를 읽을 수 있음). 하지만 검색 정밀도가 떨어집니다(한 청크에 너무 많은 주제가 섞여 있어 벡터 모델이 혼란을 겪음).

**부모 문서 검색(Parent Document Retrieval)** 패턴은 이 문제를 완벽하게 해결합니다.

---

### 컨셉: 검색은 작게, 답변은 크게

이 패턴의 핵심은 검색용 청크와 결과 제공용 문서를 두 계층으로 나누는 것입니다:

1.  **작은 청크 (자식)**: 텍스트를 아주 작게(예: 200 토큰) 나눈 뒤 벡터화하여 벡터 DB에 저장합니다. 오직 '검색'을 위해서만 사용됩니다.
2.  **큰 문서 (부모)**: 작은 청크들이 속해 있는 원본 문서나 큰 단락(예: 2000 토큰)입니다. 별도의 효율적인 Key-Value 저장소에 보관합니다.

---

### 작동 방식

1.  **질문**: 사용자가 질문을 던집니다.
2.  **검색**: 벡터 DB에서 가장 유사도가 높은 **작은 청크(자식)** 3개를 찾습니다.
3.  **확장**: 찾은 자식 청크들이 어떤 **부모 문서**에 속해 있는지 조회합니다.
4.  **답변**: AI에게는 자식 조각이 아닌, 풍부한 정보가 담긴 **부모 문서 전체**를 전달하여 답변을 생성하게 합니다.

### 왜 이 패턴을 써야 하나요?

-   **문맥 보전**: 문장이 중간에 잘리거나 논리가 끊기지 않은 채로 AI에게 전달됩니다.
-   **검색 정확도**: 작은 조각은 벡터 모델이 인덱싱하기 훨씬 수월하여 원하는 정보를 더 잘 찾습니다.
-   **전문적인 설계**: 고도화된 실서비스용 RAG 시스템에서 공통적으로 사용되는 표준 패턴입니다.

---

### LangChain에서의 구현

LangChain은 이 모든 과정을 오케스트레이션해주는 전용 `ParentDocumentRetriever`를 제공합니다.

```python
from langchain.retrievers import ParentDocumentRetriever
from langchain.storage import InMemoryStore
from langchain.text_splitter import RecursiveCharacterTextSplitter

# 1. 분할기 정의
parent_splitter = RecursiveCharacterTextSplitter(chunk_size=2000)
child_splitter = RecursiveCharacterTextSplitter(chunk_size=400)

# 2. 저장소 설정
vectorstore = Chroma(collection_name="split_parents", embedding_function=embeddings)
store = InMemoryStore()

# 3. 검색기 초기화
retriever = ParentDocumentRetriever(
    vectorstore=vectorstore,
    docstore=store,
    child_splitter=child_splitter,
    parent_splitter=parent_splitter,
)

# 4. 문서 추가 (자동으로 두 계층으로 나뉘어 저장됨)
retriever.add_documents(docs)
```

---

### 요약

부모 문서 검색은 '찾기(Search)'와 '이해하기(Understand)' 사이의 다리 역할을 합니다. 검색은 바늘 끝처럼 날카롭게 하면서도, AI의 이해도는 원본의 넓이를 그대로 유지하게 해줍니다. 만약 AI의 답변이 너무 짧거나 내용이 부족하다면, 가장 먼저 적용해 보아야 할 패턴입니다.

다음 레슨에서는 복잡한 질문을 여러 각도에서 해석하는 **다중 쿼리 검색(Multi-Query Retrieval)**에 대해 알아보겠습니다.

---

**다음 주제:** [다중 쿼리 검색: 질문의 이면을 꿰뚫어 보는 기술](/ko/study/multi-query-retrieval)