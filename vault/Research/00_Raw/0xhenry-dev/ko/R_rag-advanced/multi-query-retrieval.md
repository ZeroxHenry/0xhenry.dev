---
title: "다중 쿼리 검색(Multi-Query Retrieval): 질문의 의도를 넓혀 최적의 답을 찾는 법"
date: 2026-04-11
draft: false
tags: ["LangChain", "RAG", "다중쿼리검색", "쿼리재작성", "최적화"]
description: "질문 하나로는 부족할 때가 있습니다. LLM을 사용하여 같은 질문을 여러 각도에서 재해석하고 검색 정확도를 높이는 기술을 소개합니다."
author: "Henry"
categories: ["AI 엔지니어링"]
---

### 서론

거리 기반의 벡터 검색은 질문이 '어떻게 표현되었는지'에 매우 민감합니다.
-   사용자가 "배터리 수명은 어떻게 되나요?"라고 물었을 때,
-   문서에는 "에너지 지속 시간은 12시간입니다"라고 적혀 있다면 어떨까요?

많은 임베딩 모델에서 "배터리 수명"과 "에너지 지속 시간"은 공간적으로 꽤 멀리 떨어져 있을 수 있으며, 이 때문에 관련 문서를 놓칠 수 있습니다. **다중 쿼리 검색(Multi-Query Retrieval)**은 LLM을 통해 사용자의 질문을 여러 가지 변형된 형태로 다시 작성하여 이러한 뉘앙스와 유의어의 차이를 극복합니다.

---

### 작동 원리: 프리즘 효과

사용자의 질문을 빛의 광선이라고 한다면, 다중 쿼리 검색은 프리즘과 같습니다:

1.  **생성 (Generation)**: LLM이 원래 질문을 받아 3~5개의 변형된 질문을 작성합니다. (예: "배터리가 얼마나 오래가나요?", "전원 사양", "배터리 성능" 등)
2.  **병렬 검색 (Parallel Retrieval)**: 이 모든 변형 질문들을 사용하여 벡터 데이터베이스에서 동시에 검색을 수행합니다.
3.  **합집합 (Union)**: 각 검색 결과들을 하나로 합치고 중복된 문서를 제거합니다.

여러 각도에서 검색함으로써 '완벽한' 정보 조각을 찾아낼 확률을 비약적으로 높입니다.

---

### 왜 다중 쿼리 검색을 써야 하나요?

-   **검색 견고성**: 사용자의 특정 단어 선택에 덜 의존하게 됩니다.
-   **개념 커버리지**: 다양한 표현 방식을 통해 전문 용어와 일반 용어 사이의 간극을 메울 수 있습니다.
-   **추가 데이터 불필요**: 데이터베이스를 다시 인덱싱할 필요 없이, 검색 시점에 LLM 호출만 한 번 추가하면 됩니다.

---

### LangChain에서의 구현

LangChain은 `MultiQueryRetriever`를 통해 이 기능을 기본적으로 제공합니다.

```python
from langchain.retrievers.multi_query import MultiQueryRetriever
from langchain_openai import ChatOpenAI

# 1. 재작성을 위한 LLM 설정
llm = ChatOpenAI(temperature=0)

# 2. 기본 검색기 설정
base_retriever = vectorstore.as_retriever()

# 3. MultiQueryRetriever로 감싸기
retriever_from_llm = MultiQueryRetriever.from_llm(
    retriever=base_retriever, 
    llm=llm
)

# 4. 검색 수행
unique_docs = retriever_from_llm.get_relevant_documents(
    query="이 기기의 작동 시간은 어떻게 되나요?"
)
```

---

### 요약

다중 쿼리 검색은 혼자서 도서관을 뒤지는 대신, 다섯 명의 조수를 고용해 각기 다른 키워드로 책을 찾게 하는 것과 같습니다. 적은 노력으로 RAG 시스템을 훨씬 더 '지능적'이고 사용자 친화적으로 만들어주는 강력한 기술입니다.

다음 포스트에서는 검색 결과에 대해 컴퓨터가 직접 필터링을 수행하게 하는 더 똑똑한 방법, **셀프 쿼리 검색(Self-Querying Retrievers)**에 대해 알아보겠습니다.

---

**다음 주제:** [셀프 쿼리 검색: 스스로 필터링하는 AI 검색기](/ko/study/self-querying-retrievers)
