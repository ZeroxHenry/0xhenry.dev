---
title: "멀티모달 RAG — 이미지와 텍스트를 함께 검색하는 파이프라인"
date: 2026-04-14
draft: false
tags: ["Multimodal", "RAG", "CLIP", "이미지검색", "GPT-4o", "AI아키텍처"]
description: "세상은 텍스트로만 이루어져 있지 않습니다. 차트, 도표, 사진이 포함된 문서를 어떻게 인덱싱하고 검색할 것인가? 텍스트와 이미지를 하나의 벡터 공간에서 다루는 멀티모달 RAG 구축법을 다룹니다."
author: "Henry"
categories: ["RAG 심화"]
series: ["RAG 심화 시리즈"]
series_order: 7
images_needed:
  - position: "hero"
    prompt: "A robotic eye scanning a desk filled with photos and paper documents. Both the photo of a dog and the word 'Dog' are glowing with the same energy. Dark mode #0d1117, 16:9"
    file: "images/R/multimodal-rag-pipeline-hero.png"
  - position: "logic"
    prompt: "Architecture: Images -> CLIP Encoder, Text -> CLIP Encoder. Both stored in Shared Vector Space. Query (Text/Image) -> Retrieval. 16:9"
    file: "images/R/multimodal-logic.png"
---

이 글은 **RAG 심화 시리즈** 7편입니다.
→ 6편: [Colbert & Late Interaction — Dense 검색의 다음 단계](/ko/study/R_rag-deep-dive/colbert-late-interaction)

---

최신 기술 문서는 텍스트보다 그림이 더 많은 정보를 담고 있곤 합니다. 하지만 많은 RAG 시스템은 여전히 그림을 무시하고 글자만 추출하죠. 

2026년의 에이전트는 **차트의 꺾은선**을 보고 데이터의 흐름을 읽을 수 있어야 합니다. 텍스트와 이미지를 조화롭게 처리하는 **멀티모달 RAG** 파이프라인의 핵심 전략 2가지를 소개합니다.

---

### 전략 1: 이미지 캡셔닝 (Image-to-Text)

가장 직관적인 방법입니다. 모든 이미지를 **GPT-4o** 같은 멀티모달 모델에게 보여주고, 그 내용을 텍스트로 설명(Captioning)하게 만든 뒤 그 텍스트를 벡터 DB에 넣는 방식입니다.
- **장점**: 기존의 텍스트 기반 RAG 시스템을 그대로 쓸 수 있음.
- **단점**: 이미지의 미세한 시각적 특징이 텍스트로 변환되는 과정에서 손실됨.

---

### 전략 2: 공유 벡터 공간 (CLIP / Multimodal Embedding)

**CLIP**이나 **ImageBind** 같은 모델을 사용하여 텍스트와 이미지를 **똑같은 좌표계** 위에 올리는 방식입니다. 
- "고양이"라는 단어의 벡터와 고양이 사진의 벡터가 공간상에서 아주 가깝게 위치하게 됩니다.
- **장점**: 텍스트로 사진을 찾거나, 사진으로 텍스트를 찾는 검색이 자유로움. 이미지의 날것 그대로의 정보를 보존함.

---

### 실전 구축 시 주의사항: 레이아웃 결합

이미지만 달랑 검색하면 문맥을 알 수 없습니다. 그 이미지가 **어떤 문단 근처에 있었는지** 메타데이터로 함께 저장해야 합니다. 에이전트가 "이 표는 제3장의 매출 분석 부분에서 가져온 거야"라는 맥락을 알아야 정확한 답변이 가능하기 때문입니다.

---

### Henry의 결론: "앞으로는 멀티모달이 기본값이다"

복잡한 대시보드 스크린샷이나 회로도를 분석해야 하는 에이전트를 만들고 있다면, 더 이상 텍스트에만 머무르지 마세요. 멀티모달 임베딩은 여러분의 RAG가 볼 수 없던 세상을 열어줄 것입니다.

---

**다음 글:** [Re-ranking 없이 RAG 정확도 올리기 — Query Transformation 전략](/ko/study/R_rag-deep-dive/query-transformation-rag)
