---
title: "Code RAG: Teaching AI to Understand Your Repo"
date: 2026-04-11
draft: false
tags: ["Code-RAG", "Abstract-Syntax-Tree", "GitHub-Indexing", "LLM-Agents", "Development"]
description: "Why standard text splitting fails for code and how to build a RAG system that understands class hierarchies and function calls."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

Applying RAG to a codebase is fundamentally different from applying it to a collection of essays. In a standard document, the context is usually linear (sentences in a paragraph). In code, the context is **Relational and Structural**. A function in `auth.py` might depend on a class defined in `utils.py`. If you split these files into random chunks, the AI will lose the connection between them.

To build a **Code RAG**, we need "Code-Aware" splitting.

---

### The Challenge of Code Context

1.  **Imports and Dependencies**: To understand a file, the AI needs to know what it imports.
2.  **Class Hierarchies**: A method might be empty in the current file but defined in a parent class elsewhere.
3.  **Non-Linearity**: Code execution jumps between files.

### Solution: Structural Indexing (AST)

Instead of splitting by character count, we use an **Abstract Syntax Tree (AST)** parser to split by logical units:

-   **Functions**: Each function becomes its own chunk.
-   **Classes**: Each class definition and its metadata become a chunk.
-   **Summaries**: We pre-process each file to create a high-level summary (e.g., "This file handles JWT token validation") to help with broad architectural questions.

---

### Tools for Code RAG

-   **Tree-sitter**: An incremental parsing library that can build a syntax tree for almost any programming language. It allows you to extract every function and class with surgical precision.
-   **Greptile / Bloop**: These are enterprise-grade services that specialize in codebase indexing.
-   **LangChain CodeSplitter**: A simpler tool that understands the basic syntax of Python, JS, and Go to make cleaner splits than a standard text splitter.

---

### Implementation Strategy

1.  **Tagging**: Add metadata to every chunk indicating its file path, line number, and function name.
2.  **Dependency Mapping**: For every chunk, also include the "signature" of its imports so the AI knows where to look for related logic.
3.  **The "Map-Reduce" approach**: When a user asks a broad question like "How does the login flow work?", first retrieve file summaries, then retrieve the specific functions mentioned in those summaries.

---

### Summary

Code RAG is the ultimate tool for accelerating developer onboarding and debugging. By moving from "Text Search" to "Syntax-Aware Search," you transform your AI from a simple documentation reader into a co-pilot that actually understands your architecture.

In our next session, we’ll see how to measure if any of this is actually working: **Evaluation with the RAGAS framework.**

---

**Next Topic:** [Evaluating RAG: Measuring Accuracy with RAGAS](/en/study/evaluating-rag-ragas)
