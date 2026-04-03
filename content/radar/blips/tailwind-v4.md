---
title: "Tailwind CSS v4"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Trial"
quadrant: "Developer Tools"
moved: 1
description: "Major rewrite with Rust-based engine. CSS-first config changes the DX significantly."
---

## What is it?

Tailwind CSS v4 is a ground-up rewrite of the utility-first CSS framework, powered by a new Rust-based engine (Lightning CSS). The biggest shift: configuration moves from `tailwind.config.js` to CSS-native `@theme` directives. Content detection is automatic — no more configuring content paths. Build times are 5-10x faster than v3.

## Why does it matter?

Tailwind v3 was already dominant, but the JavaScript-based toolchain added build complexity and performance overhead. v4 fixes both. The CSS-first configuration means your theme lives in a `.css` file, not a JS config — it's more portable and easier to reason about. Automatic content detection eliminates the most common source of "why isn't my class working?" frustration.

## Trade-offs

**Strengths:**
- 5-10x faster builds via Rust-based engine
- CSS-first config with `@theme` — no more `tailwind.config.js`
- Automatic content detection (no `content` array to maintain)
- Built-in import support without PostCSS plugins
- Container queries, `@starting-style`, and modern CSS features natively supported

**Limitations:**
- Migration from v3 requires config rewrite and some class name changes
- Plugin ecosystem is still adapting to the new architecture
- Some v3 plugins don't have v4 equivalents yet
- CSS-first config is a paradigm shift that takes adjustment

## Our take

Tailwind v4 moved to **Trial** because the developer experience improvement is substantial, but the ecosystem needs time to catch up. For new projects, start with v4 — the faster builds and simpler config are worth it. For existing v3 projects, wait until your key plugins support v4 before migrating. The upgrade path is well-documented but not trivial.
