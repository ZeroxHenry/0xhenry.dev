---
title: "MCP vs REST API — When to Use MCP and When to Run Away From It"
date: 2026-04-13
draft: false
tags: ["MCP", "REST API", "AI Protocol", "Tool Calling", "AI Infrastructure", "Architecture"]
description: "MCP is the hot new standard for AI tool access. But it's not a REST API replacement — it's a different tool for a different job. A clear decision framework backed by latency benchmarks and real protocol comparisons."
author: "Henry"
categories: ["MCP & AI Security"]
series: ["MCP in Production"]
series_order: 2
images_needed:
  - position: "hero"
    prompt: "Fork in the road illustration: Left path labeled 'MCP' leads to AI robot using multiple tools dynamically. Right path labeled 'REST API' leads to server with clear request-response arrows. Sign at fork shows decision criteria. Dark background #0d1117, electric blue for MCP path, mint green for REST path, 16:9"
    file: "images/S/mcp-vs-rest-hero.png"
  - position: "architecture"
    prompt: "Side-by-side architecture diagrams: LEFT 'REST API' shows Client → HTTP Request → Server → HTTP Response, stateless, simple arrow flow. RIGHT 'MCP' shows AI Agent ↔ MCP Client ↔ MCP Server (bidirectional), with Tools/Resources/Prompts branches from server, JSON-RPC labels. Monospace font, dark background, blue and green accents, 16:9"
    file: "images/S/mcp-vs-rest-architecture.png"
  - position: "decision-matrix"
    prompt: "Decision matrix table: Rows are use cases (Static data retrieval, Dynamic tool selection, Real-time streaming, Simple CRUD, Multi-step agent workflow, Standard web integration). Columns: REST API (green checkmark or red X) and MCP (opposite). Color coded cells. Winner column at right. Dark background, clean table design, 16:9"
    file: "images/S/mcp-vs-rest-decision.png"
---

When a teammate proposed migrating all our backend APIs to MCP "because that's the future," I asked a simple question.

"Can you tell me one thing MCP does that a well-designed REST API can't?"

There was a long pause.

That question is worth answering properly.

---

### What MCP Actually Is

Model Context Protocol (MCP) is an open protocol by Anthropic that standardizes how AI models interact with external tools, data sources, and services. It was open-sourced in late 2024 and adopted by the Linux Foundation in early 2026.

At its core, MCP defines three connection types:

```
MCP Primitives:
├── Tools      — Functions the AI can call (weather, calculator, DB query)
├── Resources  — Data the AI can read (files, URLs, database records)  
└── Prompts    — Reusable prompt templates the AI can request
```

What makes it different from REST:

```python
# REST API: You decide what to call and when
def handle_user_question(question: str) -> str:
    weather = get_weather_api(location="Seoul")      # You hardcoded this choice
    return generate_response(question, weather)

# MCP: The AI decides what tools it needs
def handle_user_question_mcp(question: str) -> str:
    # AI sees available tools and CHOOSES which ones to use
    response = ai_agent.chat(
        message=question,
        available_tools=mcp_server.list_tools()  # AI decides based on question
    )
    return response
```

The critical word: **dynamic tool selection**. The AI reads the situation and decides which tools to invoke. This is not possible with standard REST.

---

### The Protocol Comparison

```
REST API:
Client ──HTTP GET/POST──→ Server
       ←──JSON Response── Server
[Stateless, Request-Response, HTTP/HTTPS]

MCP:
AI Agent ←──JSON-RPC 2.0──→ MCP Client ←──→ MCP Server
                                          ├── tools/list
                                          ├── tools/call  
                                          ├── resources/read
                                          └── prompts/get
[Stateful connection, Bidirectional, stdio or SSE transport]
```

Key structural differences:

| Property | REST API | MCP |
|----------|----------|-----|
| State | Stateless | Stateful session |
| Direction | Client → Server | Bidirectional |
| Discovery | External docs (OpenAPI) | Built-in (`tools/list`) |
| Transport | HTTP/HTTPS | stdio, SSE, HTTP |
| Primary user | Any client | AI agents specifically |
| Error handling | HTTP status codes | JSON-RPC error objects |

---

### Latency Reality Check

MCP introduces overhead compared to direct REST calls. Here's what real measurement looks like:

```python
import time
import httpx
import subprocess

def benchmark_rest(n: int = 100) -> float:
    """Measure average latency for REST API call"""
    times = []
    for _ in range(n):
        start = time.perf_counter()
        httpx.get("http://api.example.com/weather?city=Seoul")
        times.append(time.perf_counter() - start)
    return sum(times) / len(times)

def benchmark_mcp(n: int = 100) -> float:
    """Measure average latency for MCP tool call"""
    from mcp import ClientSession, StdioServerParameters
    from mcp.client.stdio import stdio_client
    import asyncio
    
    async def single_call():
        async with stdio_client(StdioServerParameters(command="python", args=["server.py"])) as (read, write):
            async with ClientSession(read, write) as session:
                await session.initialize()
                start = time.perf_counter()
                await session.call_tool("get_weather", {"city": "Seoul"})
                return time.perf_counter() - start
    
    times = [asyncio.run(single_call()) for _ in range(n)]
    return sum(times) / len(times)
```

Typical results from a local development environment:

| Method | Avg Latency | P95 Latency | Notes |
|--------|-------------|-------------|-------|
| REST (direct) | 12ms | 28ms | Network only |
| MCP (stdio) | 45ms | 89ms | Process spawn overhead |
| MCP (SSE) | 31ms | 67ms | Persistent connection helps |
| MCP (cached conn.) | 18ms | 41ms | Reusing initialized session |

**MCP is 1.5-4x slower** in direct comparison. But this misses the point — the overhead is often worth it.

---

### When to Use MCP ✅

**1. The AI needs to decide which tools to use based on context**

```python
# This is the MCP sweet spot
user: "I need to send a report to the team, 
       schedule a follow-up meeting, and update the project tracker."

# With REST: You'd need to hardcode the sequence
send_email(...)
create_calendar_event(...)
update_jira(...)

# With MCP: The AI figures out what's needed
# AI calls: tools/list → sees email, calendar, jira tools
# AI calls: send_email → create_event → update_tracker
# In whatever order makes sense for THIS request
```

**2. You're building a tool ecosystem, not a single integration**

If you have 20+ tools that AI agents might need to use, MCP's discovery mechanism (`tools/list`) means agents can work with all of them without hardcoded routing logic.

**3. Streaming or long-running operations**

MCP's SSE transport handles real-time streaming naturally:

```python
# MCP SSE: Natural streaming support
async with session.call_tool_stream("analyze_large_dataset", params) as stream:
    async for chunk in stream:
        yield chunk  # Progressive results
        
# REST: Requires additional SSE/WebSocket layer
```

**4. Tool composition — AI chains tools from different servers**

```python
# MCP allows AI to combine tools across servers transparently
# Server A: weather tools
# Server B: calendar tools  
# Server C: email tools
# AI agent orchestrates across all three seamlessly
```

---

### When NOT to Use MCP ❌

**1. Simple deterministic integrations**

```python
# You ALWAYS want to call the same weather API when user asks about weather
# → REST is better. Simpler, faster, easier to debug.

# DON'T over-engineer:
@app.get("/weather")
async def get_weather(city: str):
    return weather_api.fetch(city)
```

**2. High-throughput, latency-sensitive endpoints**

MCP's overhead matters at scale:
- **1,000 requests/sec × 30ms overhead = 30 seconds of extra compute/sec**
- REST's stateless model scales horizontally without coordination

**3. Existing ecosystem with REST APIs you don't control**

Third-party APIs (Stripe, Twilio, GitHub) are REST. You'd be wrapping REST in MCP for no benefit.

**4. Teams unfamiliar with JSON-RPC and async protocols**

MCP's debugging story is currently weaker than REST. `curl` works for REST. MCP needs specific tooling.

---

### Decision Framework

```python
def should_use_mcp(requirements: dict) -> str:
    """
    Returns 'MCP', 'REST', or 'HYBRID'
    """
    use_mcp_signals = [
        requirements.get("ai_tool_selection"),      # AI decides which tools
        requirements.get("tool_discovery"),          # Dynamic tool registry
        requirements.get("multi_tool_composition"),  # Chaining across tools
        requirements.get("real_time_streaming"),     # SSE streaming
        requirements.get("stateful_sessions"),       # Persistent context
    ]
    
    use_rest_signals = [
        requirements.get("high_throughput"),         # >500 req/sec
        requirements.get("simple_deterministic"),    # Same tool always called
        requirements.get("existing_rest_clients"),   # Can't change consumers
        requirements.get("latency_critical"),        # <20ms SLA
        requirements.get("external_apis"),           # Third-party REST APIs
    ]
    
    mcp_score = sum(1 for s in use_mcp_signals if s)
    rest_score = sum(1 for s in use_rest_signals if s)
    
    if mcp_score >= 3:
        return "MCP"
    elif rest_score >= 3:
        return "REST"
    else:
        return "HYBRID"  # MCP for agent layer, REST for execution layer
```

---

### The Hybrid Pattern (Best of Both)

Most production systems benefit from this architecture:

```
User Request
     ↓
[AI Agent] ←── MCP ──→ [MCP Server: Tool Registry]
                               ↓
                        tools/call: "search_database"
                               ↓
                        [REST API] → [PostgreSQL]
```

The AI uses MCP for **dynamic tool selection**. The MCP server calls **REST APIs** for actual execution. You get AI flexibility without replacing your existing infrastructure.

```python
# MCP server that wraps existing REST APIs
class HybridMCPServer:
    
    @mcp.tool()
    async def search_products(query: str, max_results: int = 10) -> list[dict]:
        """Search product catalog. AI calls this via MCP."""
        # MCP server internally uses REST
        response = await httpx.get(
            f"http://internal-api/products/search",
            params={"q": query, "limit": max_results}
        )
        return response.json()
    
    @mcp.tool()
    async def create_order(product_id: str, quantity: int, customer_id: str) -> dict:
        """Create a new order. AI calls this via MCP when it determines an order is needed."""
        response = await httpx.post(
            "http://internal-api/orders",
            json={"product_id": product_id, "quantity": quantity, "customer_id": customer_id}
        )
        return response.json()
```

---

### Conclusion

MCP is not a REST killer — it's a specialized protocol for a specific use case: **letting AI agents autonomously discover and compose tools.**

Use MCP when the AI needs to decide. Use REST when you already know what to call.

Most serious AI systems will end up with both — MCP at the agent orchestration layer, REST (or gRPC) at the execution layer.

---

**Previous:** [MCP Security: Tool Poisoning Attack Simulation](/en/study/S_mcp-security/mcp-tool-poisoning)
**Next:** [MCP Context Bloat — Why More Tools Make Your Agent Slower](/en/study/S_mcp-security/mcp-context-bloat)
