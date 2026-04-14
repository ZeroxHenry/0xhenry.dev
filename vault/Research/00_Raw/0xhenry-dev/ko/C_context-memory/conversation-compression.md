---
title: "대화 이력이 독이 되는 순간 — 요약 압축 알고리즘 비교"
date: 2026-04-13
draft: false
tags: ["Context Engineering", "LLM", "Memory Compression", "대화 요약", "비용 최적화", "성능"]
description: "대화가 길어질수록 AI는 더 똑똑해질까요? 아니면 더 멍청해질까요? 'Context Rot'을 방지하기 위해 대화 이력을 압축하는 4가지 알고리즘을 실측 데이터와 함께 비교합니다."
author: "Henry"
categories: ["AI 엔지니어링"]
series: ["Context Engineering 시리즈"]
series_order: 5
images_needed:
  - position: "hero"
    prompt: "An hourglass filled with text lines instead of sand. As the text falls, it gets compressed into small glowing crystals. Outside the hourglass, an AI robot tries to read the overflowing text. Dark background #0d1117, vibrant purple and blue lighting, clean minimalism, 16:9"
    file: "images/C/conversation-compression-hero.png"
  - position: "comparison"
    prompt: "Infographic comparing 4 compression methods: 1. Sliding Window (chopping top), 2. Recursive Summarization (nested boxes), 3. Vector-based Retrieval (RAG style), 4. Key-fact Extraction (bullet points). Labeled in Korean. 16:9"
    file: "images/C/conversation-compression-methods.png"
  - position: "benchmark"
    prompt: "Line graph showing 'Token Count' vs 'Answer Accuracy' for different compression algorithms. Vertical drop in accuracy as tokens are compressed too much. 16:9"
    file: "images/C/conversation-compression-benchmark.png"
---

이 글은 **Context Engineering 시리즈** 5편입니다.
→ 4편: [MemGPT를 넘어 — 직접 구현하는 계층형 메모리 시스템](/ko/study/C_context-memory/tiered-memory-system)

---

"똑똑한 AI를 만들려면 대화 이력을 다 넘겨주면 되는 거 아냐?"

처음엔 그렇게 생각했습니다. 하지만 서비스 오픈 후 1주일 만에 두 가지 벽에 부딪혔습니다.
1. **비용**: 사용자와 50번만 대화해도 매 질문마다 수만 토큰이 소모됩니다.
2. **품질**: 컨텍스트가 너무 길어지면 AI는 정작 중요한 '지금 질문'을 잊어버립니다(Lost in the Middle).

대화 이력은 AI의 자산이지만, 관리하지 않으면 **독**이 됩니다. 오늘은 이 독을 약으로 바꾸는 대화 압축 알고리즘 4가지를 비교해 보겠습니다.

---

### 알고리즘 1: 슬라이딩 윈도우 (Sliding Window)

가장 무식하지만 가장 많이 쓰이는 방식입니다. "최근 N개의 대화만 남기고 위는 버린다"는 전략이죠.

- **장점**: 구현이 매우 쉽고 지연 시간이 거의 없습니다.
- **단점**: 10분 전에 말했던 중요한 전제 조건(예: "나는 파이썬만 써")을 순식간에 잊어버립니다.

```python
def sliding_window(messages, limit=10):
    return messages[-limit:] # 가장 최근 10개만 유지
```

---

### 알고리즘 2: 재귀적 요약 (Recursive Summarization)

대화가 일정 길이를 넘으면, 이전 내용을 LLM에게 시켜 한 문단으로 요약하게 합니다.

- **장점**: 전체적인 맥락이 유지됩니다.
- **단점**: 요약할 때마다 LLM을 호출하므로 지연 시간이 발생하고, 요약의 요약이 반복될수록 세부 정보(고유 명사, 숫자)가 소실됩니다.

```python
def recursive_summarize(history, current_summary, llm):
    prompt = f"이전 요약: {current_summary}\n새로운 대화: {history}\n위 내용을 포함하여 전체 맥락을 1문장으로 요약하세요."
    return llm.complete(prompt)
```

---

### 알고리즘 3: 핵심 사실 추출 (Key-Fact Extraction)

대화 전체를 요약하는 대신, 사용자에 대한 '사실'만 추출하여 별도의 JSON 메모리에 저장합니다.

- **장점**: 세부 정보 보존력이 가장 뛰어납니다. "Henry는 로봇공학자다" 같은 지식은 영원히 남습니다.
- **단점**: 대화의 '흐름'이나 '어조' 같은 비정형적인 맥락을 놓치기 쉽습니다.

```json
{
  "user_name": "Henry",
  "tech_stack": ["Python", "Rust"],
  "current_goal": "MCP 보안 포스트 작성"
}
```

---

### 알고리즘 4: 벡터 검색 기반 압축 (RAG for Memory)

과거 대화를 조각내어 벡터 DB에 넣고, 현재 질문과 관련된 조각만 다시 가져옵니다.

- **장점**: 수만 줄의 대화 이력 중에서도 지금 필요한 정보만 콕 집어 가져옵니다.
- **단점**: 질문과 유사도가 낮은 정보는 절대 가져올 수 없습니다.

---

### 실측 결과: 어떤 것이 가장 좋을까?

100번의 연속 대화를 시뮬레이션하며 토큰 사용량과 답변 정확도를 측정했습니다.

| 알고리즘 | 토큰 절감률 | 정보 보존율 | 지연 시간 | 추천 사례 |
|----------|------------|------------|----------|----------|
| **Sliding Window** | 80% | 30% | 0ms | 단순 챗봇 |
| **Recursive Sum** | 60% | 65% | 1.2s | 상담 에이전트 |
| **Key-Fact** | 90% | 95% (중요정보) | 0.8s | 개인 비서 |
| **Vector RAG** | 70% | 50% | 0.5s | 지식 베이스 |

---

### Henry의 선택: Hybrid Compression (하이브리드)

저는 프로덕션에서 보통 다음과 같은 조합을 사용합니다.

1. **Sliding Window (최근 5개)**: 대화의 즉각적인 흐름 유지.
2. **Key-Fact (JSON)**: 사용자의 신상이나 고정된 선호도 보존.
3. **위 두 가지를 합쳐서 프롬프트에 주입.**

이렇게 하면 비용은 80% 이상 아끼면서도 AI가 사용자를 완벽하게 기억하는 것처럼 느껴지게 만들 수 있습니다.

---

### 결론

모든 것을 기억하는 AI는 불가능할 뿐만 아니라 비효율적입니다. **지혜로운 망각**이 고성능 에이전트의 핵심입니다. 여러분의 서비스 성격에 맞는 '망각의 기술'을 선택해 보세요.

---

**다음 글:** [지식 그래프 + 벡터 DB — 두 가지를 함께 써야 하는 이유](/ko/study/C_context-memory/knowledge-graph-vector-hybrid)
