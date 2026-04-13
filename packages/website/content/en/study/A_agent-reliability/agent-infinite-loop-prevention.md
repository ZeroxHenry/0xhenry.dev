---
title: "Infinite Loops in AI Agents — Designing for Cost Bomb Defusal"
date: 2026-04-13
draft: false
tags: ["AI Agents", "Cost Optimization", "Infinite Loop", "Agent Security", "Error Handling", "LLM"]
description: "What happens if your autonomous agent gets stuck in a loop and burns through your API budget in minutes? We introduce a 3-tier safety design to prevent 'Cost Bombs' in production."
author: "Henry"
categories: ["Agent Reliability"]
series: ["Agent Reliability Series"]
series_order: 5
images_needed:
  - position: "hero"
    prompt: "A robotic hand reaching for a red 'EMERGENCY STOP' button while entangled in a coil of digital film loops. Money bills are burning in the background. Dark background #0d1117, alarming red and yellow, 16:9"
    file: "images/A/agent-infinite-loop-prevention-hero.png"
  - position: "layers"
    prompt: "Security layers diagram: 1. Max Iterations, 2. Token Budget, 3. Loop Detection. Clean, futuristic UI style, 16:9"
    file: "images/A/agent-loop-prevention-layers.png"
---

This is Part 5 of the **Agent Reliability Series**.
→ Part 4: [The AI That Insists It Succeeded — The Truthy Text Problem](/en/study/A_agent-reliability/agent-truthy-text-failure)

---

My worst nightmare as a developer of autonomous agents happened shortly after I started: an agent got stuck in an **infinite loop** while I was asleep.

- Agent: "I can't read this file. Let me try again." (Calls tool)
- System: "File not found." (Returns error)
- Agent: "Oh? Let me try again." (Calls tool)
- ... (Repeated 1,000 times) ...

When I woke up, my inbox was flooded with API billing alerts—I had spent $500 in one night. 

Giving an agent autonomy means giving it the **"Authority to spend money."** Today, I'll share a 3-tier safety design to defuse these 'Cost Bombs.'

---

### Tier 1: The Iteration Hard-Limit

Simple, but the most powerful fail-safe. Cut off the agent regardless of what is happening in the loop.

```python
class AgentRunner:
    def run(self, task, max_steps=10):
        current_step = 0
        while current_step < max_steps:
            action = self.agent.decide(task)
            if action.is_final():
                return action.result
            
            self.execute_tool(action)
            current_step += 1
            
        return "ERROR: Max steps exceeded. Termination triggered."
```

In production, a limit of **5 to 8 steps** is usually safe. If it goes beyond that, the agent is likely lost.

---

### Tier 2: The Token Budget Manager

Don't just count steps; track the **cumulative token usage** for a single request. For agents with long contexts, the cost per call increases exponentially as the history grows.

```python
# Terminate if a single session costs more than $1.00
if current_session_cost > 1.00: 
    terminate_agent("Budget Exceeded")
```

---

### Tier 3: Semantic Loop Detection (Thought & Action)

A more intelligent guardrail that detects if the agent is repeating the same *intent*. Store the last 3 "Thoughts/Actions" and check their **semantic similarity**. If the agent tries to "Open file" three times in a row with the same arguments, intervene immediately.

```python
def check_for_loops(history):
    latest_action = history[-1]
    # Check if the same action appeared in 3 of the last 5 steps
    repeated_count = sum(1 for h in history[-5:] if h == latest_action)
    
    if repeated_count >= 3:
        return "LOOP_DETECTED: Stop repeating yourself. Try a new strategy."
```

---

### Henry's Take: The 'Right to Give Up'

We want agents to finish every task. But a reliable system is one that knows how to say: **"I've tried, but I'm stuck. I'm stopping here to ask for help."**

- **Self-Correction**: After 3 failures, inject a warning into the prompt: "You are repeating the same mistake. Change your approach."
- **Human-in-the-Loop**: After 5 failures, pause execution and wait for human approval before proceeding.

---

### Conclusion

An infinite loop isn't just a bug; it's a significant business risk. Don't leave an agent unattended without **Max Iterations, Token Budgets, and Loop Detection**.

---

**Next:** [Agent Tracing — How to Debug Complex Multi-Step Failures](/en/study/A_agent-reliability/agent-distributed-tracing)
