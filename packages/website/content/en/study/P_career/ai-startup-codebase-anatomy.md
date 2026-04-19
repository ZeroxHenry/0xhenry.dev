---
title: "Anatomy of an AI Startup Codebase — How the Structure is Actually Built"
date: 2026-04-14
draft: false
tags: ["Startup", "Code Structure", "Architecture", "Open Source", "LangChain", "Node.js", "Python"]
description: "What do the GitHub repositories of famous AI services look like? We dig into the folder structures, prompt management styles, and practical patterns for implementing agentic workflows used by leading AI startups."
author: "Henry"
categories: ["Career & Perspective"]
series: ["Career & Perspective Series"]
series_order: 7
images_needed:
  - position: "hero"
    prompt: "A cross-section of a high-tech building. Inside, you can see server racks, a library of prompt files, and workers (agents) passing messages to each other. Dark mode #0d1117, 16:9"
    file: "/images/study/P_career/P/ai-startup-codebase-anatomy-hero.png"
---

This is Part 7 of the **Career & Perspective Series**.

![AI Startup Codebase Anatomy Hero](/images/study/P_career/P/ai-startup-codebase-anatomy-hero.png)
→ Part 6: [Sandwich Architecture: Designing with LLMs without Depending on Them](/en/study/P_career/sandwich-architecture-llm)

---

"Agent services have easy tutorials, but how should I structure the folders in a real project?"

It’s hard to find the right answer even after looking through countless technical docs. So, I personally dissected leading AI open-source projects and startup codebases to summarize 3 common **'practical patterns.'**

---

### 1. Manage Prompts Like 'Code,' Not 'Data'

Successful projects don't hardcode prompts into `f-strings` in the source code.
- **Pattern**: They maintain a separate `/prompts` folder and manage them as `.yaml` or `.jinja2` files. This allows for version control and a structure where non-developers like planners can modify prompts.

---

### 2. Isolation of Agent 'Tools'

The functions an agent uses (weather lookup, DB search, etc.) exist as independent modules.
- **Pattern**: They isolate defined tools and input validation logic (like Pydantic) inside a `/tools` or `/actions` folder. This way, existing tools can be reused like LEGO blocks when creating new agents.

---

### 3. Centralization of State

Remembering previous conversations and recording which step an agent is currently performing is extremely complex.
- **Pattern**: They use a **'Stateful Graph'** pattern utilizing Redis or Postgres. Going beyond simply passing a 'list of previous chats,' they systematically store the agent's 'train of thought' in a DB.

---

### Henry's Take: "It is Eventually Traditional Engineering"

There is no special magic just because AI is involved. In fact, because of AI's uncertainty, **folder structure and Separation of Concerns** must be much more rigorous. Before your project grows, isolate your `/prompts` and `/tools` folders right now.

---

**Next:** [2026: Why We Must Return to 'Basics' Once More](/en/study/P_career/back-to-basics)
