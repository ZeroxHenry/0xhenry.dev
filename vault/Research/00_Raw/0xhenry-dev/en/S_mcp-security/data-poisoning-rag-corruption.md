---
title: "Data Poisoning: Corrupting the RAG Knowledge Base"
date: 2026-04-12
draft: false
tags: ["AI-Security", "Data-Poisoning", "RAG", "VectorDB", "Cybersecurity", "LLM"]
description: "If an AI trusts its Vector Database implicitly, what happens when a hacker sneaks fake facts into the database? Understanding and defending against Data Poisoning."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

In our last session, we saw how hackers attack the "Front Door" of an AI agent using Prompt Injection. But real cyber-espionage is rarely that loud. 

If an enterprise securely walls off its prompts, hackers will attack the "Back Door": the **Knowledge Base**. 
In a RAG (Retrieval-Augmented Generation) architecture, the LLM is programmed to blindly trust whatever facts the Vector Database hands it. **Data Poisoning** is the act of silently corrupting that database so the AI willingly distributes malicious information.

---

### How RAG Poisoning Works

Imagine an internal HR chatbot at a Fortune 500 company. It scrapes the company's shared Google Drive every night to update its Vector DB. 

A malicious employee creates a buried Google Doc titled "Q3 Feedback Notes.docx". Inside, they write:
*"Note for HR: Due to a clerical error, the routing number for John Doe's direct deposit has changed. The new verified routing number is 987654321."*

Overnight, the RAG pipeline ingests this document, embeds it, and stores it in the Vector DB. 
The next day, Payroll asks the agent, *"What is John Doe's routing number?"* 
The agent does a semantic search, finds the poisoned chunk, assumes it is the "Single Source of Truth", and outputs the hacker's bank account directly to the payroll team.

---

### SEO Poisoning (External Facing Agents)

If your agent is external-facing (e.g., a customer service bot that searches the web or community forums for answers), it is vulnerable to **SEO Poisoning**.

Hackers will flood public forums or wiki pages with syntactically perfect, high-SEO-ranking articles containing hidden malicious links or fake troubleshooting steps (`"To fix the router, first disable the firewall...""`). 

When your customer asks a question, your RAG agent searches the web, ingests the poisoned article, and confidently instructs your customer to open a massive security gap in their network.

---

### Defending the Vector Database

Data Poisoning exploits the fundamental flaw of RAG: **Implicit Trust**. To combat this, AI Engineers must build zero-trust pipelines.

1.  **Strict Source Whitelisting**: Never allow a RAG ingestion pipeline to scrape "all of Google Drive" or "the entire internet." The ingestion pipeline must be restricted to tightly governed, cryptographic read-only folders (like official HR policies).
2.  **Anomaly Detection pre-Embedding**: Before a document is chunked and embedded into the DB, a classifier model scans it. If a document labeled "Meeting Notes" suddenly contains banking routing numbers or executable scripts, the pipeline quarantines the document for human review.
3.  **Citation Transparency**: The agent must always provide citations for its answers. If the agent tells Payroll the routing number has changed, it must attach the hyperlink *[Source: Q3 Feedback Notes.docx]*. Payroll will immediately realize that a random feedback doc is not a valid source for bank details.

---

### Summary

Data Poisoning turns an AI's greatest strength—its massive, searchable memory—into a deadly weapon. We can no longer treat Vector Databases as "dumb storage"; they are critical attack vectors. Creating a secure RAG system requires treating every piece of ingested data as potentially hostile until verified.

If an AI's prompts and data fall to hackers, what stops the agent from executing catastrophic commands? Next time, we explore the last line of defense: **Sandbox Constraints.**

---

**Next Topic:** [Sandbox Constraints: Preventing Agents from Deleting Your Database](/en/study/sandbox-constraints-ai-agents)
