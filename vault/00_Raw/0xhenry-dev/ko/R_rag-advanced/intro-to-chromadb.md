---
title: "ChromaDB 소개: 우리를 위한 첫 번째 로컬 벡터 저장소"
date: 2026-04-11
draft: false
tags: ["ChromaDB", "벡터DB", "Python", "로컬AI"]
description: "로컬 RAG 시스템 구축 시 ChromaDB가 왜 최고의 선택인지, 그리고 어떻게 몇 분 만에 설정을 완료할 수 있는지 설명합니다."
author: "Henry"
categories: ["AI 엔지니어링"]
---

### 서론

RAG의 여정에서 우리는 지금까지 텍스트를 자르는 법(청킹)과 이를 숫자로 바꾸는 법(임베딩)을 배웠습니다. 이제 그 숫자들을 효율적으로 저장하고 검색할 수 있는 '공간'이 필요합니다.

AI 애플리케이션 개발을 위해 태어난 오픈소스 임베딩 데이터베이스, **ChromaDB**를 소개합니다.

---

### 왜 ChromaDB인가?

Pinecone, Milvus, Weaviate 등 수많은 벡터 데이터베이스가 있지만, ChromaDB가 입문자들에게 사랑받는 이유는 명확합니다:

1.  **로컬 우선(Local-First)**: 별도의 클라우드 계정이나 API 키 없이도 내 노트북에서 완전히 실행할 수 있습니다.
2.  **단순함**: 사용법이 매우 직관적입니다. 단 몇 줄의 Python 코드만으로 영구적인 데이터베이스를 시작할 수 있습니다.
3.  **가벼움**: 복잡한 Docker 설정 없이도 `pip` 설치만으로 바로 구동 가능합니다. (물론 서버 모드도 지원합니다.)
4.  **확장성**: LangChain, LlamaIndex와 같은 주요 AI 프레임워크와 완벽하게 통합됩니다.

---

### ChromaDB 설치하기

Python이 설치되어 있다면 다음 명령어로 간단히 설치할 수 있습니다:

```bash
pip install chromadb
```

---

### Python에서 ChromaDB 사용하기

컬렉션을 만들고, 문서를 추가하고, 검색하는 가장 기본적인 코드 예시입니다.

```python
import chromadb

# 1. 클라이언트 초기화 (데이터 영구 저장 경로 지정)
client = chromadb.PersistentClient(path="./my_chroma_db")

# 2. 컬렉션 생성 (데이터를 담는 바구니)
collection = client.get_or_create_collection(name="tech_blog_posts")

# 3. 문서 추가
collection.add(
    documents=["RAG는 AI 답변의 근거를 마련해주는 기술입니다.", "ChromaDB는 벡터 데이터베이스입니다."],
    metadatas=[{"source": "rag_post"}, {"source": "chroma_post"}],
    ids=["id1", "id2"]
)

# 4. 데이터 검색 (Query)
results = collection.query(
    query_texts=["ChromaDB가 무엇인가요?"],
    n_results=1
)

print(results)
```

---

### 핵심 개념 정리

-   **Client**: ChromaDB와 소통하는 관문입니다.
-   **Collection**: 전통적인 DB의 '테이블(Table)'과 같습니다. 관련 있는 임베딩들을 그룹화하는 곳입니다.
-   **Persistent vs. Ephemeral**: 데이터를 하드디스크에 저장할지(Persistent), 아니면 메모리(RAM)에만 임시로 보관할지 선택할 수 있습니다.
-   **Metadatas**: 텍스트와 함께 작성자, 날짜, URL 등 추가 정보를 저장하여 나중에 필터링하는 용도로 사용할 수 있습니다.

### 요약

ChromaDB는 로컬 RAG 시스템을 구축하는 모든 개발자에게 최적의 시작점입니다. 벡터 검색의 복잡함을 걷어내고, 여러분이 애플리케이션의 로직에만 집중할 수 있게 도와줍니다.

다음 포스트에서는 수백만 건의 대규모 문서를 빛의 속도로 검색해야 할 때 유용한 대안, **FAISS**에 대해 알아보겠습니다.

---

**다음 주제:** [고성능 검색을 위한 FAISS 활용 가이드](/ko/study/faiss-tutorial)
