---
title: "Introduction to ChromaDB: Your First Local Vector Store"
date: 2026-04-11
draft: false
tags: ["ChromaDB", "Vector-DB", "Python", "Local-AI"]
description: "Why ChromaDB is the go-to choice for local RAG systems and how to set it up in minutes."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

In our RAG journey, we’ve learned how to slice text (chunking) and how to turn it into numbers (embeddings). Now, we need a place to store those numbers so we can search through them efficiently.

Meet **ChromaDB**—the open-source embedding database. It is designed specifically for building AI applications with LLMs.

---

### Why ChromaDB?

There are many vector databases (Pinecone, Milvus, Weaviate), but ChromaDB stands out for several reasons:

1.  **Local-First**: You can run it entirely on your laptop. No cloud account or API keys are required.
2.  **Simplicity**: It’s incredibly easy to use. You can start a persistent database with just a few lines of Python.
3.  **Lightweight**: It doesn't require complex Docker setups (though it supports them). You can even run it in-memory.
4.  **Extensibility**: It integrates perfectly with LangChain and LlamaIndex.

---

### Installing ChromaDB

If you have Python installed, getting ChromaDB is a single command:

```bash
pip install chromadb
```

---

### How to use ChromaDB in Python

Here is a minimal example of creating a collection, adding documents, and querying them.

```python
import chromadb

# 1. Initialize the client (Persistent storage)
client = chromadb.PersistentClient(path="./my_chroma_db")

# 2. Create a collection
collection = client.get_or_create_collection(name="tech_blog_posts")

# 3. Add documents
collection.add(
    documents=["RAG is a technique for grounding AI answers.", "ChromaDB is a vector database."],
    metadatas=[{"source": "rag_post"}, {"source": "chroma_post"}],
    ids=["id1", "id2"]
)

# 4. Query the collection
results = collection.query(
    query_texts=["What is ChromaDB?"],
    n_results=1
)

print(results)
```

---

### Core Concepts

-   **Client**: The interface you use to talk to ChromaDB.
-   **Collection**: Think of this as a "Table" in a traditional database. It’s where you group related embeddings.
-   **Persistent vs. Ephemeral**: You can choose to save the data to your hard drive or keep it only in RAM.
-   **Metadatas**: You can store extra info (like author, date, or URL) along with the text, which is useful for filtering.

### Summary

ChromaDB is the perfect starting point for any Local RAG developer. It takes the complexity out of vector search and lets you focus on building the logic of your application.

In the next post, we’ll look at **FAISS**—an alternative for when you need to handle millions of documents at lightning speed.

---

**Next Topic:** [Using FAISS for high-performance scale](/en/study/faiss-tutorial)
