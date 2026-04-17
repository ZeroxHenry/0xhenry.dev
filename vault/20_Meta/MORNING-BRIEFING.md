---
title: Morning Briefing — 2026-04-15
created: 2026-04-15
updated: 2026-04-15
tags: [briefing, todo]
---

# Morning Briefing

> 새 세션에서 `vault/20_Meta/MORNING-BRIEFING.md 읽어` 로 시작

---

## 완료 (이번 세션)

### skiro v4.0 — Obsidian 직접 읽기/쓰기
- **learnings.jsonl 제거**, vault/Research/10_Wiki/skiro-learnings.md가 Single Source of Truth
- skiro-learnings add/solve/list/search/count 전부 vault 마크다운 직접 파싱
- 노이즈 필터 내장 (IDE 이벤트, 터미널 출력 자동 스킵)
- chobyeongjun/skiro GitHub repo에 push 완료

### Encho Extension
- 구현 → 삭제됨 (Antigravity 내장 @local 사용)

### Mac/Win 통합
- vault → 0xhenry.dev repo에 포함, symlink로 접근
- GEMINI.md + WINDOWS-TASKS.md 완성

### Vault 구조
- Research/ (연구) + Life/ (잡무) + 20_Meta/ (시스템)

---

## 다음 세션 TODO

### 1. [HIGH] Claude 메모리 → vault 참조 전환
```
Claude의 ~/.claude/memory/ 내용을 vault로 이전.
CLAUDE.md에서 "작업 시작 시 vault/Research/10_Wiki/ 참조" 규칙 추가.
목표: Claude 메모리 최소화, vault가 Single Source of Truth.
```

### 2. [HIGH] skiro-classify 노이즈 개선
```
skiro-hook-prompt가 사용자 발화를 문제로 잘못 기록하는 문제.
skiro-classify.py 수정: 실제 "문제 + 해결" 패턴만 통과.
```

### 3. [MEDIUM] Graphify 연동
```
/graphify 로 vault → knowledge graph 변환 테스트.
wiki-links 기반 그래프 생성. 노트가 많아질수록 필수.
```

### 4. [MEDIUM] 참조 테스트 10회
```
1. "h-walker 하드웨어 문제 뭐 있었어?"
2. "MIT 모드 토크 제어 어떻게 해?"
3. "보드 파손 원인이 뭐였지?"
4. "YOLO 인식 불량 해결법"
5. "AP62200WU 문제"
6. "카메라 배치 결정된 거 있어?"
7. "어드미턴스 제어 파라미터"
8. "INA333 로드셀 문제"
9. "파이프라인 동기 모드 전환"
10. "최근 미해결 CRITICAL"
→ 각각 vault에서 정확히 찾아오는지 확인. 실패 시 구조 보완.
```

### 5. [LOW] skiro-hook-prompt 전면 개편
```
새 문제 감지 시 → vault에서 유사 교훈 자동 검색 → 있으면 표시.
"이전에 이런 문제 있었음: [[skiro-learnings]]" 패턴.
```

---

## 핵심 원칙
- **Obsidian vault = Second Brain = Single Source of Truth**
- Claude 메모리, skiro learnings 다 vault를 바라봄
- 어떤 기기(Mac/Win), 어떤 AI(Claude/Gemini) 쓰든 같은 메모리
