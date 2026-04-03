---
title: "tRPC"
date: 2026-04-01
type: "radar-blip"
draft: false
ring: "Trial"
quadrant: "Platforms & APIs"
moved: 0
description: "End-to-end type-safe APIs without code generation. Perfect for TypeScript monorepos."
---

## What is it?

tRPC enables fully type-safe API calls between TypeScript client and server without code generation, schemas, or runtime validation layers. Define your API procedures on the server, and the client automatically gets full type inference — autocompletion, type checking, and refactoring support. Change a server response shape, and the client shows type errors immediately.

## Why does it matter?

The traditional API workflow — define an OpenAPI spec, generate client types, keep them in sync — is tedious and error-prone. tRPC eliminates this entirely for TypeScript monorepos. When your server and client share a codebase, tRPC gives you the type safety of a function call with the architecture of an API. Rename a field on the server, and your IDE shows every affected client call instantly.

## Trade-offs

**Strengths:**
- Zero code generation — types flow from server to client automatically
- Excellent DX with autocompletion and inline type errors
- Works with React Query (TanStack Query) for caching and state management
- Subscriptions support for real-time updates via WebSockets
- v11 introduces significant performance and DX improvements

**Limitations:**
- Only works when client and server are both TypeScript
- Not suitable for public APIs consumed by third-party developers
- Tight coupling between client and server can complicate independent deployments
- Learning curve for the procedure/router abstraction
- Middleware chain can become complex for auth and validation

## Our take

tRPC at **Trial** is the right call for TypeScript-heavy teams. If your frontend and backend live in the same monorepo and both use TypeScript, tRPC is a no-brainer — the type safety pays for itself in prevented bugs and faster refactoring. But it's not a universal solution: if you need a public API, multi-language clients, or independent frontend/backend deployment, stick with REST or GraphQL.
