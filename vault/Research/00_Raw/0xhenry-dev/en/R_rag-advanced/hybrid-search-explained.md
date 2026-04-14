---
title: "Hybrid Search: Combining the Best of Keywords and Semantic AI"
date: 2026-04-11
draft: false
tags: ["Hybrid-Search", "BM25", "Vector-Search", "RAG", "Optimization"]
description: "Why choosing between keyword and semantic search is a false dilemma, and how to combine them for maximum accuracy."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

In the early days of RAG, everyone was excited about **Vector Search** (semantic search). We thought we could finally stop worrying about exact keywords. However, reality soon set in: vector search is great at finding "concepts," but it can be surprisingly bad at finding specific product codes, technical acronyms, or unique names.

The solution? **Hybrid Search**. It’s the practice of combining traditional keyword-based search (BM25) with modern vector-based search.

---

### The Problem with Pure Vector Search

Imagine a user searches for a specific part number: `XJ-9000-A`.
-   **Vector Search**: Might find generic "mechanical parts" or "high-performance components" because it understands the *concept* of the search, but it might miss the exact document containing that specific string.
-   **Keyword Search**: Finds the exact string `XJ-9000-A` instantly, even if it doesn't understand what a "part" is.

### How Hybrid Search Works

Hybrid search runs both algorithms in parallel and then merges the results using a technique called **Reciprocal Rank Fusion (RRF)**.

1.  **Keyword Path (BM25)**: Uses frequency and statistics to find exact matches.
2.  **Vector Path (Dense Retrieval)**: Uses embeddings to find conceptual matches.
3.  **Fusion (RRF)**: A math formula combines the two lists, rewarding documents that show up high in *both* lists or extremely high in at least one.

---

### Why You Need Hybrid Search

-   **Accuracy**: It covers the weaknesses of both systems.
-   **User Experience**: Users expect "Search" to work for both questions ("How do I...?") and specific terms ("XJ-9000").
-   **Domain Specificity**: Essential for legal, medical, or technical fields where specific terminology is non-negotiable.

---

### Implementation with LangChain

Most modern vector databases like Weaviate, Pinecone, and ChromaDB now support hybrid search out of the box.

```python
# Pseudo-code for Weaviate Hybrid Search in LangChain
retriever = vectorstore.as_retriever(
    search_type="hybrid",
    search_kwargs={
        "alpha": 0.5,  # 0.5 = Equal weight to keyword and vector
        "query": "XJ-9000-A maintenance guide"
    }
)
```

The `alpha` parameter is your tuning knob:
-   `alpha = 1.0`: Pure Vector Search.
-   `alpha = 0.0`: Pure Keyword Search (BM25).
-   `alpha = 0.5`: Balanced Hybrid.

### Summary

Hybrid search is the gold standard for production RAG systems. It ensures that your AI is both "smart" (understanding concepts) and "precise" (finding exact terms). 

In the next post, we’ll look at how to further refine these results: **Implementing Cross-Encoders for Re-ranking.**

---

**Next Topic:** [Cross-Encoders: The Ultimate Accuracy Upgrade](/en/study/cross-encoders-reranking)
