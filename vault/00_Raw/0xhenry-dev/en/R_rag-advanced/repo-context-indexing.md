---
title: "Repository-level Context: How AI Sees Your Whole Project"
date: 2026-04-12
draft: false
tags: ["Context-Indexing", "RAG", "Embeddings", "Tree-Sitter", "Coding-Agents", "AI-Systems"]
description: "Going beyond the open file. How AI tools index your entire codebase to understand dependencies, architecture, and hidden logic."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

One of the biggest frustrations with early AI coding assistants was their "short-term memory." You would ask a question about a function in `main.py`, and the AI would fail because the function was defined in `utils.js` (which wasn't open).

Modern AI tools like Cursor use **Repository-level Context** to solve this. They don't just read what's on your screen; they maintain a "mental map" of your entire project.

---

### How it Works: The Indexing Pipeline

Building a repository-level context requires three core technologies:

1.  **Parsing with Tree-Sitter**: Instead of seeing code as plain text, the AI uses **Tree-Sitter** to parse the code into its actual structure (Abstract Syntax Tree). It knows exactly where classes, methods, and variables are defined.
2.  **Code Embeddings (Vector Search)**: The system generates mathematical vectors for every function and file in your project. These are stored in a local vector database.
3.  **Graph Analysis**: High-end tools create a "map" of dependencies. They know that File A imports File B, which calls a function in File C.

### The Retrieval Process

When you ask, "Where do we handle payment webhooks?", the tool doesn't search every line of code. Instead:
-   It converts your question into a vector.
-   It finds the most relevant "snippets" from the vector database.
-   It uses the **Graph Map** to expand the search to related files.
-   It stuffs only the most relevant 10-20 snippets into the LLM's context window.

---

### Why this is the "Secret Sauce"

Without repo-level context, an AI is just a general-purpose coder. With it, the AI becomes a **senior developer on your specific project**. It knows your naming conventions, your folder structure, and your unique architectural quirks.

---

### Privacy and Performance

In 2026, most of this indexing happens **locally**. 
-   **Security**: Your source code never leaves your machine for indexing; only the "search query" or a small snippet is sent to the cloud.
-   **Speed**: Specialized local indexing engines (like Cursor's `cpp` backend) can index 100,000 lines of code in seconds, keeping the AI always up-to-date with your latest changes.

---

### Summary

Repository-level context is what turns a "Chatbot" into an "Engineer." By understanding the relationships between files, AI can finally help us with the most difficult part of software development: navigating a complex, ever-growing codebase.

In our next session, we’ll see how this context is used for massive improvements: **Automated Refactoring and Cleaning Tech Debt.**

---

**Next Topic:** [Automated Refactoring: Using AI to Clean Your Base](/en/study/automated-refactoring-agents)
