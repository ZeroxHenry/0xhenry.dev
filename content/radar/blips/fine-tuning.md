---
title: "Fine-tuning LLMs"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Assess"
quadrant: "AI & ML"
moved: -1
description: "Expensive and usually unnecessary. RAG + prompt engineering handles most use cases."
---

## What is it?

Fine-tuning adapts a pre-trained language model to your specific domain by training it on your data. This can mean full fine-tuning (updating all model weights), LoRA (low-rank adaptation of specific layers), or distillation (training a smaller model to mimic a larger one). The goal is better performance on your specific task than prompting alone can achieve.

## Why does it matter?

When RAG and prompt engineering aren't enough — when the model needs to learn a specific output format, adopt a particular reasoning style, or handle domain-specific terminology consistently — fine-tuning is the next tool in the arsenal. It can also reduce inference costs by teaching a smaller model to perform tasks that otherwise require a larger, more expensive model.

## Trade-offs

**Strengths:**
- Can achieve higher quality than prompting alone for specific tasks
- Smaller fine-tuned models can replace larger general models (cost savings)
- Teaches consistent output formats and domain-specific behavior
- LoRA makes fine-tuning accessible with modest GPU resources

**Limitations:**
- Requires high-quality training data (garbage in, garbage out amplified)
- Training costs are significant (compute time, data preparation, iteration)
- Risk of catastrophic forgetting (model loses general capabilities)
- Evaluation is difficult — how do you measure "better" for open-ended generation?
- Model updates from providers invalidate your fine-tuned weights

## Our take

Fine-tuning moved down to **Assess** because we've seen too many teams jump to it prematurely. The decision tree should be: (1) try better prompting, (2) try RAG, (3) try few-shot examples, (4) only then consider fine-tuning. In our experience, 80% of "we need to fine-tune" cases are actually "we need better retrieval" cases. Reserve fine-tuning for when you have clear evidence that the base model can't learn your task from prompting and you have a robust evaluation pipeline to measure improvement.
