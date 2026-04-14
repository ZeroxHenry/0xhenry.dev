---
title: Morning Briefing — 2026-04-15
created: 2026-04-15
tags: [briefing, todo]
---

# Morning Briefing

> 이 세션에서 완료한 것 + 다음 세션에서 해야 할 것

---

## 완료

### Encho Extension
- Encho VS Code Extension 구현 (Quill 포크) → 삭제됨 (Antigravity 내장 @local 사용)
- 결론: Extension 따로 만들 필요 없음

### Mac/Win 통합
- vault를 0xhenry.dev repo에 포함 (`~/vault` → symlink)
- `git push/pull`로 양쪽 동기화
- GEMINI.md: Windows @local 지시서 (Windows에서 이미 개편)
- ENCHO.md: vault 하네스 (참조용)
- WINDOWS-TASKS.md: 구체적 @local 명령 모음

### Vault 구조 정리
- `Research/` (연구) + `Life/` (잡무) + `20_Meta/` (시스템) 3분류
- 루트 레거시 폴더 정리 완료

### Skiro → Obsidian 연동 시작
- `skiro-vault-sync` 스크립트 생성 (~/skiro/bin/)
- learnings.jsonl → vault/Research/10_Wiki/skiro-learnings.md 자동 변환
- 노이즈 필터링 적용

---

## 다음 세션 TODO (우선순위순)

### 1. [HIGH] skiro hook에 vault-sync 자동 연결
- skiro-learnings add/solve 후 자동으로 skiro-vault-sync 실행되도록
- skiro-hook-prompt에 sync 트리거 추가

### 2. [HIGH] Claude 메모리 → vault 참조 전환
- Claude의 ~/.claude/memory/ 에 있는 정보를 vault로 이전
- Claude가 작업 시작할 때 vault에서 관련 노트를 읽도록 CLAUDE.md 수정
- 목표: Claude 메모리를 최소화하고, vault가 Single Source of Truth

### 3. [HIGH] skiro-classify 노이즈 개선
- 터미널 출력, 사용자 감정 표현이 learnings에 들어가는 문제
- 실제 "문제 + 해결" 패턴만 기록하도록 필터 강화

### 4. [MEDIUM] Graphify 연동
- vault 내용이 많아지면 knowledge graph로 시각화
- /graphify 명령으로 vault → graph 변환 테스트
- 노트 간 연결(wiki-links) 기반 그래프 생성

### 5. [MEDIUM] 참조 테스트 10회
- "h-walker 관련 하드웨어 문제 뭐 있었어?" → vault에서 정확히 찾아오는지
- "MIT 모드 토크 제어 어떻게 해?" → 해결된 교훈 정확히 참조하는지
- 다양한 키워드로 10회 테스트 → 실패 시 구조 보완

### 6. [MEDIUM] skiro GitHub repo 업데이트
- chobyeongjun/skiro에 skiro-vault-sync 포함해서 push
- README에 vault 연동 설명 추가

### 7. [LOW] skiro-hook-prompt 전면 개편
- vault 기반으로 동작하도록 변경
- 새 문제 감지 시 → vault에서 유사 교훈 검색 → 있으면 자동 표시
- "이전에 이런 문제 있었음: [링크]" 패턴

---

## 핵심 원칙
- **Obsidian vault = Second Brain = Single Source of Truth**
- Claude 메모리, skiro learnings, GEMINI.md 다 vault를 바라봄
- 어떤 기기(Mac/Win), 어떤 AI(Claude/Gemini) 쓰든 같은 메모리
