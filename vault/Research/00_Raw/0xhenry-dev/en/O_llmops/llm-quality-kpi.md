---
title: "HTTP 200 But Your Business Is Broken — Designing AI Quality KPIs"
date: 2026-04-13
draft: false
tags: ["LLMOps", "AI Quality", "KPI Design", "Production AI", "Monitoring", "Observability"]
description: "The API returned 200. Logs were clean. Latency was fine. Then customers started leaving. How 'technical success' and 'business success' become completely different things in AI systems, and how to measure what actually matters."
author: "Henry"
categories: ["LLMOps"]
series: ["LLMOps in Production"]
series_order: 1
images_needed:
  - position: "hero"
    prompt: "Split screen dashboard: LEFT 'System Health' shows all green metrics - HTTP 200, Error Rate 0%, Latency 1.2s, Uptime 99.9%. RIGHT 'Business Health' shows red declining charts: User Satisfaction 61% declining, Task Completion 54% declining, Churn +23% increasing. Big gap between the two screens with question mark. Dark background #0d1117, green vs red contrast, dramatic impact, 16:9"
    file: "images/O/llm-quality-kpi-hero.png"
  - position: "kpi-layers"
    prompt: "Three-tier pyramid: Base (gray) 'Technical KPIs' - latency, uptime, error rate. Middle (blue) 'AI Quality KPIs' - faithfulness, relevance, instruction compliance. Peak (gold) 'Business KPIs' - task completion, satisfaction, revenue. Red arrow from base labeled 'Green ≠ Success' pointing up to broken chain before business tier. Dark background, pyramid diagram, 16:9"
    file: "images/O/llm-quality-kpi-pyramid.png"
  - position: "dashboard"
    prompt: "AI Quality monitoring dashboard mockup: 2x2 grid of metric cards. Card 1 Faithfulness 0.91 (green stable sparkline). Card 2 Instruction Compliance 0.71 (orange declining arrow). Card 3 Task Completion 54% (red alert). Card 4 User Satisfaction 3.2/5 (yellow declining). Dark background, monitoring tool aesthetic, 16:9"
    file: "images/O/llm-quality-kpi-dashboard.png"
---

The morning after deployment, there were no Slack alerts.

Datadog: green. CloudWatch: green. Error rate: 0.0%. Average response time: 1.3 seconds. Perfect.

Then CS messaged: "Customer churn spiked overnight."

I checked the logs again. Still green.

---

### The Gap Between Technical and Business Success

AI systems have a failure mode that other software doesn't.

**Technically healthy, but producing terrible output.**

HTTP 200 means the server successfully returned a response. It does not mean the AI gave a useful answer. 1.3-second latency means it's fast. It does not mean the response was factually accurate.

Our system was technically perfect while telling customers "refunds are not possible" — against explicit instructions that said refunds were allowed within 7 days — hundreds of times a day.

All returning HTTP 200.

---

### The 3-Layer AI Quality KPI Framework

AI system KPIs need three distinct layers:

```
Layer 3 (Business):   Task completion, user satisfaction, churn, revenue impact
                      ↑  This is what you're trying to optimize
Layer 2 (AI Quality): Faithfulness, relevance, instruction compliance, consistency
                      ↑  This determines Layer 3
Layer 1 (Technical):  API latency, uptime, error rate, throughput
                      ↑  Necessary condition — not sufficient
```

**The classic DevOps mistake**: Monitor only Layer 1. Assume green Layer 1 = healthy system.

**The LLMOps reality**: Layer 1 can be green while Layers 2-3 are red — silently damaging your business.

---

### Layer 2: Designing AI Quality KPIs

#### 1. Faithfulness

Does the AI's response actually come from the provided context? Or is it making things up?

```python
def measure_faithfulness(
    context: str,       # Documents the AI was given
    response: str,      # AI's actual response
    evaluator_llm       # Evaluation LLM (different from production LLM)
) -> float:
    
    prompt = f"""
    Compare the following context and AI response.
    
    Context:
    {context}
    
    AI Response:
    {response}
    
    Evaluate: What fraction of claims in the AI response are supported by the context?
    Return 0-1 score as JSON: {{"faithfulness": 0.xx, "unsupported_claims": ["..."]}}
    """
    
    result = evaluator_llm.complete(prompt)
    return result["faithfulness"]

# Thresholds:
# faithfulness < 0.85 → Warning alert
# faithfulness < 0.70 → Critical alert (hallucination risk)
```

#### 2. Instruction Compliance

Is the AI following the rules defined in the system prompt?

```python
COMPLIANCE_RULES = [
    {
        "rule": "Inform users that refunds are only available within 7 days of purchase",
        "test_query": "I bought something 10 days ago, can I get a refund?",
        "expected_behavior": "Politely decline and explain 7-day policy",
        "violation_signal": "refund is possible",
    },
    {
        "rule": "Do not mention or compare competitor products",
        "test_query": "How do you compare to [CompetitorX]?",
        "expected_behavior": "Decline comparison, focus on own products",
        "violation_signal": "CompetitorX",
    },
]

def daily_compliance_check(agent) -> dict:
    violations = []
    
    for rule in COMPLIANCE_RULES:
        response = agent.chat(rule["test_query"])
        violated = rule["violation_signal"].lower() in response.lower()
        
        if violated:
            violations.append({
                "rule": rule["rule"],
                "response": response,
                "severity": "HIGH"
            })
    
    compliance_rate = 1.0 - (len(violations) / len(COMPLIANCE_RULES))
    return {
        "compliance_rate": compliance_rate,
        "violations": violations,
        "alert": compliance_rate < 0.90
    }
```

#### 3. Answer Relevance

Did the AI actually address the user's question? Or did it pad the response with irrelevant filler?

```python
def measure_relevance(question: str, response: str, embedder) -> float:
    """
    Embedding similarity between question and response.
    High relevance: AI directly addressed the question.
    Low relevance: AI went off-topic or ignored the question.
    """
    q_embedding = embedder.embed(question)
    r_embedding = embedder.embed(response)
    return cosine_similarity(q_embedding, r_embedding)

# Note: Supplement with LLM-as-judge for nuanced cases.
# "I don't know" may have low similarity but is a *correct* response for
# out-of-scope questions.
```

#### 4. Response Consistency

Does the AI give consistent answers to the same question across sessions and time?

```python
def measure_consistency(agent, test_question: str, n_runs: int = 5) -> float:
    """Ask the same question n times, measure semantic similarity across answers."""
    responses = [agent.chat(test_question) for _ in range(n_runs)]
    embeddings = [embed(r) for r in responses]
    
    pairs = [(i, j) for i in range(n_runs) for j in range(i+1, n_runs)]
    similarities = [cosine_similarity(embeddings[i], embeddings[j]) for i, j in pairs]
    
    return statistics.mean(similarities)
    # Threshold: < 0.80 → Model is producing inconsistent outputs
```

---

### Production Monitoring Pipeline

Evaluating every production request in real-time creates cost and latency overhead. **Sampling is key.**

```python
import random
from functools import wraps

class AIQualityMonitor:
    def __init__(self, evaluator_llm, sample_rate: float = 0.05):
        self.evaluator = evaluator_llm
        self.sample_rate = sample_rate  # Evaluate 5% of requests
        self.metrics_store = MetricsStore()
    
    def monitor(self, agent_func):
        """Decorator: wrap any AI function with quality monitoring."""
        @wraps(agent_func)
        def wrapper(query: str, context: str = "", **kwargs):
            response = agent_func(query, context, **kwargs)
            
            # Sampling: only ~5% of requests are evaluated (cost control)
            if random.random() < self.sample_rate:
                self._evaluate_async(query, context, response)
            
            return response
        return wrapper
    
    def _evaluate_async(self, query: str, context: str, response: str):
        """Async evaluation — zero added latency for users."""
        import threading
        def evaluate():
            scores = {
                "faithfulness": measure_faithfulness(context, response, self.evaluator),
                "relevance": measure_relevance(query, response, embedder),
                "timestamp": datetime.now().isoformat()
            }
            self.metrics_store.write(scores)
            
            if scores["faithfulness"] < 0.70:
                send_alert(f"🔴 CRITICAL faithfulness: {scores['faithfulness']:.2f}")
        
        threading.Thread(target=evaluate, daemon=True).start()

# Usage
@monitor.monitor
def my_rag_agent(query: str, context: str) -> str:
    return llm.complete(build_prompt(query, context))
```

---

### Layer 3: Business KPI Connection

Track how AI quality metrics connect to business outcomes.

```python
BUSINESS_METRICS = {
    "task_completion_rate": {
        "definition": "% of users who accomplished their goal through the AI conversation",
        "measurement": "Post-session outcome tracking: no follow-up CS ticket, transaction completed",
        "target": 0.75,
    },
    "escalation_rate": {
        "definition": "% of conversations escalated to human agents",
        "measurement": "Count of sessions transferred to human support / total sessions",
        "target": 0.10,  # Below 10%
        "inverse": True
    },
    "user_satisfaction_score": {
        "definition": "Post-conversation rating (1-5 stars or thumbs up/down)",
        "measurement": "Opt-in feedback, minimum 15% response rate for statistical validity",
        "target": 4.0,
    },
}
```

---

### Sample Dashboard Layout

What to check every morning:

```
┌──────────────────────────────────────────────────────────┐
│            AI Quality Dashboard  (2026-04-13)            │
├──────────────┬───────────────┬───────────────────────────┤
│  Technical   │   AI Quality  │  Business                  │
├──────────────┼───────────────┼───────────────────────────┤
│ Uptime 99.9% │ Faithf.  0.91 │ Task Completion  71% ⚠️   │
│ Latency  1.2s│ Complian.0.87 │ Escalation Rate   8% ✅   │
│ Errors   0.0%│ Relevanc.0.89 │ Satisfaction  4.1/5 ✅    │
│              │ Consiste.0.84 │ Churn Rate    2.3%  ✅    │
└──────────────┴───────────────┴───────────────────────────┘
                                  ↑
                       Task Completion 71% is below target (75%).
                       But AI Quality metrics look healthy.
                       Root cause: user intent mismatch, not AI failure.
                       → Investigate query understanding pipeline.
```

---

### Conclusion: The New Standard for AI Monitoring

In traditional software, HTTP 200 is success.

In AI systems, HTTP 200 is the starting point. After that, you still need to answer:

- Did the AI respond based on factual, provided information?
- Did the AI follow its defined rules?
- Did the user get what they actually needed?

Without measuring these three things, your system can run flawlessly — technically — while quietly dismantling your business.

---

**Next:** [Groundedness, Faithfulness, Relevance — RAG Evaluation Metrics in Practice](/en/study/O_llmops/rag-evaluation-metrics)
