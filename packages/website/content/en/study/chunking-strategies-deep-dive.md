---
title: "Chunking Strategies: Why Slicing Data Matters for RAG"
date: 2026-04-12
draft: false
tags: ["Chunking", "RAG", "Data-Preprocessing", "LangChain"]
description: "How to properly segment your documents to improve the retrieval accuracy of your RAG system."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

In RAG, the quality of the answer is directly linked to the quality of the retrieved context. If you feed the LLM irrelevant or fragmented information, the answer will be poor. This is where **Chunking** comes in.

Chunking is the process of breaking large documents into smaller, meaningful segments (chunks).

---

### Why not just use the whole document?

1.  **Context Window Limits**: LLMs have a maximum number of tokens they can process at once.
2.  **Noise**: A 50-page PDF might only have 2 paragraphs relevant to the user's question. Sending the full 50 pages adds "noise" and confuses the model.
3.  **Cost & Efficiency**: Processing smaller, targeted chunks is faster and cheaper.

---

### Common Chunking Strategies

#### 1. Character-based Splitting (Fixed Size)
This is the simplest method. You split the text every N characters (e.g., every 500 characters).
-   **Pros**: Fast and easy.
-   **Cons**: Might cut a sentence in half, losing its meaning. "The capital of France is [CHUNK END] Paris" is a disaster for embeddings.

#### 2. Recursive Character Splitting (The Gold Standard)
This is what we used in our tutorial (`RecursiveCharacterTextSplitter`). It tries to split at logical points: paragraphs (`\n\n`), then newlines (`\n`), then spaces (` `).
-   **Pros**: Keeps paragraphs and sentences together as much as possible.
-   **Cons**: Still essentially mechanical, not conceptual.

#### 3. Semantic Splitting
This method uses an embedding model to "look" at the meaning of sentences. If two consecutive sentences are very different in meaning, a split is made.
-   **Pros**: Creates conceptually pure chunks.
-   **Cons**: Slower because it requires running an embedding model during the splitting process.

---

### The Importance of "Overlap"

When chunking, we usually include an **Overlap** (e.g., a 500-character chunk with a 50-character overlap).

**Why?**
Overlap provides **Contextual Continuity**. If a fact is split across the boundary of Chunk A and Chunk B, the overlap ensures that at least one of the chunks retains enough surrounding context to make the fact understandable to the AI.

### Best Practices

-   **Match Query Size**: If your users ask short questions, smaller chunks (300-500 chars) are often better. For complex, summary-based questions, larger chunks (1000+ chars) might be needed.
-   **Include Metadata**: Every chunk should know which document it came from. This allows you to show citations (e.g., "Source: Page 4 of User Manual").
-   **Clean Your Data**: Before chunking, remove repetitive headers, footers, and page numbers that can clutter your vector database.

### Summary

Chunking isn't a one-size-fits-all task. It’s a balancing act between keeping chunks small enough for efficiency and large enough to retain meaning.

In the next post, we’ll move from theory to specific tools: **Recursive Character Text Splitter vs. Token Splitter.**

---

**Next Topic:** [Recursive Splitter vs. Token Splitter: Choosing your Tool](/en/study/splitter-comparison)
