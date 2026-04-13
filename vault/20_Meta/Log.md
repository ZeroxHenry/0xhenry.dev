# Wiki Log

> 모든 ingest/lint/변경 작업 기록. AI가 자동으로 추가.

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
