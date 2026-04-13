---
title: "My AI Agent Got Dumber Over Time — How to Detect and Fix LLM Drift"
date: 2026-04-13
draft: false
tags: ["LLM Drift", "AI Reliability", "Agent Monitoring", "Production AI", "Observability"]
description: "Your AI agent passes all tests on day 1. By week 6, users are complaining. The model didn't change — so what happened? A complete field guide to detecting, measuring, and fixing LLM Drift in production."
author: "Henry"
categories: ["AI Engineering"]
series: ["AI Agent Reliability"]
series_order: 2
images_needed:
  - position: "hero"
    prompt: "Time series line chart showing AI agent performance degradation: X-axis 'Weeks in Production (0-12)', Y-axis 'Quality Score (%)'. Score starts at 91% week 1 and drifts down to 61% by week 12 with natural daily variance. Three labeled phases: 'Stable', 'Subtle Drift', 'Noticeable Degradation'. Dark background #0d1117, electric blue line, red danger threshold at 70%, 16:9"
    file: "images/A/llm-drift-hero.png"
  - position: "drift-types"
    prompt: "Four-panel diagram showing LLM drift types: 1.Data Drift (input distribution shift shown as two bell curves moving apart), 2.Concept Drift (same input, changing correct output shown with arrow), 3.Model Drift (same prompt, different outputs from v1 vs v2 model), 4.Context Drift (accumulated context contaminating responses). Each panel with icon and example. Dark background, 16:9"
    file: "images/A/llm-drift-types.png"
  - position: "monitoring"
    prompt: "LLM Drift monitoring dashboard mockup: Top row - 3 KPI gauges (Quality Score 71%, Instruction Compliance 68%, Response Consistency 74%, all in yellow warning zone). Middle - time series showing drift trend per metric. Bottom - alert log showing 'DRIFT DETECTED: instruction_compliance < 0.70 for 48h'. Dark background, monitoring tool aesthetic, 16:9"
    file: "images/A/llm-drift-monitoring.png"
---

Six weeks after deploying our AI customer support agent, tickets started coming in.

"The bot gave me completely wrong information about the return policy."
"It answered in English even though I wrote in Korean."
"It recommended a product we discontinued last month."

I checked the logs. The prompts hadn't changed. The model hadn't changed. All systems showed green.

The agent had drifted.

---

### What is LLM Drift?

LLM Drift is the gradual degradation of an AI system's output quality or behavioral consistency over time — without any single identifiable breaking change.

It's insidious because:
- No single deployment caused it
- Individual test cases still pass
- The model itself hasn't changed
- The degradation is slow enough to miss in normal monitoring

There are four types, and they often occur simultaneously.

**1. Data Drift** — The distribution of real user inputs shifts away from what the system was designed for.

Your RAG pipeline was optimized for formal business queries. Users start asking in slang, abbreviations, voice-to-text transcriptions. Retrieval quality drops silently.

**2. Concept Drift** — The real-world meaning of inputs changes, making historically correct outputs wrong.

"What's our latest model?" had a correct answer in January. By April, the answer has changed — but your knowledge base hasn't been updated.

**3. Model Drift** — The LLM provider silently updates the underlying model.

OpenAI, Anthropic, and Google regularly update models behind the same API endpoint. `gpt-4o` today is not identical to `gpt-4o` three months ago. Your carefully tuned prompts may be subtly misaligned.

**4. Context Drift** — Accumulated conversation history and retrieved noise gradually degrades per-session quality.

We covered this in [Context Rot](/en/study/C_context-memory/context-rot-lost-in-middle). It's the most common cause of "the agent got dumber after long conversations."

---

### The Measurement Problem

Standard uptime monitoring won't catch drift. HTTP 200 ≠ correct answer.

You need **behavioral metrics** tracked over time:

```python
from dataclasses import dataclass
from datetime import datetime
import statistics

@dataclass
class DriftMetrics:
    timestamp: datetime
    quality_score: float          # 0-1: evaluator model score
    instruction_compliance: float  # 0-1: did it follow system prompt rules?
    response_consistency: float    # 0-1: same Q → similar A across runs
    factual_accuracy: float        # 0-1: spot-check against ground truth
    
class DriftMonitor:
    def __init__(self, window_days: int = 7):
        self.window_days = window_days
        self.history: list[DriftMetrics] = []
    
    def record(self, metrics: DriftMetrics):
        self.history.append(metrics)
        self._check_drift()
    
    def _check_drift(self):
        if len(self.history) < 14:  # Need at least 2 weeks of data
            return
        
        recent = [m.quality_score for m in self.history[-7:]]
        baseline = [m.quality_score for m in self.history[-14:-7]]
        
        drift_magnitude = statistics.mean(baseline) - statistics.mean(recent)
        
        if drift_magnitude > 0.05:  # >5 percentage point drop
            self._alert(f"DRIFT DETECTED: quality dropped {drift_magnitude:.1%} over 7 days")
    
    def _alert(self, message: str):
        # PagerDuty, Slack, etc.
        print(f"🚨 {message}")
```

---

### Building a Drift Detection Pipeline

The key is an **automated evaluation loop** running continuously against a fixed golden dataset.

```python
class DriftDetectionPipeline:
    def __init__(self, agent, evaluator_llm, golden_dataset: list[dict]):
        self.agent = agent
        self.evaluator = evaluator_llm
        self.golden_dataset = golden_dataset  # [{question, expected_answer, tags}]
        self.monitor = DriftMonitor()
    
    def run_evaluation(self) -> DriftMetrics:
        """Run the full golden dataset through the agent and score it."""
        scores = []
        compliance_scores = []
        
        for example in self.golden_dataset:
            response = self.agent.chat(example["question"])
            
            # LLM-as-judge evaluation
            eval_result = self.evaluator.evaluate(
                question=example["question"],
                expected=example["expected_answer"],
                actual=response,
                rubric=EVALUATION_RUBRIC
            )
            
            scores.append(eval_result.quality)
            compliance_scores.append(
                self._check_compliance(response, example.get("rules", []))
            )
        
        metrics = DriftMetrics(
            timestamp=datetime.now(),
            quality_score=statistics.mean(scores),
            instruction_compliance=statistics.mean(compliance_scores),
            response_consistency=self._measure_consistency(),
            factual_accuracy=self._spot_check_facts()
        )
        
        self.monitor.record(metrics)
        return metrics
    
    def _check_compliance(self, response: str, rules: list[str]) -> float:
        """Check if response follows specific rules (e.g., 'never mention competitors')."""
        violations = 0
        for rule in rules:
            if self.evaluator.check_violation(response, rule):
                violations += 1
        return 1.0 - (violations / max(len(rules), 1))
    
    def _measure_consistency(self) -> float:
        """Run same question 3 times, measure semantic similarity across answers."""
        test_q = "What is your refund policy?"
        responses = [self.agent.chat(test_q) for _ in range(3)]
        
        # Embed and measure pairwise cosine similarity
        embeddings = [embed(r) for r in responses]
        similarities = [
            cosine_similarity(embeddings[i], embeddings[j])
            for i in range(3) for j in range(i+1, 3)
        ]
        return statistics.mean(similarities)
```

---

### Root Cause Diagnosis: Which Drift Type Is It?

When drift is detected, you need to know *why* before you can fix it.

```python
class DriftDiagnostics:
    
    def diagnose(self, agent, monitor: DriftMonitor) -> dict:
        results = {}
        
        # Test 1: Model drift — Does a frozen prompt produce different outputs?
        results["model_drift"] = self._test_model_drift(agent)
        
        # Test 2: Data drift — Has input distribution shifted?
        results["data_drift"] = self._test_data_drift(agent)
        
        # Test 3: Context drift — Does quality degrade within a single long session?
        results["context_drift"] = self._test_context_drift(agent)
        
        return results
    
    def _test_model_drift(self, agent) -> dict:
        """
        Compare current outputs against outputs recorded when system was healthy.
        Uses semantic similarity — same meaning, possibly different words = OK.
        Significantly different meaning = model drift.
        """
        FROZEN_TEST_CASES = load_baseline_responses()  # Saved at system launch
        
        current_responses = [agent.chat(tc["question"]) for tc in FROZEN_TEST_CASES]
        baseline_responses = [tc["baseline_response"] for tc in FROZEN_TEST_CASES]
        
        similarities = [
            semantic_similarity(curr, base) 
            for curr, base in zip(current_responses, baseline_responses)
        ]
        
        avg_similarity = statistics.mean(similarities)
        return {
            "detected": avg_similarity < 0.80,
            "similarity_score": avg_similarity,
            "recommendation": "Pin model version with 'model': 'gpt-4o-2024-11-20'" if avg_similarity < 0.80 else "OK"
        }
    
    def _test_context_drift(self, agent) -> dict:
        """Context Rot check: compare turn-1 quality vs turn-15 quality."""
        STANDARD_QUESTION = "What are your business hours?"  # Simple, stable answer
        
        # Fresh session
        fresh_response = agent.chat(STANDARD_QUESTION, history=[])
        fresh_score = evaluate_quality(fresh_response)
        
        # Long session (simulate 15 turns of noise)
        noisy_history = generate_filler_turns(15)
        long_response = agent.chat(STANDARD_QUESTION, history=noisy_history)
        long_score = evaluate_quality(long_response)
        
        degradation = fresh_score - long_score
        return {
            "detected": degradation > 0.10,
            "degradation": degradation,
            "recommendation": "Apply Context Engineering patterns (rolling summary, re-injection)" if degradation > 0.10 else "OK"
        }
```

---

### Fixes by Drift Type

| Drift Type | Diagnosis Signal | Fix |
|------------|-----------------|-----|
| **Model Drift** | Frozen prompts produce semantically different outputs | Pin model version: `gpt-4o-2024-11-20` |
| **Data Drift** | Retrieval precision drops, user queries don't match indexed content | Re-chunk and re-embed knowledge base quarterly |
| **Concept Drift** | Factual accuracy drops on time-sensitive topics | Implement knowledge freshness scoring + scheduled updates |
| **Context Drift** | Quality degrades in long sessions only | Apply Rolling Summary + Re-injection patterns |

---

### Pinning Model Versions (The Simplest Win)

If you're not doing this already, do it today.

```python
# ❌ Bad: Silent updates break your system
client.chat.completions.create(
    model="gpt-4o",  # Which version? No one knows.
    messages=messages
)

# ✅ Good: Explicit version — you control updates
client.chat.completions.create(
    model="gpt-4o-2024-11-20",  # Known, tested, stable
    messages=messages
)

# Upgrade process:
# 1. New version released (gpt-4o-2025-03-15)
# 2. Run golden dataset evaluation on new version
# 3. If quality >= current version: schedule upgrade
# 4. Deploy during low-traffic window
# 5. Monitor for 48h before fully switching
```

---

### Setting Up Alerts

Drift detection is useless without alerting.

```python
DRIFT_THRESHOLDS = {
    "quality_score":           {"warning": 0.75, "critical": 0.65},
    "instruction_compliance":  {"warning": 0.80, "critical": 0.70},
    "response_consistency":    {"warning": 0.75, "critical": 0.65},
    "factual_accuracy":        {"warning": 0.85, "critical": 0.75},
}

def evaluate_alerts(metrics: DriftMetrics) -> list[str]:
    alerts = []
    for metric_name, thresholds in DRIFT_THRESHOLDS.items():
        value = getattr(metrics, metric_name)
        if value < thresholds["critical"]:
            alerts.append(f"🔴 CRITICAL: {metric_name} = {value:.2%} (threshold: {thresholds['critical']:.0%})")
        elif value < thresholds["warning"]:
            alerts.append(f"🟡 WARNING: {metric_name} = {value:.2%}")
    return alerts
```

---

### Conclusion

Drift is silent, gradual, and expensive. It makes users distrust your AI — and once they do, it's very hard to win them back.

The fix isn't complicated. Three things:

1. **Measure behavior, not just uptime** — quality scores, instruction compliance, consistency
2. **Compare against a frozen baseline** — always know what "good" looked like at launch
3. **Pin model versions** — don't let silent updates break you

Your AI system's reliability is only as good as your ability to detect when it's degrading.

---

**Previous:** [Why Your AI Agent Sent the Email Twice — Idempotency Design](/en/study/A_agent-reliability/agent-idempotency)
**Next:** [Agent Rollback with Saga Pattern — Undo in Distributed AI Systems](/en/study/A_agent-reliability/agent-saga-rollback)
