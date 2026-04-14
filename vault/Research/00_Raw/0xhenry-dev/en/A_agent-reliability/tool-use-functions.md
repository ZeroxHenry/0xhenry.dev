---
title: "Tool Use: Giving Your AI Agent Hands"
date: 2026-04-12
draft: false
tags: ["Tool-Use", "Function-Calling", "OpenAI-Functions", "LangChain-Tools", "API-Integration"]
description: "How to bridge the gap between text and action: Teaching LLMs to interact with the real world through JSON and Python functions."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

An LLM on its own is like a brain in a jar. It can think and talk, but it can't move anything. **Tool Use** (also known as Function Calling) is the interface that gives the AI "hands." It allows the model to interact with databases, send emails, or even control hardware.

But the AI doesn't actually "click" buttons. It uses structured data (**JSON**) as the medium of action.

---

### How Tool Use Works: The Handshake

1.  **Declaration**: You describe your function to the LLM (e.g., "This is `get_weather(city)`. It takes a string name of a city and returns the temperature").
2.  **Analysis**: The user asks, "How cold is it in Seoul?". The LLM realizes it doesn't know the answer but has a tool that does.
3.  **The Call**: Instead of an answer, the LLM outputs a **JSON object**: `{"function": "get_weather", "args": {"city": "Seoul"}}`.
4.  **Execution**: Your application (not the LLM) sees this JSON, runs the real Python code, and gets the result ("2°C").
5.  **Final Response**: You feed the result back to the LLM, which then says, "It is currently 2°C in Seoul."

---

### Why is this better than raw text?

-   **Reliability**: By forcing the output into a JSON schema, you can ensure that the AI provides the exact parameters your API needs.
-   **Security**: The LLM never has direct access to your database or OS. It only "requests" a function call, and your code decides whether to execute it.
-   **Extensibility**: You can give an AI any tool as long as you can write it as a Python function.

---

### Implementation Example (LangChain)

LangChain provides a `@tool` decorator that makes this incredibly easy.

```python
from langchain.tools import tool

@tool
def get_stock_price(symbol: str) -> float:
    """Returns the current stock price for a given ticker symbol."""
    # Your real API logic here
    return 150.25

# Bind the tool to the LLM
llm_with_tools = llm.bind_tools([get_stock_price])

# Ask a question
response = llm_with_tools.invoke("What is the price of AAPL?")
print(response.tool_calls)
# Output: [{'name': 'get_stock_price', 'args': {'symbol': 'AAPL'}}]
```

---

### Summary

Tool Use is the final piece of the agentic puzzle. It transforms a conversational partner into a functional operator. When combined with reasoning (ReAct) and memory, you have a system that can not only think but also execute complex workflows in the real world.

This concludes **Batch 2**. In our next batch, we’ll scale up to **Multi-Agent Systems and Advanced Orchestration.**

---

**Next Topic:** [Multi-Agent Orchestration: Designing a Virtual Company](/en/study/multi-agent-orchestration)
