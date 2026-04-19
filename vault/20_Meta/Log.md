# Wiki Log

> 모든 ingest/lint/변경 작업 기록. AI가 자동으로 추가.

## [2026-04-19] ✍️ Content Polish: Removal of "78-Post" Branding
- **Branding Audit**: "78편 완결", "78-post pipeline" 등 특정 숫자를 강조하는 멘트와 시리즈 완결 푸터 일괄 제거.
- **Tone Adjustment**: 콘텐츠를 특정 패키지 완결이 아닌, 지속 가능한 기술 아카이브 톤으로 조정 (`ai-roadmap-2027.md` 수정).
- **Status**: 블로그 콘텐츠 정규화 및 브랜딩 최적화 완료.

## [2026-04-19] 🖼️ MISSION COMPLETE: Blog Image Recovery & Path Normalization
- **Asset Migration**: `content/` 폴더 내에 흩어져 있던 모든 시각 자료를 Next.js 표준인 `public/images/study/`로 이관 완료.
- **Path Normalization**: 모든 마크다운 파일의 본문 및 프론트매터(썸네일) 경로를 절대 경로(`/images/study/...`)로 일괄 수정.
- **Verification**: 브라우저 서브에이전트를 통해 'AI 로드맵 2027' 등 주요 포스트의 이미지 정상 출력을 최종 확인.
- **Status**: 블로그 시각적 결함 완전 복구 및 안정적 자산 관리 구조 확립.

## [2026-04-19] 🧹 MISSION COMPLETE: Blog Content Normalization & Visual Audit
- **Duplicate Removal**: `E_edge-ai` 디렉토리 내의 중복 하드웨어 포스트(STM32, ZED) 일괄 삭제 완료 (hw 카테고리 단일화).
- **Visual Audit**: "그림 없는 포스트 근절" 정책에 따라 시각 자료가 없는 100여 개의 저품질/드래프트 포스트 일괄 제거.
- **Language Sync**: 한국어(ko) 및 영어(en) 모든 스터디 콘텐츠에 동일한 기준 적용.
- **Status**: 블로그 구조 정규화 및 고품격 시각 블로깅 환경 구축 완료.

## [2026-04-18] 🛡️ MISSION COMPLETE: Blog Management Recovery & Normalization
- **Spam Cleanup**: `generated/posts/` 내 무의미한 AI 양산 폴더(200여 개) 일괄 삭제 완료.
- **System Normalization**: `vault/Meta` -> `vault/20_Meta` 정규화 및 스크립트 실행 경로 복구.
- **Reinforcement Sync**: P-Reinforce 엔진 가동을 통한 "AI 문투 배제" 정책 강제화.
- **Status**: 스팸 정크 제거 및 고퀄리티 기술 블로깅 복원 완료.

## [2026-04-15] MISSION COMPLETE: NotebookLM Native Studio Visual Engineering 🚀💎
- **Native Studio Success**: NotebookLM의 '스튜디오' 기능을 활용하여 'Cloudflare x OpenAI' 기술 리포트용 인포그래픽 및 슬라이드 생성 완료.
- **Brand Identity**: 0xhenry.dev 브랜드 가이드(Navy #171B5E, Orange #F09708)를 네이티브 생성물에 성공적으로 투영.
- **Vision Engine Pro**: 워터마크 자동 제거 및 프로페셔널 여백(Padding) 추가 도구 `vision_engine_pro.py` 배포.
- **Hybrid Workflow**: **Mac(발행)** ↔ **Windows(제작)** 역할 분담 체계 확정 및 연동 완료.
- **Status**: 시각 중심 기술 블로깅 엔진 v1.0 구축 및 1호 포스트 발행 준비 완료.

## [2026-04-14] NVCA Workflow 가동: NotebookLM 파트너십 및 시각화 자동화 🎨🚀
- **NICVP (NotebookLM-integrated Content & Visual Pipeline)**: `GEMINI.md` 정책 업데이트를 통해 "그림 없는 포스트 근절" 및 "신규 주제 전용 노트북 생성" 규칙 강제화.
- **Visual Upgrade (Demo)**: `agent-idempotency.md` (KO/EN) 포스트를 대상으로 NotebookLM Studio(인포그래픽, 슬라이드) 연동 시연 완료.
  - 생성 자산: `idempotency-guide.png`, `idempotency-architecture.png` 통합.
- **Git Sync**: 로컬 연구 환경과 원격 저장소 간의 병합 충돌 해결 및 최신 정책 동기화 완료.
- **Status**: 기술 블로그 시각적 수준 상향 평준화 프로세스 안착.

## [2026-04-15 11:21] 📊 Vault Weekly Lint Report 🔴

**Vault 품질 점수: 0/100**

| 항목 | 발견 수 | 상태 |
|------|---------|------|
| 총 노트 수 | 477 | - |
| 🔴 고아 노트 | 420 | ⚠️ 정리 필요 |
| 🔴 깨진 링크 | 64 | ⚠️ 수정 필요 |
| 🟡 태그 없는 노트 | 63 | 점검 권장 |
| 🟡 장기 미업데이트 (90일+) | 0 | ✅ 없음 |
| 🟡 밀도 초과 폴더 | 14 | 세분화 고려 |

### 🔴 고아 노트 목록
- `README.md`
- `PORTABILITY.md`
- `Research/00_Raw/youtube/2026-04-12-obsidian-ai-era.md`
- `Research/00_Raw/youtube/2026-04-12-karpathy-llm-wiki.md`
- `Research/00_Raw/youtube/2026-04-12-gemma4-second-brain.md`
- `Research/00_Raw/0xhenry-dev/_image-guides/E-P-M-U-chapters-images.md`
- `Research/00_Raw/0xhenry-dev/_image-guides/C_context-memory-images.md`
- `Research/00_Raw/0xhenry-dev/_image-guides/S-O-R-chapters-images.md`
- `Research/00_Raw/0xhenry-dev/_image-guides/A_agent-reliability-images.md`
- `Research/00_Raw/0xhenry-dev/ko/E_edge-ai/federated-learning-implementation.md`
- ... 외 410개

### 🔴 깨진 링크 목록
- `PORTABILITY.md` → `[[파일명]]`
- `Research/00_Raw/youtube/2026-04-12-obsidian-ai-era.md` → `[[위키링크]]`
- `Research/00_Raw/0xhenry-dev/ko/O_llmops/evaluating-rag-ragas.md` → `[["ChromaDB는 벡터 DB입니다. pip install chromadb를 통해 설치하세요."]]`
- `Research/00_Raw/0xhenry-dev/en/O_llmops/evaluating-rag-ragas.md` → `[["ChromaDB is a vector DB. Install it via pip install chromadb."]]`
- `Research/10_Wiki/p-reinforce.md` → `[[P-Reinforce]]`
- `Research/10_Wiki/cable-driven-mechanism.md` → `[[Cable-Driven Mechanism]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[BOARD_DESIGN_REVIEWED]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[EXOSUIT_PROTECTION]]`

### 🟡 밀도 초과 폴더 (세분화 권장)
- `Research/10_Wiki` (29개 파일)
- `Research/00_Raw/0xhenry-dev/ko/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/ko/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/ko/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/ko/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/ko/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/ko/A_agent-reliability` (28개 파일)
- `Research/00_Raw/0xhenry-dev/en/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/en/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/en/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/en/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/en/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/en/A_agent-reliability` (28개 파일)
- `Life/00_Raw/naver-blog` (52개 파일)

---

## [2026-04-15 11:27] 📊 Vault Weekly Lint Report 🔴

**Vault 품질 점수: 0/100**

| 항목 | 발견 수 | 상태 |
|------|---------|------|
| 총 노트 수 | 53 | - |
| 🔴 고아 노트 | 11 | ⚠️ 정리 필요 |
| 🔴 깨진 링크 | 58 | ⚠️ 수정 필요 |
| 🟡 태그 없는 노트 | 6 | 점검 권장 |
| 🟡 장기 미업데이트 (90일+) | 0 | ✅ 없음 |
| 🟡 밀도 초과 폴더 | 14 | 세분화 고려 |

### 🔴 고아 노트 목록
- `README.md`
- `PORTABILITY.md`
- `Research/10_Wiki/robot-hardware-protection.md`
- `Research/10_Wiki/exosuit-handoff.md`
- `Life/10_Wiki/market-research.md`
- `Life/10_Wiki/life-learnings.md`
- `20_Meta/claude-rules.md`
- `20_Meta/notebooklm-guide.md`
- `20_Meta/Reinforcement_Insights.md`
- `20_Meta/Policy.md`
- ... 외 1개

### 🔴 깨진 링크 목록
- `PORTABILITY.md` → `[[파일명]]`
- `Research/10_Wiki/p-reinforce.md` → `[[P-Reinforce]]`
- `Research/10_Wiki/cable-driven-mechanism.md` → `[[Cable-Driven Mechanism]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EP01_robot_hardware_failure.md]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[BOARD_DESIGN_REVIEWED]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[EXOSUIT_PROTECTION]]`
- `Research/10_Wiki/2026-bumbuche-grant.md` → `[[2026 Bumbuche Grant]]`
- `Research/10_Wiki/motor-benchmark.md` → `[[Motor Benchmark]]`

### 🟡 밀도 초과 폴더 (세분화 권장)
- `Research/10_Wiki` (29개 파일)
- `Research/00_Raw/0xhenry-dev/ko/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/ko/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/ko/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/ko/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/ko/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/ko/A_agent-reliability` (28개 파일)
- `Research/00_Raw/0xhenry-dev/en/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/en/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/en/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/en/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/en/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/en/A_agent-reliability` (28개 파일)
- `Life/00_Raw/naver-blog` (52개 파일)

---

## [2026-04-15 11:28] 📊 Vault Weekly Lint Report 🔴

**Vault 품질 점수: 0/100**

| 항목 | 발견 수 | 상태 |
|------|---------|------|
| 총 노트 수 | 53 | - |
| 🔴 고아 노트 | 11 | ⚠️ 정리 필요 |
| 🔴 깨진 링크 | 47 | ⚠️ 수정 필요 |
| 🟡 태그 없는 노트 | 6 | 점검 권장 |
| 🟡 장기 미업데이트 (90일+) | 0 | ✅ 없음 |
| 🟡 밀도 초과 폴더 | 14 | 세분화 고려 |

### 🔴 고아 노트 목록
- `README.md`
- `PORTABILITY.md`
- `Research/10_Wiki/robot-hardware-protection.md`
- `Research/10_Wiki/exosuit-handoff.md`
- `Life/10_Wiki/market-research.md`
- `Life/10_Wiki/life-learnings.md`
- `20_Meta/claude-rules.md`
- `20_Meta/notebooklm-guide.md`
- `20_Meta/Reinforcement_Insights.md`
- `20_Meta/Policy.md`
- ... 외 1개

### 🔴 깨진 링크 목록
- `PORTABILITY.md` → `[[파일명]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EP01_robot_hardware_failure.md]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[BOARD_DESIGN_REVIEWED]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[EXOSUIT_PROTECTION]]`
- `Research/10_Wiki/teensy-4-1.md` → `[[Teensy 4.1]]`
- `Research/10_Wiki/elmo-driver-comparison.md` → `[[exosuit-protection]]`
- `Research/10_Wiki/antigravity.md` → `[[Antigravity IDE]]`
- `Research/10_Wiki/obsidian.md` → `[[위키링크]]`

### 🟡 밀도 초과 폴더 (세분화 권장)
- `Research/10_Wiki` (29개 파일)
- `Research/00_Raw/0xhenry-dev/ko/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/ko/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/ko/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/ko/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/ko/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/ko/A_agent-reliability` (28개 파일)
- `Research/00_Raw/0xhenry-dev/en/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/en/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/en/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/en/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/en/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/en/A_agent-reliability` (28개 파일)
- `Life/00_Raw/naver-blog` (52개 파일)

---

## [2026-04-15 11:28] 📊 Vault Weekly Lint Report 🔴

**Vault 품질 점수: 44/100**

| 항목 | 발견 수 | 상태 |
|------|---------|------|
| 총 노트 수 | 53 | - |
| 🔴 고아 노트 | 11 | ⚠️ 정리 필요 |
| 🔴 깨진 링크 | 57 | ⚠️ 수정 필요 |
| 🟡 태그 없는 노트 | 6 | 점검 권장 |
| 🟡 장기 미업데이트 (90일+) | 0 | ✅ 없음 |
| 🟡 밀도 초과 폴더 | 14 | 세분화 고려 |

### 🔴 고아 노트 목록
- `README.md`
- `PORTABILITY.md`
- `Research/10_Wiki/robot-hardware-protection.md`
- `Research/10_Wiki/exosuit-handoff.md`
- `Life/10_Wiki/market-research.md`
- `Life/10_Wiki/life-learnings.md`
- `20_Meta/claude-rules.md`
- `20_Meta/notebooklm-guide.md`
- `20_Meta/Reinforcement_Insights.md`
- `20_Meta/Policy.md`
- ... 외 1개

### 🔴 깨진 링크 목록
- `PORTABILITY.md` → `[[파일명]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EP01_robot_hardware_failure.md]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[BOARD_DESIGN_REVIEWED]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[EXOSUIT_PROTECTION]]`
- `Research/10_Wiki/teensy-4-1.md` → `[[Teensy 4.1]]`
- `Research/10_Wiki/elmo-driver-comparison.md` → `[[exosuit-protection]]`
- `Research/10_Wiki/antigravity.md` → `[[Antigravity IDE]]`
- `Research/10_Wiki/obsidian.md` → `[[위키링크]]`

### 🟡 밀도 초과 폴더 (세분화 권장)
- `Research/10_Wiki` (29개 파일)
- `Research/00_Raw/0xhenry-dev/ko/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/ko/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/ko/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/ko/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/ko/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/ko/A_agent-reliability` (28개 파일)
- `Research/00_Raw/0xhenry-dev/en/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/en/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/en/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/en/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/en/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/en/A_agent-reliability` (28개 파일)
- `Life/00_Raw/naver-blog` (52개 파일)

---

## [2026-04-15 11:46] 📊 Vault Weekly Lint Report 🔴

**Vault 품질 점수: 39/100**

| 항목 | 발견 수 | 상태 |
|------|---------|------|
| 총 노트 수 | 55 | - |
| 🔴 고아 노트 | 11 | ⚠️ 정리 필요 |
| 🔴 깨진 링크 | 69 | ⚠️ 수정 필요 |
| 🟡 태그 없는 노트 | 6 | 점검 권장 |
| 🟡 장기 미업데이트 (90일+) | 0 | ✅ 없음 |
| 🟡 밀도 초과 폴더 | 14 | 세분화 고려 |

### 🔴 고아 노트 목록
- `README.md`
- `PORTABILITY.md`
- `Research/10_Wiki/robot-hardware-protection.md`
- `Research/10_Wiki/exosuit-handoff.md`
- `Life/10_Wiki/market-research.md`
- `Life/10_Wiki/life-learnings.md`
- `20_Meta/claude-rules.md`
- `20_Meta/notebooklm-guide.md`
- `20_Meta/Reinforcement_Insights.md`
- `20_Meta/Policy.md`
- ... 외 1개

### 🔴 깨진 링크 목록
- `PORTABILITY.md` → `[[파일명]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EP01_robot_hardware_failure.md]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[BOARD_DESIGN_REVIEWED]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[EXOSUIT_PROTECTION]]`
- `Research/10_Wiki/teensy-4-1.md` → `[[Teensy 4.1]]`
- `Research/10_Wiki/elmo-driver-comparison.md` → `[[exosuit-protection]]`
- `Research/10_Wiki/antigravity.md` → `[[Antigravity IDE]]`
- `Research/10_Wiki/obsidian.md` → `[[위키링크]]`

### 🟡 밀도 초과 폴더 (세분화 권장)
- `Research/10_Wiki` (29개 파일)
- `Research/00_Raw/0xhenry-dev/ko/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/ko/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/ko/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/ko/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/ko/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/ko/A_agent-reliability` (28개 파일)
- `Research/00_Raw/0xhenry-dev/en/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/en/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/en/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/en/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/en/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/en/A_agent-reliability` (28개 파일)
- `Life/00_Raw/naver-blog` (52개 파일)

---

## [2026-04-18 00:00] 📊 Vault Weekly Lint Report 🔴

**Vault 품질 점수: 34/100**

| 항목 | 발견 수 | 상태 |
|------|---------|------|
| 총 노트 수 | 62 | - |
| 🔴 고아 노트 | 16 | ⚠️ 정리 필요 |
| 🔴 깨진 링크 | 79 | ⚠️ 수정 필요 |
| 🟡 태그 없는 노트 | 13 | 점검 권장 |
| 🟡 장기 미업데이트 (90일+) | 0 | ✅ 없음 |
| 🟡 밀도 초과 폴더 | 14 | 세분화 고려 |

### 🔴 고아 노트 목록
- `README.md`
- `Backup.md`
- `Research/10_Wiki/H-Walker 5090 Fine-tuning 설정 가이드.md`
- `Research/10_Wiki/robot-hardware-protection.md`
- `Research/10_Wiki/exosuit-handoff.md`
- `Research/10_Wiki/H-Walker Fine-tuning 빠른 시작.md`
- `Research/10_Wiki/H-Walker Graph App 사용 가이드.md`
- `Research/10_Wiki/H-Walker LLM 품질 개선 Phase 1.md`
- `Research/10_Wiki/H-Walker LLM Fine-tuning 파이프라인.md`
- `Life/10_Wiki/market-research.md`
- ... 외 6개

### 🔴 깨진 링크 목록
- `Backup.md` → `[[파일명]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EXOSUIT_PROTECTION.md]]`
- `Research/10_Wiki/robot-hardware-protection.md` → `[[EP01_robot_hardware_failure.md]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[BOARD_DESIGN_REVIEWED]]`
- `Research/10_Wiki/exosuit-hardware-overview.md` → `[[EXOSUIT_PROTECTION]]`
- `Research/10_Wiki/teensy-4-1.md` → `[[Teensy 4.1]]`
- `Research/10_Wiki/elmo-driver-comparison.md` → `[[exosuit-protection]]`
- `Research/10_Wiki/antigravity.md` → `[[Antigravity IDE]]`
- `Research/10_Wiki/obsidian.md` → `[[위키링크]]`

### 🟡 밀도 초과 폴더 (세분화 권장)
- `Research/10_Wiki` (36개 파일)
- `Research/00_Raw/0xhenry-dev/ko/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/ko/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/ko/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/ko/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/ko/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/ko/A_agent-reliability` (28개 파일)
- `Research/00_Raw/0xhenry-dev/en/E_edge-ai` (27개 파일)
- `Research/00_Raw/0xhenry-dev/en/C_context-memory` (19개 파일)
- `Research/00_Raw/0xhenry-dev/en/M_models` (16개 파일)
- `Research/00_Raw/0xhenry-dev/en/R_rag-advanced` (36개 파일)
- `Research/00_Raw/0xhenry-dev/en/O_llmops` (23개 파일)
- `Research/00_Raw/0xhenry-dev/en/A_agent-reliability` (28개 파일)
- `Life/00_Raw/naver-blog` (52개 파일)

---
