---
title: "Local Fine-tuning: Training Models on Your Own GPU with Unsloth"
date: 2026-04-12
draft: false
tags: ["Fine-tuning", "Unsloth", "LoRA", "QLoRA", "Local-AI", "GPU-Training"]
description: "How to customize open-source models without a supercomputer. A guide to using Unsloth and LoRA for fast, efficient local training."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

Until recently, fine-tuning an LLM required an expensive cluster of A100 GPUs and a lot of patience. But in 2026, the technology has reached a point where you can fine-tune a powerful model like **Llama 3** or **Gemma 2** on a single consumer GPU (like an RTX 3090 or 4090) in just a few hours.

The secret to this performance leap is **Unsloth** and **LoRA**.

---

### What is LoRA (Low-Rank Adaptation)?

Traditional fine-tuning updates *every single weight* in a model. For a 7 billion parameter model, that's a massive amount of math. 

**LoRA** takes a different approach. Instead of updating the main model, it attaches tiny "adapter layers" to the existing weights. During training, only these tiny layers are updated.
-   **Main Model (Frozen)**: 7B parameters.
-   **LoRA Adapter (Trainable)**: ~1-50 Million parameters.

This makes training 100x faster and requires 90% less VRAM.

---

### Why Unsloth?

**Unsloth** is a library that optimizes the mathematical kernels used in LoRA training. It makes the process 2x-5x faster and uses even less memory than standard LoRA. It is currently the gold standard for local model training.

-   **Memory Efficient**: You can train a 7B model on just 16GB of VRAM.
-   **Fast**: What used to take days now takes 20-30 minutes for a standard dataset.
-   **One-Click Export**: Easily export your trained model to GGUF format to run it in Ollama instantly.

---

### The Workflow

1.  **Dataset Preparation**: Format your data as a JSON file (Instruction -> Input -> Output).
2.  **Load Base Model**: Use Unsloth to load a model (e.g., `unsloth/llama-3-8b-bnb-4bit`).
3.  **Configure LoRA**: Set your rank (`r`) and target modules.
4.  **Train**: Run the training loop.
5.  **Merge & Export**: Merge the LoRA adapters into the base model and export it as an Ollama-ready file.

---

### Summary

Local fine-tuning is no longer a luxury for big tech companies. With Unsloth and LoRA, individual developers can create specialized "Vertical AI" models that excel at specific tasks while keeping all data private and secure.

In our next session, we’ll look at how to run these models efficiently: **Model Quantization Explained (GGUF vs. EXL2).**

---

**Next Topic:** [Model Quantization: Making Big Models Fit in Small GPUs](/en/study/quantization-gguf-exl2)
