---
title: "UI as a Function of State: How LLMs Return Interfaces"
date: 2026-04-12
draft: false
tags: ["Generative-UI", "React", "State-Management", "LLM", "Vercel-AI-SDK", "Frontend-Architecture"]
description: "React taught us that UI is a function of state. Now, we are learning how to make the LLM the ultimate state-manager."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

In the React ecosystem, the defining philosophy has always been `UI = f(state)`. The interface is simply a visual representation of the underlying data. If you change the data, the interface updates automatically.

In the age of Generative UI, we are expanding this equation: **`UI = f(LLM(Prompt))`**. The Large Language Model determines the state, and the framework renders the interface.

---

### The Paradigm Shift in State Management

Traditionally, managing state meant fetching data from a database and stuffing it into Redux, Zustand, or React Context. You had to explicitly wire every button to a state mutation.

When building AI-powered interfaces, the "State" is the **Conversation History** and the **Tool Calls**.

1.  **The Prompt**: The user asks, *"Compare the battery life of the iPhone 15 and the Galaxy S24."*
2.  **The LLM State**: The LLM streams back a specific JSON object indicating it wants to invoke the `<ProductComparisonTable />` component with specific data parameters.
3.  **The Render**: The framework catches this JSON, instantiates the React Server Component, hydrates the data, and pushes the final HTML to the client.

The LLM is effectively acting as the supreme Redux reducer.

---

### Using Vercel AI SDK (`useUIState`)

Frameworks like the Vercel AI SDK provide specialized hooks (like `useUIState` and `useAIState`) to manage this complex choreography.

-   **`AIState` (The Brain)**: This is the raw JSON representation of the conversation. It contains the system prompts, the user messages, and the function calls. This is what is sent back to OpenAI or Anthropic.
-   **`UIState` (The Eyes)**: This is what the user actually sees. It translates the raw `AIState` into React nodes. If the `AIState` says `{ type: 'tool_call', name: 'weather', data: '75F' }`, the `UIState` arrays swaps that out for a beautiful `<WeatherCard temp="75" />`.

---

### The Challenge of Determinism

LLMs are inherently non-deterministic; they can hallucinate or change their minds. How do you build a reliable UI on top of that?

The answer is **Strict Structured Outputs (JSON Mode)**.
By forcing the LLM to reply using a strict JSON schema (e.g., using Zod), we guarantee that the data passed to our React components will never be missing a required prop. If the LLM tries to send a string where a number was expected, the parsing library catches it and retries before the UI crashes.

---

### Summary

By treating the LLM as the engine that generates application state, we unlock interfaces that adapt fluidly to the user's intent. The frontend developer's job is no longer to hardcode the "User Journey," but to build a rich library of components that the AI can dynamically assemble.

In our next session, we’ll see how this dynamic generation can solve one of the web's oldest problems: **Accessibility (a11y).**

---

**Next Topic:** [AI-Driven Accessibility: Fixing Contrast and ARIA Automatically](/en/study/ai-driven-accessibility)
