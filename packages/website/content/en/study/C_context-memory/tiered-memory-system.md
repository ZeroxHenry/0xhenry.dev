---
title: "Beyond MemGPT — Build Your Own Tiered Memory System From Scratch"
date: 2026-04-13
draft: false
tags: ["Memory System", "LLM Memory", "MemGPT", "Context Engineering", "AI Architecture", "Persistent Memory"]
description: "How does ChatGPT's Memory feature actually work? We implement the core ideas from the MemGPT paper — Working Memory, Episodic Memory, and Archival Memory — in full, runnable Python code."
author: "Henry"
categories: ["AI Engineering"]
series: ["Context Engineering Series"]
series_order: 4
images_needed:
  - position: "hero"
    prompt: "Three-tier memory hierarchy: TOP 'Working Memory' (small bright RAM chip, fast, expensive, 2000 token label), MIDDLE 'Episodic Memory' (medium Redis database with timestamps), BOTTOM 'Archival Memory' (large Qdrant vector vault, slow, cheap, infinite capacity). Vertical arrows showing on-demand data movement between tiers. LLM agent at top orchestrating. Dark #0d1117, electric blue, 16:9"
    file: "images/C/tiered-memory-hero.png"
  - position: "how-it-works"
    prompt: "MemGPT operation flow diagram: Center LLM sees 'context window' panel (Working Memory visible). Outside context: Episodic Store (Redis cylinder) and Archival Store (Qdrant symbol). Three labeled arrows: 1.LLM reads working memory in context, 2.LLM calls recall_memory() → episodic, 3.LLM calls archival_memory_search() → archival. Monospace labels, dark background, 16:9"
    file: "images/C/tiered-memory-flow.png"
  - position: "class-architecture"
    prompt: "Three Python class boxes in vertical stack with connection arrows: TOP blue box 'WorkingMemory' (dict icon, 2K token limit bar), MIDDLE green box 'EpisodicMemory + Redis' (key-value icon, TTL label), BOTTOM purple box 'ArchivalMemory + Qdrant' (vector icon, infinite capacity). Read/write method labels on arrows. Dark background, monospace, 16:9"
    file: "images/C/tiered-memory-classes.png"
---

This is **Context Engineering Series** Part 4.
→ Part 3: [The AI Manager's RAM Guide — 5 Dynamic Context Assembly Patterns](/en/study/C_context-memory/dynamic-context-assembly)

---

When ChatGPT says "I remember you mentioned that project," it felt like magic the first time.

After understanding what's happening under the hood, it feels like engineering. And it's engineering you can replicate.

---

### The Fundamental Problem

An LLM's context window is RAM. Fast, powerful, but it only lasts while the power is on.

```
Session 1: "Hi, I'm Henry. I do robotics research and run a tech blog."
Session 2: [Context reset]
           "Hello! Who am I speaking with today?"
```

Two approaches exist:

**The naive approach**: Dump all conversation history into context every time → Context Rot, exponential cost growth

**The right approach**: Tiered memory system → LLM pulls only what it needs, when it needs it

This is the core proposal of MemGPT (2023, UC Berkeley).

---

### MemGPT's Core Idea

MemGPT borrows from operating system memory hierarchy:

```
Operating System:     L1 Cache → L2 Cache → RAM → Disk
MemGPT:              Context Window → Episodic Memory → Archival Memory
```

The critical insight: **the LLM manages its own memory through tool calls.** The AI decides what to remember, what to retrieve, and when.

```python
# The LLM has access to these memory management tools
MEMORY_TOOLS = [
    {
        "name": "recall_memory",
        "description": "Search previous conversation for specific information. Use when the user references something previously discussed.",
        "parameters": {"query": "What to search for"}
    },
    {
        "name": "archival_memory_search",
        "description": "Search long-term archive for older information about user preferences, projects, etc.",
        "parameters": {"query": "Search query", "page": "Page number for pagination"}
    },
    {
        "name": "archival_memory_insert",
        "description": "Store important information in long-term memory for future sessions.",
        "parameters": {"content": "Content to store permanently"}
    },
    {
        "name": "core_memory_update",
        "description": "Update core user facts (name, occupation, key preferences). Only for fundamental information.",
        "parameters": {"field": "Field to update", "value": "New value"}
    },
]
```

---

### Layer 1: Working Memory

Always in the context window. Contains only the most critical, session-persistent facts.

```python
from dataclasses import dataclass, field
from typing import Optional

@dataclass
class WorkingMemory:
    """
    Always-present in-context memory.
    Token budget: keep under 2,000 tokens.
    """
    # User persona — what the AI should never forget
    user_name: Optional[str] = None
    user_occupation: Optional[str] = None
    user_language: str = "English"
    
    # Active session state
    current_task: Optional[str] = None
    
    # Agent self-identity
    agent_persona: str = "0xHenry Technical Writing Assistant"
    
    # Key preferences (max 5 — force prioritization)
    key_preferences: list[str] = field(default_factory=list)
    
    def to_context_string(self) -> str:
        parts = ["[Core Context]"]
        if self.user_name:
            parts.append(f"- User: {self.user_name}")
        if self.user_occupation:
            parts.append(f"- Domain: {self.user_occupation}")
        parts.append(f"- Language preference: {self.user_language}")
        if self.current_task:
            parts.append(f"- Current task: {self.current_task}")
        if self.key_preferences:
            parts.append("- Key preferences:")
            for pref in self.key_preferences[:5]:
                parts.append(f"  • {pref}")
        return "\n".join(parts)
    
    def update(self, field: str, value: str):
        if field == "key_preferences":
            if value not in self.key_preferences:
                self.key_preferences.append(value)
                self.key_preferences = self.key_preferences[-5:]  # Keep most recent 5
        elif hasattr(self, field):
            setattr(self, field, value)
```

---

### Layer 2: Episodic Memory

Recent conversation history. Frequently needed but doesn't belong in context on every call.

```python
import redis
import json
from datetime import datetime

class EpisodicMemory:
    """
    Recent conversation episodes, persisted across sessions via Redis.
    """
    
    def __init__(self, user_id: str, redis_client: redis.Redis):
        self.user_id = user_id
        self.redis = redis_client
        self.key = f"episodic:{user_id}"
        self.max_episodes = 100
    
    def store(self, episode: dict):
        """Store episode: {role, content, timestamp, tags}"""
        episode["timestamp"] = datetime.now().isoformat()
        self.redis.lpush(self.key, json.dumps(episode, ensure_ascii=False))
        self.redis.ltrim(self.key, 0, self.max_episodes - 1)
    
    def recall(self, query: str, top_k: int = 5) -> list[dict]:
        """Retrieve relevant episodes using keyword + recency scoring."""
        all_episodes = [
            json.loads(e) 
            for e in self.redis.lrange(self.key, 0, -1)
        ]
        
        if not all_episodes:
            return []
        
        scored = []
        for i, ep in enumerate(all_episodes):
            keyword_score = sum(
                1 for tag in ep.get("tags", [])
                if tag.lower() in query.lower()
            )
            # Recent episodes get higher weight
            recency_score = 1.0 / (i + 1)
            total = 0.7 * keyword_score + 0.3 * recency_score
            scored.append((total, ep))
        
        scored.sort(key=lambda x: -x[0])
        return [ep for _, ep in scored[:top_k]]
    
    def get_recent(self, n: int = 10) -> list[dict]:
        """Get the n most recent episodes for context summarization."""
        return [json.loads(e) for e in self.redis.lrange(self.key, 0, n-1)]
```

---

### Layer 3: Archival Memory

Long-term knowledge store. Semantic search via vector database — meaning you find relevant memories even when exact keywords don't match.

```python
from qdrant_client import QdrantClient
from qdrant_client.http.models import Distance, VectorParams, PointStruct
import uuid

class ArchivalMemory:
    """
    Permanent long-term memory using Qdrant vector storage.
    Semantic search: find memories by meaning, not just keywords.
    """
    
    def __init__(self, user_id: str, embedder):
        self.user_id = user_id
        self.embedder = embedder
        self.client = QdrantClient(url="http://localhost:6333")
        self.collection = f"archive_{user_id}"
        self._ensure_collection()
    
    def _ensure_collection(self):
        existing = [c.name for c in self.client.get_collections().collections]
        if self.collection not in existing:
            self.client.create_collection(
                collection_name=self.collection,
                vectors_config=VectorParams(size=1536, distance=Distance.COSINE)
            )
    
    def insert(self, content: str, metadata: dict = {}):
        """Store important information permanently."""
        embedding = self.embedder.embed(content)
        self.client.upsert(
            collection_name=self.collection,
            points=[PointStruct(
                id=str(uuid.uuid4()),
                vector=embedding,
                payload={"content": content, "timestamp": datetime.now().isoformat(), **metadata}
            )]
        )
    
    def search(self, query: str, top_k: int = 5) -> list[dict]:
        """Semantic search across all archived memories."""
        results = self.client.search(
            collection_name=self.collection,
            query_vector=self.embedder.embed(query),
            limit=top_k
        )
        return [
            {"content": r.payload["content"], "score": r.score, "timestamp": r.payload["timestamp"]}
            for r in results
        ]
```

---

### Integrating All Three: TieredMemoryAgent

```python
class TieredMemoryAgent:
    def __init__(self, user_id: str, llm, embedder, redis_client):
        self.user_id = user_id
        self.llm = llm
        self.working = WorkingMemory()
        self.episodic = EpisodicMemory(user_id, redis_client)
        self.archival = ArchivalMemory(user_id, embedder)
    
    def chat(self, user_message: str) -> str:
        # 1. Build context from working memory + recent episode summary
        system = self._build_system_context()
        messages = [
            {"role": "system", "content": system},
            {"role": "user",   "content": user_message}
        ]
        
        # 2. LLM runs with memory tools available
        response = self.llm.chat_with_tools(messages=messages, tools=MEMORY_TOOLS)
        
        # 3. Process tool calls (LLM manages its own memory)
        while response.tool_calls:
            for tool_call in response.tool_calls:
                result = self._execute_memory_tool(tool_call)
                messages.append({"role": "tool", "content": str(result)})
            response = self.llm.chat_with_tools(messages=messages, tools=MEMORY_TOOLS)
        
        # 4. Archive this episode
        self.episodic.store({"role": "user", "content": user_message, "tags": self._extract_tags(user_message)})
        self.episodic.store({"role": "assistant", "content": response.content, "tags": []})
        
        return response.content
    
    def _build_system_context(self) -> str:
        recent = self.episodic.get_recent(n=6)
        recent_text = "\n".join(
            f"[{ep['role']}]: {ep['content'][:100]}..." for ep in recent
        ) if recent else "First conversation."
        
        return f"""You are {self.working.agent_persona}.

{self.working.to_context_string()}

[Recent Conversation Summary]
{recent_text}

[Memory Tools Available]
Use recall_memory when you need to find something discussed previously.
Use archival_memory_search for older or less recent information.
Use archival_memory_insert to save important new facts for future sessions.
Use core_memory_update when you learn fundamental user information (name, job, etc.)."""
    
    def _execute_memory_tool(self, tool_call) -> str:
        name = tool_call.function.name
        args = json.loads(tool_call.function.arguments)
        
        if name == "recall_memory":
            return json.dumps(self.episodic.recall(args["query"]), ensure_ascii=False)
        elif name == "archival_memory_search":
            return json.dumps(self.archival.search(args["query"]), ensure_ascii=False)
        elif name == "archival_memory_insert":
            self.archival.insert(args["content"])
            return "Stored successfully"
        elif name == "core_memory_update":
            self.working.update(args["field"], args["value"])
            return f"Updated {args['field']}: {args['value']}"
        return "Unknown tool"
    
    def _extract_tags(self, text: str) -> list[str]:
        import re
        return list(set(re.findall(r'\b[A-Za-z]{3,}\b', text)))[:10]
```

---

### Real Conversation Example

```python
agent = TieredMemoryAgent("henry_001", llm, embedder, redis)

# Session 1
agent.chat("Hey! I'm Henry. I do robotics research and write about AI systems.")
# LLM calls core_memory_update: user_name="Henry", user_occupation="robotics researcher + AI writer"
# LLM calls archival_memory_insert: "Henry – robotics PhD, runs 0xhenry.dev tech blog"

# Days later — new session, fresh context window
agent.chat("I'm thinking about writing a post on MCP security. Where should I start?")
# LLM recalls from archival: "Henry runs a tech blog, likely writing for developers"
# Working memory still has: user_name="Henry", user_occupation="robotics researcher"
# Response: "Given your blog's audience, I'd start with the Tool Poisoning attack pattern..."
```

---

### Comparison with ChatGPT Memory

| Feature | ChatGPT Memory | This Implementation |
|---------|---------------|---------------------|
| Working Memory | ✅ Summary injected into system prompt | ✅ WorkingMemory dataclass |
| Episodic Recall | ✅ OpenAI servers | ✅ Redis + keyword scoring |
| Archival Search | ❌ Not available | ✅ Vector DB semantic search |
| Domain customization | ❌ Fixed behavior | ✅ Full control |
| Data ownership | ❌ OpenAI | ✅ Your infrastructure |
| Cost | OpenAI pricing | Infrastructure cost only |

---

### Conclusion

"The AI remembers things" is not magic. It's a systematic engineering solution: **store information outside the context window, retrieve it on demand, let the AI decide what's relevant.**

MemGPT's key insight: don't manage memory for the AI. Give the AI tools and let it manage memory itself.

Next in this series: when conversation history becomes poison — a comparison of summary compression algorithms that decides how aggressively to compress before the LLM sees it.

---

**Previous:** [The AI Manager's RAM Guide — 5 Dynamic Assembly Patterns](/en/study/C_context-memory/dynamic-context-assembly)
**Next:** [When History Becomes Poison — Conversation Compression Algorithms Compared](/en/study/C_context-memory/conversation-compression)
