---
title: "PGVector: Bringing AI Power to Your Reliable PostgreSQL Database"
date: 2026-04-11
draft: false
tags: ["PostgreSQL", "PGVector", "Database", "Vector-Search"]
description: "How to use the PGVector extension to perform vector similarity search directly inside PostgreSQL."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

So far, we’ve looked at dedicated vector databases like ChromaDB and FAISS. But what if you already have a massive enterprise database running on PostgreSQL? Do you really want to manage a separate AI database just for embeddings?

Enter **PGVector**—the extension that allows PostgreSQL to store and search vector embeddings alongside your traditional relational data.

---

### Why PGVector?

1.  **Consolidation**: No need to add another tool to your tech stack. One database handles everything: Users, Orders, and AI Vectors.
2.  **ACID Compliance**: You get the world-class reliability, backups, and transactions of PostgreSQL for your AI data.
3.  **Relational Power**: You can perform complex joins between your vectors and other tables. Efficiently find "All products in the 'Electronics' category that are semantically similar to this description."
4.  **Operational Maturity**: Your existing DBA team already knows how to manage and scale PostgreSQL.

---

### Getting Started

To use PGVector, you need to enable the extension in your database:

```sql
CREATE EXTENSION IF NOT EXISTS vector;
```

### Storing Vectors

You can now use a new column type called `vector`. You must specify the number of dimensions (e.g., 768 for nomic-embed-text).

```sql
CREATE TABLE documents (
    id serial PRIMARY KEY,
    content text,
    embedding vector(768)
);
```

### Searching with PGVector

PGVector uses standard SQL syntax for similarity search. The `<->` operator calculates Euclidean distance, and `<=>` calculates Cosine distance.

```sql
SELECT content FROM documents 
ORDER BY embedding <=> '[0.1, 0.2, 0.3, ...]' 
LIMIT 5;
```

---

### indexing for Speed

As your dataset grows, you’ll want to add an index. PGVector supports **IVFFlat** and **HNSW** (Hierarchical Navigable Small World). HNSW is generally preferred for its balance of speed and accuracy.

```sql
CREATE INDEX ON documents USING hnsw (embedding vector_cosine_ops);
```

---

### Summary

PGVector is the bridge between the "old world" of structured data and the "new world" of AI. It is perfect for developers who want to add AI features to an existing application without the overhead of learning a brand-new database system.

In our next part, we graduate to the heavy hitters: **Enterprise-grade Vector Databases like Weaviate and Milvus.**

---

**Next Topic:** [Weaviate & Milvus: Scalable AI Infrastructure](/en/study/enterprise-vector-dbs)
