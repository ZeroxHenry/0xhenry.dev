---
title: "Sandwich Architecture: Designing with LLMs without Depending on Them"
date: 2026-04-14
draft: false
tags: ["Sandwich Architecture", "Software Design", "LLM", "Agent", "Reliability", "AI Architecture"]
description: "LLMs are unpredictable. We dive into 'Sandwich Architecture,' a setup that avoids placing this uncertainty at the core of a service and instead ensures stability by sandwiching it between traditional logic."
author: "Henry"
categories: ["Career & Perspective"]
series: ["Career & Perspective Series"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A sandwich where the top and bottom buns are solid steel (Traditional Code), and the filling is a glowing, fluid plasma (The LLM). The plasma is contained perfectly. Dark mode #0d1117, 16:9"
    file: "images/P/sandwich-architecture-llm-hero.png"
---

This is Part 6 of the **Career & Perspective Series**.
→ Part 5: [Why I Chose RAG Over Fine-tuning — A Real Decision-Making Process](/en/study/P_career/why-i-chose-rag-not-finetuning)

---

The scariest moment when building an LLM agent service is "when the model answers differently than usual and breaks the entire system." If the model provider updates or a prompt gets slightly tangled, the results can be disastrous.

Modern **Sandwich Architecture** is the best design to defend against this.

---

### 1. The Top and Bottom: Deterministic Code

Don't leave everything to the model.
- **Top Layer (Pre-processing)**: This stage receives and filters user input to verify if it’s a permitted action. Use `if` statements and regular expressions here, not an LLM.
- **Bottom Layer (Post-processing)**: This mechanically validates the LLM's output. Does it match the JSON format? Does it contain forbidden words? Is the ID one that actually exists in the DB? These are checked with traditional code.

---

### 2. The Core: Probabilistic Reasoning (The LLM)

Between the solid buns (traditional logic) at the top and bottom, the LLM focuses solely on its primary mission: **Reasoning and Transformation.** Within a sandwich architecture, the LLM is free to think, but it is protected so its results don't destroy the entire system.

---

### 3. Why is this Sustainable?

This structure makes **'Model Swapping'** easy. Because the buns (traditional logic) remain constant, the system's stability is maintained even if the sauce (the LLM filling) changes from GPT to Claude.

---

### Henry's Advice: "Don't Trust AI; Trust Structure"

Perfect prompts don't exist. But perfect **'defensive designs'** do. Don't float your service purely on the liquid of an LLM. Securely sandwich it between the solid supports of traditional engineering.

---

**Next:** [Anatomy of an AI Startup Codebase — How the Structure is Actually Built](/en/study/P_career/ai-startup-codebase-anatomy)
