---
title: "Vite"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Adopt"
quadrant: "Developer Tools"
moved: 0
description: "The build tool that killed webpack. Sub-second HMR and framework-agnostic design."
---

## What is it?

Vite is a frontend build tool that uses native ES modules for development (instant server start, sub-second HMR) and Rollup for optimized production builds. It supports React, Vue, Svelte, Solid, and vanilla JS/TS out of the box. No configuration required for most projects — it just works.

## Why does it matter?

Webpack dominated frontend tooling for a decade, but its architecture — bundling everything for development — couldn't keep up as projects grew. Vite's approach of serving source files directly via native ESM during development means the dev server starts in milliseconds regardless of project size. Hot Module Replacement is near-instant. The productivity difference is not subtle.

## Trade-offs

**Strengths:**
- Instant dev server startup (no bundling step)
- Sub-second HMR that stays fast as projects grow
- Framework-agnostic with first-class support for major frameworks
- Rollup-based production builds with tree-shaking and code splitting
- Rich plugin ecosystem compatible with Rollup plugins

**Limitations:**
- Dev and production use different bundlers (ESM vs Rollup), causing occasional behavior differences
- Less mature than webpack for complex custom configurations
- SSR support exists but is less polished than framework-specific solutions
- Large legacy codebases with CommonJS dependencies can require workarounds

## Our take

Vite at **Adopt** is the easiest call on this radar. If you're starting a new frontend project in 2026 and not using Vite, you need a very good reason. The development experience improvement over webpack is dramatic and immediate. Even for existing webpack projects, the migration is often worth the effort — most teams report it taking a few days with a significant ongoing DX improvement. Just do it.
