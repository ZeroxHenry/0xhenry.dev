---
title: "Cursor"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Adopt"
quadrant: "Developer Tools"
moved: 0
description: "AI-first code editor built on VS Code. Tab completion and multi-file edits as the productivity default."
---

## What is it?

Cursor is a code editor forked from VS Code that puts AI at the center of the development workflow. Tab completion predicts your next edit based on recent changes, Cmd+K enables inline code generation and refactoring, and Composer handles multi-file edits from natural language instructions. It keeps full VS Code extension compatibility while adding AI capabilities that feel native rather than bolted on.

## Why does it matter?

GitHub Copilot proved that AI autocomplete improves developer productivity. Cursor takes that further — instead of just completing the current line, it understands the context of your recent edits and predicts what you're likely to do next. The multi-file Composer mode handles refactoring tasks that would take 30 minutes manually in under a minute. For greenfield development especially, the speed improvement is dramatic.

## Trade-offs

**Strengths:**
- Tab completion that understands edit context, not just the current file
- Multi-file edits via Composer for cross-cutting changes
- Full VS Code extension ecosystem compatibility
- Inline diff view for reviewing AI suggestions before accepting
- Supports multiple model providers (Claude, GPT-4, local models)

**Limitations:**
- Subscription cost ($20/month) on top of any model API costs
- Proprietary fork — you're dependent on the Cursor team keeping up with VS Code updates
- AI suggestions can be confidently wrong, requiring careful review
- Heavy model usage burns through included request quotas quickly
- Settings and config occasionally diverge from upstream VS Code

## Our take

Cursor stays at **Adopt** as the best IDE-embedded AI coding experience. The tab completion alone justifies the subscription — it predicts multi-line edits with uncanny accuracy after you establish a pattern. We pair it with Claude Code for different use cases: Cursor for interactive development where you're steering edits in real time, Claude Code for autonomous tasks you can hand off and review afterward. Together, they cover the full spectrum of AI-assisted development.
