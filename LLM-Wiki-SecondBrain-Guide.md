# LLM Wiki & Second Brain 종합 가이드

> 3개 영상 핵심 정리 + Antigravity Agentic AI 기반 LLM Wiki 구축
> 정리일: 2026-04-12

---

## 1. 3개 영상 핵심 정리

### 영상 1: Gemma 4로 나만의 AI "제2의 두뇌" 복제하기 (CONNECT AI LAB)

**한줄 요약**: 로컬 LLM(Gemma 4)에 내 지식을 넣어서 클라우드 없이 나만의 AI 만들기

- Gemma 4는 구글의 최신 오픈소스 모델 (2026.03.31, Apache 2.0)
- E2B(~2.3B), E4B(~4.5B), 26B A4B(MoE), 31B Dense 4종
- **Agentic 기능 내장**: function calling, 도구 사용, 자율적 계획 수립 가능
- 로컬 실행: Ollama (`ollama pull gemma4:e4b`) 또는 LM Studio
- 핵심: 마크다운으로 지식 정리 -> 컨텍스트로 제공 -> AI가 내 지식 기반으로 답변

### 영상 2: 카파시의 LLM Wiki (브레인 트리니티)

**한줄 요약**: RAG 대신 LLM이 직접 위키를 만들고 관리하게 하는 Karpathy의 패턴

**3계층 아키텍처:**
```
raw/    → 원본 소스 (내가 넣는 곳, 불변)
wiki/   → LLM이 정리하는 곳 (AI가 관리)
schema  → 규칙서 (CLAUDE.md / GEMINI.md)
```

**3가지 작업:**
| 작업 | 설명 |
|------|------|
| **Ingest** | 새 소스 -> 읽고 -> 핵심 추출 -> 위키에 통합 |
| **Query** | 위키에서 검색 -> 통합 답변 |
| **Lint** | 모순, 고아 페이지, 누락 교차참조 점검 |

**RAG vs LLM Wiki:**
- RAG: 매번 원본에서 재검색 (비효율)
- LLM Wiki: 한번 컴파일된 위키에서 조회 (71.5배 토큰 절감)
- 마크다운이라 인간도 직접 읽을 수 있음

### 영상 3: AI 시대, 왜 옵시디언인가 (브레인 트리니티 EP.1)

**한줄 요약**: 옵시디언 = 로컬 마크다운 + 그래프 뷰 + LLM 친화적 = AI 시대 최적 노트앱

- 로컬 `.md` 파일 = 벤더 락인 없음 + Git 버전관리 + LLM이 바로 읽기 가능
- 그래프 뷰: `[[위키링크]]`로 노트 간 연결 시각화
- PARA 방법론: Projects / Areas / Resources / Archive
- 1,000+ 플러그인 (Dataview, Templater, Git 등)

---

## 2. 핵심 개념: Karpathy LLM Wiki란?

2026년 4월, Andrej Karpathy가 X에 올린 포스트 (1600만+ 뷰).

> "매번 원본에서 지식을 재발견하는 RAG 대신,
> LLM이 구조화된 위키를 점진적으로 구축하고 유지한다"

**비유:**
- `raw/` = **서랍** (영수증, 메모, 논문 막 넣는 곳)
- `wiki/` = **파일링 캐비넷** (AI 비서가 정리해놓은 곳)
- `schema` = **비서 매뉴얼** ("이 형식으로 정리해" 규칙)

**인간의 역할**: 소스 선별, 질문
**AI의 역할**: 요약, 교차 참조, 일관성 유지, 위키 관리

---

## 3. Antigravity에서 구현하기

### Antigravity란?

Google의 **Agent-First IDE**. 코드 어시스턴트가 아니라 **자율 에이전트**가 계획-작성-테스트-디버그를 수행하는 플랫폼.

### 지원 모델 (2026.04 기준)
| 모델 | 용도 |
|------|------|
| Gemini 3.1 Pro (High/Low) | 기본 에이전트 |
| Gemini 3 Flash | 빠른 작업 |
| Claude Opus 4.6 (Thinking) | 복잡한 추론 |
| Claude Sonnet 4.6 (Thinking) | 균형 |
| GPT-OSS-120B | 오픈소스 |

> **중요**: Antigravity는 현재 커스텀 로컬 모델(Ollama 등)을 직접 지원하지 않음.
> 하지만 **Agent Skills**를 통해 로컬 Gemma 4를 도구로 연동하는 것은 가능.

### Agent Skills 구조

Antigravity의 핵심은 **Skills** — 에이전트가 특정 작업을 수행하는 전문 지식 패키지.

**스킬 저장 위치:**
```
~/.gemini/antigravity/skills/     # 글로벌 (모든 프로젝트)
<project>/.agents/skills/          # 워크스페이스 (특정 프로젝트)
```

### LLM Wiki를 Antigravity Agent Skills로 구현

```
<project>/
├── .agents/
│   └── skills/
│       ├── wiki-ingest/          # Skill 1: 수집 에이전트
│       │   └── SKILL.md
│       ├── wiki-compiler/        # Skill 2: 컴파일 에이전트
│       │   └── SKILL.md
│       └── wiki-health/          # Skill 3: 점검 에이전트
│           └── SKILL.md
├── raw/                          # 원본 소스
│   ├── articles/
│   ├── papers/
│   ├── youtube/
│   └── notes/
├── wiki/                         # LLM 관리 위키
│   ├── index.md
│   ├── log.md
│   ├── concepts/
│   ├── entities/
│   └── summaries/
└── GEMINI.md                     # 스키마 (Antigravity용)
```

### Skill 1: 수집 에이전트 (wiki-ingest)

```markdown
# .agents/skills/wiki-ingest/SKILL.md

---
name: wiki-ingest
description: raw/ 디렉토리의 새 파일을 감지하고 wiki/에 통합
---

## 역할
raw/ 폴더에 새로 추가된 파일을 읽고, 핵심 개념을 추출하여
wiki/ 폴더의 기존 페이지에 통합하거나 새 페이지를 생성한다.

## 규칙
1. raw/ 파일은 절대 수정하지 않는다 (읽기 전용)
2. wiki/ 페이지마다 YAML 프론트매터 포함:
   - title, created, updated, sources, tags, summary
3. 교차 참조는 [[위키링크]] 사용
4. 새 페이지 생성 시 index.md에 항목 추가
5. log.md에 작업 기록: `## [날짜] ingest | 파일명`

## 처리 흐름
1. raw/ 스캔 -> log.md와 비교 -> 미처리 파일 식별
2. 파일 읽기 -> 핵심 개념/엔티티/관계 추출
3. 기존 wiki/ 페이지에 해당 개념이 있으면 -> 업데이트
4. 없으면 -> 새 페이지 생성 (concepts/ 또는 entities/)
5. index.md + log.md 갱신
```

### Skill 2: 컴파일 에이전트 (wiki-compiler)

```markdown
# .agents/skills/wiki-compiler/SKILL.md

---
name: wiki-compiler
description: wiki/ 질의 처리 및 답변 기반 위키 보강
---

## 역할
사용자 질문에 wiki/ 기반으로 답변하고,
좋은 답변은 wiki/에 다시 저장하여 위키를 점진적으로 보강한다.

## 규칙
1. 답변은 반드시 wiki/ 페이지를 인용 (출처 명시)
2. wiki/에 없는 정보는 "wiki에 해당 정보 없음"으로 답변
3. 유용한 답변은 summaries/ 에 저장
4. 답변 생성 시 관련 페이지 간 [[위키링크]] 추가
```

### Skill 3: 점검 에이전트 (wiki-health)

```markdown
# .agents/skills/wiki-health/SKILL.md

---
name: wiki-health
description: wiki/ 전체 일관성 및 완전성 점검
---

## 역할
wiki/ 폴더를 전수 검사하여 건강 상태를 보고한다.

## 점검 항목
1. **고아 페이지**: 아무데서도 링크되지 않은 페이지
2. **깨진 링크**: 존재하지 않는 페이지로의 [[위키링크]]
3. **모순 감지**: 같은 개념에 대해 상충하는 서술
4. **오래된 정보**: 6개월 이상 업데이트 안 된 페이지
5. **인덱스 동기화**: index.md와 실제 파일 목록 일치 여부

## 출력
- HEALTH_REPORT.md에 결과 저장
- Blocking / Risk / Growth 3단계로 분류
```

### GEMINI.md (스키마)

```markdown
# .agents/skills/ 또는 프로젝트 루트의 GEMINI.md

# LLM Wiki 스키마

## 구조
- raw/: 원본 소스 (읽기 전용, 절대 수정 금지)
- wiki/: 에이전트가 관리하는 위키
- wiki/index.md: 전체 페이지 목록 + 한줄 요약
- wiki/log.md: 타임스탬프 기반 작업 기록

## 위키 페이지 형식
모든 wiki/ 페이지는 아래 프론트매터를 포함:
---
title: 페이지 제목
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [raw/파일명1, raw/파일명2]
tags: [태그1, 태그2]
summary: 한 줄 요약
---

## 워크플로우
- 수집: raw/ 새 파일 -> wiki/ 통합 (wiki-ingest 스킬)
- 질의: wiki/ 검색 -> 답변 (wiki-compiler 스킬)
- 점검: wiki/ 전수 검사 (wiki-health 스킬, 주 1회)

## 명명 규칙
- 개념: concepts/개념명.md (예: concepts/transformer.md)
- 엔티티: entities/이름.md (예: entities/karpathy.md)
- 요약: summaries/주제-날짜.md
```

---

## 4. 로컬 Gemma 4 연동 방안

Antigravity가 직접 Ollama를 지원하지 않더라도, **에이전트 스킬 안에서 로컬 Gemma 4를 도구로 호출**할 수 있음.

### 방법 A: Ollama API를 스킬에서 호출

```bash
# Ollama 서버 실행 (백그라운드)
ollama serve &
ollama pull gemma4:e4b
```

스킬에서 `curl http://localhost:11434/v1/chat/completions`로 로컬 Gemma 4 호출.
-> 간단한 분류/요약은 로컬에서, 복잡한 추론은 Antigravity 기본 모델로 분담.

### 방법 B: ADK (Agent Development Kit) 활용

Google의 [ADK](https://google.github.io/adk-docs/)를 사용해 커스텀 에이전트를 만들고 Antigravity 스킬로 등록.

```python
# ADK 에이전트 예시
from google.adk import Agent, Tool

wiki_agent = Agent(
    model="gemma4:e4b",  # 로컬 모델
    tools=[ingest_tool, query_tool, lint_tool],
    instruction="raw/ 소스를 wiki/에 통합하는 에이전트"
)
```

### 방법 C: 하이브리드 전략 (권장)

| 작업 | 모델 | 이유 |
|------|------|------|
| 단순 분류/태깅 | Gemma 4 E4B (로컬) | 빠르고 무료 |
| 개념 추출/요약 | Gemma 4 27B (로컬) | 더 정확한 이해 |
| 복잡한 교차참조 | Gemini 3.1 Pro (클라우드) | 긴 컨텍스트 필요 |
| 코드 분석 | Claude Opus 4.6 | 코드 이해력 최강 |

---

## 5. Graphify + Obsidian 연동

Antigravity와 별도로, **Graphify**를 사용해 raw/ 폴더를 지식 그래프 + Obsidian vault로 변환 가능.

```bash
# 설치
pip3 install graphifyy
graphify install

# 지식 그래프 생성
/graphify ./raw

# Obsidian vault 자동 생성
/graphify ./raw --obsidian --obsidian-dir ~/vaults/my-wiki

# YouTube 영상도 소스로 추가
pip3 install 'graphifyy[video]'
/graphify add https://youtu.be/...

# 질의
/graphify query "Gemma 4 agentic 기능"
```

**지원 파일:** 코드(22개 언어), 문서(.md .txt), 논문(.pdf), 이미지(.png .jpg), 영상/오디오(.mp4 .mp3)

**출력:**
```
graphify-out/
├── graph.html        # 브라우저에서 열면 대화형 그래프
├── GRAPH_REPORT.md   # 요약 보고서
├── graph.json        # 쿼리용 데이터
└── cache/            # 캐시
```

---

## 6. 실전 로드맵

### Phase 1: 기반 구축 (오늘)
- [ ] Obsidian 설치 + vault 생성
- [ ] raw/ 폴더에 기존 자료 이동 (논문, 메모, 북마크 등)
- [ ] Graphify 설치: `pip3 install graphifyy && graphify install`

### Phase 2: Antigravity 스킬 설정
- [ ] `.agents/skills/` 에 wiki-ingest, wiki-compiler, wiki-health 스킬 생성
- [ ] GEMINI.md 스키마 작성
- [ ] 첫 ingest 실행 테스트

### Phase 3: 로컬 Gemma 4 연동
- [ ] Ollama로 Gemma 4 서빙 확인 (이미 `antigravity.config.json`에 설정 있음)
- [ ] 스킬에서 로컬 모델 호출 파이프라인 구축
- [ ] 하이브리드 전략 적용 (단순 작업=로컬, 복잡=클라우드)

### Phase 4: 자동화
- [ ] 주간 lint 자동 실행
- [ ] raw/ 폴더 감시 -> 자동 ingest
- [ ] Git 자동 커밋으로 위키 변경 이력 관리

---

## 7. 실전 사례 참고

GPTers 커뮤니티 DECK 사용자 (7,660개 노트 관리):

| 명령어 | 기능 |
|--------|------|
| `/적용` | 새 자료 자동 분류 + 요약 + 교차참조 |
| `/위키저장` | 좋은 답변을 위키에 즉시 축적 |
| `/점검` | 전체 볼트 건강 상태 점검 |

첫 점검: 5개 에이전트 병렬 실행, 3,481개 파일 스캔
-> Blocking 4건, Risk 6건, Growth 5건 발견

> **핵심 교훈**: "남의 시스템을 그대로 쓰지 말고, 내 시스템에 맞게 변형하라"

---

## Sources

- [Karpathy LLM Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [MindStudio: How to Build LLM Wiki](https://www.mindstudio.ai/blog/andrej-karpathy-llm-wiki-knowledge-base-claude-code)
- [Graphify GitHub](https://github.com/safishamsi/graphify/)
- [GPTers: 7,660개 노트 정리 경험](https://www.gpters.org/ai-writing/post/planted-andrej-karpathys-llm-zLQc6zmON4cC3l7)
- [Antigravity x Gemma 4 Agent Guide](https://antigravitylab.net/en/articles/agents/antigravity-gemma4-production-agent-architecture-guide)
- [Antigravity x Karpathy LLM Wiki](https://antigravity.codes/de/blog/karpathy-llm-knowledge-bases)
- [ADK Agent Skill in Antigravity](https://medium.com/google-cloud/creating-an-adk-agent-skill-in-antigravity-0031f5f82ccb)
- [Antigravity Agent Manager Guide](https://www.aifire.co/p/mastering-the-antigravity-agent-manager-2026-guide-part-1)
