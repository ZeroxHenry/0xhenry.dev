---
title: "PlanetScale"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Hold"
quadrant: "Platforms & APIs"
moved: -1
description: "Serverless MySQL — free tier gone, Vitess complexity surfacing. Alternatives are winning."
---

## What is it?

PlanetScale is a serverless MySQL database platform built on Vitess, the technology that scales YouTube's databases. It offers non-blocking schema changes, database branching (like git branches for your schema), and automatic connection pooling. It was the darling of the serverless database space in 2023-2024.

## Why does it matter?

PlanetScale pioneered the "database branching" concept — create a branch, make schema changes, merge when ready. This workflow transformed how teams handle database migrations, especially for continuous deployment pipelines. The non-blocking schema changes meant zero-downtime migrations for production databases.

## Trade-offs

**Strengths:**
- Non-blocking schema changes (no table locks during migrations)
- Database branching enables safe schema experimentation
- Built on Vitess — proven at extreme scale (YouTube, Slack)
- Excellent dashboard and CLI for database management

**Limitations:**
- Free tier was removed — minimum cost is now significant for small projects
- No foreign key support (Vitess limitation) pushes constraint logic to application layer
- Vitess query compatibility issues surface with complex joins and subqueries
- Pricing based on rows read can be unpredictable for analytics-heavy workloads
- Postgres ecosystem is growing faster (Supabase, Neon, Turso)

## Our take

PlanetScale moved to **Hold**. The removal of the free tier was a signal, and the industry has moved toward Postgres-based alternatives. Supabase gives you more features with Postgres, Neon offers serverless Postgres with branching, and Turso provides edge-native SQLite. Unless you have a specific MySQL requirement or are already invested in PlanetScale, we recommend Postgres-based alternatives for new projects. The no-foreign-keys constraint alone is a dealbreaker for most applications.
