# 인수인계서: YouTube 콘텐츠 생성

> **이전 대상**: Claude Code + Antigravity(Gemini) → Gemma 4.0 (Ollama localhost:11434)
> **작성일**: 2026-04-11
> **프로젝트 위치**: `workspaces/youtube/` + `.antigravity/build-website.md`

---

## 1. 미션

**채널명**: 0xHenry
**포지셔닝**: 엔지니어 스터디 — 임베디드/로보틱스/AI 기술을 쉽게 풀어내는 채널
**브랜드**: Cyber Teal (#0d9488) 어두운 배경, 테크 패턴, Inter 폰트
**현재 단계**: 초기 기획 (영상 0편, 에셋 미생성)

---

## 2. 현재 상태 (2026-04-11 기준)

| 항목 | 상태 |
|---|---|
| 콘텐츠 캘린더 | 비어있음 ("아직 없음") |
| 에피소드 계획 | 없음 |
| 브랜드 에셋 | 미생성 (Antigravity 세션 프롬프트만 준비됨) |
| 썸네일 | 미생성 |
| 스크립트 | 없음 |

---

## 3. 파일 맵

```
workspaces/youtube/
├── planning/
│   └── content-calendar.md    ← 에피소드 일정 (현재 비어있음)
├── scripts/                   ← 영상 스크립트 (.gitkeep만 있음)
├── brand/                     ← 채널 브랜드 에셋 (.gitkeep만 있음)
└── thumbnails/                ← 썸네일 파일 (.gitkeep만 있음)

.antigravity/build-website.md  ← SESSION 2: YouTube 에셋 생성 프롬프트
.antigravity/prompts.md        ← P2: 썸네일 템플릿, P3: 로워서드/아이콘
```

---

## 4. 기존에 계획되었던 에셋 (Antigravity 세션 프롬프트 기반)

### 4-1. 썸네일 템플릿 (1280x720)
- 위치: `public/images/youtube/thumb-template-dark.svg`
- 스타일: 다크 배경 + 서킷 패턴 + 텍스트 영역
- 0xHenry 로고 워터마크 (우하단)

### 4-2. 로워 서드 (Lower Third)
- 위치: `public/images/youtube/lower-third.svg`
- 투명 배경, 하단 좌측 이름 표시, accent 언더라인

### 4-3. 포인트 아이콘 세트
- 위치: `public/images/youtube/icons/`
- check.svg, warning.svg, info.svg, arrow.svg
- accent 컬러, 투명 배경

### 4-4. 인트로/아웃트로 카드
- 위치: `public/images/youtube/intro-card.svg`, `outro-card.svg`
- 0xHenry 로고 + "Engineer Study" 텍스트

---

## 5. 콘텐츠 유형별 작업 범위

### 유형 A: 영상 스크립트 작성
Gemma 4.0이 가장 잘 할 수 있는 영역.

**스크립트 구조**:
```markdown
# [에피소드 제목]

## 메타데이터
- 예상 길이: N분
- 카테고리: [임베디드/AI/로보틱스/도구리뷰]
- 대상: [비전공자/전공자/공통]

## 인트로 (30초)
[훅 → 오늘 다룰 내용 → 왜 중요한지]

## 본문
### 파트 1: [소제목] (N분)
[설명 + 시각자료 지시]

### 파트 2: [소제목] (N분)
[설명 + 데모/코드 지시]

### 파트 3: [소제목] (N분)
[설명 + 실습/결과]

## 아웃트로 (30초)
[요약 → 다음 편 예고 → 구독 유도]

## 영상 편집 노트
- [타임스탬프]: [자막/효과/B-roll 지시]
```

### 유형 B: 썸네일 텍스트 기획
- 메인 텍스트 (3-5단어, 충격/호기심 유발)
- 서브 텍스트 (1줄)
- 컬러 지시 (브랜드 팔레트 내)

### 유형 C: 영상 설명문 + 태그
- YouTube 설명란 텍스트
- SEO 태그 (한국어 + 영어)
- 타임스탬프 챕터
- 관련 링크

---

## 6. 브랜드 가이드라인

| 항목 | 값 |
|---|---|
| 메인 컬러 | #0d9488 (Cyber Teal) |
| 호버 컬러 | #0f766e |
| 밝은 그린 | #10b981 |
| 다크 배경 | #030712 |
| 라이트 배경 | #ffffff |
| 폰트 | Inter (Bold=제목, Regular=본문) |
| 로고 위치 | public/logo.svg, public/favicon.svg |

---

## 7. Gemma 4.0 전용 워크플로우

### 제약 사항
| 이전에 가능했던 것 | Gemma 4.0 대안 |
|---|---|
| Gemini로 SVG 에셋 생성 | SVG 코드 직접 작성 가능 (Gemma는 텍스트 기반) |
| 이미지 생성 AI | 사용자가 Gemini/DALL-E로 별도 생성 |
| 웹 리서치로 트렌드 파악 | 사용자가 주제 제공 |

### Gemma 4.0이 할 수 있는 것
1. **스크립트 작성**: 영상 스크립트 전문 작성 가능
2. **SVG 코드 생성**: 간단한 썸네일/아이콘 SVG 코드 생성 가능
3. **설명문/태그 작성**: YouTube 메타데이터 최적화
4. **콘텐츠 캘린더 관리**: 에피소드 기획/일정 관리
5. **기존 블로그 글 → 영상 스크립트 변환**: 웹사이트/네이버 블로그 글을 영상 대본으로 재가공

### 세션 시작 루틴
```
1. workspaces/youtube/planning/content-calendar.md 읽기
2. 기존 에피소드 확인 (scripts/ 디렉토리)
3. 요청된 작업 수행
```

---

## 8. 세션 프롬프트 (Gemma 4.0용)

### 에피소드 스크립트 작성
```
workspaces/youtube/planning/content-calendar.md를 읽어.
'[주제]'에 대한 YouTube 영상 스크립트를 작성해.
대상: [비전공자/전공자]
예상 길이: [N]분
workspaces/youtube/scripts/[slug].md 로 저장해.
content-calendar.md에도 에피소드 추가해.
```

### 블로그 글을 영상 스크립트로 변환
```
[packages/website/content/ko/study/파일명.md 또는
 workspaces/naver-blog/generated/파일명.md]를 읽어.
이 블로그 글을 YouTube 영상 스크립트로 변환해.
말하듯 자연스러운 톤으로, 시각자료 지시도 포함해.
workspaces/youtube/scripts/[slug].md 로 저장해.
```

### 썸네일 SVG 생성
```
'[주제]' 영상의 YouTube 썸네일 SVG를 만들어.
크기: 1280x720
스타일: 다크 배경(#030712), Cyber Teal(#0d9488) 악센트
메인 텍스트: '[3-5단어]'
0xHenry 로고 워터마크 우하단
workspaces/youtube/thumbnails/[slug]-thumb.svg 로 저장해.
```

### 영상 설명문 + 태그
```
workspaces/youtube/scripts/[slug].md를 읽어.
이 영상의 YouTube 설명문, 태그, 타임스탬프 챕터를 작성해.
한국어 + 영어 태그 각 10개.
```

---

## 9. 추천 콘텐츠 시리즈 (네이버 블로그/웹사이트와 연계)

### 시리즈 A: "AI 쉽게 알기" (비전공자)
네이버 블로그 AI 용어 사전을 영상으로 확장:
1. RAG란? (블로그 글 기존재)
2. 에이전트 AI란? (블로그 글 기존재)
3. LLM이란?
4. 파인튜닝이란?
5. 프롬프트 엔지니어링이란?

### 시리즈 B: "STM32 로봇 보드 만들기" (전공자)
웹사이트 STM32 시리즈를 영상으로 확장:
1. 아키텍처 기초
2. CubeMX 설정
3. GPIO 제어
4. 클럭 시스템
5. 핀 매핑

### 시리즈 C: "개발자 도구 리뷰" (공통)
네이버 블로그 도구 리뷰를 영상으로 확장

---

## 10. 품질 체크리스트

### 스크립트
- [ ] 인트로 훅이 30초 이내
- [ ] 파트별 시간 배분 명시
- [ ] 시각자료/데모 지시 포함
- [ ] 아웃트로에 구독 유도
- [ ] 타임스탬프 챕터 포함
- [ ] 비전공자 대상이면 전문용어 풀어쓰기

### 메타데이터
- [ ] 제목 60자 이내
- [ ] 설명문 500자 이상
- [ ] 한국어 태그 10개+
- [ ] 영어 태그 10개+
