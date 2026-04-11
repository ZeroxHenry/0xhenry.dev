# 0xHenry.dev — Project Rules

## Project Overview
- **Site**: 0xhenry.dev — Engineer study blog
- **Stack**: Next.js 16.2 + Tailwind CSS 4 + Prisma + NextAuth.js
- **Monorepo**: pnpm workspace (`packages/website/` = main app)
- **Languages**: EN (`content/en/`) + KO (`content/ko/`)
- **Deploy**: Vercel auto-deploys on `main` push
- **Branch**: Always work on `main`

## Brand
- Accent: `#0d9488` (Cyber Teal)
- Accent hover: `#0f766e`
- Accent light: `#10b981`
- Background dark: `#030712` (gray-950)
- Font: Inter (system-ui fallback)
- Logo: `public/logo.svg` (0x Henry.dev badge)
- Favicon: `public/favicon.svg` (0xH mark)

## File Ownership (editable)
- `packages/website/app/globals.css` — Global styles, card system, prose
- `packages/website/app/[lang]/page.tsx` — Homepage (hero + post list)
- `packages/website/app/[lang]/study/page.tsx` — Study index
- `packages/website/app/[lang]/study/[slug]/page.tsx` — Post detail
- `packages/website/app/layout.tsx` — Root layout, metadata, OG
- `packages/website/app/[lang]/layout.tsx` — Language layout with Nav
- `packages/website/components/Nav.tsx` — Navigation
- `packages/website/components/SearchModal.tsx` — Cmd+K search
- `packages/website/components/ShareButtons.tsx` — Social sharing
- `packages/website/lib/i18n.ts` — UI strings (EN/KO)
- `packages/website/content/` — Markdown posts (edit only, never create)
- `packages/website/public/images/` — Images and brand assets

## Do NOT Touch
- `packages/website/prisma/` — Database schema
- `packages/website/app/api/` — API routes (auth, comments, bookmarks)
- `packages/website/middleware.ts` — Auth middleware
- `.github/workflows/` — CI/CD pipelines
- `packages/website/lib/posts.ts` — Post parser logic (no changes)

## Absolute Rules
- NEVER install new npm packages without explicit approval
- NEVER create new blog posts (edit existing only)
- NEVER modify API routes or database schema
- ALL code comments and commit messages in English
- Korean for user-facing content and explanations
- No AI-sounding phrases ("Let's dive in", "In this article we will explore")
- Keep changes minimal and focused — one task per session

## Design System

### Typography
- h1: `letter-spacing: -0.06em`
- h2: `letter-spacing: -0.04em`
- h3: `letter-spacing: -0.03em`, accent color
- Body: `line-height: 1.8`

### Components
- `.card-hover` — Layered shadows, `translateY(-2px)` on hover
- `.nav-glass` — Glassmorphism `blur(20px) + saturate(180%)`
- `.prose` — All markdown styling in globals.css

### Reference Aesthetic
- Vercel Blog, Linear Blog, Raycast Blog
- Dark mode first, minimal + personality
- NO stock illustrations, NO rainbow colors

## Workflow
1. Read this file (GEMINI.md) at session start
2. Check `.antigravity/prompts.md` for prioritized tasks
3. Work on the requested or highest priority task
4. Verify dark mode + mobile (640px) for all changes
5. `git add . && git commit -m "descriptive message" && git push`

## Operational Strategy: Local First (Gemma 4.0)

- **Default**: Local Gemma 4.0 via Ollama (`http://localhost:11434`) — zero cost
- **Fallback**: Context 초과 시 Gemini 3 Pro 자동 전환
- **Manual switch**: `@gemini` or `@claude`로 필요 시 클라우드 모델 사용 가능
- 일상 작업(코드 수정, 버그 픽스, 리팩토링)은 로컬 우선
