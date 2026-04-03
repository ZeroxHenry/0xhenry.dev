---
title: "GitHub Actions"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Adopt"
quadrant: "Cloud & Infrastructure"
moved: 0
description: "De facto CI/CD for GitHub-hosted projects. Marketplace ecosystem covers most automation needs."
---

## What is it?

GitHub Actions is GitHub's built-in CI/CD and workflow automation platform. Workflows are defined in YAML and triggered by repository events — pushes, pull requests, releases, schedules, or manual dispatch. The Marketplace provides thousands of pre-built actions for common tasks like deployment, testing, notifications, and security scanning.

## Why does it matter?

For teams already on GitHub, Actions eliminates the need for a separate CI/CD service (Jenkins, CircleCI, Travis). The tight integration means CI status shows directly on PRs, deployment environments are linked to commits, and secrets management is centralized. Reusable workflows and composite actions enable DRY automation across multiple repositories.

## Trade-offs

**Strengths:**
- Zero setup for GitHub-hosted projects — just add a YAML file
- 2,000 free minutes/month for public repos, generous for private
- Marketplace actions cover 90% of common CI/CD tasks
- Matrix builds for cross-platform and multi-version testing
- Reusable workflows reduce duplication across repos

**Limitations:**
- YAML debugging is painful — no local execution without third-party tools (act)
- Runner startup time adds 15-30 seconds to every job
- Secrets management is per-repo or per-org (no cross-org sharing)
- Complex workflows with many dependencies become hard to read and maintain
- Self-hosted runners require infrastructure management

## Our take

GitHub Actions is the obvious choice for any team using GitHub, and we keep it firmly at **Adopt**. For most projects, a simple CI workflow (lint, test, build, deploy) takes 30 minutes to set up and just works. The trick is keeping workflows simple — resist the urge to build a complex multi-stage pipeline when a straightforward linear workflow does the job. Use composite actions to share common steps across repos.
