---
title: "Why Your AI Agent Sent the Email Twice — Idempotency Design for Agents"
date: 2026-04-13
draft: false
tags: ["AI Agents", "Idempotency", "Agent Design", "Distributed Systems", "AI Architecture"]
description: "AI agents automatically retry on failure. Without idempotency design, the same email gets sent twice, the same payment gets processed twice. Here's how to prevent it — with real code patterns."
author: "Henry"
categories: ["AI Engineering"]
---

This actually happened.

I built a system where an AI agent automatically sent quote emails to customers. It worked perfectly in testing. On launch day, a single network timeout occurred — and the agent judged that the action had "failed" and sent the email again.

Result: One customer received the same quote three times.

This isn't a minor inconvenience. What if it wasn't an email, but a payment request? A contract signing?

The name for this problem is **Idempotency**. And in the age of AI agents, this concept has never been more important.

![AI Agent Idempotency Design Guide](/images/study/A_agent-reliability/idempotency-guide.png)

---

### What is Idempotency?

In mathematics, idempotency means "a property where applying the same operation multiple times produces the same result as applying it once."

```
f(f(x)) = f(x)  ← Same result no matter how many times you run it
```

In software, we express it this way:

> **Executing the same request multiple times should produce the same result as executing it once.**

For example:

```python
# NOT idempotent (dangerous)
def send_email(customer_id: str, content: str):
    email = get_email(customer_id)
    send(email, content)  # Every call sends one more email

# Idempotent (safe)
def send_email_idempotent(customer_id: str, content: str, idempotency_key: str):
    if already_sent(idempotency_key):
        return {"status": "already_sent"}  # Already sent — just return success
    
    email = get_email(customer_id)
    send(email, content)
    mark_as_sent(idempotency_key)
    return {"status": "sent"}
```

---

### Why Is This Especially Dangerous for AI Agents?

With a regular API, a human explicitly clicks "Resend." AI agents are different.

AI agents **automatically retry** in these situations:
1. When a network timeout occurs
2. When the response to a tool call is ambiguous ("Not sure if it succeeded — let me try again")
3. In multi-agent systems, when two agents perform the same task simultaneously
4. When an agent is force-killed mid-task and then restarted

AI doesn't perfectly remember and track "what it just did." If a network response is slightly slow, it may confuse "did this succeed?" with "have I done this yet?"

---

### Three Real-World Risk Scenarios

#### Scenario 1: Double Payment Processing
```
Agent: Receives a customer payment processing request
Agent: Calls payment_tool → No response (timeout)
Agent: "Not sure if that worked?" → Calls again
Payment system: Charges twice
Customer: Files a double-billing complaint
```

#### Scenario 2: Duplicate Contract Signing Request
```
Agent A: Sends email to legal team requesting contract signature
Agent B: (Backup agent assigned to same task) Sends the same email again
Legal team: Receives two requests for the same contract — confusion ensues
```

#### Scenario 3: Duplicate Database Records
```
Agent: INSERTs new customer data into DB
Agent: Response delayed → INSERTs again
DB: Two duplicate records created (hard to detect without a primary key)
```

![Idempotency Architecture Pattern](/images/study/A_agent-reliability/idempotency-architecture.png)

---

### Production Idempotency Implementation Patterns

#### Pattern 1: Idempotency Key-Based Deduplication

The most versatile approach. Assign a unique key to each agent action and use it to block duplicate execution.

```python
import hashlib
import json

class IdempotencyGuard:
    def __init__(self, store):
        self.store = store  # Redis, DB, etc.
    
    def generate_key(self, action: str, payload: dict) -> str:
        """Same action + same data = same key = natural idempotency"""
        content = f"{action}:{json.dumps(payload, sort_keys=True)}"
        return hashlib.sha256(content.encode()).hexdigest()[:16]
    
    def execute_once(self, key: str, action_fn, *args, **kwargs):
        """If key exists, return stored result. Otherwise, execute and store."""
        existing = self.store.get(key)
        if existing:
            return json.loads(existing)  # Return previously executed result
        
        result = action_fn(*args, **kwargs)
        self.store.set(key, json.dumps(result), ex=86400)  # Store for 24 hours
        return result

# Apply to agent tools
guard = IdempotencyGuard(redis_client)

def send_contract_email(customer_id: str, contract_id: str):
    key = guard.generate_key("send_contract_email", {
        "customer_id": customer_id,
        "contract_id": contract_id
    })
    
    return guard.execute_once(
        key,
        _actually_send_email,  # The real send function
        customer_id,
        contract_id
    )
```

#### Pattern 2: State Machine-Based Task Tracking

Best suited for complex multi-step operations. Explicitly persists the status of each task.

```python
from enum import Enum

class TaskStatus(Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"

class AgentTask:
    def __init__(self, task_id: str, db):
        self.task_id = task_id
        self.db = db
    
    def execute(self, steps: list):
        task = self.db.get_task(self.task_id)
        
        if task["status"] == TaskStatus.COMPLETED:
            return task["result"]  # Already done — do NOT re-execute
        
        if task["status"] == TaskStatus.IN_PROGRESS:
            # Another agent is already running this
            raise ConflictError("This task is already being executed")
        
        self.db.update_status(self.task_id, TaskStatus.IN_PROGRESS)
        
        try:
            result = self._execute_steps(steps)
            self.db.update_status(self.task_id, TaskStatus.COMPLETED, result)
            return result
        except Exception as e:
            self.db.update_status(self.task_id, TaskStatus.FAILED, error=str(e))
            raise
```

#### Pattern 3: The Saga Pattern — Rollback on Failure

When an agent operates across multiple systems, a mid-task failure means already-completed steps need to be unwound.

```python
class AgentSaga:
    """Step-by-step execution + reverse compensating transactions on failure"""
    
    def __init__(self):
        self.steps = []
        self.compensations = []
    
    def add_step(self, action, compensation):
        """action: the actual work; compensation: the rollback function"""
        self.steps.append(action)
        self.compensations.append(compensation)
    
    def execute(self):
        completed = []
        
        for i, (step, compensation) in enumerate(zip(self.steps, self.compensations)):
            try:
                result = step()
                completed.append((i, compensation, result))
            except Exception as e:
                print(f"Step {i} failed: {e}")
                print("Starting rollback...")
                
                # Roll back completed steps in reverse order
                for idx, comp, res in reversed(completed):
                    try:
                        comp(res)
                        print(f"Step {idx} rolled back successfully")
                    except Exception as rollback_error:
                        print(f"Rollback failed (manual intervention needed): {rollback_error}")
                raise

# Usage: contract processing agent
saga = AgentSaga()

saga.add_step(
    action=lambda: create_contract_record(customer_id, contract_data),
    compensation=lambda result: delete_contract_record(result["contract_id"])
)

saga.add_step(
    action=lambda: charge_payment(customer_id, amount),
    compensation=lambda result: refund_payment(result["charge_id"])
)

saga.add_step(
    action=lambda: send_confirmation_email(customer_id),
    compensation=lambda result: None  # Can't unsend — just log it
)

saga.execute()  # Auto-rollback on failure
```

---

### Summary: Core Principles for AI Agent Developers

| Principle | Explanation |
|-----------|-------------|
| **Check for duplicates first** | Always ask "Have I already done this?" before executing |
| **Assign Idempotency Keys** | Issue a unique key for every external action |
| **Externalize state** | Store state in external DB, not inside the agent |
| **Prepare compensation transactions** | Design a rollback for every action |
| **Retry ≠ Re-execute** | Only allow retries when the same result is guaranteed |

---

### Closing Thoughts

In the era of autonomous AI agents, developers must treat "the agent will make mistakes" as a baseline assumption — not an edge case.

Rather than trying to make your agent run perfectly with zero errors, **designing your system so mistakes produce no side effects** is far more realistic and far more robust.

Next time you add an external API tool to an AI agent, ask yourself:

> **"What happens if this tool gets called twice?"**

If you don't have an immediate answer, your design isn't finished yet.

---
