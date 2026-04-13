---
title: "Whisper & Diarization: Who said what, and when?"
date: 2026-04-12
draft: false
tags: ["Whisper", "Diarization", "Speech-Processing", "AI-Engineering", "Pyannote", "Transcription"]
description: "Going beyond simple text. How to identify multiple speakers and create professional-grade meeting transcripts using Whisper and Pyannote."
author: "Henry"
categories: ["AI Engineering"]
---

### Introduction

A giant block of text is hard to read. If you have a transcript of a 3-person debate but it doesn't say who is talking, the transcript is almost useless. To build a professional audio AI, you need two distinct technologies working in tandem: **Transcription** and **Diarization**.

---

### The Transcription Engine: OpenAI Whisper

Whisper is the world's most capable open-source speech-to-text model. It doesn't just "hear" words; it understands context, punctuation, and even translates from 99 different languages.

-   **Why it's the standard**: It was trained on a massive, diverse dataset, making it incredibly robust against background noise and technical terminology.
-   **Local Performance**: With a single high-end GPU, you can transcribe audio faster than real-time (e.g., 60 minutes of audio in 2 minutes of compute).

### The Identity Engine: Speaker Diarization

Diarization is the process of partitioning an audio stream into segments according to "Who" is speaking. Whisper cannot do this by itself—it only hears the words.

Using models like **Pyannote Audio**, we can:
1.  **Extract Voiceprints**: Analyze the unique frequency and pitch of a person's voice.
2.  **Cluster Segments**: Group all parts of the audio that match a specific voiceprint.
3.  **Label Speakers**: Assign generic IDs like "Speaker 0" and "Speaker 1" (which you can later name "Henry" and "User").

---

### The Combined Workflow

To create a professional transcript, the pipeline looks like this:

1.  **Pre-process**: Clean the audio (remove long silences).
2.  **Diarize**: Run Pyannote to find the "time-stamps" for each speaker (e.g., [00:01 - 00:15]: Speaker A).
3.  **Transcribe**: Run Whisper on those specific segments.
4.  **Merge**: Combine the results into a final document:
    -   **[00:01] Speaker A**: "Hello everyone, let's start the meeting."
    -   **[00:15] Speaker B**: "Sure, I have the agenda ready."

---

### Summary

Transcription (Whisper) + Diarization (Pyannote) = **Structured Meetings**. By knowing not just what was said, but *who* said it, we turn raw audio into a structured data source that LLMs can analyze for "sentiment tracking," "action item extraction," and "conflict resolution."

In our next session, we’ll see how agents can talk back: **Text-to-Speech (TTS) for AI Agents.**

---

**Next Topic:** [Text-to-Speech: Giving Your AI a Natural Voice](/en/study/tts-agents)
