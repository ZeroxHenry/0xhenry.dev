# 0xHenry 병렬 작업 분배

## 작업 현황
- main 브랜치: AI 마커 제거 + CI/CD 완료 (PR #1 머지됨)
- claude/radar-mvp-4pJNg 브랜치: Tech Radar MVP 코드 완료 (push됨, PR 미생성)
- 레이더 시각화(D3.js), Hugo 레이아웃, 5개 블립 상세 페이지, 뉴스레터 partial 생성됨

---

## Session A: AI Assistant — 레이더 블립 콘텐츠 (25개)

브랜치: `claude/radar-blips-content`
base: `claude/radar-mvp-4pJNg`

### 프롬프트 (복사해서 붙여넣기):

```
이 레포는 0xhenry.dev — Hugo + PaperMod 기반 테크 미디어 사이트야.
/data/radar/2026-q2.json 에 30개 기술 블립 데이터가 있어.
/content/radar/blips/ 에 5개(claude-code, cloudflare-workers, rag-pipelines, supabase, hono) 상세 페이지가 이미 있어.

나머지 25개 블립의 상세 페이지를 /content/radar/blips/ 에 생성해줘.

기존 5개 파일의 포맷을 정확히 따라:
- frontmatter: title, date(2026-04-01), type("radar-blip"), ring, quadrant, moved, description
- 본문: ## What is it? / ## Why does it matter? / ## Trade-offs / ## Our take

JSON 데이터의 blip id 2-30 중 아직 없는 25개:
langchain, bun, vercel-v0, stripe-billing, llama, docker-compose, tailwind-v4, 
claude-api, kubernetes-small-teams, github-actions, vite, openai-assistants, 
ai-code-review, deno, multi-agent, fly-io, trpc, stable-diffusion, 
planetscale, turborepo, fine-tuning, neon, biome, toss-payments

각 블립은 실제 개발자가 읽을 수 있는 실질적인 분석이어야 해.
AI가 만든 티가 나면 안 돼 — 솔직하고 의견이 뚜렷한 톤으로.

브랜치 claude/radar-blips-content 에서 작업하고 push해줘.
```

---

## Session B: AI Assistant — 콘텐츠 파이프라인 리팩토링

브랜치: `claude/content-pipeline`
base: `claude/radar-mvp-4pJNg`

### 프롬프트 (복사해서 붙여넣기):

```
이 레포는 0xhenry.dev — Hugo 기반 테크 미디어 사이트야.
현재 .github/workflows/auto-content.yml 이 있는데, 이건 AI가 자동으로 글을 생성해서 
바로 PR을 만드는 방식이야. 이걸 human-in-the-loop 방식으로 교체해야 해.

해야 할 것:

1. .github/workflows/auto-content.yml 을 삭제하거나 비활성화

2. .github/workflows/content-brief.yml 신규 생성:
   - 매주 월요일 오전 9시 UTC에 실행 (+ 수동 실행 가능)
   - AI Assistant Action (anthropics/claude-code-action@v1) 사용
   - 프롬프트: "이번 주 테크 트렌드를 분석하고, 3개의 기사 주제를 제안해줘. 
     각 주제별로: 제목, 핵심 논점 3개, 참고 소스 3개, 예상 독자층, 
     관련 Tech Radar 블립 연결을 포함해. PR로 /data/briefs/YYYY-WW.yml 파일 생성."
   - 시크릿: ANTHROPIC_API_KEY 필요

3. .github/workflows/radar-update.yml 신규 생성:
   - 분기별 실행 (1월/4월/7월/10월 1일) + 수동 실행
   - AI Assistant Action 사용
   - 프롬프트: "현재 /data/radar/ 의 최신 JSON을 분석하고, 
     블립 이동 제안을 PR로 만들어줘. 각 변경에 대한 근거를 포함해."

4. /data/briefs/ 디렉토리 생성 + 샘플 brief 파일 1개

브랜치 claude/content-pipeline 에서 작업하고 push해줘.
```

---

## Session C: AI Assistant — 기존 콘텐츠 재구성

브랜치: `claude/content-restructure`  
base: `claude/radar-mvp-4pJNg`

### 프롬프트 (복사해서 붙여넣기):

```
이 레포는 0xhenry.dev — Hugo 기반 테크 미디어 사이트야.
/content/posts/ 에 19개 블로그 포스트가 있어.
/data/radar/2026-q2.json 에 30개 Tech Radar 블립이 있어.

해야 할 것:

1. 19개 포스트 각각의 frontmatter에 related_radar 필드 추가:
   - 해당 글과 관련된 레이더 블립의 slug를 배열로 지정
   - 예: related_radar: ["claude-code", "rag-pipelines"]
   - 관련 없으면 빈 배열

2. 구조적 AI 느낌 제거:
   - 모든 글이 동일한 패턴(도입→섹션1~5→결론)인 것을 다양화
   - 과도한 keywords 배열 정리 (7-8개 → 3-4개로 축소)
   - "I tested this myself" 같은 반복 내러티브 변형
   - 코드 블록의 잘못된 closing 태그 수정 (```python 으로 끝나는 것 → ``` 로)

3. 코드 블록 closing 태그 버그 수정:
   - 여러 파일에서 ```python 이나 ```javascript 로 코드 블록이 끝나는 문제 있음
   - 정규식: ```[a-z]+ 으로 끝나는 코드 블록 찾아서 ``` 로 수정

브랜치 claude/content-restructure 에서 작업하고 push해줘.
```

---

## Session D: Antigravity — 디자인 리뉴얼

### 프롬프트 (Antigravity IDE에 붙여넣기):

```
이 Hugo + PaperMod 블로그를 프리미엄 테크 레이더 플랫폼으로 리디자인해줘.

현재 상태:
- assets/css/extended/custom.css (640줄 커스텀 CSS)
- 브랜드 컬러: #6c5ce7 (보라)
- 다크모드 지원
- 새로 추가된 Tech Radar 페이지 (/radar/current/)
- 뉴스레터 구독 폼 (footer)

리디자인 요구사항:

1. 커스텀 SVG 로고 (⚡ 번개 모티브, 텍스트 이모지 교체)
2. SVG 파비콘
3. 히어로 섹션 리뉴얼:
   - 현재 "Your daily dose of AI updates..." 텍스트만 있음
   - 미묘한 CSS 애니메이션 배경 추가 (그라디언트 메시 또는 부유하는 도형)
   - Tech Radar CTA 버튼 눈에 띄게
4. 레이더 페이지 비주얼 폴리시:
   - static/css/radar.css 수정
   - 쿼드런트별 색상 시스템 강화 (AI=#6c5ce7, Cloud=#0ea5e9, DevTools=#f59e0b, Platforms=#10b981)
   - 블립 호버/클릭 인터랙션 개선
5. 포스트 카드 디자인 개선:
   - 카테고리별 다른 악센트 색상
   - 호버 마이크로 인터랙션 세련화
6. 저자 프로필 카드 (포스트 하단) — layouts/partials/author-card.html 신규
7. 타이포그래피: Inter 폰트 명시적 로드

피해야 할 것:
- AI가 만든 느낌 (대칭적, 기계적)
- 과도한 글래스모피즘
- 스톡 일러스트레이션
- 무지개 색상

수정할 파일:
- assets/css/extended/custom.css
- static/css/radar.css
- layouts/partials/extend_head.html (폰트 로딩)
- layouts/partials/footer.html
- static/logo.svg (신규)
- static/favicon.svg (신규)
- layouts/partials/author-card.html (신규)

레퍼런스: Vercel, Linear, Raycast 수준의 미니멀하면서도 개성 있는 디자인
```

---

## 통합 순서 (내가 할 일)

1. Session A, B, C가 각각 push하면 → 내가 충돌 해결 + 통합 머지
2. Session D (Antigravity) 결과물을 레포에 반영
3. 최종 통합 PR → main 머지 → 자동 배포

각 세션은 독립적인 브랜치에서 작업하므로 충돌 최소화됨.
