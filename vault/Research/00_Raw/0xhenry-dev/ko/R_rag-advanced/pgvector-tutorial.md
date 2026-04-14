---
title: "PGVector: 가장 신뢰받는 PostgreSQL에 AI의 숨결 불어넣기"
date: 2026-04-11
draft: false
tags: ["PostgreSQL", "PGVector", "데이터베이스", "벡터검색"]
description: "PGVector 확장 기능을 사용하여 PostgreSQL 데이터베이스 내부에서 직접 벡터 유사성 검색을 수행하는 방법을 알아봅니다."
author: "Henry"
categories: ["AI 엔지니어링"]
---

### 서론

지금까지 우리는 ChromaDB나 FAISS 같은 전용 벡터 데이터베이스들을 살펴봤습니다. 하지만 만약 여러분이 이미 PostgreSQL 기반의 거대한 서비스를 운영 중이라면 어떨까요? 오직 AI 기능을 위해서 별도의 데이터베이스를 하나 더 관리해야 할까요?

이런 고민을 해결해 주는 것이 바로 **PGVector**입니다. PostgreSQL 확장 기능을 통해 기존의 관계형 데이터(사용자, 주문 등)와 AI 임베딩을 한곳에 저장하고 검색할 수 있게 해줍니다.

---

### 왜 PGVector인가요?

1.  **데이터 통합**: 기술 스택에 도구를 더 추가할 필요가 없습니다. 하나의 DB가 사용자 정보부터 AI 벡터까지 모두 처리합니다.
2.  **ACID 준수**: PostgreSQL이 자랑하는 세계 최고 수준의 신뢰성, 백업, 트랜잭션 기능을 AI 데이터에도 그대로 적용할 수 있습니다.
3.  **관계형 쿼리의 강력함**: 벡터와 일반 테이블을 자유롭게 조인(Join)할 수 있습니다. "가전 카테고리에 있는 상품 중, 이 설명과 의미적으로 가장 비슷한 상품들을 찾아줘"와 같은 쿼리가 매우 효율적으로 가능합니다.
4.  **운영의 성숙도**: 이미 익숙한 PostgreSQL 관리 및 확장 기법을 그대로 사용할 수 있습니다.

---

### 시작하기

PGVector를 사용하려면 먼저 데이터베이스에서 확장 기능을 활성화해야 합니다:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

### 벡터 저장하기

이제 `vector`라는 새로운 컬럼 타입을 사용할 수 있습니다. 이때 차원 수(예: nomic-embed-text의 경우 768)를 지정해야 합니다.

```sql
CREATE TABLE documents (
    id serial PRIMARY KEY,
    content text,
    embedding vector(768)
);
```

### PGVector로 검색하기

표준 SQL 구문을 그대로 사용합니다. `<->` 연산자는 유클리드 거리를, `<=>` 연산자는 코사인 유사도 거리를 계산합니다.

```sql
SELECT content FROM documents 
ORDER BY embedding <=> '[0.1, 0.2, 0.3, ...]' 
LIMIT 5;
```

---

### 성능을 위한 인덱싱

데이터가 늘어나면 인덱스를 추가해야 합니다. PGVector는 **IVFFlat**과 **HNSW** 인덱싱을 지원하며, 일반적으로 속도와 정확도의 균형이 좋은 HNSW 방식이 권장됩니다.

```sql
CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops);
```

---

### 요약

PGVector는 정형 데이터의 '구세계'와 AI의 '신세계'를 잇는 다리입니다. 새로운 데이터베이스 시스템을 배우는 부담 없이, 기존 애플리케이션에 AI 기능을 빠르게 추가하고 싶은 개발자들에게 최고의 선택지입니다.

다음 포스트에서는 벡터 DB 업계의 거물들, **엔터프라이즈급 성능을 자랑하는 Weaviate와 Milvus**에 대해 알아보겠습니다.

---

**다음 주제:** [Weaviate & Milvus: 확장 가능한 AI 인프라 구축](/ko/study/enterprise-vector-dbs)
