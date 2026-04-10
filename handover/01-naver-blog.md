# 인수인계서: 네이버 AI 블로그 자동화

> **이전 대상**: Claude Code → Gemma 4.0 (Ollama localhost:11434)
> **작성일**: 2026-04-11
> **프로젝트 위치**: `workspaces/naver-blog/`

---

## 1. 미션

**블로그명**: AI 데일리 — 매일 쏟아지는 AI 뉴스 정리
**URL**: https://blog.naver.com/0xhenry
**목표**: 50편 작성 후 네이버 애드포스트 수익화 신청 (50편 + 90일 활동)
**컨셉**: 비전공자도 이해할 수 있는 AI 교육 콘텐츠 — "로봇 교육의 선구자"

---

## 2. 현재 상태 (2026-04-11 기준)

| 항목 | 값 |
|---|---|
| 생성된 글 | 2편 |
| 발행된 글 | 0편 |
| 목표까지 남은 글 | 48편 |
| 마지막 세션 | 2026-04-08 |

### 완료된 글
1. `generated/2026-04/2026-04-08-rag-explained.md` — "RAG란? AI가 검색해서 답하는 기술" (draft, 1950자)
2. `generated/2026-04/2026-04-10-agentic-ai.md` — "에이전트 AI란?" (미커밋 상태)

### Topic Backlog 진행률
- AI 용어 사전: 2/10 완료 (RAG, 에이전트 AI)
- AI 도구 리뷰: 0/10
- AI 활용법: 0/10
- 주간 AI 브리핑: 0/6
- Evergreen: 0/5

---

## 3. 파일 맵

```
workspaces/naver-blog/
├── WORKFLOW.md              ← 운영 매뉴얼 (세션 모드, 규칙, SEO)
├── NAVER-BLOG-PLAN.md       ← 전략 플랜 (카테고리, 로드맵)
├── generated/
│   ├── index.json           ← 글 트래킹 (status: draft/ready/published)
│   ├── images/YYYY-MM/      ← 포스트별 이미지
│   └── 2026-04/             ← 월별 생성된 글
├── templates/
│   ├── ai-news.md           ← AI 뉴스 템플릿
│   ├── ai-glossary.md       ← AI 용어 사전 템플릿
│   ├── ai-how-to.md         ← AI 활용법 템플릿
│   ├── ai-tool-review.md    ← AI 도구 리뷰 템플릿
│   ├── weekly-briefing.md   ← 주간 AI 브리핑 템플릿
│   └── _image-guidelines.md ← 이미지 소싱 가이드
├── research/
│   ├── topic-backlog.md     ← 주제 큐 (체크리스트)
│   └── news-sources.md      ← 뉴스 소스 목록 (Tier 1-3)
└── scripts/
    ├── PUBLISH-GUIDE.md     ← Chrome 자동화 발행 스크립트
    └── session-prompts.md   ← 복사해서 쓰는 프롬프트 모음
```

---

## 4. 카테고리별 작성 규칙

| 카테고리 | 템플릿 | 글자수 | 이미지 | 빈도 |
|---|---|---|---|---|
| AI 뉴스 | `templates/ai-news.md` | 1500-2500자 | 3장+ | 매일 1-2편 |
| AI 도구 리뷰 | `templates/ai-tool-review.md` | 1800-2200자 | 4-5장 | 주 2-3편 |
| AI 활용법 | `templates/ai-how-to.md` | 1800-2500자 | 5-7장 | 주 1-2편 |
| AI 용어 사전 | `templates/ai-glossary.md` | 1500-2000자 | 2-3장 | 주 1편 |
| 주간 AI 브리핑 | `templates/weekly-briefing.md` | 2000-2500자 | 3-4장 | 주 1편 |

**각 템플릿 파일에 제목 패턴, 본문 구조, 태그 규칙이 상세하게 정의되어 있으니 반드시 먼저 읽을 것.**

---

## 5. 공통 글쓰기 규칙

### 5-1. AI 티 안 나게 쓰기 (최우선)
- 문장 끝 다양하게: ~어요, ~습니다, ~거든요, ~네요 혼용
- 개인 반응 1-2문장 삽입: "솔직히 이건 좀 놀랐어요", "써보니까 괜찮더라고요"
- 문단 길이 불균일 (2~5문장 섞기)
- **금지 표현**: 결론적으로, 종합하면, 요약하자면, 다양한, 주목할 만한
- 마무리 질문은 구체적으로 ("AI에 대해 어떻게 생각하시나요?" ← 이런 식 금지)

### 5-2. SEO / C-Rank
- 태그 #AI #인공지능 항상 포함
- 전체 포스트의 40%+ = AI 뉴스 카테고리
- 3주차부터 이전 포스트 내부 링크 삽입
- 발행 시간: 오전 7-9시 or 저녁 7-9시
- 포스트 삭제 금지

### 5-3. 글 구조
- 본문 1,800-2,200자
- 이미지 3-5장 (섹션 사이 배치)
- 태그 7-9개
- H2 소제목 3개 이상
- 제목에 검색 키워드를 앞에 배치

### 5-4. 작가 페르소나
- 필명: 0xHenry
- 포지셔닝: "비전공자도 이해할 수 있는 로봇 교육의 선구자"
- 톤: 친근하지만 전문적, 구어체 섞기
- 로봇/교육 관련 문맥 자연스럽게 연결

---

## 6. Gemma 4.0 전용 워크플로우

### 환경 (Antigravity 연동)
| 기능 | 상태 |
|---|---|
| 웹 검색 (뉴스 수집) | 가능 — Antigravity 웹 접근으로 실시간 뉴스 검색 |
| GitHub (commit/push) | 가능 — git 명령어 직접 실행 |
| 파일 읽기/쓰기 | 가능 |
| 네이버 블로그 발행 | 불가 — 브라우저 자동화 없음, 사용자 수동 발행 필요 |
| 최대 출력 | 4096 토큰 — 2000자 글은 약 3000 토큰이므로 충분 |

### 세션 시작 루틴
```
1. WORKFLOW.md 읽기
2. generated/index.json 읽기 (현재 상태 확인)
3. research/topic-backlog.md 읽기 (다음 주제 확인)
4. 해당 카테고리 templates/*.md 읽기
```

### 글 생성 프로세스
```
1. topic-backlog.md에서 미완료 주제 선택 (또는 웹 검색으로 뉴스 주제 확보)
2. 해당 카테고리 템플릿 로드
3. 템플릿 구조대로 글 작성
4. generated/YYYY-MM/YYYY-MM-DD-{slug}.md 로 저장
5. index.json에 새 항목 추가 (status: "draft")
6. topic-backlog.md에 체크표시 + 날짜
7. git add + commit + push (GitHub 접근 가능)
```

### index.json 항목 형식
```json
{
  "id": "YYYY-MM-DD-slug",
  "title": "제목",
  "category": "카테고리명",
  "status": "draft",
  "generated_at": "ISO8601",
  "published_at": null,
  "naver_url": null,
  "tags": ["태그1", "태그2"],
  "char_count": 1950,
  "image_count": 3,
  "images_ready": false,
  "file": "generated/YYYY-MM/YYYY-MM-DD-slug.md"
}
```

### 발행 프로세스
브라우저 자동화는 불가하므로 발행만 사용자 수동:
1. Gemma가 글 생성 → status를 "ready"로 변경 → git commit + push
2. 사용자가 generated/ 에서 파일 열기
3. 네이버 블로그 글쓰기에 복붙
4. 발행 후 Gemma에게 "발행 완료, URL은 [URL]" 전달
5. Gemma가 index.json의 status를 "published"로, naver_url 업데이트 → commit + push

---

## 7. 뉴스 수집 워크플로우

Antigravity 웹 접근으로 실시간 뉴스 검색 가능.

### 뉴스 기반 글 작성 프로세스
```
1. research/news-sources.md의 Tier 1-2 소스 웹 검색
2. 가장 임팩트 있는 소식 1-2개 선택
3. index.json과 중복 체크
4. 한국 독자 관점에서 관심도 높은 주제 우선
5. 해당 카테고리 템플릿으로 글 작성
```

### 용어사전/활용법 병행 전략
뉴스와 무관하게 작성 가능한 카테고리도 병행:
- AI 용어 사전 8편 남음 (LLM, 파인튜닝, 프롬프트 엔지니어링 등)
- AI 활용법 10편 대기
- Evergreen 5편 대기
→ 이것만으로도 23편. 뉴스 글과 병행하면 50편 목표 빠르게 달성 가능.

---

## 8. 세션 프롬프트 (Gemma 4.0용)

### 용어 사전 1편 작성
```
workspaces/naver-blog/WORKFLOW.md를 읽어.
templates/ai-glossary.md 템플릿을 읽어.
research/topic-backlog.md에서 AI 용어 사전 중 아직 체크 안 된 첫 번째 주제로
블로그 글 1편을 작성해.
generated/2026-04/ 에 저장하고 index.json을 업데이트해.
```

### 도구 리뷰 1편 작성
```
workspaces/naver-blog/WORKFLOW.md를 읽어.
templates/ai-tool-review.md 템플릿을 읽어.
research/topic-backlog.md에서 AI 도구 리뷰 중 '[도구명]' 주제로
블로그 글 1편을 작성해.
generated/2026-04/ 에 저장하고 index.json을 업데이트해.
```

### 배치 생성 (3편)
```
workspaces/naver-blog/WORKFLOW.md를 읽어.
templates/ai-glossary.md 템플릿을 읽어.
research/topic-backlog.md에서 AI 용어 사전 중 아직 안 쓴 3개를 순서대로
모두 작성해서 generated/에 저장해. index.json도 업데이트해.
```

### 진행 상황 확인
```
workspaces/naver-blog/generated/index.json을 읽고,
현재 몇 편 생성됐고 몇 편 발행됐는지, 50편까지 얼마나 남았는지 알려줘.
```

---

## 9. 이미지 처리

### Gemma 4.0으로 할 수 있는 것
- 이미지 프롬프트 작성 (Gemini/DALL-E용)
- 이미지 alt text 한국어 작성
- 포스트 .md 파일에 이미지 위치 명세 작성

### 사용자가 해야 하는 것
- Unsplash/Pexels에서 이미지 다운로드
- Gemini로 커스텀 이미지 생성
- `generated/images/YYYY-MM/` 에 저장
- 파일명: `{post-id}-{순번}.jpg`

### 이미지 명세 포맷 (글에 포함)
```yaml
images_needed:
  - position: "도입부 아래"
    description: "설명"
    source: "unsplash"  # unsplash | gemini | screenshot
    search_query: "artificial intelligence technology"  # unsplash용
    prompt: "..."  # gemini용
```

---

## 10. 품질 체크리스트

글 생성 후 반드시 확인:

- [ ] 글자수 1,500-2,500자 범위 내
- [ ] H2 소제목 3개 이상
- [ ] 태그 7-9개, #AI #인공지능 포함
- [ ] "결론적으로", "종합하면" 같은 AI 투 문구 없음
- [ ] 문장 끝 ~어요/~습니다/~거든요/~네요 혼용됨
- [ ] 개인 반응 문장 1-2개 포함
- [ ] 문단 길이 불균일 (2-5문장 섞임)
- [ ] 마무리 질문이 구체적
- [ ] 제목에 검색 키워드가 앞에 위치
- [ ] images_needed 명세 포함
- [ ] index.json 업데이트됨
- [ ] topic-backlog.md 체크표시됨

---

## 11. 로드맵 (남은 작업)

| 우선순위 | 작업 | 편수 | 뉴스 필요 |
|---|---|---|---|
| 1 | AI 용어 사전 나머지 | 8편 | 불필요 |
| 2 | AI 활용법 | 10편 | 불필요 |
| 3 | Evergreen 콘텐츠 | 5편 | 불필요 |
| 4 | AI 도구 리뷰 | 10편 | 일부 필요 |
| 5 | AI 뉴스 | 매일 | 필요 |
| 6 | 주간 AI 브리핑 | 매주 | 필요 |

**권장 순서**: 1→2→3 먼저 (뉴스 없이 23편 확보 가능), 이후 4→5→6
