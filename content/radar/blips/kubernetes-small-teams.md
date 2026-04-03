---
title: "Kubernetes (for small teams)"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Hold"
quadrant: "Cloud & Infrastructure"
moved: 0
description: "Operational complexity remains prohibitive for teams under 5 engineers."
---

## What is it?

Kubernetes is the industry-standard container orchestration platform. It manages deployment, scaling, networking, and self-healing for containerized applications across clusters of machines. Managed offerings (EKS, GKE, AKS) reduce the infrastructure burden, but the operational complexity of Kubernetes itself remains.

## Why does it matter?

Kubernetes solved real problems for large engineering organizations: consistent deployment across environments, automatic scaling, service mesh, and infrastructure-as-code. But those problems don't exist at the same scale for small teams, and adopting Kubernetes anyway introduces operational overhead that dwarfs the complexity of the application itself.

## Trade-offs

**Strengths:**
- Industry standard with massive ecosystem and talent pool
- Handles complex microservice architectures at scale
- Infrastructure-as-code enables reproducible environments
- Managed offerings (EKS, GKE) reduce cluster management burden

**Limitations:**
- YAML configuration is verbose and error-prone
- Debugging networking issues requires deep platform knowledge
- Monitoring, logging, and observability need additional tooling (Prometheus, Grafana, etc.)
- Even managed Kubernetes requires dedicated ops expertise
- Cost overhead is significant for small workloads

## Our take

**Hold** for teams under 5 engineers. We've seen too many small teams spend months on Kubernetes setup that could have been avoided with Railway, Fly.io, or Cloudflare Workers. If your application fits in a single container (most do), you don't need an orchestrator. If you need multiple services, Docker Compose for dev and a managed platform for production is simpler and cheaper. Save Kubernetes for when you actually have the scaling problems it solves.
