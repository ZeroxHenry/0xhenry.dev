---
title: "Evaluating RAG: Measuring Accuracy with RAGAS"
date: 2026-04-11
draft: false
tags: ["Evaluation", "RAGAS", "RAG-Metrics", "Faithfulness", "Relevance"]
description: "How to stop guessing and start measuring: A deep dive into the RAGAS framework for automated RAG evaluation."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

"It looks correct" is not a valid evaluation for a production AI system. As you change your chunk size, your embedding model, or your prompt, you need a way to **measure** if your system is actually getting better or worse. 

This is where **RAGAS** (RAG Assessment) comes in. It’s a framework that uses an LLM to evaluate your RAG pipeline across four key metrics, known as the **RAGAS Rag Triad**.

---

### The RAGAS Metrics

Instead of just checking if the final answer is right, RAGAS evaluates the relationship between the **Query**, the **Context**, and the **Answer**.

1.  **Faithfulness (Answer vs. Context)**: Does the answer contain information *not* found in the retrieved context? (Prevents hallucinations).
2.  **Answer Relevance (Answer vs. Query)**: Does the answer actually address what the user asked?
3.  **Context Precision (Context vs. Query)**: How relevant are the retrieved chunks to the user's question?
4.  **Context Recall (Context vs. Ground Truth)**: Does the retrieved context contain all the information needed to answer the question?

---

### Why use an LLM to evaluate an LLM?

Human evaluation is slow and expensive. RAGAS uses a powerful model (like GPT-4o) to act as a "judge." This judge analyzes the semantic alignment between your data points. While not 100% perfect, it provides a consistent, automated benchmark that you can run every time you change your code.

---

### Implementation with Python

RAGAS integrates perfectly with LangChain and can use local models for the evaluation if needed.

```python
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevance, context_precision
from datasets import Dataset

# 1. Prepare your test data
data = {
    "question": ["How do I install ChromaDB?"],
    "answer": ["You can install it with pip install chromadb."],
    "contexts": [["ChromaDB is a vector DB. Install it via pip install chromadb."]],
    "ground_truth": ["Run 'pip install chromadb' in your terminal."]
}

dataset = Dataset.from_dict(data)

# 2. Run Evaluation
result = evaluate(
    dataset,
    metrics=[faithfulness, answer_relevance, context_precision]
)

print(result)
```

---

### Summary

RAGAS turns RAG development from "vibe-based engineering" into a data-driven science. By tracking these metrics over time, you can confidently iterate on your system, knowing exactly where it's strong and where it needs more work.

In our next tutorial, we’ll move from evaluation to real-time operations: **Monitoring RAG with LangSmith.**

---

**Next Topic:** [Monitoring RAG: Real-time Observability with LangSmith](/en/study/monitoring-langsmith)
