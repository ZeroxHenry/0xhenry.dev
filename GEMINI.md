# 0xhenry.dev — AI Agent Instructions

## Machine Role
- **이 문서가 있는 기기 (Windows RTX 5060 Ti)**: 메인 작업대
  - 네이버 블로그, 기술블로그, 유튜브, 모든 콘텐츠 생산
  - Encho Extension (gemma4:e4b) + Antigravity
- **Mac**: 기술 개발 전용 (코딩, 연구). 콘텐츠 작업 안 함.
- 중복 방지: 작업 전 `vault/20_Meta/Log.md` 확인

## @local Model Routing
`@local` 입력 시 로컬 모델로 라우팅:
- `baseUrl`: `http://localhost:11434/v1`
- `model`: `gemma4:e4b`

## Shared Memory (Obsidian Vault)
- 위치: `vault/` (이 repo 안)
- 구조:
  ```
  vault/
  ├── 00_Raw/          ← 원본 소스 (유튜브, 논문, 아이디어)
  │   ├── naver-blog/  ← 네이버 블로그 원본/이미지
  │   └── _templates/  ← 노트 템플릿
  ├── 10_Wiki/         ← AI가 정리하는 위키
  │   ├── Projects/    ← 프로젝트별 위키
  │   └── Topics/      ← 개념별 위키
  └── 20_Meta/         ← 메타 (Log, Policy, Index, Dashboard)
  ```
- **Log.md**: 모든 작업 기록. 작업 완료 시 반드시 추가.
- **wiki-link**: `[[노트이름]]` 형식으로 노트 간 연결
- **YAML frontmatter**: 모든 위키 노트에 tags, created, summary 포함

## Language & Style
- 한국어로 소통
- 기술 스펙은 공식 소스 확인 필수, 추측 금지
- Exosuit이라고 부를 것 (외골격/exoskeleton 아님)

---

# Task Prompts

## 1. 네이버 블로그

### 1-1. 뉴스 기반 1편 생성 + 발행
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
오늘의 AI 뉴스를 검색해서 블로그 글 1편 작성해줘.
generated/ 폴더에 저장하고 vault/20_Meta/Log.md에 기록해.
```

### 1-2. 배치 생성 (3편)
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
AI 용어 사전 카테고리로 3편 생성해줘.
각 포스트는 generated/ 폴더에 저장. 발행은 안 해도 됨.
완료 후 vault/20_Meta/Log.md에 기록.
```

### 1-3. 주간 브리핑
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
이번 주 AI 뉴스 종합 주간 브리핑 작성해줘.
vault/20_Meta/naver-blog-dashboard.md 업데이트 포함.
```

### 1-4. 특정 주제
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
'[주제]' 에 대한 블로그 글을 작성해줘.
카테고리: [AI 용어 사전 / AI 뉴스 / AI 도구 리뷰 / AI 실전 활용]
```

## 2. 기술 블로그 (0xhenry.dev)

### 2-1. 새 포스트 생성
```
@local packages/website/content/ko/study/ 구조를 확인하고,
'[주제]' 에 대한 기술 블로그 포스트를 작성해줘.
ko/와 en/ 양쪽에 생성. Hugo frontmatter 형식 사용.
vault/10_Wiki/에 관련 위키 노트도 업데이트.
```

### 2-2. 기존 포스트 보완
```
@local packages/website/content/ko/study/[카테고리]/ 의 포스트들을 읽고,
내용이 부족한 부분을 보완해줘.
코드 예제 추가, 설명 보강, 관련 링크 추가.
```

### 2-3. 시리즈 기획
```
@local vault/10_Wiki/Topics/ 에서 '[주제]' 관련 위키를 읽고,
이 주제로 5편짜리 기술 블로그 시리즈를 기획해줘.
각 편의 제목, 핵심 내용, 예상 분량을 정리해서
vault/10_Planning/ 에 저장.
```

## 3. 유튜브 콘텐츠

### 3-1. 스크립트 작성
```
@local '[주제]' 에 대한 유튜브 스크립트를 작성해줘.
형식: 인트로(30초) → 본론(5-7분) → 아웃트로(30초)
톤: 친근하지만 전문적, 한국어
vault/00_Raw/youtube/ 에 저장.
```

### 3-2. 영상 기획
```
@local vault/10_Wiki/Topics/ 에서 인기 있을 만한 주제 5개를 골라서
유튜브 영상 기획안을 작성해줘.
각 기획안: 제목, 썸네일 컨셉, 핵심 내용, 예상 조회수 근거.
vault/10_Planning/ 에 저장.
```

## 4. Vault 관리

### 4-1. 새 지식 Ingest
```
@local 다음 내용을 vault에 정리해줘:
[URL 또는 텍스트 붙여넣기]

1. 00_Raw/에 원본 저장
2. 10_Wiki/Topics/ 에 위키 노트 생성/업데이트
3. 기존 노트와 [[링크]] 연결
4. 20_Meta/Log.md에 기록
```

### 4-2. Vault Lint
```
@local vault/10_Wiki/ 전체를 점검해줘:
- 고아 노트 (아무데서도 링크 안 되는 노트)
- 깨진 링크 ([[존재하지 않는 노트]])
- 태그 불일치
- 오래된 정보 (3개월 이상 미업데이트)
결과를 20_Meta/Log.md에 기록.
```

### 4-3. 일일 브리핑
```
@local vault/20_Meta/Log.md 와 최근 커밋 히스토리를 보고
오늘의 브리핑을 작성해줘:
- 어제 완료한 작업
- 오늘 할 일 제안
- vault 상태 요약
```

## 5. Git Sync (작업 마무리)

### 모든 작업 후 반드시 실행:
```
@local 작업 완료. 다음을 실행해줘:
1. vault/20_Meta/Log.md에 오늘 작업 내역 추가
2. git add .
3. git commit -m "content: [작업 요약]"
4. git push
```

---

# Rules
- 작업 시작 전 `git pull` 필수
- 작업 완료 후 `git push` 필수
- vault Log에 모든 작업 기록
- 파일명은 한국어 가능, 특수문자 최소화
- 이미지는 해당 포스트 폴더에 함께 저장
- JSON-AI 구조화 프롬프트 스타일 활용 (복잡한 지시 시)
