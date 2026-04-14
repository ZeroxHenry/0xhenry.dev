---
title: "Model Quantization: Making Big Models Fit in Small GPUs"
date: 2026-04-12
draft: false
tags: ["Quantization", "GGUF", "EXL2", "Ollama", "Large-Language-Models", "Inference-Optimization"]
description: "How to run 70B models on a home computer. Comparing the two most popular quantization formats for local AI."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

Modern LLMs are huge. A standard Llama 3 70B model requires about 140GB of VRAM just to load if you use full precision (FP16). Most home GPUs only have 8GB to 24GB. How do we close this gap?

The answer is **Quantization**. By reducing the precision of the model's numbers (from 16-bit down to 8, 4, or even 2-bit), we can shrink a model to fit on consumer hardware with surprisingly little loss in "intelligence."

---

### The Two Kings: GGUF and EXL2

In the local AI world, two formats dominate the inference space. Choosing between them depends on your hardware and your goals.

#### 1. GGUF (The Universal Choice)
Created by the developer of `llama.cpp` (Georgi Gerganov), GGUF is designed for **flexibility**.

-   **Works everywhere**: Can run on CPU, GPU, or a mix of both (offloading).
-   **No GPU? No Problem**: If your model is too big for your VRAM, GGUF will simply use your system RAM (though it will be slower).
-   **Standard**: It is the format used by Ollama, LM Studio, and Faraday.

#### 2. EXL2 (The Performance Choice)
Based on the ExLlamaV2 loader, EXL2 is designed for **pure GPU speed**.

-   **VRAM Only**: Must fit entirely within your GPU memory.
-   **Blazing Fast**: Offers the highest tokens-per-second (TPS) for local NVIDIA cards.
-   **Variable Bitrate**: Allows you to quantize at exactly 4.65-bit or 5.0-bit to perfectly fill your specific VRAM limit.

---

### Which one should you use?

-   **Use GGUF if**:
    -   You have an Apple Silicon Mac (M1/M2/M3).
    -   You want to use Ollama for its secondary features (API, server management).
    -   Your model is slightly larger than your VRAM.
-   **Use EXL2 if**:
    -   You have one or more NVIDIA RTX cards (3090/4090).
    -   You want the absolute fastest chat experience.
    -   Speed is more important than universal compatibility.

---

### Summary

Quantization is the "Magic" of local AI. It takes a model meant for a data center and makes it run on a laptop. While you lose a tiny bit of nuanced reasoning (perplexity), the trade-off for speed and accessibility is almost always worth it.

In our next session, we’ll move from local chat to local deployment: **Deploying Private AI with vLLM.**

---

**Next Topic:** [vLLM: High-Throughput Model Serving for Private AI](/en/study/vllm-deployment)
