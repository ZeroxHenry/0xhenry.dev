# C_context-memory — 이미지 프롬프트 가이드

> **비주얼 스타일 공통 규칙**
> - 배경: 짙은 네이비/다크 (#0d1117 계열)
> - 강조색: 일렉트릭 블루 (#58a6ff), 민트 (#4fffb0)
> - 폰트 느낌: 테크 다이어그램, 깔끔한 라벨
> - 비율: 16:9 (썸네일/히어로), 1:1 (인포그래픽 삽입형)
> - 스타일: "Clean technical diagram, dark background, minimal icons, professional tech blog, no gradients"

---

## C-01: context-engineering.md

### 이미지 1 — 히어로 (도입부)
```
위치: 본문 시작 직후
설명: CPU와 RAM 관계로 LLM과 Context Window를 비유하는 다이어그램

프롬프트:
"Technical architecture diagram showing CPU labeled 'LLM' connected to RAM modules labeled 'Context Window', 
with arrows showing data flow labeled 'instruction', 'history', 'retrieved docs', 'tool outputs'. 
Dark background #0d1117, electric blue #58a6ff highlights, clean minimal lines, monospace font labels, 
professional engineering blog style, 16:9 aspect ratio, no gradients, high contrast"

파일명: images/C/context-engineering-hero.png
```

### 이미지 2 — 비교 다이어그램 (프롬프트 엔지니어링 vs Context Engineering)
```
위치: "프롬프트 엔지니어링 vs Context Engineering" 섹션

프롬프트:
"Side-by-side comparison diagram: LEFT side labeled 'Prompt Engineering' shows a person writing a single message 
with a pencil icon, thought bubble says 'How to ask?'. RIGHT side labeled 'Context Engineering' shows an architect 
with a blueprint designing a full information system with boxes: System Prompt, History, Retrieved Docs, Tools. 
LEFT side in orange/warm tones, RIGHT side in blue/cool tones. Dark background, clean flat design, 16:9"

파일명: images/C/context-engineering-comparison.png
```

### 이미지 3 — 컨텍스트 오염 vs 정제 다이어그램
```
위치: "Context Rot" 코드 블록 위

프롬프트:
"Two-panel technical diagram: LEFT panel 'Bad Context' shows a cluttered RAM bar filled with red blocks 
labeled 'old history 8K', 'irrelevant docs 15K', 'all tools 3K', total 28K tokens, with a warning icon.
RIGHT panel 'Context Engineering' shows a clean RAM bar with small precise blue blocks labeled 
'compressed history 1.2K', 'relevant docs only 3K', 'needed tools 0.4K', total 5.1K tokens, 
with a green checkmark. Dark background, red vs blue color coding, 16:9"

파일명: images/C/context-engineering-rot.png
```

### 이미지 4 — 동적 컨텍스트 조립 플로우
```
위치: "Core Technique 1: Dynamic Assembly" 섹션

프롬프트:
"Technical flowchart: User Query enters from left → splits into three parallel paths: 
(1) Retriever searches vector DB → returns 'top 2 relevant docs', 
(2) History compressor → returns 'last 3 turns + summary', 
(3) Tool router → selects '2 needed tools'. 
All three paths merge into 'Context Assembler' box → outputs to LLM cylinder. 
Dark background, electric blue arrows, mint green boxes, monospace labels, clean diagram style, 16:9"

파일명: images/C/context-engineering-assembly.png
```

---

## C-02: context-rot-lost-in-middle.md

### 이미지 1 — 히어로 (Lost in the Middle 시각화)
```
위치: 도입부

프롬프트:
"Data visualization showing attention distribution across a long input sequence. 
X-axis: 'Token Position in Context (0 to 60K)', Y-axis: 'Model Attention Score'. 
U-shaped curve with HIGH attention at LEFT (tokens 0-5K, labeled 'System Prompt') 
and RIGHT (tokens 55K-60K, labeled 'Current Query'), 
LOW attention dip in the MIDDLE (labeled 'Lost Here — Your Important Instructions'). 
Red danger zone highlighted in the middle. Dark background, white curve line, 16:9"

파일명: images/C/context-rot-hero.png
```

### 이미지 2 — 4가지 증상 인포그래픽
```
위치: "Context Rot의 4가지 증상" 섹션

프롬프트:
"Four-panel infographic grid (2x2): 
Panel 1 (red icon: brain with X): 'Instruction Forgetting' - robot ignoring a rule sign
Panel 2 (orange icon: question mark): 'Context Confusion' - robot saying 'Who are you?' to familiar person
Panel 3 (yellow icon: shifting mask): 'Role Drift' - AI character morphing from professional to casual
Panel 4 (purple icon: biohazard): 'Accumulative Contamination' - error messages stacking like poison bottles
Dark background, each panel with distinct warning color border, clean icon style, 16:9"

파일명: images/C/context-rot-symptoms.png
```

### 이미지 3 — 성능 저하 그래프 (실측 수치)
```
위치: "컨텍스트 크기와 성능 저하: 실측 데이터" 표 위

프롬프트:
"Line chart showing LLM performance degradation vs context size. 
X-axis: 'Context Size (tokens)' with values 1K, 5K, 15K, 30K, 60K.  
Y-axis: 'Performance Score (%)' from 0 to 100.  
Three declining lines: blue='Instruction Compliance', orange='Information Accuracy', green='Role Consistency'.  
All start near 95-97% at 1K tokens and drop to 44-51% at 60K tokens.  
Data points clearly marked. Dark background, grid lines subtle, professional chart style, 16:9"

파일명: images/C/context-rot-chart.png
```

### 이미지 4 — 3가지 Anti-Rot 패턴 다이어그램
```
위치: "해결책: 3가지 Anti-Rot 패턴" 섹션

프롬프트:
"Three-column solution diagram:
Column 1 'Rolling Summary': timeline showing old turns compressed to summary box, recent turns kept raw.
Column 2 'Re-injection': conversation timeline with periodic REMINDER boxes inserted every 5 turns, highlighted in yellow.
Column 3 'Context Purging': error messages shown as red X blocks being filtered out, clean messages pass through green.
Title above: 'Anti-Rot Patterns'. Dark background, each column with its own accent color, 16:9"

파일명: images/C/context-rot-solutions.png
```

---

## C-03: context-window-limits-llm.md

### 이미지 1 — 히어로
```
프롬프트:
"Visual metaphor: a funnel labeled 'Context Window' with different sized inputs falling in — 
small blue blocks (instructions, 500 tokens), medium orange blocks (history, 3K), 
large red blocks (documents, 20K), massive gray blocks (trying to fit 100K, getting cut off with scissors icon).
Dark background, clean illustrative style, 16:9"

파일명: images/C/context-window-limits-hero.png
```

### 이미지 2 — 토큰 크기 비교표
```
프롬프트:
"Comparison bar chart: different content types and their typical token counts. 
Bars (horizontal): 'System Prompt' 200-500 tokens (blue), 'Single conversation turn' 100-300 (green), 
'1 page PDF' ~750 tokens (orange), 'Full book chapter' ~5K (yellow), 
'Full codebase' ~50K-200K (red, extends beyond chart with arrow).
Dark background, color-coded bars, clean labels in monospace font, 16:9"

파일명: images/C/context-window-comparison.png
```

### 이미지 3 — 컨텍스트 한계 실패 다이어그램
```
프롬프트:
"Technical diagram showing context overflow scenario: 
A RAM bar completely full (red overflow indicator at right), labeled 'Context Window 128K tokens FULL'.
Text bubbles from the AI (robot icon): 'I cannot see your system prompt anymore', 
'Truncating earlier conversation...'. Warning symbols, danger red highlights on overflow area.
Dark background, technical illustration style, 16:9"

파일명: images/C/context-window-overflow.png
```

---

## C-04: infinite-context-models-vs-retrieval.md

### 이미지 1 — 히어로 (무한 컨텍스트 vs RAG 대결)
```
프롬프트:
"Epic battle scene diagram (tech style): LEFT side 'Infinite Context (1M+ tokens)' 
represented as a massive hard drive with 'FULL' label, cost tag '$$$' floating above.
RIGHT side 'RAG' represented as a smart librarian robot quickly selecting 2 relevant books 
from a huge library, cost tag '$' floating above.
VS symbol in the middle. Dark background, dramatic lighting, 16:9"

파일명: images/C/infinite-context-vs-rag-hero.png
```

### 이미지 2 — 비용 vs 정확도 2D 플롯
```
프롬프트:
"Scatter plot diagram: X-axis 'Cost per Query ($)', Y-axis 'Accuracy (%)'.
Plot points: 
- 'Naive Full Context' at high cost ($1.20), medium accuracy (73%), red dot
- 'RAG + Small Model' at low cost ($0.08), high accuracy (81%), green dot
- 'Infinite Context + Large Model' at very high cost ($4.50), medium-high accuracy (78%), orange dot
- 'Hybrid RAG + MoE' at low cost ($0.15), highest accuracy (89%), blue star (optimal zone)
Green 'Sweet Spot' region highlighted. Dark background, grid lines, 16:9"

파일명: images/C/infinite-context-cost-accuracy.png
```

### 이미지 3 — 결론 의사결정 트리
```
프롬프트:
"Decision tree flowchart: Start 'Do you need full document understanding?' 
→ YES branch → 'Is the document < 50K tokens?' → YES: 'Use Full Context' → NO: 'Use RAG + Chunking'
→ NO branch → 'Is real-time retrieval feasible?' → YES: 'Use RAG' → NO: 'Use Cached Context'
Clean tree diagram, dark background, blue decision nodes, green result leaves, 16:9"

파일명: images/C/infinite-context-decision-tree.png
```

---

## C-05: llm-long-term-memory-intro.md

### 이미지 1 — 히어로 (AI 메모리 계층)
```
프롬프트:
"Memory hierarchy pyramid diagram for AI systems (top to bottom):
Level 1 (top, smallest, gold): 'Working Memory — Context Window' — 128K tokens, ephemeral
Level 2 (middle, silver): 'Short-term Memory — Conversation Cache' — session-based
Level 3 (larger, bronze): 'Long-term Memory — Vector Database' — persistent, searchable  
Level 4 (base, largest, iron): 'Permanent Memory — Fine-tuned Weights' — baked in model
Labels, sizes, and durations for each level. Dark background, pyramid shape, 16:9"

파일명: images/C/llm-memory-hierarchy.png
```

### 이미지 2 — 메모리 없는 AI vs 있는 AI
```
프롬프트:
"Before/After comparison: 
LEFT 'AI without Long-term Memory': robot meets same user 10 times, each time with a blank expression and 'Nice to meet you!' speech bubble. Groundhog day loop symbol.
RIGHT 'AI with Long-term Memory': robot meets user, checks memory database, says 'Welcome back Alex! Your last project was...' Smart, connected, personalized feel.
Dark background, warm vs cool color contrast, 16:9"

파일명: images/C/llm-memory-intro-comparison.png
```

---

## C-06: memgpt-tiered-memory-agents.md

### 이미지 1 — MemGPT 아키텍처 다이어그램
```
프롬프트:
"Technical architecture diagram of MemGPT's tiered memory system:
Top layer 'Main Context' (small, fast, expensive) — bright blue box, shows active conversation
Middle layer 'Recall Storage' (medium, searchable) — orange box, recent conversation archive
Bottom layer 'Archival Storage' (large, slow, cheap) — gray box, long-term database/vector store
Arrows showing: 'memory_search()' going up from archival to recall, 'memory_append()' going down.
Small OS/scheduler component managing transfers. Dark background, clean architecture diagram, 16:9"

파일명: images/C/memgpt-architecture.png
```

### 이미지 2 — 메모리 이동 플로우
```
프롬프트:
"Process flow diagram: 
Step 1: User message arrives → Agent processes
Step 2: Context nearly full (red indicator) → Eviction trigger
Step 3: Old memories compressed and moved to Archival Storage (downward arrow)
Step 4: Relevant memories retrieved from Archival on demand (upward arrow with search icon)
Step 5: Fresh context assembled → Agent responds
Six steps connected by arrows. Dark background, orange flow colors, 16:9"

파일명: images/C/memgpt-memory-flow.png
```

---

## C-07: continuous-learning-agent-updates.md

### 이미지 1 — 에이전트 업데이트 사이클
```
프롬프트:
"Circular continuous learning loop diagram for AI agents:
1. (blue) 'Interaction' — user talks to agent
2. (green) 'Feedback Collection' — thumbs up/down, implicit signals
3. (orange) 'Pattern Analysis' — data analysis icon
4. (red) 'Knowledge Update' — database update icon
5. (purple) 'Model Refinement' — neural network icon
Back to 1. Arrows connecting all steps in a circle. Center label: 'Continuous Learning Loop'.
Dark background, colorful numbered steps, 16:9"

파일명: images/C/continuous-learning-cycle.png
```

---

## C-08: knowledge-graphs-relational-memory.md

### 이미지 1 — 지식 그래프 vs 벡터 DB 비교
```
프롬프트:
"Side-by-side comparison:
LEFT 'Vector Database': floating dots in 3D space with distance lines between similar points.
Query dot with search radius circle. Good at: 'semantic similarity'.
RIGHT 'Knowledge Graph': network of named nodes (Person: Alice, Company: Acme, Project: Apollo)
connected by labeled edges (works_at, leads, founded_in). Good at: 'relationships & facts'.
Show a 'Hybrid' arrow in the middle suggesting combination. Dark background, 16:9"

파일명: images/C/knowledge-graph-vs-vector.png
```

### 이미지 2 — 트리플(Triple) 구조
```
프롬프트:
"Knowledge graph triple visualization: 
Three connected boxes: [Subject: 'Claude Sonnet'] --[Predicate: 'developed by']--> [Object: 'Anthropic']
Another triple: [Anthropic] --[founded in]--> [2021]
Another: [Claude Sonnet] --[context window]--> [200K tokens]
Nodes as rounded rectangles, predicates as labeled arrows. Dark background, blue nodes, green edges, 16:9"

파일명: images/C/knowledge-graph-triple.png
```

---

## C-09: multi-user-conflict-resolution-memory.md

### 이미지 1 — 메모리 충돌 시나리오
```
프롬프트:
"Conflict diagram: Shared AI agent (center robot icon) serves TWO users simultaneously.
User A (left): 'Remember: I prefer formal English responses'
User B (right): 'Remember: Always respond in casual Korean'
Both arrows pointing to agent, creating a collision symbol (⚡) at the center.
Question mark bubble from agent: 'Which preference applies NOW?'
Dark background, red collision highlight, 16:9"

파일명: images/C/multi-user-memory-conflict.png
```

### 이미지 2 — 메모리 격리 해결책
```
프롬프트:
"Solution architecture diagram: 
Shared Agent (center) with three separate memory namespaces (colored containers):
[user:alice namespace] — blue container with Alice's preferences
[user:bob namespace] — green container with Bob's preferences  
[global namespace] — white container for shared knowledge
Agent reads from correct namespace based on session context.
Dark background, namespace isolation clearly visualized, 16:9"

파일명: images/C/multi-user-memory-isolation.png
```

---

## C-10: privacy-and-memory-ai-forgetting.md

### 이미지 1 — AI 메모리 삭제 권리(GDPR)
```
프롬프트:
"Legal-tech concept diagram: Robot holding a formal document labeled 'GDPR Art. 17 — Right to Erasure'.
On the right, a database with a highlighted entry being deleted (red X button with 'DELETE' label).
Below: three storage types that must be cleaned: 'Context Cache', 'Vector DB', 'Fine-tuned Weights'.
Scales of justice icon above. Dark background, legal-tech hybrid style, 16:9"

파일명: images/C/privacy-ai-forgetting.png
```

### 이미지 2 — 망각 레이어 아키텍처
```
프롬프트:
"Architecture diagram: 'Forget Layer' middleware between User and AI Memory.
Input: 'Forget me' API call with user_id.
Processing: cascade deletes across:
1. Redis Cache (fastest, complete in 1ms)
2. Vector Database (embedding deletion, 100ms)
3. Relational DB (user profile, 50ms)
4. Model weights (cannot delete — shown as red X with warning)
Output: Audit log entry. Dark background, cascade delete flow, 16:9"

파일명: images/C/privacy-forget-architecture.png
```

---

## C-11: vector-databases-hippocampus.md

### 이미지 1 — 해마(Hippocampus) ↔ 벡터 DB 비유
```
프롬프트:
"Split comparison illustration:
LEFT: Human brain with hippocampus highlighted in glowing blue, label 'Hippocampus — biological memory indexer'.
Arrows show: experience → encode → store → retrieve.
RIGHT: Vector Database cylinder with embedding dimensions shown as numerical vectors [0.23, -0.87, 0.54...],
label 'Vector DB — AI memory indexer'. Same encode→store→retrieve arrows.
Scientific illustration meets tech diagram style. Dark background, 16:9"

파일명: images/C/vector-db-hippocampus.png
```

### 이미지 2 — 벡터 유사도 검색 시각화
```
프롬프트:
"3D vector space visualization: Multiple colored dots floating in 3D space representing embedded documents.
Query vector shown as a gold star. Nearest neighbors (top-3) highlighted with blue circles and dotted lines.
Distance labels showing cosine similarity scores: 0.94, 0.87, 0.81.
Faraway irrelevant documents shown as dim gray dots. Axis labels: dim-1, dim-2, dim-3.
Dark background, 3D perspective, professional visualization style, 16:9"

파일명: images/C/vector-similarity-search.png
```
