---
title: "Building Your First Local RAG with Python & Ollama"
date: 2026-04-12
draft: false
tags: ["Python", "Ollama", "ChromaDB", "Tutorial"]
description: "A practical step-by-step guide to setting up a fully local RAG system on your machine using Python and Ollama."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

In our previous posts, we discussed what RAG is and why running it locally is a game-changer for privacy. Today, we’re getting hands-on. We will build a minimal, fully functional Local RAG system that can answer questions about a local text file.

**Prerequisites:**
- Python 3.10+ installed.
- [Ollama](https://ollama.com/) installed and running.
- Basic knowledge of Python.

---

### Step 1: Install Dependencies

We need a few libraries: `langchain` (for orchestration), `chromadb` (as our vector database), and `ollama` (to interact with our local LLM).

```bash
pip install langchain langchain-community chromadb ollama
```

### Step 2: Choose Your Models

Open your terminal and pull the models we need. We'll use **Llama 3** (or Gemma 2) as the generator and **nomic-embed-text** as the embedding model.

```bash
ollama pull llama3
ollama pull nomic-embed-text
```

### Step 3: The Python Script

Create a file named `local_rag.py`. We will divide the code into three parts: Document Loading, Embedding, and Retrieval.

```python
from langchain_community.llms import Ollama
from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.vectorstores import Chroma
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains import RetrievalQA
from langchain_community.document_loaders import TextLoader

# 1. Load your data
loader = TextLoader("your_data.txt")
documents = loader.load()

# 2. Split text into chunks
text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=50)
chunks = text_splitter.split_documents(documents)

# 3. Create Vector Store
embeddings = OllamaEmbeddings(model="nomic-embed-text")
vector_db = Chroma.from_documents(
    documents=chunks, 
    embedding=embeddings,
    collection_name="local-rag"
)

# 4. Setup Retrieval Chain
llm = Ollama(model="llama3")
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=vector_db.as_retriever()
)

# 5. Ask a question
query = "What is the main topic of the document?"
response = qa_chain.invoke(query)
print(response["result"])
```

---

### How it Works

1.  **Loading**: We read a simple text file.
2.  **Chunking**: Large documents are hard for AI to "digest." We break them into 500-character chunks so the AI can find specific sections easily.
3.  **Embedding**: We convert text into numbers (vectors) using the `nomic-embed-text` model. Similar meanings end up as similar numbers.
4.  **Vector DB**: We store these numbers in ChromaDB, which acts like a specialized search engine.
5.  **Retrieval**: When you ask a question, the system finds the most relevant chunks and feeds them to the LLM (Llama 3) to generate an answer.

### Summary

Congratulations! You just built a private AI that knows only what you tell it. No data went to the cloud, and no API keys were needed.

In the next post, we will explore **Vector Embeddings** in more detail—how exactly does the computer turn "Hello" into a list of numbers?

---

**Next Topic:** [Understanding Vector Embeddings: The Math of Meaning](/en/study/vector-embeddings-explained)
