---
title: "The MemGPT Architecture: Tiered Memory for Agents"
date: 2026-04-12
draft: false
tags: ["MemGPT", "LLM", "Memory-Management", "AI-Agents", "Operating-Systems", "Context-Window"]
description: "How computer science history from the 1960s solved the LLM context window problem. An introduction to the MemGPT architecture and virtual memory for AI."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

If the Context Window is too small to fit our entire database, and too expensive to constantly fill, how do we build agents that can reason over infinite amounts of data? 

The answer doesn't lie in a new AI breakthrough, but in a Computer Science trick from the 1960s: **Virtual Memory**. 
Just as your computer's OS pages RAM to a physical Hard Drive when it runs out of space, AI agents now page their Context Window to a Vector Database. The framework that popularized this is called **MemGPT**.

---

### The OS Metaphor

MemGPT treats the LLM fundamentally like an Operating System processor.

-   **Main Context (RAM)**: This is what the LLM can "see" right now. It is strictly limited (e.g., 8k tokens) to remain fast and cheap. It contains the system prompt, the most recent chat messages, and a tiny "scratchpad" for the LLM to write internal thoughts.
-   **External Context (Hard Drive)**: This is the infinitely large Vector Database or Knowledge Graph. It contains every document, past conversation, and fact. The LLM *cannot* see this directly.

### How the Agent "Pages" Memory

Because the LLM cannot see the External Context, it has to actively search it. The genius of MemGPT is that it gives the LLM specific **Functions (System Calls)** to manage its own memory.

1.  **`ArchivalMemory_Search(query)`**: If a user asks, *"What did I say about my favorite food last year?"*, the LLM realizes the answer is not in RAM. It outputs a function call to search the hard drive. 
2.  **The Paging Event**: The MemGPT orchestrator executes the Vector DB search, retrieves the top 3 relevant paragraphs, and injects them back into the LLM's Main Context (RAM).
3.  **The Answer**: Now that the information is in RAM, the LLM reads it and answers the user.

---

### Managing "Eviction"

RAM fills up quickly. If an AI agent chats with a user for 3 hours, the Main Context will hit its token limit. 
When the LLM detects its RAM is 90% full, it is forced to do garbage collection. 

It uses another function call: `CoreMemory_Append(summary)`. The LLM writes a 3-sentence summary of the last 3 hours of conversation, saves that summary to the "Hard Drive" (External Memory), and then aggressively deletes the raw chat logs from its RAM. 

This creates an illusion of infinite context. The agent remembers the *essence* of everything, but only pays the computational cost for the *exact details* when it explicitly searches for them.

---

### Summary

The MemGPT architecture is a profound paradigm shift. We have stopped treating LLMs as passive text generators and started treating them as active Operating Systems that manage their own resources. By learning when to search, when to summarize, and when to forget, AI agents can finally maintain infinite, stateful relationships with users.

But memory isn't just about reading the past; it's about updating it. Next time, we will explore how agents handle conflicting facts over time: **Continuous Learning.**

---

**Next Topic:** [Continuous Learning: Updating an Agent's Knowledge Without Fine-Tuning](/en/study/continuous-learning-agent-updates)
