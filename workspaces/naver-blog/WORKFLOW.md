# Naver Blog Workflow

## Quick Stats
- Published: 0 / 50
- Days active: 0
- AdPost 신청까지: 50편 + 90일
- Last session: -

## Today's Queue
> index.json의 status가 ready인 포스트를 여기서 확인

(아직 없음)

---

## Session Modes

### Mode 1: 뉴스 1편 생성 + 발행
```
WORKFLOW.md 읽고, 오늘의 AI 뉴스를 검색해서 블로그 글 1편 작성해줘.
generated/ 폴더에 저장하고, chrome으로 네이버 블로그에 발행해줘.
```

### Mode 2: 배치 생성 (발행 안 함)
```
WORKFLOW.md 읽고, AI 용어 사전 카테고리로 3편 생성해줘. 발행은 안 해도 됨.
```

### Mode 3: ready 포스트 일괄 발행
```
WORKFLOW.md 읽고, status가 ready인 포스트 모두 발행해줘.
```

### Mode 4: 주간 브리핑
```
WORKFLOW.md 읽고, 이번 주 AI 뉴스 종합 주간 브리핑 작성하고 발행해줘.
```

### Mode 5: 특정 주제 1편
```
WORKFLOW.md 읽고, AI 용어 사전 카테고리로 'RAG란?' 주제의 블로그 글을 작성해서 발행해줘.
```

---

## 콘텐츠 생성 규칙

### 글 구조
- 1,800-2,200자 (본문)
- 이미지 3-5장 (섹션 사이 배치)
- 태그 7-9개 (#AI #인공지능 필수 포함)
- H2 소제목 3개 이상

### AI 티 안 나게 쓰는 법
- 문장 끝 다양하게: ~어요, ~습니다, ~거든요, ~네요 혼용
- 개인 반응 1-2문장: "솔직히 이건 좀 놀랐어요", "써보니까 괜찮더라고요"
- 문단 길이 불균일 (2~5문장)
- 금지 표현: 결론적으로, 종합하면, 요약하자면, 다양한, 주목할 만한
- 마무리 질문은 구체적으로

### 이미지 원칙 (Collaboration)
- Quota 초과 시 `image_bridge/tasks.json`에 프롬프트 생성
- 사용자가 `image_bridge/input/`에 넣은 이미지를 에이전트가 자동 가공 (워터마크 제거)
- 가공된 이미지는 `generated/images/YYYY-MM/` 에 저장
- 네이버 블로그 권장 해상도(최소 1200px 이상) 및 16:9 비율 지향

---

## Chrome 자동화 요약

### 전제
- Chrome에서 Naver 로그인 상태
- claude-in-chrome MCP 활성

### 발행 순서
1. navigate → blog.naver.com/0xhenry/postwrite
2. javascript_tool → 로그인 확인
3. javascript_tool → 제목 입력
4. javascript_tool → 본문 섹션별 입력
5. upload_image → 이미지 삽입
6. javascript_tool → 카테고리/태그/발행

상세: scripts/PUBLISH-GUIDE.md 참고

---

## SEO / C-Rank / 정체성 규칙 (0xHenry Persona)
- **로봇 교육 지양**: "로봇 교육"이 주제가 아닌, "로봇 전문가의 시각"이 핵심 양념이 되어야 함.
- **차별화 소스**: 하드웨어 리스크, 물리 보안, 로컬 서버 구축 등 '실제 세상'과 연결된 AI 이슈 강조.
- **태그**: #AI #인공지능 필수 포함. 특정 기술 태그 병행.
- **발행 시간**: 오전 7-9시 or 저녁 7-9시.

---

## 카테고리
| 카테고리 | 템플릿 | 빈도 |
|---|---|---|
| AI 뉴스 | templates/ai-news.md | 매일 1-2편 |
| AI 도구 리뷰 | templates/ai-tool-review.md | 주 2-3편 |
| AI 활용법 | templates/ai-how-to.md | 주 1-2편 |
| AI 용어 사전 | templates/ai-glossary.md | 주 1편 |
| 주간 AI 브리핑 | templates/weekly-briefing.md | 주 1편 |

## 파일 참조
- `generated/index.json` — 트래킹
- `research/topic-backlog.md` — 주제 큐
- `research/news-sources.md` — 뉴스 소스
- `scripts/PUBLISH-GUIDE.md` — 발행 가이드
- `scripts/session-prompts.md` — 프롬프트 모음
