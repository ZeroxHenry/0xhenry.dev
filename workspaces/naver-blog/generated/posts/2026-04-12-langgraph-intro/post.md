# LangGraph: 복잡한 에이전트 워크플로우 오케스트레이션

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


### 서론

표준 AI 에이전트(ReAct 패턴 등)는 기본적으로 단일 루프 구조입니다. 끝날 때까지 생각하고, 행동하고, 관찰하죠. 단순한 작업에는 잘 작동하지만, 소프트웨어 기능을 개발하거나 다중 소스 리서치 프로젝트를 수행하는 것처럼 길고 복잡한 과정에서 단일 루프는 너무나 취약합니다. 한 단계에서라도 막히면 전체 프로세스가 실패하기 때문입니다.

**LangGraph**는 이에 대한 완벽한 해결책입니다. 에이전트를 **상태 머신(State Machine)**으로 구축하여, 정확한 노드(단계)와 엣지(전이)를 정의할 수 있게 해줍니다.

---

### 왜 LangGraph인가? 상태와 제어권

기본 에이전트의 가장 큰 문제는 '상태(State)'가 없다는 점입니다. 루프가 한 번 끝나고 나면 기억이 휘발되거나 뒤섞이기 쉽죠. LangGraph는 이를 다음과 같이 해결합니다:

1.  **지속성 (Persistence)**: 에이전트의 상태를 저장합니다. 에이전트를 도중에 멈추고 사람의 승인을 기다린 뒤, 정확히 멈췄던 지점부터 다시 시작할 수 있습니다.
2.  **사이클과 루프 (Cycles)**: 특정 단계로 되돌아가는 조건을 정교하게 정의할 수 있습니다. (예: "코드에 오류가 있다면 다시 '코드 작성' 노드로 돌아가라")
3.  **다중 에이전트 협업**: 서로 다른 전문 에이전트(예: '리서처' 에이전트와 '라이터' 에이전트)가 공유된 상태를 통해 소통하는 구조를 만들 수 있습니다.

---

### LangGraph의 구조

LangGraph를 구축하려면 다음 세 가지를 정의해야 합니다:

-   **State (상태)**: 모든 노드가 읽고 쓸 수 있는 공유 객체입니다.
-   **Nodes (노드)**: 특정 작업을 수행하는 Python 함수입니다. (예: "웹 검색" 또는 "요약 생성")
-   **Edges (엣지)**: 현재 상태를 바탕으로 다음에 어떤 노드로 이동할지 결정하는 로직입니다.

### 구현 예시

```python
from langgraph.graph import StateGraph, END

# 1. 상태 정의
class AgentState(TypedDict):
    query: str
    results: List[str]
    is_finished: bool

# 2. 노드 정의 (실제 작업 함수)
def search_node(state: AgentState):
    # 검색 수행 로직
    return {"results": ["사실 A", "사실 B"]}

def judge_node(state: AgentState):
    # 정보가 충분한지 판단
    return {"is_finished": True}

# 3. 그래프 빌드
workflow = StateGraph(AgentState)
workflow.add_node("search", search_node)
workflow.add_node("judge", judge_node)

workflow.set_entry_point("search")
workflow.add_edge("search", "judge")
workflow.add_conditional_edges("judge", lambda x: END if x["is_finished"] else "search")

app = workflow.compile()
```

---

### 요약

LangGraph는 AI 에이전트를 '흥미로운 실험'에서 '신뢰할 수 있는 소프트웨어'로 격상시킵니다. 에이전트를 혼란스러운 루프가 아닌 구조화된 그래프로 다룸으로써, 전문적인 수준의 자동화에 필요한 제어력과 지속성을 얻을 수 있습니다.

다음 세션에서는 에이전트 프레임워크의 주요 강자들을 비교해 보겠습니다: **CrewAI vs. AutoGPT.**

---

**다음 주제:** [CrewAI vs AutoGPT: 어떤 에이전트 프레임워크를 선택해야 할까?](/ko/study/crewai-vs-autogpt)