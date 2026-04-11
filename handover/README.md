# Gemma 4.0 글쓰기 인수인계서

> Claude Code에서 Local AI (Gemma 4.0 via Ollama)로 모든 글쓰기 작업 이전을 위한 문서

## 대상 모델
- **모델**: gemma4:e4b
- **엔드포인트**: http://localhost:11434/v1
- **컨텍스트**: 128K
- **최대 출력**: 4096 토큰
- **설정 파일**: `antigravity.config.json`
- **헬스 체크**: `scripts/check-local-ai.sh`

## 인수인계서 목록

| # | 문서 | 내용 |
|---|---|---|
| **00** | [머신별 역할 분배](00-machine-roles.md) | 3대 머신 역할, 협업 워크플로우, 주간 목표 |
| 01 | [네이버 블로그](01-naver-blog.md) | 비전공자 AI 교육 블로그 (2/50편, 애드포스트 수익화) |
| 02 | [YouTube](02-youtube.md) | 영상 스크립트, 썸네일, 채널 에셋 (초기 단계) |
| 03 | [기술 블로그](03-tech-blog.md) | 전공자 경험/공부 공유, 0xhenry.dev (9편 발행 중) |

## 머신 역할 요약

| 머신 | 모델 | 역할 | 주 산출물 |
|---|---|---|---|
| MAC | gemma4:e4b (12B) | 네이버 블로그 초안 대량 생산 | naver-blog/generated/ |
| RTX 5060 Ti | gemma4:e4b | 기술 블로그 + YouTube + 초안 검수 | website/content/ + youtube/ |
| RTX 5090 | — | 학습 전용 (콘텐츠 생산 제외) | PaperBanana |

## Gemma 4.0 환경 (Antigravity 연동)

Antigravity를 통해 웹 접근 + GitHub 접근이 가능한 환경.

| 기능 | Claude Code | Gemma 4.0 (Antigravity) |
|---|---|---|
| 웹 검색 | WebSearch 도구 | 가능 (Antigravity 웹 접근) |
| GitHub | gh CLI / API | 가능 (commit, push, PR) |
| 브라우저 자동화 | claude-in-chrome MCP | 불가 — 네이버 발행만 수동 |
| 긴 출력 | 제한 없음 | 4096 토큰 — EN/KO 분할 작성 권장 |
| 파일 시스템 | 직접 읽기/쓰기 | 가능 |

## 세션 시작 순서

```bash
# 1. Ollama 헬스 체크
./scripts/check-local-ai.sh

# 2. 원하는 작업의 인수인계서 읽기
# 네이버 블로그: handover/01-naver-blog.md
# YouTube:       handover/02-youtube.md
# 기술 블로그:    handover/03-tech-blog.md

# 3. 인수인계서의 "세션 프롬프트" 섹션에서 적절한 프롬프트 복사
# 4. Gemma 4.0 세션에서 실행
```

## 유일한 수동 작업

**네이버 블로그 발행만 수동** — 브라우저 자동화(MCP)가 없으므로 Gemma가 글 생성 후 사용자가 복붙 발행.
나머지(웹 검색, 글 작성, git commit/push, Vercel 배포)는 모두 Gemma가 직접 처리 가능.

## 우선순위 권장

1. **네이버 블로그** — 뉴스 검색 가능하니 모든 카테고리 바로 착수, 50편 수익화 목표 직행
2. **기술 블로그 STM32 확장** — 기존 8편에 후속 시리즈 추가, push 즉시 Vercel 배포
3. **YouTube 스크립트** — 기존 블로그 글을 영상으로 재가공
