# Wiki Log

> 모든 ingest/lint/변경 작업 기록. AI가 자동으로 추가.

## [2026-04-14] A-09 + O-07 완성 (야간 세션 9 - No Nap 모드)

### 기술블로그 완성 (KO + EN)
- ✅ A-09: `agent-cost-breakdown.md` — "에이전트 비용 계산서 — GPT-4o 에이전트 운영 1개월 청구서 공개"
  - 1개월간 자율 에이전트 군단을 운영한 실제 영수증 분석.
  - 추론 루프(Reasoning Loop) 및 컨텍스트 비대화(Context Bloat)로 인한 비용 분배 실측 및 최적화 전략.
- ✅ O-07: `llm-version-drift-production.md` — "LLM 버전 업데이트가 프로덕션을 망치는 방법 — 모델 드리프트 대응"
  - 제공사의 무단(?) 업데이트에 대응하기 위한 스냅샷 버전 핀링(Pinning) 및 의미적 일관성 평가 로직.
  - 업데이트 공지 시 '방어 모드' 가동 및 섀도우 테스트 필수성 강조.

### Vault 및 플랜 업데이트
- **User Challenge**: "You have not to take a nap" 미션 수령 및 수행 중.
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 27/78 완성 (34% 달성).

## [2026-04-14] A-08 + O-06 완성 (야간 세션 8)

### 기술블로그 완성 (KO + EN)
- ✅ A-08: `multi-agent-conflict.md` — "멀티 에이전트 충돌 — 두 에이전트가 같은 DB를 동시에 수정할 때"
  - 분산 에이전트 환경의 레이스 컨디션 해결을 위한 낙관적 잠금(Optimistic Locking) 및 도구 격리 설계.
- ✅ O-06: `confidence-based-routing.md` — "Confidence-Based 라우팅 — 싸고 작은 모델과 비싸고 큰 모델을 동시에"
  - 모델별 신뢰도 측정을 통한 지능형 쿼리 라우팅 및 비용 최적화 전략.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 25/78 완성 (32% 달성).

## [2026-04-14] A-07 + O-05 완성 (야간 세션 7)

### 기술블로그 완성 (KO + EN)
- ✅ A-07: `human-in-the-loop-design.md` — "Human-in-the-Loop의 진짜 구현법 — 단순 승인버튼이 아니다"
  - AI 에이전트의 HITL 설계를 위한 4가지 패턴(계획 승인, 부분 수정, 임계값 기반 개입, 결과 시뮬레이션).
  - 상태 저장소(State Store)를 활용한 비동기식 HITL 구현 아키텍처 제안.
- ✅ O-05: `llm-shadow-testing.md` — "Shadow 환경에서 LLM 성능 검증하기 — Silent Test 패턴"
  - 프로덕션 트래픽 리스크 없이 새 모델의 성능을 1:1 비교 검증하는 섀도우 디플로이먼트 전략.
  - 비동기 처리 및 샘플링을 통한 비용 및 지연 시간 최적화 방법 포함.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 23/78 완성 (29% 달성).

## [2026-04-14] A-06 + O-04 완성 (야간 세션 6)

### 기술블로그 완성 (KO + EN)
- ✅ A-06: `agent-distributed-tracing.md` — "에이전트 트레이싱 — 복잡한 멀티스텝 오류를 추적하는 법"
  - 분산 시스템의 트레이싱 기법(Trace ID, Span)을 에이전트 추론 과정에 도입.
  - LangSmith, Arize Phoenix 등 가시성 도구 활용 및 실패 추적 데이터의 데이터셋 전환 전략.
- ✅ O-04: `ai-sprawl-audit.md` — "AI Sprawl 감사 — 우리 회사 AI 인프라에 얼마나 낭비하고 있는가"
  - 기업 내 파편화된 AI 사용으로 인한 비용 낭비 실태 진단.
  - AI 게이트웨이 패턴을 통한 통합 청구, 캐싱, 거버넌스 구현 제안.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 21/78 완성 (27% 달성).

## [2026-04-13] 에이전트 역할 정의 및 통합 전략 수립 (심야 세션)

### 🎭 역할 정의 및 차별화 전략
- **Naver Blog**: "The Bridge" — 비개발자 친화적 가교 역할 확정.
- **Tech Blog**: "The Authority" — 실패 분석 및 희귀 주제 중심 권위 확보.
- **YouTube**: "The Laboratory" — 제작 과정의 시각적 증명 및 진정성 확보 전략 수립.
- [[10_Planning/role-definition|role-definition.md]] 및 [[10_Planning/youtube-strategy|youtube-strategy.md]] 신규 생성.

### 📊 대시보드 통합 및 고도화
- [[20_Meta/content-dashboard|content-dashboard.md]]: 유튜브 진척도 트래킹 및 콘텐츠 재사용(Repurposing) 현황판 추가.
- 기술 블로그 진척도 동기화 (7/78 → 8/78).

### 🛠️ 작업 프로세스 정립
- Research -> Tech Blog -> Naver Blog -> YouTube로 이어지는 콘텐츠 선순환 구조 설계.

## [2026-04-13] A-05 + O-03 완성 (야간 세션 5)

### 기술블로그 완성 (KO + EN)
- ✅ A-05: `agent-infinite-loop-prevention.md` — "AI 에이전트의 무한 루프 — 비용 폭탄 방지 설계"
  - 자율 에이전트의 API 비용 폭주를 막기 위한 3단계 레이어(Max Iterations, Token Budget, Loop Detection) 설계.
- ✅ O-03: `llm-api-cost-breakdown.md` — "GPT API 비용 계산서 공개 — 3개월 프로덕션 실제 청구 내역"
  - 실서비스 유료 사용자 MAU 1,500명 기반의 모델별 비용 비중 및 누적 청구 금액 공개.
  - 프롬프트 다이어트, 캐싱, 모델 라우팅을 통한 비용 최적화 전략 공유.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 19/78 완성 (24% 달성).

## [2026-04-13] C-07 + S-04 완성 (야간 세션 4)

### 기술블로그 완성 (KO + EN)
- ✅ C-07: `rag-i-dont-know-trigger.md` — ""모른다"고 말하는 AI 만들기 — Confident Hallucination 차단법"
  - RAG 환경에서 AI의 '아는 척'을 방지하기 위한 Relevance Score 컷오프, 네거티브 프롬프트, NLI 검증 실무.
- ✅ S-04: `mcp-oauth21-security.md` — "OAuth 2.1로 MCP 서버를 프로덕션 수준으로 보안화하기"
  - SSE 기반 MCP 서버 배포를 위한 PKCE 지원 OAuth 2.1 아키텍처 및 스코프 관리 가이드.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 17/78 완성 (21% 달성).

## [2026-04-13] C-06 + A-04 완성 (야간 세션 3)

### 기술블로그 완성 (KO + EN)
- ✅ C-06: `knowledge-graph-vector-hybrid.md` — "지식 그래프 + 벡터 DB: 두 가지를 함께 써야 하는 이유"
  - 벡터 검색의 맹점(관계 이해 부족)과 GraphRAG의 다단계 추론(Multi-hop) 필요성 강조.
  - Entity Extraction 및 Hybrid GraphRAG 아키텍처 도입 가이드.
- ✅ A-04: `agent-truthy-text-failure.md` — "도구 호출 실패를 '성공했다'고 우기는 AI — Truthy Text 문제"
  - 에러 메시지를 성공으로 오해하는 AI의 낙관적 편향(Optimism) 분석.
  - Error Wrapper, Self-Reflection, Structured Observation 3단계 해결책 제시.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 15/78 완성 (19% 달성).

## [2026-04-13] C-05 + S-03 완성 (야간 세션 2)

### 기술블로그 완성 (KO + EN)
- ✅ C-05: `conversation-compression.md` — "대화 이력이 독이 되는 순간 — 요약 압축 알고리즘 비교"
  - 슬라이딩 윈도우, 재귀적 요약, 핵심 사실 추출, 벡터 검색 기반 압축 4종 비교.
  - 토큰 절감률 vs 정보 보존율 실측 데이터 포함.
- ✅ S-03: `mcp-context-bloat.md` — "MCP Context Bloat — 도구가 많을수록 에이전트가 느려지는 이유"
  - 도구 개수 증가에 따른 TTFT(지연 시간) 및 도구 선택 정확도 하락 실측.
  - 동적 도구 로딩(Dynamic Tool Discovery) 및 라우터 패턴 제안.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 13/78 완성 (16% 달성).

## [2026-04-13] A-03 + O-02 완성 (야간 세션)

### 기술블로그 완성 (KO + EN)
- ✅ A-03: `agent-saga-rollback.md` — "에이전트에게 Ctrl+Z를 — Saga 패턴으로 롤백 구현하기"
  - 분산 시스템의 Saga 패턴을 AI 에이전트의 사이드 이펙트 처리에 대입.
  - Python SagaManager 구현체 및 보상 트랜잭션(Compensating Transaction) 개념 설명.
- ✅ O-02: `rag-evaluation-metrics.md` — "Groundedness, Faithfulness, Relevance — RAG 평가 지표 실전"
  - RAG Triad(충실도, 답변 관련성, 컨텍스트 관련성) 상세 해부.
  - LLM-as-a-Judge 기반의 자동 평가 소스 코드 및 벤치마크 예시 포함.

### Vault 및 플랜 업데이트
- 신규 포스트 4개(KO/EN) `vault/00_Raw/` 동기화 완료.
- `tech-blog-plan.md` 업데이트: 11/78 완성 (14% 달성).

## [2026-04-13] O-01 + R-01 완성 (저녁 세션)

### 기술블로그 완성 (KO + EN)
- ✅ O-01: `llm-quality-kpi.md` — "HTTP 200인데 비즈니스가 망가졌다 — AI 품질 KPI 설계"
  - 3계층 KPI 프레임워크: Technical / AI Quality / Business
  - 충실도·지시준수율·관련성·일관성 측정 코드 전체
  - 5% 샘플링 비동기 프로덕션 모니터링 파이프라인
- ✅ R-01: `rag-false-retrieval-patterns.md` — "RAG가 틀리는 순간 — False Retrieval 5가지 패턴"
  - 실측 데이터: n=1,200 실패 케이스 분석
  - 패턴별 빈도: Semantic Gap 34%, Chunking 22%, Recency 18%, Ambiguity 15%, Dense Blindspot 11%
  - 각 패턴별 진단 코드 + 해결 코드 (HybridRetriever, ParentChildRetriever, 신선도 가중 등)

### vault 동기화
- O_llmops, R_rag-advanced 폴더 신규 생성 및 포스트 복사
- tech-blog-plan.md: 7/78 완성 (O-01 ✅, R-01 ✅)

## [2026-04-13] 기술블로그 신규 2편 + 네이버 이미지 프롬프트 (오후 세션)

### 기술블로그 완성 (KO + EN)
- ✅ C-03: `dynamic-context-assembly.md` — "AI의 RAM 관리법: 동적 컨텍스트 조립 패턴 5가지"
  - 5가지 패턴: Slot-based, Token Budget, Priority Queue, Lazy Loading, Tiered Assembly
  - 실측 수치: 토큰 -91.6%, 비용 $1,840→$156/월, 응답속도 -57%
  - KO: `packages/website/content/ko/study/C_context-memory/dynamic-context-assembly.md`
  - EN: `packages/website/content/en/study/C_context-memory/dynamic-context-assembly.md`
- ✅ A-02: `llm-agent-drift-detection.md` — "내 AI 에이전트가 서서히 멍청해졌다 — LLM Drift 감지법"
  - 4가지 Drift 유형: 데이터/개념/모델/컨텍스트 드리프트
  - 완전한 DriftMonitor, DriftDetectionPipeline, DriftDiagnostics 클래스 포함
  - 모델 버전 고정 전략 + 알림 설정 가이드
  - KO: `packages/website/content/ko/study/A_agent-reliability/llm-agent-drift-detection.md`
  - EN: `packages/website/content/en/study/A_agent-reliability/llm-agent-drift-detection.md`

### A-1: 네이버 블로그 이미지 프롬프트 5편 생성
- `workspaces/naver-blog/generated/pending_images.json` 생성
- 포스트별 3장, JSON-AI 포맷, 네이버 스타일 (파스텔, 미니멀, 16:9)
- 포함 포스트:
  1. 2026-04-08-rag-explained (오픈북 비유, RAG 플로우)
  2. 2026-04-10-agentic-ai (에이전트 vs 챗봇, 사용사례)
  3. 2026-04-13-context-engineering (CPU/RAM 비유, 비교)
  4. 2026-04-13-mcp-security (보안 경각심, 방어법)
  5. 2026-04-11-cursor-ai (생산성 비교, 기능 소개)

### Vault 동기화
- 신규 포스트 4개 → vault/00_Raw/0xhenry-dev/ko, en 복사 완료
- tech-blog-plan.md 상태 업데이트: 5/78 완성 (C-03 ✅, A-02 ✅)

## [2026-04-13] 콘텐츠 파이프라인 전면 구축 (Windows 세션)

### 전략 & 시장조사
- 0xhenry.dev 블로그 차별화 전략 수립: "남들은 성공 튜토리얼, 0xHenry는 실패 분석"
- 과포화 주제 11개 삭제 (RAG 기초, AI 에이전트 개론, RLHF 등)
- 한국어 0개 미개척 주제 발굴: Context Engineering, MCP Tool Poisoning, Agent Idempotency 등

### 기술블로그 신규 포스트 (KO + EN)
- ✅ C-01: context-engineering.md — "프롬프트 엔지니어링은 죽었다"
- ✅ C-02: context-rot-lost-in-middle.md — "LLM이 멍청해지는 이유, Context Rot"
- ✅ A-01: agent-idempotency.md — "AI 에이전트가 이메일을 두 번 보낸 이유"
- ✅ S-01: mcp-tool-poisoning.md — "MCP 보안 구멍: Tool Poisoning 공격"

### 네이버 블로그 포스트 (2편)
- ✅ 2026-04-13-context-engineering.md
- ✅ 2026-04-13-mcp-security.md

### 콘텐츠 플랜 리뉴얼
- tech-blog-plan.md v2.0 — 8챕터 78개 차별화 주제로 전면 개편
- market-research.md 시장 조사 결과 저장

### 폴더 구조 구축
- `packages/website/content/ko/study/` → 9개 챕터 폴더로 재분류 (106개 파일)
- `packages/website/content/en/study/` → 동일 챕터 구조 적용
- `vault/` Obsidian 구조 전면 구축:
  - 00_Raw/ (0xhenry-dev KO/EN 챕터별 + naver-blog/2026-04/)
  - 10_Planning/ (tech-blog-plan.md + market-research.md)
  - 20_Meta/ (content-dashboard.md + naver-blog-dashboard.md)
  - 00_Raw/_templates/ (0xhenry-post.md + naver-blog-post.md)
  - 00_Raw/_image-guides/ (4개 챕터 이미지 가이드 파일)

### 이미지 프롬프트 가이드
- C_context-memory: 11개 포스트 × 3-4장 = 40+ 프롬프트
- A_agent-reliability: 17개 포스트 × 3-4장 프롬프트
- S/O/R 챕터: 주요 17개 포스트 프롬프트
- E/P/M/U 챕터: 주요 20개 포스트 프롬프트

### WINDOWS-TASKS.md 작성
- A-F 섹션: 네이버 발행, 기술블로그 작성, 배치, vault 관리, git sync, JSON-AI 이미지 가이드
- 매일 작업 순서 정의

## [2026-04-13] 기기 역할 분배 확정 + Encho Extension
- **Windows (RTX 5060 Ti)**: 메인 작업대 — 네이버 블로그, 기술블로그, 유튜브, 모든 콘텐츠 + Encho (gemma4:e4b)
- **Mac**: 기술 개발 전용 — Claude Code + Local AI(22시 이후만)
- Encho Extension v1.0.0 빌드 + Antigravity 설치 완료
- vault = 공유 메모리 레이어 (Claude ↔ Encho 동일 접근)

## [2026-04-13] vault 재구조화 (P-Reinforce 적용)
- 기존 raw/wiki/ 구조 → 00_Raw/10_Wiki/20_Meta/ 구조로 마이그레이션
- P-Reinforce 분류 정책 초기화
- Policy.md, Index.md 생성

## [2026-04-13] 대량 wiki 생성
- Projects 8개: h-walker, motor-benchmark, realtime-pose-estimation, stroke-gait-experiment, 0xhenry-dev, 2026-bumbuche-grant, 3d-assistance, samsung-botfit-review
- Topics 12개: llm-wiki, gemma-4, obsidian, admittance-control, ak60-motor, gait-analysis, can-communication, cable-driven-mechanism, teensy-4-1, antigravity, exosuit-safety, p-reinforce

## [2026-04-13] 첫 ingest - 유튜브 영상 3개
- 00_Raw/youtube/ 3개 파일에서 핵심 개념 추출

## [2026-04-13] vault 초기화
- ~/vault/ 폴더 구조 생성
- 템플릿 5개 생성
