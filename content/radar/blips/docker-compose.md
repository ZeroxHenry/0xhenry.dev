---
title: "Docker Compose for Dev"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Adopt"
quadrant: "Cloud & Infrastructure"
moved: 0
description: "Still the most reliable way to replicate production-like environments locally."
---

## What is it?

Docker Compose defines multi-container development environments in a single YAML file. Need Postgres, Redis, and your API running together? One `docker compose up` and it's done. With Docker Desktop alternatives like OrbStack (macOS) and Colima gaining traction, the container developer experience has significantly improved.

## Why does it matter?

"It works on my machine" should be a solved problem by now, and Docker Compose is the reason it mostly is. New developer onboarding goes from "follow this 47-step wiki page" to "clone and docker compose up." Database migrations, seed data, service dependencies — all codified and version-controlled alongside your application.

## Trade-offs

**Strengths:**
- One command to spin up entire development environments
- Environment parity between dev, CI, and production
- OrbStack/Colima fix Docker Desktop's resource overhead on macOS
- Compose Watch enables file sync without rebuilds
- Works with every language and framework

**Limitations:**
- Resource-heavy on machines with limited RAM (each container adds overhead)
- Volume mount performance on macOS is still not great (despite improvements)
- Docker Desktop licensing has pushed some teams to alternatives
- Compose files can become complex for large microservice architectures

## Our take

Docker Compose at **Adopt** is barely controversial. Every project we start gets a `compose.yml` for local development. The key insight: don't try to replicate your entire production Kubernetes setup in Compose. Keep it focused — your app, its database, and the services it directly depends on. If you're on macOS, switch to OrbStack. It's noticeably faster and uses less memory than Docker Desktop.
