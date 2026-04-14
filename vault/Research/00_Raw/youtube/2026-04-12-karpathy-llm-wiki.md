---
source: https://youtu.be/cNlvrU-KcRg
date: 2026-04-12
type: youtube
channel: Brain Trinity
tags: [karpathy, llm-wiki, obsidian, graphify, second-brain]
---

## 핵심 내용
- Andrej Karpathy가 제안한 LLM Wiki 패턴 (2026.04, X에서 1600만+ 뷰)
- RAG 대신 LLM이 직접 위키를 구축/유지하는 방식
- 3계층: raw/(원본) -> wiki/(AI정리) -> schema(규칙)
- 3작업: ingest(수집), query(질의), lint(점검)
- Graphify: 지식을 그래프로 변환하는 오픈소스 도구
- Claude Code + Obsidian 조합으로 구현 가능
- 쿼리당 71.5배 토큰 절감 (RAG 대비)

## 내 생각
- raw/wiki/schema 구조가 깔끔하다
- 내가 넣기만 하면 AI가 정리해주는 게 핵심
- Antigravity에서도 같은 패턴 적용 가능
- Graphify는 노트가 많아지면 그때 도입

## 액션 아이템
- ~/vault/ 에 raw/wiki/ 구조 만들기 (완료)
- 스키마(규칙서) 작성해서 어떤 AI든 같은 방식으로 동작하도록
