# Local AI 머신별 역할 분배

> **작성일**: 2026-04-11
> **목적**: 3대 머신의 유휴 시간을 활용한 콘텐츠/부가가치 생산 자동화

---

## 머신 스펙 요약

| # | 머신 | GPU/모델 | 모델 크기 | OS | 위치 | 주 용도 |
|---|---|---|---|---|---|---|
| 1 | MAC | gemma4:e4b | 9.6 GB (~12B) | macOS | 집/이동 | 개인 작업 + 로봇 테스트 |
| 2 | RTX 5060 Ti | gemma4:e4b | 9.6 GB (~12B) | Windows | 사무실 | 가끔 사용 |
| 3 | RTX 5090 | gemma4:e4b+ | 서버급 | Windows/Linux | 연구실 | 학습 + PaperBanana |

**모델 동일**: MAC과 RTX 5060 Ti 모두 gemma4:e4b — 역할로 분리 (초안 생산 vs 검수+고품질)
**유휴 시간 순서**: RTX 5060 Ti (가끔 사용) > MAC (주력)

---

## 역할 분배

```
┌─────────────────────────────────────────────────────────────┐
│                    콘텐츠 파이프라인                          │
│                                                             │
│  MAC (E4B)          RTX 5060 Ti (E4B)    RTX 5090 (서버)    │
│  ┌──────────┐      ┌──────────────┐     ┌──────────────┐   │
│  │ 네이버    │      │ 기술 블로그   │     │ PaperBanana  │   │
│  │ 블로그    │      │ + YouTube    │     │ + 연구 콘텐츠 │   │
│  │ 초안 생산 │      │ 고품질 생산   │     │ + 품질 검수   │   │
│  └──────────┘      └──────────────┘     └──────────────┘   │
│       │                   │                    │            │
│       └───────────────────┴────────────────────┘            │
│                    ↓ git push → Vercel 배포                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 1. MAC — gemma4:e4b (경량 초안 생산기)

### 왜 이 역할?
- 주력 머신이라 유휴 시간이 상대적으로 적음 → 빠르게 초안만 찍어내는 역할
- 템플릿 기반 짧은 글 (1500-2500자)에 집중
- Antigravity 연동으로 웹 + GitHub 접근 가능

### 담당 작업

| 작업 | 세부 | 빈도 |
|---|---|---|
| **네이버 블로그 초안** | AI 용어 사전, AI 활용법, Evergreen | 유휴 시 배치 3-5편 |
| **네이버 뉴스 글** | 웹 검색 → AI 뉴스 1편 | 매일 유휴 시 |
| **index.json 관리** | 트래킹 업데이트, 상태 변경 | 글 생성마다 |
| **topic-backlog 관리** | 체크표시, 새 주제 추가 | 글 생성마다 |
| **git commit + push** | 생성된 글 즉시 푸시 | 매 작업 후 |

### 유휴 시간 자동화 시나리오
```
[사용자 자리 비움 감지 or 수동 시작]
  → WORKFLOW.md 읽기
  → topic-backlog.md에서 미완료 주제 확인
  → 용어 사전/활용법 중심으로 3편 배치 생성
  → index.json 업데이트
  → git commit + push
  → 완료 로그 남김
```

### 세션 프롬프트
```
workspaces/naver-blog/WORKFLOW.md를 읽어.
research/topic-backlog.md에서 체크 안 된 항목 중
AI 용어 사전 또는 AI 활용법 카테고리에서 3편을 순서대로 작성해.
각 편마다 해당 templates/ 파일을 참고해.
generated/2026-04/ 에 저장하고 index.json 업데이트해.
topic-backlog.md에 체크표시 + 날짜 추가.
완료 후 git commit + push.
```

### 출력 위치
```
workspaces/naver-blog/generated/YYYY-MM/*.md
workspaces/naver-blog/generated/index.json
```

---

## 2. RTX 5060 Ti — gemma4:e4b (고품질 콘텐츠 생산기)

### 왜 이 역할?
- 사무실에서 가끔 사용 = 유휴 시간 가장 많음 → 시간 많이 드는 작업 배정
- 기술 블로그(EN+KO 이중 언어), YouTube 스크립트 등 긴 작업 담당
- MAC 초안을 검수해서 품질 올리는 편집장 역할

### 담당 작업

| 작업 | 세부 | 빈도 |
|---|---|---|
| **기술 블로그 포스트** | STM32 시리즈 확장, 새 기술 주제 (EN+KO) | 주 1-2편 |
| **YouTube 스크립트** | 영상 대본, 설명문, 태그 | 주 1편 |
| **네이버 도구 리뷰** | 심층 리뷰 (E4B 품질 필요) | 주 1-2편 |
| **주간 AI 브리핑** | 뉴스 종합 (긴 글, 분석력 필요) | 주 1편 |
| **MAC 초안 품질 검수** | E4B가 생성한 네이버 글 리뷰/수정 | 필요 시 |
| **Tech Radar 업데이트** | blip 추가/이동 | 분기별 |

### 유휴 시간 자동화 시나리오
```
[사무실 퇴근 후 자동 시작]
  → 기술 블로그: 웹에서 트렌드 리서치
  → EN 포스트 작성 → content/en/study/
  → KO 포스트 작성 → content/ko/study/
  → YouTube 스크립트 작성 → workspaces/youtube/scripts/
  → MAC이 생성한 네이버 초안 리뷰 (generated/ 확인)
  → git commit + push
```

### 세션 프롬프트

#### 기술 블로그 (EN → KO)
```
packages/website/content/en/study/ 기존 포스트 스타일을 확인해.
'[주제]'에 대한 블로그 포스트를 EN으로 작성해.
800-1500 단어, 톤: conversational, opinionated, 코드 예시 포함.
content/en/study/[slug].md 에 저장.

이어서 같은 내용을 한국어로 번역해서
content/ko/study/[slug].md 에 저장해.
완료 후 git commit + push.
```

#### YouTube 스크립트
```
workspaces/youtube/planning/content-calendar.md를 확인해.
'[주제]' 영상 스크립트를 작성해.
인트로(30초) → 본문(파트 3개) → 아웃트로(30초) 구조.
workspaces/youtube/scripts/[slug].md 에 저장.
content-calendar.md에 에피소드 추가.
완료 후 git commit + push.
```

#### MAC 초안 검수
```
workspaces/naver-blog/generated/ 에서 최근 생성된 글들을 읽어.
AI 투 표현, 문체 불균일, 사실 오류를 체크해서 수정해.
수정된 글의 index.json status를 "ready"로 변경.
완료 후 git commit + push.
```

### 출력 위치
```
packages/website/content/en/study/*.md
packages/website/content/ko/study/*.md
workspaces/youtube/scripts/*.md
workspaces/naver-blog/generated/*.md (검수 후 수정)
```

---

## 3. RTX 5090 — 학습 전용 (콘텐츠 생산 제외)

### 역할
- **PaperBanana 구현** + **모델 학습(fine-tuning)** 전용
- GPU를 학습에 집중 투입, 콘텐츠 생산에는 사용하지 않음
- 품질 검수와 콘텐츠 생산은 MAC + RTX 5060 Ti 2대가 전담

---

## 워크플로우: MAC + RTX 5060 Ti 2대 협업

```
     MAC (E4B)                    RTX 5060 Ti (E4B)
     ─────────                    ────────────────
     │                            │
     ├─ 네이버 초안 3-5편 생성     │
     ├─ git push ──────────────→  ├─ pull
     │                            ├─ 초안 검수 + 수정
     │                            ├─ status → "ready"
     │                            ├─ 기술 블로그 EN+KO 작성
     │                            ├─ YouTube 스크립트 작성
     │                            ├─ git push
     │                            │
     ↓                            ↓
  사용자: 네이버 발행 (복붙)    Vercel 자동 배포
```

**RTX 5090은 학습 전용 — 콘텐츠 파이프라인에 포함하지 않음.**

### 핵심 규칙
1. **같은 파일을 동시에 수정하지 않음** — 각 머신의 출력 디렉토리가 분리됨
2. **git pull 먼저, push 나중** — 충돌 방지
3. **index.json은 MAC이 주 관리** — 네이버 블로그 트래킹의 single source of truth
4. **검수는 E4B가 담당** — E4B 초안 → E4B 검수 후 "ready" 처리

---

## 주간 목표 (MAC + RTX 5060 Ti)

| 콘텐츠 | 편수/주 | 담당 |
|---|---|---|
| 네이버 블로그 (초안) | 7-10편 | MAC |
| 네이버 블로그 (검수→ready) | 7-10편 | RTX 5060 Ti |
| 기술 블로그 (EN+KO) | 1-2편 | RTX 5060 Ti |
| YouTube 스크립트 | 1편 | RTX 5060 Ti |
| 주간 AI 브리핑 | 1편 | RTX 5060 Ti |

### 50편 달성 예상
- MAC이 주 7-10편 초안 → RTX 5060 Ti가 검수
- 약 5-7주 안에 50편 달성 가능 (기존 2편 + 신규 48편)
- 애드포스트 신청 조건: 50편 + 90일 활동
