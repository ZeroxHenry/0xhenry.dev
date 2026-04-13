# Wiki Log

> 모든 ingest/lint/변경 작업 기록. AI가 자동으로 추가.

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
