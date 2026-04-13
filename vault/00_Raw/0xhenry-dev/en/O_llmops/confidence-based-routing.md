---
title: "Confidence-Based Routing — Mixing Small and Large Models Dynamically"
date: 2026-04-14
draft: false
tags: ["LLMOps", "Model Routing", "Cost Optimization", "GPT-4o", "GPT-4o-mini", "ConfidenceScore"]
description: "Why use expensive GPT-4o for every question? We introduce intelligent routing techniques where the AI decides to send easy tasks to cheap models and hard ones to premium ones."
author: "Henry"
categories: ["LLMOps"]
series: ["LLMOps in Production"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A futuristic traffic controller AI directing data packets. Simple packets are sent to a small, fast drone (Mini model), while complex holographic gears are sent to a massive supercomputer (Pro model). Dark mode #0d1117, neon blue and gold, 16:9"
    file: "images/O/confidence-based-routing-hero.png"
  - position: "chart"
    prompt: "Distribution chart: 80% tasks solved by Mini ($), 20% tasks solved by Pro ($$$). Showing total cost reduction. 16:9"
    file: "images/O/confidence-routing-savings.png"
---

This is Part 6 of the **LLMOps in Production** series.
→ Part 5: [Validating LLM Performance in Shadow — The Silent Test Pattern](/en/study/O_llmops/llm-shadow-testing)

---

We are greedy. We want the best performance (GPT-4o, Claude 3.5) while paying the lowest price (GPT-4o-mini, Llama 3). 

The solution to this contradiction is **Confidence-Based Routing**. It's the automation of a very common-sense approach: "Only assign hard jobs to the smart model."

---

### Why Routing Matters?

Research shows that about **70-80% of production requests can be solved by small models (Mini)**. Yet, because of the 20% of complex queries, we often use expensive models for everything. 

Implementing a routing system can maintain performance while **cutting costs by over 50%**.

---

### 3 Strategies for Implementation

#### Strategy 1: Logprobs-based Confidence
Let the small model try first, but check the probability (Logprobs) of each generated token. If the model isn't sure (low probability), immediately hand the task over to the large model.

#### Strategy 2: Pre-positioned Classifier
As soon as a query arrives, pass it through a lightweight classifier (like BERT or a small finetuned model) to judge task difficulty.
- "Hello?" → **EASY** (Route to Mini)
- "Compare and summarize 3 recent quantum mechanics papers" → **HARD** (Route to Pro)

#### Strategy 3: Self-Correction Loop
Let the small model generate an answer, then ask it to evaluate itself: "Did I answer this perfectly?" If it says "No," the large model steps in as a relief pitcher.

---

### Code Example: Hybrid Routing Pipeline

```python
async def smart_route_request(user_input):
    # 1. Try with the small model
    initial_output = await mini_model.generate(user_input, logprobs=True)
    
    # 2. Check confidence (e.g., Fail if mean logprob < 0.85)
    if initial_output.confidence_score < 0.85:
        print("Routing to Pro Model...")
        # 3. Re-request with the large model
        return await pro_model.generate(user_input)
    
    return initial_output.text
```

---

### The Latency Trap: What to Watch Out For

Routing saves money, but **it doubles latency in failure cases** (Small model attempt + Large model attempt). 

Tuning is essential:
1. **Classification Accuracy**: Minimize cases where the small model *thinks* it can solve something when it actually can't (False Positives).
2. **Stream Switching**: If a small model starts streaming with low confidence, cut it immediately and switch to the large model's stream for a seamless UI experience.

---

### Henry's Conclusion

The smartest agent isn't the one with all the knowledge, but the one that knows how to say, **"This is too heavy for me,"** and picks the right tool (or model). 

If you want to protect your wallet, don't let every request lead with a heavy-hitter; check the opponent's weight class first.

---

**Next:** [How LLM Version Updates Break Production — Handling Model Drift](/en/study/O_llmops/llm-version-drift-production)
