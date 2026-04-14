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

### 이미지 원칙 (Visual-First v8)
- **NotebookLM 우선**: 인위적인 생성 이미지 대신 NotebookLM의 브리핑/가이드 영역 캡처본 사용.
- **Vision Clean 필수**: `scripts/vision_cleaner.py`를 사용하여 상/하단 UI 바 일괄 제거.
- **해상도**: 네이버 블로그 권장 해상도(최소 1200px 이상) 지향.

---

## Chrome 자동화 요약 (Anti-Bot 가이드)

### 🛡️ 봇 감지 우회 규칙 (필수)
1. **인간적 타이핑**: `page.type` 사용 시 각 글자 사이에 **100~300ms 랜덤 딜레이** 부여.
2. **유동적 섹션 대기**: 섹션 입력(제목 -> 본문 -> 이미지) 사이에 **5~15초 랜덤 대기**.
3. **스크롤 시뮬레이션**: 발행 버튼 클릭 전, 페이지 하단까지 스크롤했다가 다시 상단으로 올라오는 '검토' 모션 수행.
4. **버튼 호버(Hover)**: 모든 클릭 버튼(발행, 확인 등)에 마우스를 **0.5~1.5초간 호버** 후 클릭.
5. **고정 패턴 파기**: 매 포스트마다 대기 시간과 마우스 경로를 무작위로 변경.

### 발행 순서 (Secure Mode)
1. navigate → blog.naver.com/0xhenry/postwrite
2. javascript_tool → 로그인 확인
3. human_typing → 제목 입력 (랜덤 딜레이)
4. human_typing → 본문 섹션별 입력 (섹션 간 10초 대기)
5. upload_image → 이미지 삽입 (NotebookLM 정제본)
6. mouse_move & click → 카테고리/태그 설정
7. scroll_and_review → 페이지 전체 스캔 시뮬레이션
8. hover_and_publish → 발행 버튼 클릭

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
