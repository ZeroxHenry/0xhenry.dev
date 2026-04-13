---
title: "Re-ranking 없이 RAG 정확도 올리기 — Query Transformation 전략"
date: 2026-04-14
draft: false
tags: ["Query Transformation", "HyDE", "RAG", "프롬프트엔지니어링", "검색최적화"]
description: "사용자가 던진 질문이 항상 최선은 아닙니다. 검색하기 좋은 형태로 질문을 재작성하거나, 미리 답변을 예상해 보는 'Query Transformation' 기술로 검색 정확도를 비약적으로 높이는 법을 다룹니다."
author: "Henry"
categories: ["RAG 심화"]
series: ["RAG 심화 시리즈"]
series_order: 8
images_needed:
  - position: "hero"
    prompt: "A blurred, messy question mark being passed through a magic lens. On the other side, it turns into a sharp, golden key. Dark mode #0d1117, 16:9"
    file: "images/R/query-transformation-rag-hero.png"
---

이 글은 **RAG 심화 시리즈** 8편입니다.
→ 7편: [멀티모달 RAG — 이미지와 텍스트를 함께 검색하는 파이프라인](/ko/study/R_rag-deep-dive/multimodal-rag-pipeline)

---

보통 RAG에서 정확도를 올리려면 검색된 결과의 순위를 다시 매기는 **Re-ranking** 모델을 도입합니다. 하지만 Re-ranking은 비용이 비싸고 레이턴시가 깁니다. 

오늘은 Re-ranking 단계에 가기도 전, 즉 **검색기(Retriever)에 넣기 전**에 질문 자체를 교정해서 정확도를 올리는 **Query Transformation** 기법 3가지를 소개합니다.

---

### 1. HyDE (Hypothetical Document Embeddings)

가장 혁신적인 방식입니다. 유저의 질문으로 바로 검색하는 대신, 먼저 LLM에게 **"가상의 답변을 한 문단만 써줘"**라고 시킵니다. 그리고 그 **가상의 답변**으로 벡터 DB를 검색합니다.
- **왜?**: "질문 벡터"와 "답변 벡터"보다 "답변 벡터"와 "답변 벡터" 사이의 거리가 훨씬 가깝기 때문입니다.

---

### 2. Multi-Query (질문 확장)

유저의 질문 하나를 의미가 비슷한 3~5개의 다른 질문으로 변환합니다.
- **원본**: "휴가 규정 알려줘"
- **변환**: "연차 사용 규칙", "경조 휴가 가이드라인", "휴가 신청 프로세스"
이후 이 5개의 질문으로 모두 검색한 뒤 결과물을 합칩니다. 검색 실패(Miss) 확률을 혁신적으로 낮춰줍니다.

---

### 3. Step-back Prompting (추상화)

너무 구체적인 질문은 검색이 잘 안 될 때가 있습니다. 이럴 땐 한 단계 더 넓은 개념의 질문을 생성합니다.
- **원본**: "애플 맥북 M3 Pro 14인치 배터리 수명 어때?"
- **추상화**: "맥북 M3 시리즈의 전반적인 배터리 성능 지표"
넓은 범위의 문서를 먼저 찾아서 모델에게 풍부한 배경 지식을 제공하는 전략입니다.

---

### Henry의 조언: "질문은 원석이다"

유저의 말은 다듬어지지 않은 원석입니다. 이를 그대로 검색기에 던지지 마세요. 검색기가 가장 좋아하는 '공학적 언어'로 질문을 가공하는 과정을 추가하는 것만으로도, 비싼 Re-ranking 모델 없이 놀라운 결과를 얻을 수 있습니다.

---

**다음 글:** [코드베이스 RAG — IDE를 대체하는 코드 검색 에이전트 구축](/ko/study/R_rag-deep-dive/codebase-rag-agent)
