---
title: "Undo for Agents — Implementing Rollbacks with Saga Pattern"
date: 2026-04-13
draft: false
tags: ["AI Agents", "Saga Pattern", "Rollback", "Agent Reliability", "Error Handling", "Distributed Systems"]
description: "What happens if an AI agent sends the wrong email or charges a customer twice? We borrow the classic Saga pattern from distributed systems to implement 'Cancellable AI' workflows."
author: "Henry"
categories: ["Agent Reliability"]
series: ["Agent Reliability Series"]
series_order: 3
images_needed:
  - position: "hero"
    prompt: "A modern robot holding a glowing 'Ctrl+Z' key, reversing a chain of digital task blocks. An envelope is flying back into a mailbox. High-tech aesthetic, dark background #0d1117, electric blue and orange lighting, 16:9"
    file: "images/A/agent-saga-rollback-hero.png"
  - position: "diagram"
    prompt: "Saga pattern flowchart: Forward line with 'Step 1: Book', 'Step 2: Pay', 'Step 3: Error!'. Backward line with 'Step 2: Refund', 'Step 1: Cancel'. Clean technical diagram, 16:9"
    file: "images/A/agent-saga-rollback-concept.png"
  - position: "code"
    prompt: "Simplified code snippet showing a Saga class with .execute() and .rollback() methods. Neon syntax highlighting on dark background, 16:9"
    file: "images/A/agent-saga-rollback-implementation.png"
---

This is Part 3 of the **Agent Reliability Series**.
→ Part 2: [I Replaced My LLM and My Agent Got Stupider — Detecting LLM Drift](/en/study/A_agent-reliability/llm-agent-drift-detection)

---

Most AI agent demos only show the "Happy Path":

- "Book a meeting for tomorrow at 10 AM" → Meeting created!
- "Buy me a flight to Tokyo" → Ticket booked!

But in production, reality looks like this:

1. The meeting is booked, but the invitation email fails to send.
2. The ticket is bought, but the receipt fails to upload to the corporate expense system.
3. **Worst of all**: The AI hallucinates a plan and sends a sensitive email to the wrong person.

The user screams: **"Wait, undo that!"**

---

### Why 'Rollback' is Hard for AI

In a database, a `ROLLBACK` command fixes everything. But AI agents deal with **Side Effects** — sending emails, Slack messages, or calling external APIs. These cannot be "un-sent."

For systems requiring "Eventual Consistency," the software engineering answer is the **Saga Pattern**.

---

### What is the Saga Pattern?

A Saga breaks a long business process into small **Local Transactions**. For every step that executes, a **Compensating Transaction** is defined to undo its effect.

- **Execution**: Do A → Do B → Do C (Success!)
- **Failure**: Do A → Do B → Do C (FAIL!) → **Undo B → Undo A**

The goal isn't to make the error "never happen," but to bring the system back to a clean state logically.

---

### Implementing an Agent Saga Manager in Python

Every time an agent uses a tool, it must record how to undo that action.

```python
from abc import ABC, abstractmethod
from typing import Any, Callable, List
import logging

class SagaStep:
    def __init__(self, name: str, action: Callable, compensate: Callable):
        self.name = name
        self.action = action
        self.compensate = compensate
        self.status = "pending"

class SagaManager:
    def __init__(self):
        self.steps: List[SagaStep] = []
        self.completed_steps: List[SagaStep] = []

    def add_step(self, name: str, action: Callable, compensate: Callable):
        self.steps.append(SagaStep(name, action, compensate))

    def execute(self):
        for step in self.steps:
            try:
                logging.info(f"Executing: {step.name}")
                step.action()
                step.status = "completed"
                self.completed_steps.append(step)
            except Exception as e:
                logging.error(f"Failed at {step.name}: {e}")
                self.rollback()
                raise e

    def rollback(self):
        logging.warning("Starting Compensation (Rollback)...")
        # Compensate in reverse order of completion
        for step in reversed(self.completed_steps):
            try:
                logging.info(f"Compensating: {step.name}")
                step.compensate()
            except Exception as e:
                # If compensation fails, we are in a 'Nuclear' state
                logging.critical(f"FATAL: Compensation failed for {step.name}: {e}")
```

---

### Saga in Agent Workflows

When defining your tools for frameworks like CrewAI or LangGraph, get into the habit of defining an `undo` function alongside the `run` function.

```python
class TravelAgent:
    def book_trip(self):
        saga = SagaManager()
        
        # Step 1: Hotel
        saga.add_step(
            "Book Hotel", 
            lambda: api.book_hotel(id=1), 
            lambda: api.cancel_booking(id=1)
        )
        
        # Step 2: Flight
        saga.add_step(
            "Pay Flight", 
            lambda: api.charge_card(amount=500), 
            lambda: api.refund_card(amount=500)
        )
        
        # Step 3: Car Rental
        saga.add_step(
            "Rent Car",
            lambda: api.rent_car(type="SUV"),
            lambda: api.cancel_rental()
        )

        try:
            saga.execute()
        except:
            print("Transaction failed. System restored to safe state.")
```

---

### Three Core Challenges of Compensating Transactions

1. **Idempotency**: Your undo function must be safe to run multiple times. If a refund is called twice, it shouldn't crash your rollback process.
2. **Visibility**: You can't delete a sent email. The compensation might be **sending a second email** explaining the previous one was an error.
3. **Time Gaps**: If a step fails 30 minutes after the first step succeeded, a hotel room might have already been released or a non-refundable window might have closed.

---

### Conclusion: The Condition for Agency

The more power (Agency) we give to AI, the more robust our "Undo" mechanisms must be. 

Don't build agents that "don't make mistakes." Build agents that **safely recover from their own mistakes.** That is the mark of a production-ready system.

---

**Next:** [Truthy Text Failure — When AI Insists a Failed Tool Call was a Success](/en/study/A_agent-reliability/agent-truthy-text-failure)
