# 이미지 가이드라인

## 일반 규칙
- 포스트당 최소 3장, 이상적으로 5장
- 섹션 사이에 배치 (글 맨 아래 몰아넣기 X)
- 한국어 alt text 필수 (네이버 이미지 검색 인덱싱)
- 가로형(landscape) 선호 — 블로그 레이아웃에 적합
- 권장 크기: 1080px 너비, 250-400KB
- 출처: Unsplash (우선) / Pexels (백업)

## 카테고리별 검색 쿼리

### AI 뉴스
| 우선순위 | 검색어 | 용도 |
|---|---|---|
| 1 | artificial intelligence technology | 대표 이미지 |
| 2 | computer neural network | 기술 설명 |
| 3 | robot technology future | 미래 전망 |
| 4 | digital transformation | 산업 변화 |

### AI 도구 리뷰
| 우선순위 | 검색어 | 용도 |
|---|---|---|
| 1 | laptop software interface | 도구 소개 |
| 2 | productivity technology workspace | 작업 환경 |
| 3 | person using computer | 사용 장면 |
| 4 | app interface design | UI 소개 |

### AI 활용법
| 우선순위 | 검색어 | 용도 |
|---|---|---|
| 1 | person working computer office | 실사용 장면 |
| 2 | digital workflow productivity | 워크플로우 |
| 3 | step by step guide | 단계별 가이드 |
| 4 | before after comparison | 전후 비교 |

### AI 용어 사전
| 우선순위 | 검색어 | 용도 |
|---|---|---|
| 1 | abstract data visualization | 개념 도식 |
| 2 | technology concept digital | 기술 개념 |
| 3 | brain network connection | 뉴럴넷 비유 |
| 4 | book learning education | 학습/교육 비유 |

### 주간 AI 브리핑
| 우선순위 | 검색어 | 용도 |
|---|---|---|
| 1 | news technology digital | 뉴스 대표 |
| 2 | weekly review summary | 요약/정리 |
| 3 | trend graph chart | 트렌드 차트 |

## 이미지 저장 규칙
- 경로: `generated/images/YYYY-MM/`
- 파일명: `{post-id}-{순번}.jpg` (예: `rag-explained-1.jpg`)
- 메타데이터: 포스트 .md frontmatter의 images 배열에 기록

## 이미지 조달 방식 (비용 0원)

### 1. Unsplash/Pexels 직접 다운로드 (Claude가 Chrome으로)
- 사이트 접속 → 검색 → 다운로드 버튼 클릭
- API 키 불필요, 계정 불필요
- 일반 배경/개념 이미지에 적합

### 2. Gemini AI 이미지 생성 (사용자가 직접)
- Claude가 한국어 Gemini 프롬프트 작성
- 사용자가 Gemini 무료 티어로 생성
- generated/images/YYYY-MM/ 에 저장
- 커스텀 도식, 개념 설명 이미지에 적합

### 3. 스크린샷 (Claude가 Chrome으로)
- 서비스/도구 리뷰 시 해당 사이트 캡처
- chrome 자동화로 직접 촬영

### 포스트 작성 시 이미지 명세서 포함
각 포스트 .md 파일에 필요한 이미지 명세:
```
images_needed:
  - position: "도입부 아래"
    description: "AI가 문서를 검색하는 모습 일러스트"
    source: "gemini"  # unsplash | gemini | screenshot
    prompt: "AI 로봇이 책장에서 책을 꺼내는 미니멀한 일러스트, 파란색 톤, 16:9"
  - position: "핵심 내용 1 아래"
    description: "RAG 아키텍처 다이어그램"
    source: "gemini"
    prompt: "RAG 시스템 플로우차트, 검색→생성 과정, 깔끔한 인포그래픽 스타일"
```

## 저작권 / 크레딧
- Unsplash: 크레딧 불필요 (권장사항일 뿐)
- Pexels: 크레딧 불필요
- Gemini 생성: 저작권 문제 없음 (본인 생성)
- 절대 사용 금지: Google 이미지 검색에서 가져온 이미지
- 공식 발표 이미지: 출처 명시 필요 (예: "출처: OpenAI 공식 블로그")
