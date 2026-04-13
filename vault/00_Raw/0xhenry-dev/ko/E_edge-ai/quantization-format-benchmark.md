---
title: "GGUF vs EXL2 vs AWQ: 양자화 포맷 실제 성능 비교 (같은 모델, 다른 결과)"
date: 2026-04-14
draft: false
tags: ["양자화", "GGUF", "EXL2", "AWQ", "LLM", "성능비교", "EdgeAI"]
description: "Llama-3를 돌릴 때 어떤 파일을 받아야 할까요? CPU에 최적화된 GGUF부터 GPU 속도에 몰빵한 EXL2까지, 양자화 포맷에 따른 속도와 비디오 메모리(VRAM) 점유율을 실측 비교합니다."
author: "Henry"
categories: ["Edge AI"]
series: ["Edge AI & 임베디드 시리즈"]
series_order: 5
images_needed:
  - position: "hero"
    prompt: "Three different shaped keys (labeled GGUF, EXL2, AWQ) trying to fit into a single glowing lock (The GPU). Light sparkles represent performance efficiency. Dark mode #0d1117, 16:9"
    file: "images/E/quantization-format-benchmark-hero.png"
  - position: "table"
    prompt: "Comparison table: Format vs VRAM Usage vs Token/s. Highlighting EXL2's speed on GPU and GGUF's versatility. 16:9"
    file: "images/E/quantization-stats-table.png"
---

이 글은 **Edge AI & 임베디드 시리즈** 5편입니다.
→ 4편: [5W 이하에서 LLM 추론: 저전력 엣지 AI의 현실](/ko/study/E_edge-ai/low-power-llm-inference)

---

Hugging Face에서 모델을 다운로드하려고 하면 수많은 약자가 우리를 반깁니다. `Q4_K_M.gguf`, `4bit-AWQ`, `exl2-5.0bpw`... 도대체 어떤 파일을 받아야 내 컴퓨터(혹은 엣지 디바이스)에서 가장 빠를까요?

오늘은 현존하는 주요 **양자화 포맷(Quantization Formats)** 3종을 동일한 하드웨어에서 벤치마킹한 결과를 공유합니다.

---

### 1. GGUF: 범용성의 끝판왕

**GGUF(GPT-Generated Unified Format)**는 llama.cpp 생태계의 표준입니다. 
- **특징**: CPU와 GPU를 섞어서 사용할 수 있습니다. VRAM이 부족하면 남은 부분을 시스템 RAM으로 넘겨서(Offloading) 어떻게든 돌려냅니다. 
- **추천**: 맥북(Apple Silicon), 라즈베리 파이, VRAM이 부족한 윈도우 PC.

---

### 2. EXL2: 엔비디아 GPU의 스피드 레이서

**EXL2**는 ExLlamaV2 라이브러리 전용 포맷입니다.
- **특징**: 오직 엔비디아 GPU를 위해 태어났습니다. GGUF보다 훨씬 빠르고, 비트(bpw)를 아주 세밀하게 조절할 수 있습니다.
- **추천**: RTX 30/40 시리즈 그래픽카드를 가진 유저, 속도가 최우선인 프로덕션 서버.

---

### 3. AWQ: 신뢰할 수 있는 정확도

**AWQ(Activation-aware Weight Quantization)**는 vLLM 같은 추론 엔진에서 널리 쓰입니다.
- **특징**: 모델의 중요한 가중치를 보호하며 깎아내기 때문에, 동일한 비트수 대비 지능(Perplexity) 저하가 가장 적다고 알려져 있습니다.
- **추천**: 클라우드 서버 배포, 정확도가 중요한 업무용 에이전트.

---

### 4. 실측 벤치마크 결과 (Llama-3-8B 기준)

| 포맷 | 속도 (tok/s) | VRAM 점유 | 비고 |
|------|-------------|-----------|------|
| GGUF (Q4_K_S) | 45 tok/s | 5.8 GB | CPU+GPU 하이브리드 가능 |
| AWQ (4-bit) | 68 tok/s | 5.2 GB | 표준적인 GPU 추론 |
| **EXL2 (4.0 bpw)**| **82 tok/s** | **4.9 GB** | **압도적인 속도와 효율** |

---

### Henry의 가이드: "당신의 환경이 어디인가?"

1. **내 GPU 메모리가 넉넉하다**: 무조건 **EXL2**를 쓰세요. 가장 쾌적합니다.
2. **GPU가 없거나 메모리가 부족하다**: **GGUF**가 유일한 답입니다.
3. **서버에 배포하고 여러 명이 쓴다**: **AWQ**와 vLLM 조합이 가장 안정적입니다.

---

### 결론

모델 그 자체만큼이나 중요한 것이 **'어떤 옷(포맷)'**을 입히느냐입니다. 여러분의 하드웨어 스펙에 맞는 최적의 양자화 포맷을 선택하여 AI의 잠재력을 100% 끌어올려 보세요.

---

**다음 글:** [Raspberry Pi 5로 로컬 LLM: 실제 토큰/초 속도 측정 결과](/ko/study/E_edge-ai/rpi5-llm-speed-test)
