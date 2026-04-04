# TechBlips — Antigravity / Gemini Rules

## 프로젝트 개요
- **사이트**: techblips.com — Hugo + PaperMod 기반 테크 레이더 플랫폼
- **레포**: github.com/techblips/techpulse-eng
- **브랜치**: main (직접 push)
- **배포**: Cloudflare Pages (main push → 자동 배포)
- **브랜드 컬러**: #6c5ce7 (보라), #0ea5e9 (파랑), #f59e0b (노랑), #10b981 (초록)

## 절대 규칙
1. **AI 생성 느낌 금지** — 대칭적, 기계적, 반복적 패턴 사용하지 마
2. **한국어 댓글/주석은 넣지 마** — 코드와 콘텐츠는 영어
3. **기존 파일 구조 유지** — 새 파일 만들기 전에 기존 파일 먼저 확인
4. **PaperMod 테마 파일 직접 수정 금지** — themes/ 폴더 건들지 마
5. **커밋 메시지 영어로** — 짧고 명확하게

## 파일 구조 (수정 가능한 것만)
```
assets/css/extended/custom.css    — 메인 CSS (700줄+)
static/css/radar.css              — 레이더 페이지 전용 CSS
static/js/radar.js                — D3.js 레이더 시각화
static/logo.svg                   — SVG 로고
static/favicon.svg                — SVG 파비콘
layouts/partials/extend_head.html — <head> 확장 (폰트, 메타, CSS)
layouts/partials/footer.html      — 푸터 (뉴스레터 include)
layouts/partials/newsletter.html  — Buttondown 뉴스레터 폼
layouts/partials/author-card.html — 저자 프로필 카드
layouts/radar/single.html         — 레이더 메인 페이지 레이아웃
layouts/radar-blip/single.html    — 블립 상세 페이지 레이아웃
content/posts/*.md                — 블로그 포스트 (19개)
content/radar/blips/*.md          — 레이더 블립 페이지 (30개)
data/radar/2026-q2.json           — 레이더 데이터 (JSON)
static/data/radar/2026-q2.json    — 같은 파일 (브라우저용 복사본)
hugo.toml                         — Hugo 설정
```

## CSS 변수 시스템
```css
:root {
  --accent: #6c5ce7;
  --accent-hover: #5a4bd1;
  --accent-light: #ede9fe;
  --text-primary: #1a1a2e;
  --text-secondary: #64748b;
  --bg-surface: #ffffff;
  --bg-page: #fafbfc;
  --border-light: #e8ecf1;
  --radius: 12px;
}
```
다크모드: `.dark` 클래스에서 변수 오버라이드

## 레이더 쿼드런트 색상
- Quadrant 0 (AI & ML): #6c5ce7
- Quadrant 1 (Cloud & Infrastructure): #0ea5e9
- Quadrant 2 (Developer Tools): #f59e0b
- Quadrant 3 (Platforms & APIs): #10b981

## 디자인 레퍼런스
Vercel, Linear, Raycast 수준의 미니멀 + 개성있는 톤

## 현재 알려진 버그
1. 레이더 페이지에서 blip 점(dot)이 렌더링 안 됨 — 브라우저 콘솔 확인 필요
2. author-card.html이 아무 템플릿에도 include 안 됨 — 블로그 포스트 하단에 넣어야 함
