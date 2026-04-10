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

| # | 문서 | 작업 | 현재 상태 |
|---|---|---|---|
| 01 | [네이버 블로그](01-naver-blog.md) | 비전공자 대상 AI 교육 블로그 (애드포스트 수익화) | 2/50편 생성, 0편 발행 |
| 02 | [YouTube](02-youtube.md) | 영상 스크립트, 썸네일, 채널 에셋 | 초기 기획 단계 |
| 03 | [기술 블로그](03-tech-blog.md) | 전공자 대상 경험/공부 공유 (0xhenry.dev) | 9편 발행 중 |

## Gemma 4.0 한계와 대안

| 기능 | Claude Code | Gemma 4.0 | 대안 |
|---|---|---|---|
| 웹 검색 | WebSearch 도구 | 불가 | 사용자가 뉴스/소스 제공 |
| 브라우저 자동화 | claude-in-chrome MCP | 불가 | 수동 발행 (복붙) |
| GitHub Actions | anthropic API 자동 실행 | 불가 | 로컬 cron 또는 수동 |
| 긴 출력 | 제한 없음 | 4096 토큰 | 분할 작성 |
| 이미지 생성 | Gemini 연동 | 불가 | 사용자가 별도 생성 |
| 파일 시스템 접근 | 직접 읽기/쓰기 | 도구에 따라 다름 | Ollama API + 스크립트 |

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

## 우선순위 권장

1. **네이버 블로그 용어사전/활용법** — 뉴스 불필요, 23편 확보 가능, 수익화 목표 달성에 직접 기여
2. **기술 블로그 STM32 확장** — 기존 8편에 후속 시리즈 추가
3. **YouTube 스크립트** — 기존 블로그 글을 영상으로 재가공
