---
title: "AI 게이트웨이 패턴 — PII 스크러빙, RBAC, 감사 로그를 한 곳에"
date: 2026-04-14
draft: false
tags: ["AI Gateway", "인프라", "보안", "PII", "RBAC", "감사로그", "기업용AI"]
description: "수십 개의 에이전트가 각자 API 키를 들고 모델에 접근하게 두실 건가요? 중앙에서 보안, 비용, 로그를 통제하는 'AI 게이트웨이' 아키텍처의 필요성과 구현 방법을 다룹니다."
author: "Henry"
categories: ["MCP & 보안"]
series: ["MCP & AI 보안"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A massive glowing portal (the Gateway) in a dark server rack. Information flows through it, turning from red (raw) to green (scrubbed) as it passes. Symbols for Shield, Key, and Log are integrated. Dark mode #0d1117, 16:9"
    file: "images/S/ai-gateway-pattern-hero.png"
  - position: "arch"
    prompt: "Architecture: App -> AI Gateway (Auth, PII Masking, Rate Limit) -> LLM Providers (OpenAI, Anthropic). 16:9"
    file: "images/S/ai-gateway-architecture.png"
---

이 글은 **MCP & AI 보안 시리즈** 6편입니다.
→ 5편: [프롬프트 인젝션 공격 — 외부 데이터가 AI를 납치하는 방법](/ko/study/S_mcp-security/prompt-injection-attacks)

---

기업에서 AI 에이전트를 도입할 때 가장 큰 고민은 **거버넌스(Governance)**입니다. 
"어떤 사원이 어떤 데이터를 모델에게 보냈지? 실수로 고객 전화번호가 유출되지는 않았나? 이번 달 AI 비용은 누가 제일 많이 썼지?"

이 모든 질문에 답하기 위해 개별 앱을 전수조사하는 것은 불가능합니다. 그래서 우리는 **AI 게이트웨이(AI Gateway)**라는 중앙 통제실을 세워야 합니다.

---

### 1. AI 게이트웨이란 무엇인가?

전통적인 API 게이트웨이와 유사하지만, **LLM 요청과 응답의 '내용'을 이해하고 가공**한다는 점이 다릅니다. 모든 에이전트는 모델 제공사로 직접 통신하지 않고, 반드시 이 게이트웨이를 거쳐야 합니다.

---

### 2. 게이트웨이가 수행하는 3대 보안 업무

#### PII 스크러빙 (Personal Identifiable Information Scrubbing)
에이전트가 모델에게 요청을 보내기 전, 본문에서 이메일, 전화번호, 주민번호 등을 자동으로 감지하여 `[REDACTED]` 처리합니다. 데이터 유출을 원천 봉쇄하는 가장 강력한 수단입니다.

#### RBAC (Role-Based Access Control)
사원 등급에 따라 사용할 수 있는 모델을 제한합니다. 
- **인턴**: GPT-4o-mini (저비용 모델)만 사용 가능.
- **개발팀**: Claude 3.5 Sonnet (고성능 모델) 사용 가능.
- **HR팀**: 사내 보안 문서 접근 권한 부여.

#### 감사 로그 및 비용 할당 (Audit Log & Cost Allocation)
모든 요청의 프롬프트와 응답을 기록하여 나중에 문제가 생겼을 때 '누가, 언제, 왜' 그런 답변이 나왔는지 역추적합니다. 또한 API 키별로 사용량을 집계하여 팀별로 비용을 배분합니다.

---

### 3. 실전 구현 도구

바닥부터 짤 수도 있지만, 이미 검증된 오픈소스를 활용하는 것이 현명합니다.
- **Portkey / Helicone**: 클라우드 기반 AI 게이트웨이 서비스.
- **Kong API Gateway**: AI 플러그인을 사용하여 기존 게이트웨이를 확장.
- **Cloudflare AI Gateway**: 가장 빠르고 쉽게 적용 가능한 엣지 기반 게이트웨이.

---

### Henry의 팁: "캐싱(Caching)으로 돈을 벌어라"

AI 게이트웨이는 보안 도구일 뿐만 아니라 **비용 절감 도구**이기도 합니다. 자주 묻는 질문(예: "우리 회사 휴가 규정 알려줘")에 대한 응답을 게이트웨이 단에서 캐싱하면, 모델 호출 비용을 0원으로 만들고 응답 속도를 100배 빠르게 만들 수 있습니다.

---

### 결론

에이전트의 수가 늘어날수록 통제력은 약해집니다. 폭발적으로 늘어나는 AI 트래픽을 감당하기 위해, 지금 바로 강력한 **AI 게이트웨이**라는 방파제를 구축하세요. 그것이 기업용 AI 에이전트 운영의 시작입니다.

---

**다음 글:** [RAG 데이터 오염 공격 — 벡터 DB를 독살하는 법과 방어](/ko/study/S_mcp-security/rag-data-poisoning)
