---
title: "지식 그래프 + 벡터 DB — 두 가지를 함께 써야 하는 이유"
date: 2026-04-13
draft: false
tags: ["GraphRAG", "지식그래프", "벡터DB", "RAG", "AI아키텍처", "데이터구조"]
description: "벡터 검색(RAG)이 모든 질문에 답할 수 없는 이유를 아시나요? 관계를 이해하는 지식 그래프(Knowledge Graph)를 더해 AI의 기억력을 상향 평준화하는 GraphRAG 아키텍처를 상세히 해부합니다."
author: "Henry"
categories: ["AI 엔지니어링"]
series: ["Context Engineering 시리즈"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A futuristic glowing network of nodes and edges (Knowledge Graph) blending with a dense sea of floating particles (Vector Space). An AI robot is connecting dots between disparate pieces of information. High-contrast dark mode #0d1117, electric blue and neon orange, 16:9"
    file: "images/C/knowledge-graph-vector-hybrid-hero.png"
  - position: "comparison"
    prompt: "Comparison infographic: Left 'Vector DB' (Searching by similarity, blurry boundaries), Right 'Knowledge Graph' (Searching by relationship, clear nodes/edges). Middle 'Hybrid' combining both. Labeled in Korean. 16:9"
    file: "images/C/knowledge-graph-vs-vector.png"
  - position: "example"
    prompt: "Diagram showing a complex relationship: 'Henry (Person) -> Writes (Action) -> Blog (Object) -> About (Topic) -> AI (Field)'. Vector search might find 'Henry' or 'AI' but Graph handles the full chain. 16:9"
    file: "images/C/graph-relationship-chain.png"
---

이 글은 **Context Engineering 시리즈** 6편입니다.
→ 5편: [대화 이력이 독이 되는 순간 — 요약 압축 알고리즘 비교](/ko/study/C_context-memory/conversation-compression)

---

"우리 회사의 지난 3년간 핵심 사업 전략의 변화 흐름을 요약해줘."

이런 질문을 일반적인 벡터 기반 RAG에게 던지면 AI는 당황합니다. 관련 문서를 몇 개 가져오긴 하겠지만, 3년이라는 긴 시간 속의 '관계'와 '흐름'을 꿰뚫는 답변을 내놓기는 어렵죠.

그 이유는 벡터 검색(Vector Search)의 근본적인 한계 때문입니다. 오늘은 이 한계를 돌파하기 위한 비장의 카드, **지식 그래프(Knowledge Graph)**를 소개합니다.

---

### 벡터 DB의 맹점: "비슷한 건 찾지만, 관계는 모른다"

벡터 검색은 "의미적으로 가까운 조각"을 찾는 데는 천재적입니다. 하지만 '관계'를 추론하는 데는 젬병이죠.

- **벡터 검색**: "A와 비슷한 단어가 있는 문서를 다 가져와!"
- **지식 그래프**: "A와 연결된 B를 찾고, 그 B와 연결된 C를 찾아줘. 그리고 그들 사이의 관계가 '소유'인지 '협력'인지 알려줘."

전자가 점들의 모임이라면, 후자는 선들의 네트워크입니다.

---

### GraphRAG: 두 세계의 만남

가장 강력한 시스템은 이 두 가지를 합친 **Hybrid GraphRAG**입니다.

1. **글로벌 요약 (Graph)**: 지식 그래프 전체를 훑어 데이터의 거시적인 구조를 파악합니다. (예: "우리 회사의 주요 인물 관계도")
2. **로컬 검색 (Vector)**: 특정 질문에 가장 유사한 텍스트 조각을 찾아 세부 정보를 채웁니다. (예: "Henry가 쓴 최근 포스트의 결론")

---

### 왜 지식 그래프가 필요한가? (3가지 핵심 이유)

#### 1. 다단계 추론 (Multi-hop Reasoning)
"Henry가 다니는 회사의 위치는 어디야?"
벡터 DB는 'Henry' 문서는 찾지만, 회사 정보가 다른 문서에 있다면 연결하지 못할 수 있습니다. 그래프는 `Henry -> WorkAt -> Company -> LocatedIn -> Seoul`이라는 경로를 즉시 찾아냅니다.

#### 2. 맥락의 보존 (Context Preservation)
청킹(Chunking) 과정에서 텍스트가 잘리면 맥락이 소실됩니다. 그래프는 엔티티(Entity)를 중심으로 정보를 저장하기 때문에, 정보가 아무리 파편화되어도 관계망을 통해 맥락을 복원할 수 있습니다.

#### 3. 거시적 질문에 대한 답변 (Global Summarization)
"이 문서 전체의 핵심 주제는 뭐야?"
벡터 DB는 관련 조각을 Top-K개만 가져오기 때문에 전체를 보지 못합니다. 그래프는 전체 노드들의 군집(Community)을 분석하여 데이터 전체의 조감도를 그려낼 수 있습니다.

---

### 2026년의 트렌드: Graph-Native AI

마이크로소프트의 GraphRAG 논문 이후, 업계는 단순히 벡터만 쓰는 단계에서 그래프를 결합하는 단계로 빠르게 넘어가고 있습니다. Neo4j, FalkorDB 같은 그래프 DB들이 AI 에이전트의 핵심 저장소로 부상하는 이유이기도 하죠.

#### 구현 팁:
- 처음부터 모든 데이터를 그래프로 만들려고 하지 마세요. 비용이 많이 듭니다.
- **Entity Extraction**: LLM을 통해 문서에서 주요 인물, 장소, 개념을 뽑아내고 그들 사이의 관계만 먼저 정의하는 것부터 시작하세요.

---

### 결론

벡터 DB가 AI의 **'직관'**이라면, 지식 그래프는 AI의 **'논리'**입니다. 이 두 가지가 만날 때, 비로소 AI는 파편화된 정보를 넘어 전체를 이해하는 통찰력을 가질 수 있습니다.

---

**다음 글:** ["모른다"고 말하는 AI 만들기 — Confident Hallucination 차단법](/ko/study/C_context-memory/rag-i-dont-know-trigger)
