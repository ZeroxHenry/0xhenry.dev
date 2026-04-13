---
title: "Multi-user Conflict Resolution in AI Memory"
date: 2026-04-12
draft: false
tags: ["AI-Memory", "Multi-Agent", "Conflict-Resolution", "Knowledge-Graph", "Data-Governance", "LLM"]
description: "When Alice says the meeting is at 2 PM, and Bob says it's at 3 PM, who does the AI agent believe? How multi-user environments resolve memory collisions."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

Personal AI assistants have a relatively easy job with memory. If a single user says, "I hate broccoli," the AI saves that fact. End of story. 

But what happens when an AI agent is integrated into an enterprise workspace (like Slack or Notion) handling dozens of users? 

- *Alice*: "The marketing budget Q3 is $50,000."
- *Bob*: "No, we cut the Q3 marketing budget to $40,000."

If a CEO asks the agent for the budget, the agent cannot hallucinate or average the numbers. It must resolve the **Memory Conflict**.

---

### The Problem with Flat Vector Storage

In a standard RAG (Retrieval-Augmented Generation) setup, both Alice and Bob's statements are simply turned into vectors and dumped into the same database.

When the CEO asks for the budget, the Vector DB mathematically retrieves both statements because they are semantically identical. A vanilla LLM will read both retrieved chunks and usually panic, outputting something like: *"The budget is either $40,000 or $50,000 depending on who you ask."* This is useless for enterprise decision-making.

---

### Solution 1: Role-Based Access Control (RBAC) Weighting

The first layer of conflict resolution is **Credential Weighting**. 
When inserting memories into the database, the agent tags the metadata with the user's role ID. 

When retrieving conflicting facts, the system prompt employs strict logic: 
*"If two facts contradict, the fact provided by the user with the higher organizational authority overrides the other."* 
If Bob is the CFO and Alice is an intern, the agent definitively states the budget is $40,000.

---

### Solution 2: The Consensus Knowledge Graph

In situations where colleagues have equal footing (e.g., two lead engineers arguing about a server architecture), role weighting fails. 

Here we use a **Consensus Knowledge Graph**. Instead of saving facts directly as truth, the agent saves them as *claims*. 
`Alice -> CLAIMS -> (Budget = 50k)`
`Bob -> CLAIMS -> (Budget = 40k)`

The agent is programmed to recognize the unresolved collision. When asked for the budget, the agent does not guess. It leverages the graph to route a notification back to the humans: *"Warning: I have a memory collision for the Q3 Budget. Alice claims $50k, Bob claims $40k. Please resolve this thread so I can update the official state."*

---

### The "Single Source of Truth" Paradigm

Ultimately, modern enterprise AI doesn't rely entirely on conversational memory for hard data. 
To avoid conflicts altogether, agents are given API access to a definitive **Single Source of Truth (SSOT)**—like Salesforce, Jira, or a SQL database. 

If Alice and Bob argue about the budget in chat, the agent records the conversation for context. But when the CEO asks for the final number, the agent ignores the chat vectors entirely and executes a direct GraphQL query to the finance software.

---

### Summary

Human collaboration is messy, contradictory, and constantly changing. If we want AI agents to participate in our workspaces, they cannot treat all text as equal truth. By implementing Role-Based Weighting, Consensus Graphs, and leaning on SSOT APIs, we teach AI how to navigate human disagreement and maintain a reliable, logical memory.

But in this web of shared memory, how do we protect sensitive information? Next time, we explore the legal and technical minefield of **Privacy and Memory: How to forget user data effectively.**

---

**Next Topic:** [Privacy and Memory: How to Forget User Data Effectively](/en/study/privacy-and-memory-ai-forgetting)
