---
title: "The ReAct Pattern: How Agents Think and Act"
date: 2026-04-12
draft: false
tags: ["ReAct", "AI-Agents", "Prompting", "Reasoning", "Chain-of-Thought"]
description: "The fundamental loop of modern AI agents: Synergizing reasoning and acting to solve complex, multi-step problems."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

How does an AI know when to search the web, when to use a calculator, and when it has finally found the answer? In the early days of agents, LLMs would often "hallucinate" tool usage. The breakthrough came with the **ReAct** (Reason + Act) pattern.

ReAct is a prompting technique that forces the LLM to write down its internal thought process before it takes any action.

---

### The ReAct Loop: Thought, Action, Observation

The ReAct pattern consists of a repeating loop that follows these three steps:

1.  **Thought**: The LLM writes down what it is thinking. 
    -   *Example*: "I need to find the current price of Bitcoin to calculate the total value of 5 BTC."
2.  **Action**: The LLM chooses a tool and provides the input.
    -   *Example*: `Search(query="current bitcoin price")`
3.  **Observation**: The system runs the tool and Feeds the result back to the LLM.
    -   *Example*: "Bitcoin is currently $95,000."

The LLM then looks at the **Observation** and starts the loop again with a new **Thought**. ("Now that I know the price is $95,000, I will multiply it by 5...")

---

### Why ReAct is a Game Changer

-   **Explainability**: You can read the "Thought" section to understand exactly *why* the AI chose a specific tool. If it makes a mistake, you can see where its logic went wrong.
-   **Error Correction**: If a tool returns an error (e.g., "Page not found"), the LLM sees that in the Observation and can "think" of an alternative way to get the information.
-   **Synergy**: It combines the power of **Chain-of-Thought** reasoning with the utility of external tools.

---

### Implementation Example (Conceptual)

In LangChain, this is handled by the `ReActAgent`. The internal prompt looks something like this:

```text
Answer the following questions as best you can. You have access to the following tools:
{tool_descriptions}

Use the following format:
Question: the input question you must answer
Thought: you should always think about what to do
Action: the action to take, should be one of [{tool_names}]
Action Input: the input to the action
Observation: the result of the action
... (this Thought/Action/Action Input/Observation can repeat N times)
Thought: I now know the final answer
Final Answer: the final answer to the original input question
```

---

### Summary

The ReAct pattern is the "Operating System" of the agentic world. It provides the structured discipline an LLM needs to navigate the real world reliably. By forcing the model to "think before it acts," we transform it from a reactive text-filler into a proactive problem-solver.

In our next session, we’ll see how to build these complex flows visually and structurally: **Building Agents with LangGraph.**

---

**Next Topic:** [LangGraph: Orchestrating Complex Agent Workflows](/en/study/langgraph-intro)
