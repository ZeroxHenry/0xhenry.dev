---
title: "크로스 인코더: 프로급 RAG 정확도를 위한 최후의 퍼즐"
date: 2026-04-11
draft: false
tags: ["리랭킹", "크로스인코더", "바이인코더", "자연어처리", "검색"]
description: "단순한 검색은 시작일 뿐입니다. 리랭킹(Re-ranking)을 통해 노이즈를 제거하고 AI에게 가장 완벽한 컨텍스트를 제공하는 방법을 알아봅니다."
author: "Henry"
categories: ["AI 엔지니어링"]
---

### 서론

RAG 시스템을 구축하고 하이브리드 검색까지 적용했습니다. 하지만 사용자의 질문에 답변할 때 가끔씩 검색된 청크들 사이에 끼어 있는 관계없는 정보 때문에 AI가 엉뚱한 소리를 하지는 않나요? 이는 벡터 검색에 사용되는 **바이 인코더(Bi-Encoders)**가 속도는 빠르지만, 정밀한 관련성보다는 전반적인 유사도에만 집중하기 때문입니다.

프로 수준의 정확도에 도달하기 위해서는 **리랭커(Re-ranker)**, 그중에서도 **크로스 인코더(Cross-Encoder)**가 필요합니다.

---

### 바이 인코더 vs. 크로스 인코더

리랭킹을 이해하려면 먼저 두 종류의 모델 차이를 알아야 합니다.

1.  **바이 인코더 (스프린터)**: 문서들을 각각 독립적으로 벡터로 변환합니다. 검색할 때 컴퓨터는 단순히 벡터 간의 거리만 계산합니다. 번개처럼 빠르지만 의미 파악의 깊이는 얕습니다.
2.  **크로스 인코더 (학자)**: 질문과 문서를 **쌍(Pair)**으로 묶어 함께 처리합니다. 질문과 텍스트 사이의 깊은 의미적 상호작용을 파악할 수 있습니다. 엄청나게 정확하지만, 수만 개의 문서를 검색하기에는 너무 느립니다.

### 2단계 검색 파이프라인 (Two-Stage Retrieval)

속도와 정확도를 모두 잡기 위해 우리는 2단계 프로세스를 사용합니다:

-   **1단계: 검색 (바이 인코더)**: 수백만 개의 문서 중 가장 유사한 100개를 빠르게 찾아냅니다. (속도 중시)
-   **2단계: 리랭킹 (크로스 인코더)**: 찾아낸 100개의 후보군을 크로스 인코더로 다시 순위를 매겨 가장 정확한 3~5개를 골라냅니다. (정밀도 중시)

---

### 왜 리랭킹이 게임 체인저인가요?

1.  **할루시네이션 방지**: 상위 3~5개의 청크가 정말로 질문과 관련 있다는 확신이 생기면, LLM이 거짓말(환각)을 할 확률이 급격히 줄어듭니다.
2.  **효율적인 컨텍스트 압축**: 1단계에서 넉넉하게 데이터를 뽑아온 뒤, 필요한 것만 날카롭게 정제해서 LLM에게 전달할 수 있습니다.
3.  **모호한 질문 처리**: 크로스 인코더는 단순한 벡터 거리보다 질문의 미묘한 뉘앙스를 훨씬 더 잘 이해합니다.

---

### 구현 방법: LangChain과 FlashRank

Cohere의 Rerank API를 쓸 수도 있지만, 0xHenry의 철학인 로컬 실행을 위해 `FlashRank`나 `SentenceTransformers` 같은 로컬 라이브러리도 훌륭한 대안입니다.

```python
from langchain.retrievers import ContextualCompressionRetriever
from langchain.retrievers.document_compressors import FlashRankRerank

# 1. 기본 검색기 설정 (Chroma 등)
base_retriever = vectorstore.as_retriever()

# 2. 리랭커 설정
compressor = FlashRankRerank()

# 3. 압축 검색기 생성
compression_retriever = ContextualCompressionRetriever(
    base_compressor=compressor, 
    base_retriever=base_retriever
)

# 4. 검색 및 리랭킹 실행
compressed_docs = compression_retriever.get_relevant_documents("크로스 인코딩은 어떻게 작동하나요?")
```

### 요약

검색이 건더미 속에서 바늘을 찾는 일이라면, 리랭킹은 찾은 바늘들을 하나하나 검사해서 우리가 원한 진짜 바늘이 맞는지 확인하는 과정입니다. 이는 현재 RAG 시스템의 정확도를 높이는 가장 효과적인 방법입니다.

다음 포스트에서는 검색의 구조적 패턴인 **부모 문서 검색 패턴(Parent Document Retrieval)**에 대해 알아보겠습니다.

---

**다음 주제:** [부모 문서 검색: 의미의 단절 없는 정밀한 검색](/ko/study/parent-document-retrieval)
