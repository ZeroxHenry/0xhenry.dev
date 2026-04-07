---
title: "Biome"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Assess"
quadrant: "Developer Tools"
moved: 1
description: "Rust-based linter + formatter replacing ESLint + Prettier. 10-100x faster, but ecosystem is young."
---

## What is it?

Biome is a Rust-based toolchain that combines linting and formatting into a single tool, replacing the ESLint + Prettier combo. It handles JavaScript, TypeScript, JSX, JSON, and CSS with near-instant execution. Configuration is minimal — a single `biome.json` file replaces `.eslintrc`, `.prettierrc`, and their respective ignore files.

## Why does it matter?

The ESLint + Prettier setup is a rite of passage that wastes hours on every new project: plugin conflicts, configuration inheritance, `.eslintignore` vs `.prettierignore`, the Prettier-ESLint integration plugin, and the inevitable "which rule is conflicting?" debugging session. Biome replaces all of this with one tool, one config file, and formatting speeds that make save-on-format invisible.

## Trade-offs

**Strengths:**
- 10-100x faster than ESLint + Prettier
- Single tool replaces two (linting + formatting)
- Minimal configuration with sensible defaults
- Great VS Code extension with instant feedback
- Growing rule set covering most common ESLint rules

**Limitations:**
- Plugin ecosystem is nonexistent compared to ESLint's thousands of plugins
- Missing rules that teams depend on (specific React patterns, accessibility, etc.)
- Framework-specific rules (Next.js, Remix) are not yet available
- CSS support is still maturing
- Smaller community means fewer ready-made configs and answers

## Our take

Biome is at **Assess** — fast, clean, and promising, but the plugin gap is real. If your team's ESLint config is just the recommended rules plus Prettier, Biome is a drop-in upgrade. If you rely on specific plugins (eslint-plugin-import, eslint-plugin-jsx-a11y, custom rules), you'll need to evaluate what's missing. We're running Biome on new internal tools and side projects to build confidence before migrating our main projects.
