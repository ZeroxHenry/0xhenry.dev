# MemGPT를 넘어 — 직접 구현하는 계층형 메모리 시스템

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


이 글은 **Context Engineering 시리즈** 4편입니다.
→ 3편: [AI의 RAM 관리법: 동적 컨텍스트 조립 패턴 5가지](/ko/study/C_context-memory/dynamic-context-assembly)

---

ChatGPT가 "저번에 말씀하셨던 프로젝트명이 기억나네요"라고 했을 때, 처음엔 마법처럼 느껴졌습니다.

뒤에서 어떤 일이 일어나는지 알고 나서야 — 마법이 아니라 공학이라는 걸 깨달았습니다. 그리고 직접 만들 수 있습니다.

---

### LLM 메모리의 근본적인 한계

LLM의 컨텍스트 창은 RAM입니다. 빠르고 강력하지만, 켜져 있는 동안만 지속됩니다.

```
대화 1: "제 이름은 Henry입니다. 로봇공학을 연구해요."
대화 2 (새 세션): [컨텍스트 리셋됨]
          "안녕하세요! 저는 어떤 분을 도와드리고 있나요?"
```

두 가지 접근 방법이 있습니다:

**단순한 방법**: 대화 이력을 전부 컨텍스트에 쑤셔 넣기 → Context Rot, 비용 폭탄
**올바른 방법**: 계층형 메모리 시스템 → LLM이 스스로 필요한 것만 꺼내 씀

MemGPT(2023, UC Berkeley)가 제안한 것이 바로 두 번째 방법입니다.

---

### MemGPT의 핵심 아이디어

MemGPT는 운영체제의 메모리 계층 구조에서 아이디어를 빌립니다.

```
운영체제:    L1 캐시 → L2 캐시 → RAM → 디스크
MemGPT:     컨텍스트 창 → 에피소딕 메모리 → 아카이브 메모리
```

중요한 점은 **LLM이 직접 메모리를 관리한다**는 것입니다. LLM은 도구 호출을 통해 메모리를 읽고 씁니다.

```python
# LLM이 사용하는 메모리 도구들
MEMORY_TOOLS = [
    {
        "name": "recall_memory",
        "description": "이전 대화에서 특정 정보를 검색합니다. 사용자가 언급했던 내용을 찾을 때 사용.",
        "parameters": {"query": "검색할 내용"}
    },
    {
        "name": "archival_memory_search", 
        "description": "장기 아카이브에서 정보를 검색합니다. 오래된 프로젝트, 선호도 등.",
        "parameters": {"query": "검색 쿼리", "page": "페이지 번호"}
    },
    {
        "name": "archival_memory_insert",
        "description": "중요한 정보를 장기 메모리에 저장합니다.",
        "parameters": {"content": "저장할 내용"}
    },
    {
        "name": "core_memory_update",
        "description": "핵심 사용자 정보(이름, 직업, 중요 선호도)를 업데이트합니다.",
        "parameters": {"field": "필드명", "value": "새로운 값"}
    },
]
```

---

### 3계층 메모리 시스템 직접 구현

#### 계층 1: 작업 메모리 (Working Memory)

항상 컨텍스트 창에 있는 핵심 정보입니다. 가장 자주 필요한 것들만.

```python
from dataclasses import dataclass, field
from typing import Optional
import json

@dataclass
class WorkingMemory:
    """
    항상 컨텍스트에 포함되는 핵심 메모리.
    크기 제한: 2,000 토큰 이하 유지
    """
    # 사용자 페르소나 (절대 잊으면 안 되는 것들)
    user_name: Optional[str] = None
    user_occupation: Optional[str] = None
    user_language: str = "Korean"
    
    # 현재 세션 목표
    current_task: Optional[str] = None
    
    # AI의 자기 인식
    agent_persona: str = "0xHenry 기술 블로그 어시스턴트"
    
    # 중요 선호도 (최대 5개)
    key_preferences: list[str] = field(default_factory=list)
    
    def to_context_string(self) -> str:
        """컨텍스트에 주입될 문자열 생성"""
        parts = ["[핵심 정보]"]
        if self.user_name:
            parts.append(f"- 사용자: {self.user_name}")
        if self.user_occupation:
            parts.append(f"- 직업/분야: {self.user_occupation}")
        parts.append(f"- 선호 언어: {self.user_language}")
        if self.current_task:
            parts.append(f"- 현재 작업: {self.current_task}")
        if self.key_preferences:
            parts.append("- 주요 선호도:")
            for pref in self.key_preferences[:5]:
                parts.append(f"  • {pref}")
        return "\n".join(parts)
    
    def update(self, field: str, value: str):
        if hasattr(self, field):
            setattr(self, field, value)
        elif field == "key_preferences":
            if value not in self.key_preferences:
                self.key_preferences.append(value)
                self.key_preferences = self.key_preferences[-5:]  # 최근 5개 유지
```

#### 계층 2: 에피소딕 메모리 (Episodic Memory)

최근 대화 이력. 자주 접근하지만 전부를 컨텍스트에 올릴 필요는 없습니다.

```python
import redis
from datetime import datetime

class EpisodicMemory:
    """
    최근 대화 에피소드 저장소.
    Redis를 사용해 세션 간 지속성 유지.
    """
    
    def __init__(self, user_id: str, redis_client: redis.Redis):
        self.user_id = user_id
        self.redis = redis_client
        self.key = f"episodic:{user_id}"
        self.max_episodes = 100  # 최대 100개 에피소드 보관
    
    def store(self, episode: dict):
        """
        에피소드 저장: {role, content, timestamp, tags}
        tags = LLM이 분류한 중요 키워드 (나중에 검색용)
        """
        episode["timestamp"] = datetime.now().isoformat()
        serialized = json.dumps(episode, ensure_ascii=False)
        
        # Redis List에 최신 순으로 저장
        self.redis.lpush(self.key, serialized)
        # 최대 개수 초과 시 오래된 것 제거
        self.redis.ltrim(self.key, 0, self.max_episodes - 1)
    
    def recall(self, query: str, top_k: int = 5) -> list[dict]:
        """
        쿼리와 관련된 에피소드 검색.
        tags 기반 키워드 매칭 + 시간 가중치 적용.
        """
        all_episodes = [
            json.loads(e) 
            for e in self.redis.lrange(self.key, 0, -1)
        ]
        
        if not all_episodes:
            return []
        
        # 관련도 점수 계산
        scored = []
        for i, ep in enumerate(all_episodes):
            # 키워드 매칭
            keyword_score = sum(
                1 for tag in ep.get("tags", [])
                if tag.lower() in query.lower()
            )
            # 최신성 가중치 (최근 = 높은 점수)
            recency_score = 1.0 / (i + 1)
            
            total_score = 0.7 * keyword_score + 0.3 * recency_score
            scored.append((total_score, ep))
        
        # 상위 k개 반환
        scored.sort(key=lambda x: -x[0])
        return [ep for _, ep in scored[:top_k]]
    
    def get_recent(self, n: int = 10) -> list[dict]:
        """최근 n개 에피소드 반환 (압축된 대화 이력용)"""
        return [json.loads(e) for e in self.redis.lrange(self.key, 0, n-1)]
```

#### 계층 3: 아카이브 메모리 (Archival Memory)

장기 지식 저장소. 벡터 DB를 활용해 의미 검색이 가능합니다.

```python
from qdrant_client import QdrantClient
from qdrant_client.http.models import Distance, VectorParams, PointStruct
import uuid

class ArchivalMemory:
    """
    장기 아카이브 메모리.
    Qdrant 벡터 DB 사용 — 의미론적 유사도 검색 지원.
    """
    
    def __init__(self, user_id: str, embedder):
        self.user_id = user_id
        self.embedder = embedder
        self.client = QdrantClient(url="http://localhost:6333")
        self.collection = f"archive_{user_id}"
        self._ensure_collection()
    
    def _ensure_collection(self):
        collections = [c.name for c in self.client.get_collections().collections]
        if self.collection not in collections:
            self.client.create_collection(
                collection_name=self.collection,
                vectors_config=VectorParams(size=1536, distance=Distance.COSINE)
            )
    
    def insert(self, content: str, metadata: dict = {}):
        """중요 정보를 아카이브에 영구 저장"""
        embedding = self.embedder.embed(content)
        
        self.client.upsert(
            collection_name=self.collection,
            points=[PointStruct(
                id=str(uuid.uuid4()),
                vector=embedding,
                payload={
                    "content": content,
                    "timestamp": datetime.now().isoformat(),
                    **metadata
                }
            )]
        )
    
    def search(self, query: str, top_k: int = 5) -> list[dict]:
        """의미론적 유사도로 아카이브 검색"""
        query_embedding = self.embedder.embed(query)
        
        results = self.client.search(
            collection_name=self.collection,
            query_vector=query_embedding,
            limit=top_k
        )
        
        return [
            {"content": r.payload["content"], "score": r.score, "timestamp": r.payload["timestamp"]}
            for r in results
        ]
```

---

### 전체 시스템 통합: TieredMemoryAgent

```python
class TieredMemoryAgent:
    """
    3계층 메모리를 통합해서 사용하는 AI 에이전트.
    LLM이 메모리 도구를 통해 스스로 메모리를 관리.
    """
    
    def __init__(self, user_id: str, llm, embedder, redis_client):
        self.user_id = user_id
        self.llm = llm
        self.working = WorkingMemory()
        self.episodic = EpisodicMemory(user_id, redis_client)
        self.archival = ArchivalMemory(user_id, embedder)
    
    def chat(self, user_message: str) -> str:
        # 1. 시스템 컨텍스트 구성 (작업 메모리 + 최근 대화 요약)
        system = self._build_system_context()
        
        # 2. LLM 호출 (메모리 도구 포함)
        messages = [
            {"role": "system", "content": system},
            {"role": "user", "content": user_message}
        ]
        
        response = self.llm.chat_with_tools(
            messages=messages,
            tools=MEMORY_TOOLS
        )
        
        # 3. 도구 호출 처리
        while response.tool_calls:
            for tool_call in response.tool_calls:
                tool_result = self._execute_memory_tool(tool_call)
                messages.append({"role": "tool", "content": str(tool_result)})
            
            response = self.llm.chat_with_tools(messages=messages, tools=MEMORY_TOOLS)
        
        # 4. 에피소드 저장
        self.episodic.store({
            "role": "user",
            "content": user_message,
            "tags": self._extract_tags(user_message)
        })
        self.episodic.store({
            "role": "assistant", 
            "content": response.content,
            "tags": []
        })
        
        return response.content
    
    def _build_system_context(self) -> str:
        recent = self.episodic.get_recent(n=6)
        recent_summary = "\n".join([
            f"[{ep['role']}]: {ep['content'][:100]}..."
            for ep in recent
        ]) if recent else "첫 대화입니다."
        
        return f"""당신은 {self.working.agent_persona}입니다.

{self.working.to_context_string()}

[최근 대화 요약]
{recent_summary}

[사용 가능한 메모리 도구]
- recall_memory: 이전 대화에서 정보 검색
- archival_memory_search: 장기 아카이브 검색
- archival_memory_insert: 중요 정보 아카이브에 저장
- core_memory_update: 핵심 사용자 정보 업데이트

기억해야 할 중요 정보가 있으면 archival_memory_insert를 호출하세요.
사용자 기본 정보가 변경되면 core_memory_update를 호출하세요."""

    def _execute_memory_tool(self, tool_call) -> str:
        name = tool_call.function.name
        args = json.loads(tool_call.function.arguments)
        
        if name == "recall_memory":
            results = self.episodic.recall(args["query"])
            return json.dumps(results, ensure_ascii=False)
        
        elif name == "archival_memory_search":
            results = self.archival.search(args["query"])
            return json.dumps(results, ensure_ascii=False)
        
        elif name == "archival_memory_insert":
            self.archival.insert(args["content"])
            return "저장 완료"
        
        elif name == "core_memory_update":
            self.working.update(args["field"], args["value"])
            return f"{args['field']} 업데이트 완료: {args['value']}"
        
        return "알 수 없는 도구"
    
    def _extract_tags(self, text: str) -> list[str]:
        """간단한 키워드 추출 (프로덕션에서는 LLM 분류 사용)"""
        import re
        words = re.findall(r'\b[가-힣]{2,}|[A-Za-z]{3,}\b', text)
        return list(set(words))[:10]
```

---

### 실제 동작 예시

```python
agent = TieredMemoryAgent("henry_001", llm, embedder, redis)

# 첫 번째 대화
agent.chat("안녕하세요! 저는 Henry예요. 로봇공학 박사과정이고 AI 블로그를 운영해요.")
# LLM이 자동으로 core_memory_update 호출:
# - user_name: "Henry"
# - user_occupation: "로봇공학 박사과정, AI 블로그 운영"

# 며칠 후 새 세션
agent.chat("요즘 MCP 관련 글 쓰려고 하는데 뭐부터 시작하면 좋을까요?")
# LLM이 recall_memory("MCP 글쓰기") 호출 → 이전 대화에서 맥락 복원
# 작업 메모리에서 사용자가 AI 블로그 운영자임을 확인
# → "Henry님, 블로그 독자분들이 MCP를 처음 접하는 개발자들이라면..."
```

---

### ChatGPT Memory와의 비교

| 기능 | ChatGPT Memory | 우리 구현 |
|------|---------------|---------|
| 작업 메모리 | ✅ 시스템 프롬프트에 요약 주입 | ✅ WorkingMemory 클래스 |
| 에피소딕 기억 | ✅ OpenAI 서버에 저장 | ✅ Redis + 키워드 검색 |
| 아카이브 검색 | ❌ 지원 안 함 | ✅ 벡터 DB 의미 검색 |
| 도메인 커스터마이징 | ❌ | ✅ 완전 제어 |
| 데이터 주권 | ❌ OpenAI 서버 | ✅ 자체 서버 |

---

### 결론

"AI가 기억한다"는 것은 마법이 아닙니다. 컨텍스트 창 밖에 있는 정보를 체계적으로 저장하고, 필요할 때 꺼내오는 공학적 설계입니다.

MemGPT의 핵심 통찰: **LLM 자신이 메모리 관리자가 되게 하라.** 어떤 정보가 중요한지, 언제 꺼내올지를 LLM이 판단합니다.

다음 편에서는 "대화 이력이 독이 되는 순간" — 요약 압축 알고리즘들을 실측 비교합니다.

---

**이전 글:** [AI의 RAM 관리법: 동적 컨텍스트 조립 패턴 5가지](/ko/study/C_context-memory/dynamic-context-assembly)
**다음 글:** [대화 이력이 독이 되는 순간 — 요약 압축 알고리즘 비교](/ko/study/C_context-memory/conversation-compression)