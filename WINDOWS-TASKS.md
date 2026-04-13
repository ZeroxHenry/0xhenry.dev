# Windows @local 작업 명령 모음

> Windows에서 `git pull` 후, Antigravity에서 아래 명령을 @local 뒤에 복붙해서 사용.
> 작업 완료 후 반드시 `git add . && git commit -m "내용" && git push`

---

## A. 네이버 블로그 — 미발행 58편 이미지 생성 + 발행

### A-1. 이미지 없는 포스트에 이미지 생성 (최우선)
```
@local workspaces/naver-blog/generated/index.json 을 읽어.
images_ready가 false인 포스트 목록을 뽑고, 그 중 처음 5개의 본문을 읽어서
각 포스트에 필요한 이미지 3장의 프롬프트를 작성해줘.
결과를 workspaces/naver-blog/generated/pending_images.json 에 저장.
```

### A-2. 네이버 블로그 발행 (이미지 준비된 것부터)
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
workspaces/naver-blog/generated/index.json 에서 images_ready가 true인 포스트를 확인해.
가장 오래된 draft 3편을 네이버 블로그에 발행해줘.
발행 후 index.json의 status를 published로, naver_url을 기록해.
vault/20_Meta/Log.md에 발행 내역 추가.
```

### A-3. 뉴스 기반 신규 1편 생성
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
오늘의 AI 뉴스를 검색해서 가장 화제인 주제로 블로그 글 1편 작성.
workspaces/naver-blog/generated/2026-04/ 에 저장하고 index.json에 추가.
이미지 프롬프트 3개도 함께 작성.
vault/20_Meta/Log.md에 기록.
```

---

## B. 기술 블로그 — Chapter별 포스트 작성

### B-1. Chapter 1: Context & Memory (다음 미작성분)
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
CHAPTER 1에서 ⬜ 상태인 첫 번째 포스트를 작성해줘.
C-03 "AI의 RAM 관리법: 동적 컨텍스트 조립 패턴 5가지" 를 작성.

규칙:
- packages/website/content/ko/study/C_context-memory/ 에 한국어 버전
- packages/website/content/en/study/C_context-memory/ 에 영어 버전
- Hugo frontmatter 포함 (title, date, tags, categories, series)
- 2,000-3,000자 (ko 기준), 코드 예제 포함
- "남들은 성공 튜토리얼을 씁니다. 0xHenry는 실패와 그 해결을 씁니다" 톤
- 완료 후 tech-blog-plan.md 의 상태를 ✅ 로 변경
- vault/20_Meta/Log.md에 기록
```

### B-2. Chapter 2: AI 에이전트 신뢰성 (다음 미작성분)
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
CHAPTER 2에서 ⬜ 상태인 첫 번째 포스트를 작성해줘.
A-02 "내 AI 에이전트가 서서히 멍청해졌다 — LLM Drift 감지법" 를 작성.

규칙:
- packages/website/content/ko/study/A_agent-reliability/ 에 한국어 버전
- packages/website/content/en/study/A_agent-reliability/ 에 영어 버전
- Hugo frontmatter 포함
- 실패 사례 + 해결법 중심으로
- 완료 후 tech-blog-plan.md 상태 ✅ 변경
- vault/20_Meta/Log.md에 기록
```

### B-3. Chapter 3: MCP 보안 (다음 미작성분)
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
CHAPTER 3에서 ⬜ 상태인 첫 번째 포스트를 작성해줘.
S-02 "MCP vs REST API: 언제 MCP를 쓰고 언제 쓰지 말아야 하는가" 를 작성.

규칙:
- packages/website/content/ko/study/S_mcp-security/ 에 한국어 버전
- packages/website/content/en/study/S_mcp-security/ 에 영어 버전
- 실측 비교, 표, 코드 예시 포함
- 완료 후 tech-blog-plan.md 상태 ✅ 변경
- vault/20_Meta/Log.md에 기록
```

### B-4. Chapter 4: LLMOps (다음 미작성분)
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
CHAPTER 4에서 ⬜ 상태인 첫 번째 포스트를 작성해줘.
O-01 "HTTP 200인데 비즈니스가 망가졌다 — AI 품질 KPI 설계" 를 작성.

규칙:
- packages/website/content/ko/study/O_llmops/ 에 한국어 버전
- packages/website/content/en/study/O_llmops/ 에 영어 버전
- 실전 사례, 메트릭 설계, 모니터링 코드 포함
- 완료 후 tech-blog-plan.md 상태 ✅ 변경
- vault/20_Meta/Log.md에 기록
```

### B-5. Chapter 5: RAG 심화 (다음 미작성분)
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
CHAPTER 5에서 ⬜ 상태인 첫 번째 포스트를 작성해줘.
R-01 "RAG가 틀리는 순간 — False Retrieval 5가지 패턴과 수치" 를 작성.

규칙:
- packages/website/content/ko/study/R_rag-advanced/ 에 한국어 버전
- packages/website/content/en/study/R_rag-advanced/ 에 영어 버전
- 실패 패턴 분석, 실측 수치, 재현 코드
- 완료 후 tech-blog-plan.md 상태 ✅ 변경
- vault/20_Meta/Log.md에 기록
```

### B-6. Chapter 6: Edge AI (다음 미작성분)
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
CHAPTER 6에서 ⬜ 상태인 첫 번째 포스트를 작성해줘.
E-01 "STM32에서 AI를? TinyML로 제스처 인식 실전 구현" 를 작성.

규칙:
- packages/website/content/ko/study/E_edge-ai/ 에 한국어 버전
- packages/website/content/en/study/E_edge-ai/ 에 영어 버전
- 하드웨어 스펙 정확히, 코드 전체 포함, 회로도 설명
- 완료 후 tech-blog-plan.md 상태 ✅ 변경
- vault/20_Meta/Log.md에 기록
```

### B-7. 범용: "다음 미작성 포스트 1편 써줘"
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
전체 챕터에서 ⬜ 상태인 포스트 중 가장 첫 번째를 찾아서 작성해줘.

규칙:
- ko/와 en/ 양쪽 생성
- Hugo frontmatter 포함
- 0xHenry 톤 (실패+해결 중심)
- 완료 후 상태 ✅ 변경 + vault Log 기록
```

---

## C. 배치 작업 (한번에 여러 편)

### C-1. 기술블로그 3편 배치
```
@local vault/10_Planning/tech-blog-plan.md 를 읽어.
⬜ 상태인 포스트 중 처음 3개를 순서대로 작성해줘.
각각 ko/en 버전 생성. 완료 시 tech-blog-plan.md 상태 업데이트.
vault/20_Meta/Log.md에 3편 모두 기록.
```

### C-2. 네이버 블로그 5편 배치 생성
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
AI 실전 활용 카테고리로 5편 생성해줘.
주제: 일상에서 바로 쓸 수 있는 AI 활용법.
generated/ 폴더에 저장하고 index.json 업데이트.
vault/20_Meta/Log.md에 기록.
```

---

## D. Vault 관리

### D-1. 오늘의 브리핑
```
@local vault/20_Meta/Log.md 와 git log --oneline -20 을 보고 브리핑 작성:
- 최근 완료 작업
- 네이버 블로그: 발행/미발행 현황
- 기술블로그: 챕터별 진행률
- 오늘 추천 작업
vault/20_Meta/Log.md에 브리핑 추가.
```

### D-2. Vault 위키 업데이트
```
@local 최근 작성한 기술블로그 포스트들을 읽고,
vault/10_Wiki/Topics/ 에 관련 위키 노트를 업데이트해줘.
새 개념이 있으면 새 노트 생성, 기존 노트는 내용 보강.
[[링크]]로 연결. vault/20_Meta/Log.md에 기록.
```

---

## E. Git Sync (모든 작업 마무리)

```
@local 작업 마무리해줘.
1. vault/20_Meta/Log.md에 오늘 작업 요약 추가
2. git add .
3. git commit -m "content: [오늘 날짜] [작업 요약]"
4. git push
```

---

## 작업 순서 추천 (매일)

1. `git pull` (Mac 작업물 동기화)
2. **D-1** 브리핑으로 현황 파악
3. **B-7** 기술블로그 1편 작성
4. **A-2** 네이버 블로그 발행 (준비된 것)
5. **E** Git sync
