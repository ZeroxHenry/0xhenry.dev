---
title: "AI 스타트업 코드베이스 해부 — 실제로 어떻게 구조가 짜여 있는가"
date: 2026-04-14
draft: false
tags: ["스타트업", "코드구조", "아키텍처", "OpenSource", "LangChain", "Node.js", "Python"]
description: "유명한 AI 서비스들의 깃허브 저장소는 어떤 모습일까요? 실제 잘나가는 AI 스타트업들의 폴더 구조와 프롬프트 관리 방식, 그리고 에이전트 워크플로우를 구현하는 실무 패턴을 파헤칩니다."
author: "Henry"
categories: ["커리어 & 관점"]
series: ["커리어 & 관점 시리즈"]
series_order: 7
images_needed:
  - position: "hero"
    prompt: "A cross-section of a high-tech building. Inside, you can see server racks, a library of prompt files, and workers (agents) passing messages to each other. Dark mode #0d1117, 16:9"
    file: "images/P/ai-startup-codebase-anatomy-hero.png"
---

이 글은 **커리어 & 관점 시리즈** 7편입니다.

![AI Startup Codebase Anatomy Hero](images/P/ai-startup-codebase-anatomy-hero.png)
→ 6편: [Sandwich 아키텍처: LLM을 이용하되 LLM에 의존하지 않는 설계](/ko/study/P_career/sandwich-architecture-llm)

---

"에이전트 서비스, 튜토리얼은 쉬운데 실제 프로젝트는 어떻게 폴더를 짜야 하죠?" 

수많은 기술 문서를 봐도 정답을 찾기 어렵습니다. 그래서 제가 직접 잘나가는 AI 오픈소스 프로젝트와 스타트업들의 코드베이스를 뜯어보고 발견한 공통적인 **'실전 패턴'** 3가지를 정리했습니다.

---

### 1. 프롬프트는 '데이터'가 아니라 '코드'처럼 관리하기

잘된 프로젝트는 프롬프트를 소스 코드 안에 `f-string`으로 박아넣지 않습니다.
- **패턴**: `/prompts` 폴더를 따로 두고 `.yaml` 이나 `.jinja2` 파일로 관리합니다. 버전 관리가 가능하고, 개발자가 아닌 기획자도 프롬프트를 수정할 수 있는 구조입니다.

---

### 2. 에이전트의 '도구(Tools)' 분리

에이전트가 쓰는 기능(날씨 조회, DB 검색 등)은 독립적인 모듈로 존재합니다.
- **패턴**: `/tools` 혹은 `/actions` 폴더 안에 각 도구의 정의와 입력값 검증(Pydantic 등) 로직을 격리합니다. 이렇게 하면 새로운 에이전트를 만들 때 기존 도구들을 레고 블록처럼 재사용할 수 있습니다.

---

### 3. 상태 관리(State)의 중앙 집중화

에이전트가 이전 대화를 기억하고 현재 어떤 단계를 수행 중인지 기록하는 것은 매우 복잡합니다.
- **패턴**: Redis나 Postgres를 활용한 **'Stateful Graph'** 패턴을 사용합니다. 단순히 '이전 대화 목록'을 넘기는 수준을 넘어, 현재 에이전트의 '생각의 흐름'을 체계적으로 DB에 저장합니다.

---

### Henry의 한 줄 평: "결국은 전통적인 엔지니어링이다"

AI가 들어갔다고 해서 특별한 마법이 있는 게 아닙니다. 오히려 AI가 가진 불확실성 때문에 **폴더 구조와 관심사 분리(Separation of Concerns)**가 훨씬 더 엄격해야 합니다. 여러분의 프로젝트가 커지기 전에, 지금 바로 `/prompts`와 `/tools` 폴더부터 독립시키세요.

---

**다음 글:** [2026년, 우리가 다시 '기본기'로 돌아가야 하는 이유](/ko/study/P_career/back-to-basics)
