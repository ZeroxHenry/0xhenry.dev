---
title: "OCR for RAG: Reading Scanned Documents and Images"
date: 2026-04-11
draft: false
tags: ["OCR", "Tesseract", "PaddleOCR", "Vision-LLM", "RAG", "Data-Extraction"]
description: "How to unlock the knowledge hidden in scanned PDFs and photos using Optical Character Recognition for your RAG pipeline."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

Not every document is a digital PDF with searchable text. Many companies rely on legacy systems where "digitizing" a document simply means taking a photo or scanning it into an image-based PDF. To a standard RAG system, these documents are invisible—they are just "pictures of words."

To index these, we must use **Optical Character Recognition (OCR)**.

---

### The OCR Workflow in RAG

1.  **Image Pre-processing**: Enhancing contrast, deskewing (straightening), and removing noise from the scan to make characters clearer.
2.  **Detection**: Finding where the blocks of text are located on the page.
3.  **Recognition**: Converting the pixels into actual digital characters.
4.  **Verification**: Using an LLM to "spellcheck" the OCR output, as OCR often makes mistakes (e.g., reading `l` as `1`).

---

### Choosing your OCR Engine

-   **Tesseract**: The classic open-source engine. Good for clean text, but struggles with complex layouts or multi-columns.
-   **PaddleOCR**: A modern, high-performance engine that is excellent at Chinese/Korean/Japanese and complex layouts.
-   **Vision LLMs (The New Standard)**: Models like Gemini 1.5 Pro or GPT-4o can "look" at a page and move directly from pixels to perfectly formatted text without a traditional OCR library.

### Why Vision LLMs are changing OCR

Traditional OCR is "dumb." It reads characters but doesn't understand context. If it sees a smudge on the paper that looks like a comma, it will output a comma. 

A **Vision LLM** understands context. It knows that in the phrase "Total Revenue: $10,000", that smudge between the numbers is almost certainly a comma because it "understands" what a currency figure looks like. This reduces "OCR Hallucinations" significantly.

---

### Implementation Example: Local Vision OCR

If you are following the 0xHenry philosophy of local execution, you can use local Vision models like **Llava** or **Moondream** via Ollama to "describe" your images.

```python
import ollama

# Describe a scanned receipt
response = ollama.generate(
    model='moondream',
    prompt='Transcribe the text in this image exactly as it appears.',
    images=['scanned_receipt.jpg']
)

print(response['response'])
```

---

### Summary

OCR is the front door for RAG in many traditional industries. Without it, your knowledge base is deaf and blind to legacy data. By combining traditional OCR speed with Vision LLM intelligence, you can build a pipeline that reads even fuzzy, low-quality scans with high confidence.

In our next session, we’ll move to a more specialized field: **Building a RAG for Codebases.**

---

**Next Topic:** [Code RAG: Teaching AI to Understand Your Repo](/en/study/code-rag)
