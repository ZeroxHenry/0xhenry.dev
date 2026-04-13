---
title: "Local LLMs on Raspberry Pi 5: Real-world Tokens Per Second Results"
date: 2026-04-14
draft: false
tags: ["Raspberry Pi 5", "LLM", "Ollama", "LlamaCP", "Benchmark", "EdgeAI"]
description: "Can you run a chatbot on a Raspberry Pi 5? Using the 8GB RAM model, we measured real-world speeds for Llama-3, Phi-3, and Gemma. We set the bar for practical usability."
author: "Henry"
categories: ["Edge AI"]
series: ["Edge AI & Embedded Series"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A Raspberry Pi 5 board with a small fan spinning fast. A digital speech bubble above it contains complex AI logic symbols. Dark mode #0d1117, 16:9"
    file: "images/E/rpi5-llm-speed-test-hero.png"
---

This is Part 6 of the **Edge AI & Embedded Series**.
→ Part 5: [GGUF vs EXL2 vs AWQ: Benchmarking Quantization Formats](/en/study/E_edge-ai/quantization-format-benchmark)

---

I get asked "Does an LLM run on a Raspberry Pi?" all the time. The short answer is: **"It runs, but model choice is everything."**

Today, I’m sharing real-world speed data on a Raspberry Pi 5 (8GB) using the most popular tools: **Ollama** and **llama.cpp**.

---

### 1. Test Environment

- **Hardware**: Raspberry Pi 5 (8GB RAM) + Active Cooler
- **OS**: Raspberry Pi OS (64-bit)
- **Tool**: Ollama (using GGUF format)

---

### 2. Measured Speed (Tokens per second)

| Model Name | Parameters | Speed (tok/s) | Perceived Performance |
|------------|------------|---------------|-----------------------|
| **TinyLlama** | 1.1B | 12.5 tok/s | Very fast (Real-time chat) |
| **Phi-3-Mini** | 3.8B | 3.2 tok/s | Slow (Waitable while reading) |
| **Llama-3-8B** | 8B | 1.5 tok/s | Very slow (Fails for business use) |
| **Gemma-2B** | 2B | 6.8 tok/s | Good (Suitable for simple tasks) |

---

### 3. Why is it Slow? (Memory Bandwidth Bottleneck)

While the RPi5 CPU (Cortex-A76) is excellent, it lacks the **memory bandwidth** found in desktops or dedicated NPU boards. Since LLMs must constantly read massive model files from memory, this bandwidth becomes the ultimate bottleneck.

---

### 4. Henry's Recipe for Success

If you want to use an RPi5 as an AI agent:
1. **Model**: Use **Phi-3 (3.8B)** or **Gemma (2B)** as a sweet spot between intelligence and speed.
2. **Role**: Assign single-shot tasks like **'Text Summarization'** or **'JSON Data Extraction'** instead of long reasoning.
3. **Optimization**: Turn off all background processes and dedicate resources solely to `llama.cpp`.

---

### Conclusion

The RPi5 might be insufficient as a 'personal chatbot,' but it has immense value as an **'Edge AI Agent'** performing specific commands. If you own an 8GB model, install Ollama now and try a 1.1B model. It's a surprising experience.

---

**Next:** [ROS 2 + AI Agent: Replacing Robotic Brains with LLMs](/en/study/E_edge-ai/ros2-llm-agent)
