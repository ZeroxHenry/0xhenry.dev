---
title: "Neon Postgres"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Trial"
quadrant: "Cloud & Infrastructure"
moved: 1
description: "Serverless Postgres with database branching. Scale-to-zero billing is the killer feature."
---

## What is it?

Neon is a serverless PostgreSQL platform that separates storage and compute. This enables database branching (fork your production database for testing in seconds), scale-to-zero billing (no charges when idle), and instant provisioning. It's fully compatible Postgres — extensions, pg_dump, existing ORMs all work as expected.

## Why does it matter?

Traditional managed Postgres (RDS, Cloud SQL) charges you 24/7 whether your database is active or not. Neon's scale-to-zero means staging environments, preview deploys, and side projects cost nothing when idle. Database branching lets you test migrations against production data without touching production — a workflow that transforms how teams handle schema changes.

## Trade-offs

**Strengths:**
- Scale-to-zero billing (pay only for active compute)
- Database branching: fork production data in seconds for testing
- Instant provisioning — new databases in under a second
- Full Postgres compatibility (extensions, pg_vector, etc.)
- Generous free tier for development and side projects

**Limitations:**
- Cold start latency when scaling from zero (~500ms for first query)
- Compute size limits on lower tiers constrain heavy workloads
- Newer platform means less operational track record than RDS
- Connection pooling requires PgBouncer configuration for high-concurrency apps
- Some Postgres extensions are not yet supported

## Our take

Neon moved to **Trial** because the developer experience and billing model are genuinely better than traditional managed Postgres. We use it for all preview and staging environments — each PR gets its own database branch with production data, and it costs nothing until someone actually uses it. For production workloads, we want more operational maturity before fully committing, but the trajectory is strong. If you're starting a new project that uses Postgres, Neon should be on your shortlist.
