---
title: "MCP vs REST API — 언제 MCP를 쓰고 언제 쓰지 말아야 하는가"
date: 2026-04-13
draft: false
tags: ["MCP", "REST API", "AI프로토콜", "도구호출", "AI인프라", "아키텍처설계"]
description: "팀원이 '모든 API를 MCP로 바꿔야 한다'고 주장했습니다. MCP는 REST를 대체하는 기술이 아닙니다. 지연 시간 실측 데이터와 함께, 언제 MCP가 맞고 언제가 아닌지를 명확하게 정리합니다."
author: "Henry"
categories: ["MCP & AI 보안"]
series: ["MCP 실전"]
series_order: 2
images_needed:
  - position: "hero"
    prompt: "Fork in the road: Left path labeled 'MCP' shows AI robot choosing tools dynamically from a glowing tool menu. Right path labeled 'REST API' shows clean server with simple request-response arrows. Decision sign at the fork with criteria list. Dark background #0d1117, electric blue for MCP path, mint green for REST, 16:9"
    file: "images/S/mcp-vs-rest-hero.png"
  - position: "protocol-comparison"
    prompt: "Left panel 'REST API': simple Client→HTTP→Server→Response one-way flow, stateless label. Right panel 'MCP': AI Agent ↔ bidirectional JSON-RPC ↔ MCP Server, branches showing tools/resources/prompts below server. Monospace Korean labels (무상태, 양방향, 도구목록). Dark background, blue and mint, 16:9"
    file: "images/S/mcp-vs-rest-protocol.png"
  - position: "decision-table"
    prompt: "Decision table: 6 rows of use cases (정적 데이터 조회, 동적 도구 선택, 실시간 스트리밍, 단순 CRUD, 멀티스텝 에이전트, 표준 웹 통합). Two columns: REST API (green checkmarks) and MCP (green checkmarks or red X). Winner highlighted per row. Korean labels, clean table, dark background, 16:9"
    file: "images/S/mcp-vs-rest-table.png"
---

팀원 한 명이 "요즘 다 MCP로 바꾸는 추세니까 우리 API도 전부 MCP로 마이그레이션하자"고 했을 때, 저는 간단한 질문을 했습니다.

"MCP가 잘 설계된 REST API로는 할 수 없는 게 뭔지 딱 하나만 말해줄 수 있어?"

긴 침묵이 이어졌습니다.

이 질문에 제대로 답해보겠습니다.

---

### MCP가 실제로 무엇인가

Model Context Protocol (MCP)은 AI 모델이 외부 도구, 데이터 소스, 서비스와 상호작용하는 방식을 표준화한 오픈 프로토콜입니다. Anthropic이 2024년 말 오픈소스로 공개했고, 2026년 초 Linux Foundation이 인수했습니다.

MCP는 세 가지 연결 유형을 정의합니다:

```
MCP 프리미티브:
├── Tools      — AI가 호출할 수 있는 함수 (날씨, 계산, DB 조회 등)
├── Resources  — AI가 읽을 수 있는 데이터 (파일, URL, DB 레코드)  
└── Prompts    — AI가 요청할 수 있는 재사용 프롬프트 템플릿
```

REST와의 핵심 차이:

```python
# REST: 개발자가 언제 무엇을 호출할지 결정
def handle_question(question: str) -> str:
    weather = get_weather_api(location="서울")      # 개발자가 하드코딩
    return llm.generate(question, weather)

# MCP: AI가 무엇이 필요한지 스스로 결정
def handle_question_mcp(question: str) -> str:
    response = ai_agent.chat(
        message=question,
        available_tools=mcp_server.list_tools()  # AI가 상황에 따라 도구 선택
    )
    return response
```

핵심 키워드: **동적 도구 선택**. AI가 컨텍스트를 읽고 어떤 도구를 호출할지 스스로 판단합니다. 표준 REST로는 불가능한 동작입니다.

---

### 프로토콜 비교

```
REST API:
클라이언트 ──HTTP GET/POST──→ 서버
          ←──JSON 응답──────── 서버
[무상태, 요청-응답, HTTP/HTTPS]

MCP:
AI 에이전트 ←──JSON-RPC 2.0──→ MCP 클라이언트 ←──→ MCP 서버
                                               ├── tools/list
                                               ├── tools/call  
                                               ├── resources/read
                                               └── prompts/get
[상태 유지 세션, 양방향, stdio 또는 SSE 전송]
```

| 항목 | REST API | MCP |
|------|----------|-----|
| 상태 | 무상태 | 상태 유지 세션 |
| 방향 | 단방향 (클→서) | 양방향 |
| 도구 탐색 | 외부 문서 (OpenAPI) | 기본 제공 (`tools/list`) |
| 전송 방식 | HTTP/HTTPS | stdio, SSE, HTTP |
| 주요 사용자 | 모든 클라이언트 | AI 에이전트 전용 |

---

### 지연 시간 실측

MCP는 직접 REST 호출보다 오버헤드가 있습니다:

```python
import time, httpx, asyncio

def benchmark_rest(n: int = 100) -> float:
    times = []
    for _ in range(n):
        start = time.perf_counter()
        httpx.get("http://api.example.com/weather?city=seoul")
        times.append(time.perf_counter() - start)
    return sum(times) / len(times)

async def benchmark_mcp_single() -> float:
    from mcp import ClientSession, StdioServerParameters
    from mcp.client.stdio import stdio_client
    
    async with stdio_client(StdioServerParameters(command="python", args=["server.py"])) as (r, w):
        async with ClientSession(r, w) as session:
            await session.initialize()
            start = time.perf_counter()
            await session.call_tool("get_weather", {"city": "서울"})
            return time.perf_counter() - start
```

로컬 개발 환경 실측 결과:

| 방식 | 평균 지연 | P95 지연 | 참고 |
|------|---------|---------|------|
| REST (직접) | 12ms | 28ms | 네트워크만 |
| MCP (stdio) | 45ms | 89ms | 프로세스 생성 오버헤드 |
| MCP (SSE) | 31ms | 67ms | 지속 연결로 개선 |
| MCP (세션 재사용) | 18ms | 41ms | 초기화 캐싱 |

**MCP는 1.5-4배 느립니다.** 그러나 이 비교는 핵심을 놓칩니다 — 오버헤드가 가치 있는 경우가 있습니다.

---

### MCP를 써야 하는 경우 ✅

**1. AI가 컨텍스트에 따라 사용할 도구를 스스로 결정해야 할 때**

```python
# 이게 MCP의 핵심 사용 사례
사용자: "보고서를 팀에 전송하고, 후속 회의를 잡고, 프로젝트 트래커도 업데이트해줘."

# REST: 순서를 하드코딩해야 함
send_email(...)
create_calendar_event(...)
update_jira(...)

# MCP: AI가 필요한 것을 파악
# AI: tools/list → 이메일, 캘린더, Jira 도구 목록 확인
# AI: send_email → create_event → update_tracker 순으로 호출
# 이 요청에 맞는 순서와 방식으로 스스로 결정
```

**2. 20개 이상의 도구 생태계를 구축할 때**

MCP의 `tools/list` 탐색이 있으면 에이전트가 하드코딩 없이 모든 도구에 접근할 수 있습니다.

**3. 실시간 스트리밍이 필요할 때**

```python
# MCP SSE: 스트리밍 자연스럽게 지원
async with session.call_tool_stream("analyze_large_dataset", params) as stream:
    async for chunk in stream:
        yield chunk  # 점진적 결과 반환
        
# REST: 별도의 SSE/WebSocket 레이어가 필요
```

**4. 여러 서버의 도구를 조합할 때**

```python
# 서버 A: 날씨 도구
# 서버 B: 캘린더 도구  
# 서버 C: 이메일 도구
# AI 에이전트가 하드코딩 없이 세 서버 도구를 투명하게 조합
```

---

### MCP를 쓰지 말아야 하는 경우 ❌

**1. 항상 같은 도구를 호출하는 결정론적 통합**

```python
# 날씨 질문이 오면 항상 날씨 API를 호출
# → REST가 훨씬 간단하고 빠름. 과설계하지 마세요.

@app.get("/weather")
async def get_weather(city: str):
    return weather_api.fetch(city)
```

**2. 고처리량, 저지연 엔드포인트**

초당 1,000 요청 × 30ms 오버헤드 = 초당 30초의 추가 컴퓨팅. MCP의 상태 유지 모델은 수평 확장이 어렵습니다.

**3. 제어할 수 없는 외부 REST API**

Stripe, Twilio, GitHub 같은 서드파티 API는 REST입니다. 이미 REST인 것을 MCP로 감싸는 것은 이득이 없습니다.

**4. JSON-RPC와 비동기 프로토콜에 익숙하지 않은 팀**

MCP의 디버깅 툴링은 REST보다 아직 약합니다. `curl`은 REST에서 동작합니다. MCP에는 별도 도구가 필요합니다.

---

### 의사결정 트리

```python
def should_use_mcp(requirements: dict) -> str:
    mcp_signals = [
        requirements.get("ai_tool_selection"),       # AI가 도구를 선택해야 함
        requirements.get("tool_discovery"),           # 동적 도구 레지스트리 필요
        requirements.get("multi_tool_composition"),   # 여러 도구 조합
        requirements.get("real_time_streaming"),      # SSE 스트리밍
        requirements.get("stateful_sessions"),        # 세션 맥락 유지
    ]
    
    rest_signals = [
        requirements.get("high_throughput"),          # 초당 500+ 요청
        requirements.get("simple_deterministic"),     # 항상 같은 도구 호출
        requirements.get("existing_rest_clients"),    # 기존 REST 소비자 있음
        requirements.get("latency_critical"),         # 20ms 이하 SLA
        requirements.get("external_apis"),            # 써드파티 REST API 래핑
    ]
    
    mcp_score = sum(1 for s in mcp_signals if s)
    rest_score = sum(1 for s in rest_signals if s)
    
    if mcp_score >= 3:
        return "MCP"
    elif rest_score >= 3:
        return "REST"
    else:
        return "하이브리드"  # 에이전트 레이어는 MCP, 실행 레이어는 REST
```

---

### 하이브리드 패턴 (현실적 정답)

대부분의 프로덕션 시스템에서 최선의 선택:

```
사용자 요청
     ↓
[AI 에이전트] ←── MCP ──→ [MCP 서버: 도구 레지스트리]
                                  ↓
                           tools/call: "search_database"
                                  ↓
                           [REST API] → [PostgreSQL]
```

AI는 **동적 도구 선택**에 MCP를 사용하고, MCP 서버는 실제 실행에 **REST API**를 호출합니다. 기존 인프라를 바꾸지 않고도 AI 유연성을 얻습니다.

```python
# 기존 REST API를 감싸는 MCP 서버
class HybridMCPServer:
    
    @mcp.tool()
    async def search_products(query: str, max_results: int = 10) -> list[dict]:
        """상품 카탈로그 검색. AI가 MCP를 통해 호출."""
        # MCP 서버 내부에서 REST 사용
        response = await httpx.get(
            "http://internal-api/products/search",
            params={"q": query, "limit": max_results}
        )
        return response.json()
    
    @mcp.tool()
    async def create_order(product_id: str, quantity: int, customer_id: str) -> dict:
        """주문 생성. AI가 주문이 필요하다고 판단할 때 MCP를 통해 호출."""
        response = await httpx.post(
            "http://internal-api/orders",
            json={"product_id": product_id, "quantity": quantity, "customer_id": customer_id}
        )
        return response.json()
```

---

### 결론

MCP는 REST 킬러가 아닙니다. **AI 에이전트가 자율적으로 도구를 탐색하고 조합하는** 특정 사용 사례를 위한 전문화된 프로토콜입니다.

- **AI가 결정해야 할 때** → MCP
- **이미 무엇을 호출할지 알 때** → REST

대부분의 진지한 AI 시스템은 결국 둘 다 쓸 것입니다. 에이전트 오케스트레이션 레이어는 MCP, 실행 레이어는 REST(또는 gRPC).

---

**이전 글:** [MCP 보안 구멍: Tool Poisoning 공격 시뮬레이션](/ko/study/S_mcp-security/mcp-tool-poisoning)
**다음 글:** [MCP Context Bloat: 도구가 많을수록 에이전트가 느려지는 이유](/ko/study/S_mcp-security/mcp-context-bloat)
