# 0xHenry 블로그 콘텐츠 플랜 v2.0 — 완전 리뉴얼

> **블로그 정체성**: "남들은 성공 튜토리얼을 씁니다. 0xHenry는 실패와 그 해결을 씁니다."
> **선점 원칙**: 한국어 블로그에 거의 없는 주제만 → 압도적 정보량과 정확성으로 승부

---

## ❌ 삭제된 과포화 주제 (작성 금지 목록)

> 아래 주제들은 Velog/Tistory에 수백 개 이상 존재. 써도 묻힌다.

| 삭제된 주제 | 이유 |
|------------|------|
| RAG Explained for Everyone | 기초 설명 — 수백 개 존재 |
| Building your first RAG with Python & Ollama | 입문 튜토리얼 — 과포화 |
| Introduction to ChromaDB | 단순 설치 가이드 — 공식 문서로 대체 가능 |
| What is an AI Agent? | 개론 — 모두가 쓰는 주제 |
| ReAct Pattern: Reasoning and Acting | 기초 개념 설명 — 과포화 |
| Ollama vs vLLM: Choosing your server | 단순 비교 — 레드오션 |
| LoRA and QLoRA for local fine-tuning | 기초 튜토리얼 — 과포화 |
| RLHF (Reinforcement Learning from Human Feedback) | 개념 설명 — 위키 수준 |
| Deployment on AWS SageMaker | 클라우드 벤더 가이드 — 공식 문서 대체 가능 |
| Digital Twins + AI | 추상적 개론 — 차별성 없음 |
| Smart Cities and AI Surveillance | 미래 전망 — 검증 불가 |

---

## ✅ 완성된 포스트

- [x] **Context Engineering: 프롬프트 엔지니어링은 죽었다** (KO + EN) — `context-engineering.md`
- [x] **MCP 보안 구멍: Tool Poisoning 공격 시뮬레이션** (KO + EN) — `mcp-tool-poisoning.md`
- [x] **AI 에이전트가 이메일을 두 번 보낸 이유 — Idempotency 설계** (KO + EN) — `agent-idempotency.md`

---

## 🔥 CHAPTER 1: Context & Memory 아키텍처 (10편)
> **왜 이 챕터가 필요한가**: Context Engineering은 2026년 가장 중요한 신개념.
> 한국어 심화 포스트 거의 없음. 독점 선점 가능.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| C-01 | **Context Engineering: 프롬프트 엔지니어링은 죽었다** | `context-engineering.md` | ✅ |
| C-02 | **LLM이 "멍청해지는" 이유 — Context Rot 완전 해부** | `context-rot-lost-in-middle.md` | ✅ |
| C-03 | **AI의 RAM 관리법: 동적 컨텍스트 조립 패턴 5가지** | `dynamic-context-assembly.md` | ✅ |
| C-04 | **MemGPT를 넘어: 직접 구현하는 계층형 메모리 시스템** | `tiered-memory-system.md` | ⬜ |
| C-05 | **대화 이력이 독이 되는 순간 — 요약 압축 알고리즘 비교** | `conversation-compression.md` | ⬜ |
| C-06 | **지식 그래프 + 벡터 DB: 두 가지를 함께 써야 하는 이유** | `knowledge-graph-vector-hybrid.md` | ⬜ |
| C-07 | **"모른다"고 말하는 AI 만들기 — Confident Hallucination 차단법** | `rag-i-dont-know-trigger.md` | ⬜ |
| C-08 | **무한 컨텍스트 vs RAG: 100만 토큰 시대에도 RAG가 필요한가** | `infinite-context-vs-rag.md` | ⬜ |
| C-09 | **멀티 유저 메모리 충돌 — 공유 에이전트에서 기억을 격리하는 법** | `multi-user-memory-isolation.md` | ⬜ |
| C-10 | **AI가 "기억해줘"라고 했을 때 실제로 일어나는 일** | `how-llm-memory-actually-works.md` | ⬜ |

---

## 🔥 CHAPTER 2: AI 에이전트 신뢰성 & 운영 (12편)
> **왜 이 챕터가 필요한가**: AI 에이전트의 "실패 모드"를 다루는 한국어 포스트 극히 드묾.
> 실제 프로덕션 운영 경험 기반 콘텐츠는 신뢰도와 SEO 모두 최강.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| A-01 | **AI 에이전트가 이메일을 두 번 보낸 이유 — Idempotency 설계** | `agent-idempotency.md` | ✅ |
| A-02 | **내 AI 에이전트가 서서히 멍청해졌다 — LLM Drift 감지법** | `llm-agent-drift-detection.md` | ✅ |
| A-03 | **에이전트에게 Ctrl+Z를 — Saga 패턴으로 롤백 구현하기** | `agent-saga-rollback.md` | ⬜ |
| A-04 | **도구 호출 실패를 "성공했다"고 우기는 AI — Truthy Text 문제** | `agent-truthy-text-failure.md` | ⬜ |
| A-05 | **AI 에이전트의 무한 루프 — 비용 폭탄 방지 설계** | `agent-infinite-loop-prevention.md` | ⬜ |
| A-06 | **에이전트 트레이싱: 복잡한 멀티스텝 오류를 추적하는 법** | `agent-distributed-tracing.md` | ⬜ |
| A-07 | **Human-in-the-Loop의 진짜 구현법 — 단순 승인버튼이 아니다** | `human-in-the-loop-design.md` | ⬜ |
| A-08 | **멀티 에이전트 충돌: 두 에이전트가 같은 DB를 동시에 수정할 때** | `multi-agent-conflict.md` | ⬜ |
| A-09 | **에이전트 비용 계산서: GPT-4o 에이전트 운영 1개월 청구서 공개** | `agent-cost-breakdown.md` | ⬜ |
| A-10 | **Supervisor 패턴 vs Swarm 패턴: 멀티 에이전트 아키텍처 선택 기준** | `multi-agent-architecture-choice.md` | ⬜ |
| A-11 | **AI 에이전트의 법적 책임은 누구에게 있는가** | `agentic-ai-legal-liability.md` | ⬜ |
| A-12 | **프롬프트를 코드처럼 관리하라 — Prompt Versioning 시스템 구축** | `prompt-as-code-versioning.md` | ⬜ |

---

## 🔥 CHAPTER 3: MCP & AI 인프라 보안 (8편)
> **왜 이 챕터가 필요한가**: MCP는 2026년 표준이 됐지만 보안 심화 포스트 한국어 **0개**.
> 보안 + 신기술 조합은 검색 유입 최강 조합.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| S-01 | **MCP 보안 구멍: Tool Poisoning 공격 시뮬레이션** | `mcp-tool-poisoning.md` | ✅ |
| S-02 | **MCP vs REST API: 언제 MCP를 쓰고 언제 쓰지 말아야 하는가** | `mcp-vs-rest-api.md` | ⬜ |
| S-03 | **MCP Context Bloat: 도구가 많을수록 에이전트가 느려지는 이유** | `mcp-context-bloat.md` | ⬜ |
| S-04 | **OAuth 2.1로 MCP 서버를 프로덕션 수준으로 보안화하기** | `mcp-oauth21-security.md` | ⬜ |
| S-05 | **프롬프트 인젝션 공격: 외부 데이터가 AI를 납치하는 방법** | `prompt-injection-attacks.md` | ⬜ |
| S-06 | **AI 게이트웨이 패턴: PII 스크러빙, RBAC, 감사 로그를 한 곳에** | `ai-gateway-pattern.md` | ⬜ |
| S-07 | **RAG 데이터 오염 공격 — 벡터 DB를 독살하는 법과 방어** | `rag-data-poisoning.md` | ⬜ |
| S-08 | **Linux Foundation이 MCP를 인수한 의미 — AI 표준 전쟁의 현재** | `mcp-linux-foundation-governance.md` | ⬜ |

---

## 🔥 CHAPTER 4: LLMOps & 프로덕션 AI 운영 (10편)
> **왜 이 챕터가 필요한가**: "LLMOps"는 2026년 DevOps만큼 필수인데 한국어 깊이 있는 글이 없음.
> HTTP 200을 반환해도 비즈니스는 망가질 수 있는 AI 시스템 운영의 현실.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| O-01 | **HTTP 200인데 비즈니스가 망가졌다 — AI 품질 KPI 설계** | `llm-quality-kpi.md` | ✅ |
| O-02 | **Groundedness, Faithfulness, Relevance — RAG 평가 지표 실전** | `rag-evaluation-metrics.md` | ⬜ |
| O-03 | **GPT API 비용 계산서 공개: 3개월 프로덕션 실제 청구 내역** | `llm-api-cost-breakdown.md` | ⬜ |
| O-04 | **AI Sprawl 감사: 우리 회사 AI 인프라에 얼마나 낭비하고 있는가** | `ai-sprawl-audit.md` | ⬜ |
| O-05 | **Shadow 환경에서 LLM 성능 검증하기 — Silent Test 패턴** | `llm-shadow-testing.md` | ⬜ |
| O-06 | **Confidence-Based 라우팅: 싸고 작은 모델과 비싸고 큰 모델을 동시에** | `confidence-based-routing.md` | ⬜ |
| O-07 | **LLM 버전 업데이트가 프로덕션을 망치는 방법 — 모델 드리프트 대응** | `llm-version-drift-production.md` | ⬜ |
| O-08 | **데이터 계보(Lineage) 추적: AI가 망했을 때 원인 역추적하는 법** | `ai-data-lineage.md` | ⬜ |
| O-09 | **Evaluation-Driven Development: AI를 코드처럼 테스트하라** | `evaluation-driven-development.md` | ⬜ |
| O-10 | **Fine-tuning vs RAG vs Prompt — 2026년 기준 선택 결정 트리** | `finetune-rag-prompt-decision.md` | ⬜ |

---

## 🔥 CHAPTER 5: RAG 심화 & 실패 분석 (10편)
> **왜 이 챕터가 필요한가**: RAG 기초는 과포화. 하지만 "RAG가 틀리는 이유"는 아무도 안 쓴다.
> 실패 분석 포맷 + 실측 수치 = 독보적 콘텐츠.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| R-01 | **RAG가 틀리는 순간 — False Retrieval 5가지 패턴과 수치** | `rag-false-retrieval-patterns.md` | ✅ |
| R-02 | **Hybrid Search 실측 비교: BM25 vs Dense vs 조합의 실제 점수** | `hybrid-search-benchmark.md` | ⬜ |
| R-03 | **GraphRAG가 일반 RAG를 이기는 유일한 상황** | `graphrag-vs-rag-conditions.md` | ⬜ |
| R-04 | **청킹 전략 실험 결과: 어떤 방식이 실제로 검색 정확도를 높이는가** | `chunking-strategy-experiment.md` | ⬜ |
| R-05 | **법률 계약서 RAG 구축기 — 도메인 특화 RAG의 현실** | `legal-rag-case-study.md` | ⬜ |
| R-06 | **Colbert & Late Interaction: Dense 검색의 다음 단계** | `colbert-late-interaction.md` | ⬜ |
| R-07 | **멀티모달 RAG: 이미지와 텍스트를 함께 검색하는 파이프라인** | `multimodal-rag-pipeline.md` | ⬜ |
| R-08 | **Re-ranking 없이 RAG 정확도 올리기 — Query Transformation 전략** | `query-transformation-rag.md` | ⬜ |
| R-09 | **코드베이스 RAG: IDE를 대체하는 코드 검색 에이전트 구축** | `codebase-rag-agent.md` | ⬜ |
| R-10 | **RAG 시스템의 캐시 전략 — 속도와 비용을 동시에 잡는 법** | `rag-caching-strategy.md` | ⬜ |

---

## 🔥 CHAPTER 6: Edge AI & 임베디드 (독점 영역, 12편)
> **왜 이 챕터가 필요한가**: 한국 블로그에서 STM32+AI, 임베디드+LLM을 함께 다루는 곳 거의 없음.
> 이 영역을 독점하면 임베디드 개발자 커뮤니티 전체를 흡수 가능.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| E-01 | **STM32에서 AI를? TinyML로 제스처 인식 실전 구현** | `stm32-tinyml-gesture.md` | ⬜ |
| E-02 | **STM32 + Edge Impulse: 마이크로컨트롤러에 ML 모델 올리기** | `stm32-edge-impulse.md` | ⬜ |
| E-03 | **Jetson Orin vs Raspberry Pi 5: 엣지 AI 실측 벤치마크** | `jetson-vs-rpi5-benchmark.md` | ⬜ |
| E-04 | **5W 이하에서 LLM 추론: 저전력 엣지 AI의 현실** | `low-power-llm-inference.md` | ⬜ |
| E-05 | **GGUF vs EXL2 vs AWQ: 양자화 포맷 실제 성능 비교 (같은 모델, 다른 결과)** | `quantization-format-benchmark.md` | ⬜ |
| E-06 | **Raspberry Pi 5로 로컬 LLM: 실제 토큰/초 속도 측정 결과** | `rpi5-llm-speed-test.md` | ⬜ |
| E-07 | **ROS 2 + AI 에이전트: 로봇의 두뇌를 LLM으로 교체한 실험** | `ros2-llm-agent.md` | ⬜ |
| E-08 | **TensorRT로 Jetson에서 LLM 2배 빠르게 — 최적화 실전** | `tensorrt-jetson-optimization.md` | ⬜ |
| E-09 | **On-Device RAG: 스마트폰에서 인터넷 없이 RAG 돌리기** | `on-device-rag-mobile.md` | ⬜ |
| E-10 | **Federated Learning 실전: 데이터를 공유하지 않고 모델 학습하기** | `federated-learning-implementation.md` | ⬜ |
| E-11 | **WebGPU로 브라우저에서 LLM 추론: 2026년 실측과 한계** | `webgpu-llm-browser.md` | ⬜ |
| E-12 | **NPU vs GPU vs CPU: llama.cpp 동일 모델 플랫폼별 속도 비교** | `npu-gpu-cpu-llm-benchmark.md` | ⬜ |

---

## 🔥 CHAPTER 7: AI 커리어 & 실전 관점 (8편)
> **왜 이 챕터가 필요한가**: 기술 블로그 중 커리어/실전 관점 포스트는 검색량 최고.
> "시니어 vs 주니어", "AI가 대체하는 것들" 같은 주제는 개발자 커뮤니티에서 항상 뜨거움.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| P-01 | **2026년, AI가 가져간 주니어 개발자의 업무 목록** | `junior-dev-tasks-ai-took.md` | ⬜ |
| P-02 | **"AI 엔지니어"가 되려면 무엇을 알아야 하는가 — 현실적인 로드맵** | `ai-engineer-roadmap-2026.md` | ⬜ |
| P-03 | **Claude Code vs Cursor: 6개월 실사용 후 솔직한 비교** | `claude-code-vs-cursor.md` | ⬜ |
| P-04 | **AI로 월 100만원 버는 것이 가능한가? 솔직한 숫자 계산** | `ai-side-income-calculation.md` | ⬜ |
| P-05 | **나는 왜 Fine-tuning 대신 RAG를 선택했는가 — 실제 결정 과정** | `why-i-chose-rag-not-finetuning.md` | ⬜ |
| P-06 | **Sandwich 아키텍처: LLM을 이용하되 LLM에 의존하지 않는 설계** | `sandwich-architecture-llm.md` | ⬜ |
| P-07 | **AI 스타트업 코드베이스 해부 — 실제로 어떻게 구조가 짜여 있는가** | `ai-startup-codebase-anatomy.md` | ⬜ |
| P-08 | **Vibe Coding의 위험성 — 검증 없이 AI 생성 코드를 배포하면 생기는 일** | `vibe-coding-dangers.md` | ⬜ |

---

## 🔥 CHAPTER 8: 최신 모델 & 기술 선점 (8편)
> **왜 이 챕터가 필요한가**: 빠른 선점 = 오가닉 트래픽 독점.
> 새 모델/표준이 나왔을 때 가장 먼저 한국어로 심층 분석하는 블로그.

| # | 제목 | 파일명 | 상태 |
|---|------|--------|------|
| M-01 | **Gemma 4 실전 평가: 로컬에서 쓸 만한가? 모델 시리즈 총정리** | `gemma4-evaluation.md` | ⬜ |
| M-02 | **Mixture of Experts 실제로 어떻게 작동하는가 — GPT-4 구조 해부** | `moe-architecture-deep-dive.md` | ⬜ |
| M-03 | **Speculative Decoding: 왜 모델이 갑자기 2-3배 빨라지는가** | `speculative-decoding-explained.md` | ⬜ |
| M-04 | **Flash Attention 3과 그 이후: Attention 연산 최적화의 현재** | `flash-attention-evolution.md` | ⬜ |
| M-05 | **Context-Length Wars: 1M vs 2M vs 10M 토큰의 실제 차이** | `context-length-wars.md` | ⬜ |
| M-06 | **Multimodal LLM이 이미지를 "이해"하는 방법 — CLIP부터 GPT-4V까지** | `multimodal-llm-vision.md` | ⬜ |
| M-07 | **SWE-bench 점수의 진실 — AI 코딩 능력 벤치마크는 얼마나 믿을 수 있는가** | `swe-bench-truth.md` | ⬜ |
| M-08 | **DeepSeek vs Qwen vs Llama: 2026년 오픈소스 모델 현황** | `open-source-llm-landscape-2026.md` | ⬜ |

---

## 📊 전체 통계

| 챕터 | 주제 수 | 완성 | 남은 것 |
|------|---------|------|---------|
| C. Context & Memory | 10 | 2 | 8 |
| A. 에이전트 신뢰성 | 12 | 2 | 10 |
| S. MCP & 보안 | 8 | 1 | 7 |
| O. LLMOps | 10 | 1 | 9 |
| R. RAG 심화 | 10 | 1 | 9 |
| E. Edge AI | 12 | 0 | 12 |
| P. 커리어 & 관점 | 8 | 0 | 8 |
| M. 최신 모델 | 8 | 0 | 8 |
| **합계** | **78** | **7** | **71** |

---

## ✍️ 글쓰기 공식 (모든 포스트 적용)

### 오프닝 훅 공식
```
❌ 나쁜 예: "오늘은 [주제]에 대해 알아보겠습니다."
✅ 좋은 예: 실제 겪은 상황 → "이상한 걸 발견했습니다" → 원인이 [주제]였습니다.
```

### 포스트 구조 (5단계)
1. **문제 훅** — 독자가 공감할 실제 상황으로 시작
2. **기존 접근법의 한계** — 기존 글과 차별화 포인트
3. **새로운 관점** — 0xHenry만의 인사이트
4. **실전 코드 / 실측 수치** — 증거 제시 (신뢰도 ↑)
5. **결론 + 다음 글 예고** — 시리즈화

### 제목 공식
- **숫자**: "5가지 패턴", "3개월 청구서", "2배 속도"
- **대척**: "A는 틀렸다", "진짜 이유", "아무도 안 말해준 것"
- **개인화**: "내가 실패한", "나는 왜", "실제로 일어난 일"
- **의문형**: "X는 가능한가?", "정말 그럴까?"

---

## 🗓️ 다음 작성 우선순위 (즉시 시작)

```
1순위: C-02 Context Rot 해부 — context-engineering 다음 편으로 자연스럽게 연결
2순위: A-02 LLM Drift 감지법 — 완전 오리지널, 선점 필수
3순위: O-03 GPT API 비용 계산서 — 실제 숫자 공개 = 폭발적 클릭률
4순위: E-03 Jetson vs RPi5 벤치마크 — 실측 데이터로 독보적
5순위: R-01 RAG 실패 패턴 5가지 — 실패 분석 포맷의 킬러 콘텐츠
```
