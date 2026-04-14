---
title: 0xhenry.dev
created: 2026-04-13
updated: 2026-04-13
sources: []
tags: [blog, content-pipeline, vercel, youtube]
summary: 개인 기술 블로그 + 콘텐츠 플랫폼. Vercel 배포, pnpm monorepo.
confidence_score: 0.8
---

# [[0xhenry.dev]]

## Brief Summary
개인 기술 블로그와 콘텐츠 플랫폼으로, Vercel에 배포되는 pnpm monorepo 구조이다.

## Core Content

### Stack
- **배포:** Vercel
- **패키지 관리:** pnpm monorepo

### Content Pipeline
- 네이버 블로그 AI 자동화 파이프라인
- 유튜브 콘텐츠 제작

### Machine Role Distribution (2026-04-13 확정)
| Machine | Role | AI |
|---------|------|-----|
| **Windows (RTX 5060 Ti)** | 메인 작업대: 네이버 블로그 + 기술블로그 + 유튜브 + 모든 콘텐츠 | Encho (gemma4:e4b) + Antigravity |
| **Mac** | 기술 개발 전용 (코딩, 연구) | Claude Code + Local AI(22시 이후만) |

**원칙:**
- 콘텐츠 생산은 전부 Windows
- Mac에서는 커밋/푸시만, 콘텐츠 작업 안 함
- `~/vault/` (Obsidian)가 공유 메모리 → 양쪽에서 동일 접근
- 중복 작업 방지: 작업 시작 전 vault Log 확인

## Knowledge Connections
- **Related Topics:** [[antigravity]], [[gemma-4]]
- **Projects/Contexts:** [[naver-blog-pipeline]]
- **Contradictions/Notes:** 

---
*Last updated: 2026-04-13*
