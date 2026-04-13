---
title: "Groundedness, Faithfulness, Relevance — RAG Evaluation Metrics in Practice"
date: 2026-04-13
draft: false
tags: ["RAG", "LLMOps", "Evaluation", "Groundedness", "Faithfulness", "Relevance", "RAGAS"]
description: "How do you measure if a RAG response is 'good'? Stop guessing and start measuring with the RAG Triad: Groundedness, Faithfulness, and Relevance. A guide to automated quality metrics with source code."
author: "Henry"
categories: ["LLMOps"]
series: ["RAG Failure Analysis"]
series_order: 2
images_needed:
  - position: "hero"
    prompt: "A digital scale weighing an AI response against a source document. Holographic numbers (0.95, 0.88) floating in a science laboratory setting. Dark blue background, high-tech aesthetic, 16:9"
    file: "images/O/rag-evaluation-metrics-hero.png"
  - position: "triad"
    prompt: "Venn diagram of the RAG Triad: Faithfulness, Answer Relevance, Context Relevance. Central intersection labeled 'High Quality RAG'. Smooth gradients and professional look, 16:9"
    file: "images/O/rag-evaluation-triad.png"
  - position: "chart"
    prompt: "Comparison bar charts showing RAG performance score before and after optimization. Modern dark mode dashboard design, 16:9"
    file: "images/O/rag-evaluation-dashboard.png"
---

This is Part 2 of the **LLMOps in Production** series.
→ Part 1: [HTTP 200 But Your Business Is Broken — Designing AI Quality KPIs](/en/study/O_llmops/llm-quality-kpi)

---

When you build a RAG (Retrieval-Augmented Generation) system, you will eventually hear this:

"The answers... they just feel a bit off."

Answering with "I'll try a new embedding model" or "I'll tweak the prompt" is the amateur way. Professionals answer with **data**. But "quality" in AI is notoriously subjective.

To turn subjectivity into objectivity, we use the **RAG Triad** — a set of standard metrics used by frameworks like Ragas and TruLens.

---

### The RAG Triad: Three Pillars of Quality

The RAG Triad evaluates the two core stages of RAG: **Retrieval** and **Generation**.

#### 1. Faithfulness (Gen Quality)
- **The Question**: Is the answer derived *only* from the retrieved context?
- **The Check**: Does the AI hallucinate info from its internal training data that wasn't in the documents?

#### 2. Answer Relevance (Gen Quality)
- **The Question**: Does the answer actually address the user's query?
- **The Check**: Even if factually correct, is it helpful? Or did the AI ignore the core question?

#### 3. Context Relevance (Retrieval Quality)
- **The Question**: Does the retrieved context actually contain the answer to the question?
- **The Check**: If your search engine returns trash, your generation stage will produce trash.

---

### Measuring Metrics: LLM-as-a-Judge

We can't have humans score every response. Instead, we use a **Judge LLM** (usually a more powerful model like GPT-4o or Claude 3.5 Sonnet) to do the work.

#### Code Example: Measuring Faithfulness (Python)

```python
def check_faithfulness(question, context, answer, judge_llm):
    prompt = f"""
    You are a strict Fact-Checking Agent.
    Evaluate if the [AI Answer] is supported ONLY by the [Context].

    [Context]: {context}
    [AI Answer]: {answer}

    Steps:
    1. Extract all underlying claims from the AI Answer.
    2. For each claim, check if it is explicitly stated in the Context.
    3. Calculate score: (Number of supported claims) / (Total claims).

    Output as JSON:
    {{"score": 0.0-1.0, "reason": "...", "unsupported_claims": []}}
    """
    response = judge_llm.complete(prompt)
    return json.loads(response.text)
```

---

### Groundedness vs. Faithfulness: What’s the difference?

In the field, these are often used interchangeably. But there is a nuance:

- **Faithfulness**: Do you lie? (Accuracy relative to source)
- **Groundedness**: Can you prove it? (Attribution/Citation)

**Groundedness** is often used when evaluating if the AI can provide specific **Citations** (e.g., "This fact is from Paragraph 4").

---

### Sample Benchmarking Table

When you introduce a new retrieval algorithm (like Hybrid Search), your dashboard should look like this:

| Metric | Base RAG | Hybrid Search | Delta |
|--------|----------|---------------|-------|
| **Context Relevance** | 0.65 | 0.82 | +26% 🟢 |
| **Faithfulness** | 0.88 | 0.85 | -3% 🟡 |
| **Answer Relevance** | 0.72 | 0.81 | +12% 🟢 |

**Analysis**: Hybrid Search greatly improved search quality (+26%). However, retrieving more chunks slightly confused the LLM, leading to a minor drop in Faithfulness (-3%). Overall, Answer Relevance improved.

---

### Recommended Tools

Don't build everything from scratch. Use these libraries:

1. **Ragas**: The industry standard for RAG evaluation. Uses NLI (Natural Language Inference).
2. **TruLens**: Great visualization for the RAG Triad.
3. **DeepEval**: Allows you to run AI quality checks like unit tests (Pytest style).

---

### Conclusion: From Vibes to Metrics

"My AI seems to work" is not the language of engineering.

"Our system maintains a **Faithfulness of 0.92 and Context Relevance of 0.85**, which is a 15% improvement over our Q1 baseline." That is how you talk about production AI.

Start logging these 3 metrics today, and your path to optimization will become clear.

---

**Next:** [GPT API Bill Leak — Real Production Costs for 3 Months](/en/study/O_llmops/llm-api-cost-breakdown)
