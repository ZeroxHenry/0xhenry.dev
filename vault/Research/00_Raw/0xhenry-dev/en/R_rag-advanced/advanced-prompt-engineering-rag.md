---
title: "Advanced Prompt Engineering: Steering the RAG Response"
date: 2026-04-11
draft: false
tags: ["Prompt-Engineering", "RAG", "Few-Shot", "System-Instructions", "Prompt-Optimization"]
description: "How to craft the perfect system prompt for RAG: Handling 'I don't know' cases, citations, and structural formatting."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

Retrieval is only 50% of the RAG equation. The other 50% is how you instruct the LLM to use that retrieved data. If your prompt is weak, even the best retrieval system will result in generic, inaccurate, or hallucinated answers.

To build a professional RAG bot, you need **Advanced Prompt Engineering**.

---

### The Anatomy of a High-Quality RAG Prompt

A production-ready RAG prompt has four distinct sections:

1.  **Role Definition**: Contextualize the AI (e.g., "You are an expert legal researcher").
2.  **Instructional Constraints**: Strict rules for the answer (e.g., "Only use the provided context. If the answer is not there, say you don't know.").
3.  **Context Block**: Where you inject the retrieved chunks.
4.  **Formatting Instructions**: How the user wants the output (e.g., "Answer in Markdown with bullet points and include citations").

### Section 1: Handling "I Don't Know"

The most important instruction in RAG is the **Exit Clause**.
-   *Bad Prompt*: "Use the context to answer." (This encourages the LLM to guess if the answer isn't perfect).
-   *Good Prompt*: "Strictly use the provided context. If the context does not contain the answer, apologize and state that you cannot find the information in the current documents. Do not use your pre-trained knowledge."

---

### Section 2: Implementing Citations

Citations build trust. You can instruct the LLM to reference specific chunks by their metadata (e.g., ID or Title).

**Prompt Example**: 
> "Every time you mention a fact, cite the source in square brackets, for example [Source 1]. List the sources at the end of your response."

---

### Section 3: The "Context-Query" separator

To prevent **Prompt Injection** (where the context text might try to trick the LLM), use clear XML-style tags or distinct separators.

```text
### CONTEXT ###
{context_data}
###############

### USER QUESTION ###
{user_query}
#####################
```

---

### Summary

Prompt engineering for RAG isn't about being "polite" to the AI; it's about providing a rigid structural framework that forces the model to stay grounded in facts. By refining your system instructions, you can turn a "generic chat bot" into a precise, trustworthy domain expert.

In our next session, we’ll move to a critical operational topic: **Security & Privacy in Local RAG.**

---

**Next Topic:** [Local RAG Security: Protecting Your Proprietary Data](/en/study/local-rag-security)
