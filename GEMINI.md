# 0xhenry.dev — AI Agent Instructions

## Machine Role
- **이 문서가 있는 기기 (Windows RTX 5060 Ti)**: 메인 작업대
  - 네이버 블로그, 기술블로그, 유튜브, 모든 콘텐츠 생산
  - Encho Extension (google/gemma-4-e4b) + Antigravity
- **Mac**: 기술 개발 전용 (코딩, 연구). 콘텐츠 작업 안 함.
- 중복 방지: 작업 전 `vault/20_Meta/Log.md` 확인

## P-Reinforce Loop (MANDATORY)
**모든 콘텐츠 작업 시작 전 반드시 실행:**
1. `vault/20_Meta/Reinforcement_Insights.md` 읽기 → 현재 Reward/Punish 규칙 확인
2. ✅ Reward Rules에 명시된 패턴은 적극 복제
3. ❌ Punish Rules에 명시된 패턴은 즉시 배제
4. 작업 완료 후 `p_reinforce_collector.py` → `p_reinforce_analyzer.py` 순서로 실행하여 최신 인사이트 갱신

> 판단 기준: 조회수(블로그), 구독자/조회수(YouTube). 목표치 미달 시 원인 분석 필수.

---

## @local Model Routing
`@local` 입력 시 로컬 모델로 라우팅:
- `baseUrl`: `http://localhost:1234/v1`
- `model`: `google/gemma-4-e4b`

## Shared Memory (Obsidian Vault)
- 위치: `vault/` (이 repo 안)
- 구조:
  ```
   vault/
   ├── Research/           ← 학술 연구, 기술 프로젝트
   │   ├── 00_Raw/      ← 원본 소스 (Papers, Youtube)
   │   ├── 10_Wiki/      ← AI가 정리하는 위키 (Topics, Projects)
   │   └── 10_Planning/  ← 기술 로드맵
   ├── Life/               ← 개인 생활, 여가, 취미
   │   ├── 00_Raw/      ← 임시 스테이징 (초안, 발행 전) — Obsidian 지식으로 취급 안 함
   │   └── 10_Wiki/      ← 발행 완료된 포스트 아카이브 (글 + 사진 포함)
   └── 20_Meta/            ← 시스템 공통 관리 (Log, Policy, GEMINI)
  ```
- **Obsidian 정책**: `10_Wiki`에는 **발행 완료된 글만** 저장. 초안/작업 중인 파일은 `00_Raw`에서 관리.
- **발행 후 자동 아카이브**: `python3 scripts/vault_archive.py --post [파일명] --url [네이버URL]`
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
vault/Research/10_Wiki/ 에 관련 위키 노트도 업데이트.
```

### 2-2. 기존 포스트 보완
```
@local packages/website/content/ko/study/[카테고리]/ 의 포스트들을 읽고,
내용이 부족한 부분을 보완해줘.
코드 예제 추가, 설명 보강, 관련 링크 추가.
```

### 2-3. 시리즈 기획
```
@local vault/Research/10_Wiki/ 에서 관련 위키를 읽고,
이 주제로 5편짜리 기술 블로그 시리즈를 기획해줘.
각 편의 제목, 핵심 내용, 예상 분량을 정리해서
vault/Research/10_Planning/ 에 저장.
```

## 3. 유튜브 콘텐츠

### 3-1. 스크립트 작성
```
@local '[주제]' 에 대한 유튜브 스크립트를 작성해줘.
형식: 인트로(30초) → 본론(5-7분) → 아웃트로(30초)
톤: 친근하지만 전문적, 한국어
vault/Research/00_Raw/ 에 저장.
```

### 3-2. 영상 기획
```
@local vault/Research/10_Wiki/ 에서 인기 있을 만한 주제 5개를 골라서
유튜브 영상 기획안을 작성해줘.
각 기획안: 제목, 썸네일 컨셉, 핵심 내용, 예상 조회수 근거.
vault/Research/10_Planning/ 에 저장.
```

## 4. Vault 관리

### 4-1. 새 지식 Ingest
```
@local 다음 내용을 vault에 정리해줘:
[URL 또는 텍스트 붙여넣기]

1. 기술 관련 내용은 vault/Research/ 에 저장
2. 개인/여가 내용은 vault/Life/ 에 저장
3. 기존 노트와 [[링크]] 통해 연결
4. 20_Meta/Log.md에 기록
```

### 4-2. Vault Lint
```
@local vault/Research/ 및 vault/Life/ 전체를 점검해줘:
- 고아 노트 (아무데서도 링크 안 되는 노트)
- 깨진 링크 ([[존재하지 않는 노트]])
- 태그 불일치
- 오래된 정보 (3개월 이상 미업데이트)
- 폴더 밀도 점검 (파일 12개 초과 시 재귀적 세분화 제안)
- MOC 최신화 상태 점검
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

## 5. NotebookLM Deep Research

### 5-1. 신규 연구 노트북 생성
```
@local [주제]에 대한 신규 노트북을 생성하고 다음 소스를 추가해줘:
- [URL 1]
- [URL 2]
```

### 5-2. 소스 기반 심층 질의
```
@local 노트북에서 [질문 내용]에 대해 분석해줘.
포함 사항: 주요 논점, 소스 인용, 상충되는 의견 정리.
```

### 5-3. 위키 업데이트 연동
```
@local 노트북 분석 결과를 바탕으로 vault/Research/10_Wiki/[노트명].md 를 업데이트해줘.
```

## 6. Visual Content Production (Creative Partner)

### 6-1. 인포그래픽/PPT 생성 (Studio 활용)
```
@local [주제]에 대해 NotebookLM Studio를 사용하여 다음 이미지를 생성해줘:
1. 관련 소스(MD, PDF) 업로드
2. Studio(인포그래픽/슬라이드)를 사용하여 기술 시각 자료 생성
3. 생성된 자료 평가 후 기술 블로그에 통합 (워터마크 없음, 고대비 스타일)
```

### 6-2. 워터마크 제거 가이드 (Vision Cleaner)
```
@local [이미지]에서 워터마크나 UI 요소를 제거하기 위한 처리 전략을 제안해줘.
```

## 7. Full-time Automatic Blog Operation

### 7-1. 데일리 자동 루틴 (Research -> Clean -> Publish)
```
@local workspaces/naver-blog/WORKFLOW.md 읽고,
1. vault의 보관된 초안이나 오늘의 뉴스를 선택
2. NotebookLM으로 관련 주제 심층 분석 및 인포그래픽 컨셉 도출
3. 고화질 이미지 생성 및 vision_cleaner.py로 정제 (브랜드 제거)
4. 본문 작성 및 기술 블로그(0xhenry.dev) 우선 발행
```

### 7-2. 이미지 대량 정제 (Vision Cleaner)
```
@local workspaces/naver-blog/scripts/vision_cleaner.py 를 사용해서
[폴더/이미지]의 NotebookLM UI와 워터마크를 제거해줘.
```

## 8. Git Sync (작업 마무리)

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
- **NotebookLM Rule**: 새로운 주제 작업 시 반드시 전용 노트북을 생성할 것
- **Visual Rule**: "그림 없는 포스트는 존재할 수 없음." 모든 기술 블로그 포스트는 NotebookLM Studio 등을 활용한 고품격 시각 자료를 포함해야 함
- **Priority**: 기술 블로그(0xhenry.dev)의 기술적 수월성을 최우선으로 하며, 네이버 블로그는 보조 수단으로만 활용
- 파일명은 한국어 가능, 특수문자 최소화
- 이미지는 해당 포스트 폴더에 함께 저장
- JSON-AI 구조화 프롬프트 스타일 활용 (복잡한 지시 시)

# Shared Agent Rules — Byeongjun
# Applied to both Antigravity + Claude Code

## Coding Standards
- No hardcoding — use config/parameter files
- ROS2: rclcpp (C++) preferred, rclpy secondary
- No blocking calls inside timer callbacks
- Always specify QoS for real-time control topics

## Harness Safety Gates
- Destructive commands (rm -rf, DROP TABLE) → confirm first
- Motor/actuator direct control → verify in simulation first
- git push --force → forbidden
- Production deploy → explicit approval required

## Project Context
### H-Walker
- Cable-driven gait rehabilitation robot
- Control: inner impedance @ 111Hz, outer ILC (stride-to-stride)
- Motor: AK60-6 via CAN bus
- Camera: ZED X Mini, pose via YOLO26s (FP16)
- Platform: Jetson Orin NX 16G (L4T 36.4.0)

### 0xhenry.dev
- Personal blog (GitHub Pages, ZeroxHenry)
- Brand colors: Navy #171B5E, Orange #F09708, Terminal Green #00FFB2
