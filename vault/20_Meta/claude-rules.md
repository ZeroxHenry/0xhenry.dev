---
title: Claude Rules
created: 2026-04-15
updated: 2026-04-15
tags: [claude, rules, meta]
summary: Claude Code가 따라야 할 규칙. 모든 세션에서 자동 참조.
---

# Claude Rules

## 행동 규칙
- 작업 완료 시 항상 커밋 + 푸시까지 수행 (별도 요청 불필요)
  - git에 AI 흔적 금지 (Co-Authored-By, claude/ai 브랜치명, PR에 Claude 언급 금지)
- 기술 스펙은 공식 소스 확인 필수, 추측 금지
  - 확신 없으면 "확인 필요"로 표기하거나 빈칸
- Exosuit이라고 부를 것 (외골격/exoskeleton 아님)

## 기기별 역할
| 기기 | 역할 | AI |
|------|------|-----|
| **Windows (RTX 5060 Ti)** | 메인: 콘텐츠 전담 (네이버, 기술블로그, 유튜브) | @local (gemma4:e4b) + Antigravity |
| **Mac** | 기술 개발 전용 (코딩, 연구) | Claude Code + Local AI(22시 이후만) |

- Mac에서 콘텐츠 작업 요청 시 → "Windows에서 하세요" 안내
- 중복 방지: 작업 전 vault/20_Meta/Log.md 확인

## 네이버 블로그
- 세션 진입점: `workspaces/naver-blog/WORKFLOW.md`
- 트래킹: `workspaces/naver-blog/generated/index.json`
- 목표: 50편 발행 → 애드포스트

## Vault 참조 규칙
- 연구/하드웨어 작업 시 → `vault/Research/10_Wiki/skiro-learnings.md` 먼저 읽기
- 관련 키워드로 vault 검색: `vault/Research/10_Wiki/` 내 wiki 노트 참조
- 새 교훈 발생 시 → `skiro-learnings add` 로 vault에 직접 기록

## Related
- [[skiro-learnings]]
- [[h-walker]]
