---
title: "OAuth 2.1로 MCP 서버를 프로덕션 수준으로 보안화하기"
date: 2026-04-13
draft: false
tags: ["MCP", "OAuth 2.1", "AI보안", "인증", "API보안", "보안아키텍처"]
description: "로컬에서만 돌던 MCP 서버를 실제 서비스에 배포하려면 무엇이 필요할까요? AI 에이전트의 도구 호출 권한을 안전하게 관리하기 위한 OAuth 2.1 통합 전략을 상세히 다룹니다."
author: "Henry"
categories: ["MCP & AI 보안"]
series: ["MCP 실전"]
series_order: 4
images_needed:
  - position: "hero"
    prompt: "A digital vault door with an OAuth 2.1 logo. Multiple AI agents are showing their ID cards to a security guard robot to get access to specific tools inside the vault. Dark background #0d1117, teal and white, 16:9"
    file: "images/S/mcp-oauth21-security-hero.png"
  - position: "architecture"
    prompt: "OAuth 2.1 flow diagram: User -> AI Agent -> Authorization Server -> MCP Server (Tool Execution). Labeled with 'PKCE', 'Refresh Token', 'Access Token'. Technical flow design, 16:9"
    file: "images/S/mcp-oauth21-flow.png"
---

이 글은 **MCP 실전 시리즈** 4편입니다.
→ 3편: [MCP Context Bloat — 도구가 많을수록 에이전트가 느려지는 이유](/ko/study/S_mcp-security/mcp-context-bloat)

---

로컬에서 `stdio` 방식으로 MCP 서버를 돌리는 것은 쉽습니다. 하지만 그 서버를 클라우드에 올리고 회사 동료들이나 외부 사용자가 쓰게 하려면 상황이 달라집니다.

"누가 이 도구를 쓸 수 있는가?"
"이 에이전트가 내 대신 결제를 해도 되는가?"

이 질문에 답하기 위해 우리는 **OAuth 2.1**이라는 표준 보안 레이어를 MCP에 씌워야 합니다.

---

### 왜 OAuth 2.1인가?

OAuth 2.1은 기존 2.0의 복잡성을 줄이고 보안을 강화한 최신 표준입니다. 특히 AI 에이전트 환경에서 중요한 **PKCE(Proof Key for Code Exchange)**를 기본으로 요구하며, 안전하지 않은 방식(Implicit Grant 등)을 제거했습니다.

AI 에이전트가 사용자의 데이터에 접근할 때, **"대리인(Agent)에게 명시적인 권한을 위임한다"**는 철학에 가장 잘 부합하는 프로토콜입니다.

---

### MCP + OAuth 2.1 아키텍처

```
[사용자] ──(1) 도구 사용 요청──→ [AI 에이전트]
   │                                  │
   └─(2) 권한 승인 (OAuth Consent) ───┘
                                      │
   [인증 서버] ←──(3) Token 발급 ─── [AI 에이전트]
                                      │
                                (4) Access Token 전역 설정
                                      │
[MCP 서버] ←──(5) tools/call (Token 포함) ── [AI 에이전트]
```

---

### 구현 핵심: SSE 기반 전송과 인증 헤더

로컬의 `stdio`와 달리 서버 방식인 `SSE(Server-Sent Events)`를 사용할 때는 HTTP 헤더를 통해 인증 정보를 넘겨야 합니다.

#### 1. 에이전트(클라이언트) 쪽 설정
에이전트는 사용자를 대신해 획득한 `AccessToken`을 MCP 요청마다 헤더에 포함시킵니다.

```python
from mcp import ClientSession
from mcp.client.sse import sse_client

async with sse_client("https://mcp.0xhenry.dev/tools") as (read, write):
    async with ClientSession(read, write) as session:
        # 인증 헤더를 포함하여 세션 초기화
        await session.initialize(
            headers={"Authorization": f"Bearer {user_access_token}"}
        )
        # 이제 안전하게 도구 호출
        result = await session.call_tool("secure_data_query", {"id": "123"})
```

#### 2. MCP 서버 쪽 검증
서버는 각 요청이 올 때마다 토큰의 유효성과 **스코프(Scope)**를 확인해야 합니다.

```python
from fastapi import Request, HTTPException
from mcp.server.fastapi import MCPServer

app = MCPServer("secure-mcp-server")

@app.tool()
async def delete_user_record(record_id: str, request: Request):
    # (1) 헤더에서 토큰 추출
    auth_header = request.headers.get("Authorization")
    
    # (2) OAuth 서버를 통해 토큰 검증 및 권한 확인
    user_info = await verify_oauth_token(auth_header)
    
    # (3) 스코프 확인: 'admin:write' 권한이 있는가?
    if "admin:write" not in user_info["scopes"]:
        raise HTTPException(status_code=403, detail="권한이 부족합니다.")
        
    # (4) 실제 로직 수행
    return do_delete(record_id)
```

---

### 프로덕션 적용 시 주의사항 (Security Checklist)

1. **상태 유지 세션(Stateful Sessions)**: MCP는 서버 쪽에서 상태를 유지할 수 있습니다. 각 세션이 서로 다른 사용자의 권한을 침범하지 않도록 **Isolaton(격리)**을 철저히 설계하세요.
2. **짧은 토큰 수명**: AI 에이전트는 해킹의 표적이 되기 쉽습니다. Access Token의 만료 시간을 짧게 설정하고, Refresh Token을 사용하여 필요할 때만 갱신하세요.
3. **세밀한 스코프(Granular Scopes)**: 단순히 `read`, `write`가 아니라 `mcp:tool:weather:read`, `mcp:tool:db:delete` 처럼 도구 단위로 권한을 쪼개는 것이 안전합니다.
4. **감사 로그(Audit Logs)**: "누가, 언제, 어떤 토큰으로, 어떤 도구를 호출했는가"를 반드시 로그로 남겨야 합니다. AI가 저지른 사고를 추적할 유일한 방법입니다.

---

### 결론

MCP 서버를 로컬 샌드박스 밖으로 꺼내는 순간, 그것은 하나의 정규 API 서버와 다를 바 없습니다. **OAuth 2.1**을 통해 "믿을 수 있는 에이전트"에게만 도구 상자를 열어주세요. 보안이 담보되지 않은 AI 편의성은 언제든 부메랑이 되어 돌아옵니다.

---

**다음 글:** [프롬프트 인젝션 공격 — 외부 데이터가 AI를 납치하는 방법](/ko/study/S_mcp-security/prompt-injection-attacks)
