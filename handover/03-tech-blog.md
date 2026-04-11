# 인수인계서: 0xhenry.dev 기술 블로그

> **이전 대상**: Claude Code + GitHub Actions(Anthropic API) → Gemma 4.0 (Ollama localhost:11434)
> **작성일**: 2026-04-11
> **프로젝트 위치**: `packages/website/content/` + `.github/workflows/`

---

## 1. 미션

**사이트**: https://0xhenry.dev
**기술 스택**: Next.js 16 + Tailwind CSS 4 + Prisma + PostgreSQL
**배포**: Vercel (main 브랜치 push 시 자동 배포)
**목적**: 전공자(개발자/엔지니어) 대상 개인 경험 및 공부 내용 공유
**언어**: 영문(EN) + 한국어(KO) 이중 언어

---

## 2. 현재 상태 (2026-04-11 기준)

### 블로그 포스트 (9편, EN/KO 쌍)
| 파일명 | 주제 | 카테고리 |
|---|---|---|
| stm32-architecture.md | Cortex-M7, 메모리 맵, 버스 | STM32 로봇 보드 개발 |
| stm32-bringup.md | STM32 보드 브링업 | STM32 로봇 보드 개발 |
| stm32-clock-system.md | 클럭 시스템 | STM32 로봇 보드 개발 |
| stm32-cubemx.md | CubeMX 설정 | STM32 로봇 보드 개발 |
| stm32-gpio.md | GPIO 제어 | STM32 로봇 보드 개발 |
| stm32-peripherals.md | 주변장치 | STM32 로봇 보드 개발 |
| stm32-pin-mapping.md | 핀 매핑 | STM32 로봇 보드 개발 |
| stm32-pin-system.md | 핀 시스템 | STM32 로봇 보드 개발 |
| zed-x-mini-jetson-setup.md | Zed X Mini + Jetson | 설정 가이드 |

### Tech Radar (27개 blip)
- AI 도구: claude-code, claude-api, llama, fine-tuning, rag-pipelines, multi-agent, openai-assistants, stable-diffusion
- JS/TS: bun, deno, vite, hono, trpc, biome
- 인프라: cloudflare-workers, fly-io, neon, supabase, planetscale, docker-compose, kubernetes-small-teams, github-actions
- 프론트엔드: tailwind-v4, vercel-v0, turborepo
- 결제: stripe-billing, toss-payments

### GitHub Actions 자동화 (6개)
| 워크플로우 | 스케줄 | 역할 |
|---|---|---|
| daily-briefing.yml | 매일 06:00 KST | GitHub Issue로 일일 브리핑 |
| nightly-research.yml | 매일 00:00 KST | 뉴스 스캔 → research YAML → PR |
| content-brief.yml | 월요일 18:00 KST | 주간 콘텐츠 브리프 YAML → PR |
| auto-content.yml | 수동 트리거 | 블로그 포스트 생성 → PR |
| pr-auto-review.yml | PR 오픈 시 | AI 코드/콘텐츠 리뷰 |
| radar-update.yml | 분기별 (1/4/7/10월) | Tech Radar 업데이트 → PR |

---

## 3. 파일 맵

```
packages/website/
├── content/
│   ├── en/study/            ← 영문 포스트 (9편)
│   ├── ko/study/            ← 한국어 포스트 (9편, EN과 1:1 대응)
│   └── radar/
│       ├── blips/           ← Tech Radar 항목 (27개 .md)
│       └── current.md       ← Tech Radar 현재 에디션
├── app/
│   ├── [lang]/              ← i18n 라우팅
│   ├── api/                 ← API 라우트 (수정 금지)
│   └── globals.css          ← 전역 스타일
├── components/              ← React 컴포넌트
├── lib/
│   ├── posts.ts             ← Markdown 파서
│   ├── i18n.ts              ← 번역 문자열
│   └── prisma.ts            ← DB 클라이언트
├── prisma/schema.prisma     ← DB 스키마 (수정 금지)
└── public/images/study/     ← 포스트 이미지

.github/workflows/           ← CI/CD (6개 워크플로우)
data/
├── research/                ← nightly-research 결과 YAML
└── briefs/                  ← content-brief 결과 YAML
```

---

## 4. 포스트 작성 규칙

### 4-1. Frontmatter 형식
```yaml
---
title: "제목 — 부제"
date: YYYY-MM-DD
draft: false
tags: ["tag1", "tag2", "tag3"]  # 3-4개 max
description: "150자 이내 설명"
author: "Henry"
categories: ["카테고리명"]
---
```

### 4-2. 파일명 규칙
- kebab-case, 날짜 접두사 없음
- 예: `stm32-gpio.md`, `zed-x-mini-jetson-setup.md`
- EN/KO 동일 파일명 사용

### 4-3. 글쓰기 스타일
- **톤**: conversational, opinionated, developer-focused
- **작가**: Henry (엔지니어 시점, 실무 경험 기반)
- **길이**: 800-1500 단어 (EN 기준)
- **구조**: 실용적 개발자 각도, 코드 예시 포함
- **이중 언어**: 모든 포스트는 EN + KO 쌍으로 작성

### 4-4. AI 티 안 나게 쓰기 (auto-content.yml 규칙)
- "## Hook", "## Introduction" 같은 섹션 헤더 금지
- `<!-- seo-optimized -->` 같은 HTML 주석 마커 금지
- 같은 글 구조 반복 금지 (매번 다른 내러티브)
- 키워드 frontmatter에 3-4개 max (7-8개 금지)
- 구체적 디테일, 의견, 간간이 유머 포함
- "I tested this myself" 매번 반복하지 않기

### 4-5. Related Articles
- 실제 존재하는 포스트만 링크 (`content/en/study/` 확인)
- 없는 글 링크 절대 금지

---

## 5. Tech Radar 관리

### Blip 파일 형식
```
content/radar/blips/[slug].md
```

### Radar 업데이트 주기
- 분기별 (1/4/7/10월 1일)
- 새 기술 추가, 기존 blip 링 이동 (Adopt/Trial/Assess/Hold)

---

## 6. GitHub Actions 전환 가이드

현재 모든 워크플로우가 `anthropics/claude-code-action@v1`을 사용.
Gemma 4.0이 Antigravity를 통해 웹 + GitHub 접근 가능하므로, 대부분 로컬 Gemma 세션에서 직접 대체 가능.

### 전환 전략: Gemma 4.0 Antigravity 세션에서 직접 실행

GitHub Actions의 역할을 Gemma 4.0 로컬 세션이 대체:
```
1. 웹 검색으로 뉴스/트렌드 수집 (nightly-research 대체)
2. 글 작성 (auto-content 대체)
3. 기존 글 리뷰 (pr-auto-review 부분 대체)
4. git commit + push → Vercel 자동 배포
```

### 워크플로우별 전환 계획

| 워크플로우 | 전환 방법 | 우선순위 |
|---|---|---|
| auto-content.yml | Gemma 세션에서 직접 글 작성 + push | 높음 |
| nightly-research.yml | Gemma 세션에서 웹 검색 + research YAML 생성 | 중간 |
| content-brief.yml | Gemma 세션에서 주간 브리프 생성 | 중간 |
| daily-briefing.yml | Gemma 세션에서 git log 기반 브리핑 생성 | 낮음 |
| pr-auto-review.yml | 유지 (Claude API) 또는 Gemma로 PR diff 리뷰 | 낮음 |
| radar-update.yml | Gemma 세션에서 분기별 웹 리서치 + blip 업데이트 | 낮음 |

### 기존 GitHub Actions 처리
- 즉시 비활성화할 필요 없음 — 병행 운영 가능
- Gemma 세션으로 충분히 대체되면 하나씩 disable
- `pr-auto-review.yml`은 Claude API 유지가 가장 효율적 (PR 이벤트 트리거)

---

## 7. Gemma 4.0 전용 워크플로우

### 환경 (Antigravity 연동)
| 기능 | 상태 |
|---|---|
| 웹 검색 (트렌드 리서치) | 가능 |
| GitHub (commit/push/PR) | 가능 |
| 파일 읽기/쓰기 | 가능 |
| 최대 출력 | 4096 토큰 — EN/KO 별도 세션 권장 |

### 세션 시작 루틴
```
1. packages/website/content/en/study/ 목록 확인
2. packages/website/content/ko/study/ 목록 확인
3. content/radar/blips/ 목록 확인
4. 기존 포스트 스타일/톤 파악
```

### 포스트 작성 프로세스
```
1. 주제 결정 (웹 검색으로 트렌드 파악 또는 research YAML 참고)
2. 기존 관련 포스트 읽기 (스타일 참조)
3. EN 포스트 작성 → content/en/study/[slug].md
4. KO 포스트 작성 → content/ko/study/[slug].md
5. 이미지가 필요하면 public/images/study/[topic]/ 에 명세
6. git add + commit + push (GitHub 접근 가능)
7. Vercel이 main push 감지 → 자동 배포
```

### 4096 토큰 제한 대응
800-1500 단어 포스트는 약 1000-2000 토큰. EN + KO 합치면 최대 4000 토큰.
→ **EN과 KO를 별도 턴에서 작성 권장**

---

## 8. 세션 프롬프트 (Gemma 4.0용)

### 기술 포스트 작성 (EN)
```
packages/website/content/en/study/ 디렉토리를 확인해.
기존 포스트 스타일을 참고해서 '[주제]'에 대한 블로그 포스트를 작성해.

규칙:
- 800-1500 단어
- Frontmatter: title, date, draft: false, tags (3-4개), description (150자 이내), author: Henry, categories
- 파일명: kebab-case, 날짜 없음
- 톤: conversational, opinionated, 개발자 시점
- 코드 예시 포함
- "## Hook"이나 "## Introduction" 같은 섹션 헤더 금지
- Related Articles는 실제 존재하는 파일만 링크

content/en/study/[slug].md 에 저장해.
```

### 기술 포스트 번역 (KO)
```
packages/website/content/en/study/[slug].md를 읽어.
이것을 한국어로 번역해서 content/ko/study/[slug].md에 저장해.

규칙:
- 파일명 동일하게 유지
- Frontmatter의 title, description만 한국어로
- tags는 영문 유지
- categories는 한국어로 (예: "STM32 로봇 보드 개발")
- 자연스러운 한국어 (번역체 금지)
- 기존 ko/study/ 포스트 톤 참고
```

### Tech Radar 업데이트
```
content/radar/blips/ 디렉토리의 기존 blip 파일들을 확인해.
'[기술명]'에 대한 새 radar blip을 추가해.
기존 blip 형식을 따라서 content/radar/blips/[slug].md에 저장해.
```

### 기존 포스트 품질 개선
```
packages/website/content/en/study/[파일명].md를 읽어.
AI 느낌 나는 문장을 자연스럽게 다듬어.
content/ko/study/[파일명].md도 같이 수정해.
새 포스트 생성하지 말고 기존 글만 수정해.
```

---

## 9. 콘텐츠 방향성

### 현재 시리즈: STM32 로봇 보드 개발 (8편)
- 아키텍처 → CubeMX → 핀 시스템 → GPIO → 클럭 → 주변장치 → 핀 매핑 → 브링업
- **확장 가능**: UART 통신, I2C/SPI, 타이머/PWM, ADC, DMA, FreeRTOS 포팅

### 확장 가능한 시리즈
- ROS2 + STM32 통합
- Jetson + 카메라 파이프라인 (Zed X Mini 후속)
- 로봇 제어 알고리즘 (PID, 경로 계획)
- 임베디드 Linux
- AI/ML on Edge (TensorRT, ONNX)

### 개인 경험/공부 공유 포맷
- "~를 해보았다" 스타일 (실험/설정 기록)
- 삽질 과정 포함 (해결까지의 여정)
- 코드 + 설정 파일 전문 포함
- Before/After 비교

---

## 10. 수정 금지 영역

**절대 건드리지 말 것**:
- `app/api/` — API 라우트 (auth, comments, bookmarks)
- `prisma/` — 데이터베이스 스키마
- `middleware.ts` — 인증 미들웨어
- `lib/posts.ts` — 마크다운 파서 로직
- `.github/workflows/` — CI/CD (별도로 수정 계획이 없다면)

**수정 가능 영역**:
- `content/en/study/` — EN 포스트 (생성/수정)
- `content/ko/study/` — KO 포스트 (생성/수정)
- `content/radar/blips/` — Radar blip (생성/수정)
- `public/images/study/` — 포스트 이미지

---

## 11. 품질 체크리스트

### 포스트 작성 후
- [ ] EN + KO 쌍으로 존재
- [ ] Frontmatter 필수 필드 모두 있음 (title, date, draft, tags, description, author, categories)
- [ ] tags 3-4개 이내
- [ ] description 150자 이내
- [ ] 파일명 kebab-case, 날짜 접두사 없음
- [ ] EN/KO 파일명 동일
- [ ] "## Hook", "## Introduction" 헤더 없음
- [ ] HTML 주석 마커 없음
- [ ] Related Articles가 실제 존재하는 파일만 참조
- [ ] 코드 예시 포함 (기술 포스트)
- [ ] AI 느낌 문장 없음
- [ ] draft: false (발행 준비 완료 시)
