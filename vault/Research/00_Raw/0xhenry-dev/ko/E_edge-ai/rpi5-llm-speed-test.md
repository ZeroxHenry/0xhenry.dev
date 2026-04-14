---
title: "Raspberry Pi 5로 로컬 LLM: 실제 토큰/초 속도 측정 결과"
date: 2026-04-14
draft: false
tags: ["Raspberry Pi 5", "LLM", "Ollama", "LlamaCP", "벤치마크", "EdgeAI"]
description: "라즈베리 파이 5에서도 챗봇을 돌릴 수 있을까요? 8GB RAM 모델을 활용해 Llama-3, Phi-3, Gemma 등 최신 모델들의 실측 속도를 측정해 봤습니다. 실사용 가능 여부의 기준을 제시합니다."
author: "Henry"
categories: ["Edge AI"]
series: ["Edge AI & 임베디드 시리즈"]
series_order: 6
images_needed:
  - position: "hero"
    prompt: "A Raspberry Pi 5 board with a small fan spinning fast. A digital speech bubble above it contains complex AI logic symbols. Dark mode #0d1117, 16:9"
    file: "images/E/rpi5-llm-speed-test-hero.png"
---

이 글은 **Edge AI & 임베디드 시리즈** 6편입니다.
→ 5편: [GGUF vs EXL2 vs AWQ: 양자화 포맷 실제 성능 비교](/ko/study/E_edge-ai/quantization-format-benchmark)

---

"라즈베리 파이에서 LLM이 돌아가나요?"라는 질문을 정말 많이 받습니다. 결론부터 말씀드리면 **"돌아는 가지만 모델 선택이 핵심이다"**입니다. 

오늘은 라즈베리 파이 5 (8GB) 환경에서 가장 대중적인 도구인 **Ollama**와 **llama.cpp**를 사용하여 실측한 모델별 속도 데이터를 공개합니다.

---

### 1. 테스트 환경

- **하드웨어**: Raspberry Pi 5 (8GB RAM) + 액티브 쿨러
- **OS**: Raspberry Pi OS (64-bit)
- **도구**: Ollama (GGUF 포맷 활용)

---

### 2. 모델별 실측 속도 (Tokens per second)

| 모델 이름 | 파라미터 수 | 속도 (tok/s) | 체감 성능 |
|-----------|------------|--------------|-----------|
| **TinyLlama** | 1.1B | 12.5 tok/s | 매우 빠름 (실시간 대화 가능) |
| **Phi-3-Mini** | 3.8B | 3.2 tok/s | 느림 (읽으면서 기다릴 만함) |
| **Llama-3-8B** | 8B | 1.5 tok/s | 매우 느림 (업무용으로는 불합격) |
| **Gemma-2B** | 2B | 6.8 tok/s | 양호 (단순 응답용으로 적합) |

---

### 3. 왜 이렇게 느릴까? (메모리 대역폭의 한계)

라즈베리 파이 5의 CPU(Cortex-A76)는 훌륭하지만, AI 연산의 핵심인 **메모리 대역폭**이 데스크톱이나 전용 NPU 보드보다 훨씬 좁습니다. 모델 파일(수 GB)을 메모리에서 지속적으로 읽어와야 하는 LLM 특성상 이 대역폭이 병목 현상을 일으키는 것입니다.

---

### 4. Henry의 활용 레시피

라즈베리 파이 5를 AI 에이전트로 쓰고 싶다면 이렇게 하세요.
1. **모델**: 지능과 속도의 타협점인 **Phi-3(3.8B)** 또는 **Gemma(2B)**를 쓰세요.
2. **역할**: 복잡한 추론보다는 **'텍스트 요약'**이나 **'JSON 데이터 추출'** 같은 단발성 업무를 시키세요.
3. **최적화**: 백그라운드 프로세스를 모두 끄고, 오직 `llama.cpp`만 띄워서 자원을 몰아주세요.

---

### 결론

라즈베리 파이 5는 '개인용 챗봇'으로는 부족할 수 있지만, 특정 명령을 수행하는 **'엣지 AI 에이전트'**로서는 충분히 가치가 있습니다. 8GB 램 모델을 가지고 계신다면 지금 바로 Ollama를 설치하고 1.1B 모델부터 돌려보세요. 생각보다 신기한 경험이 될 것입니다.

---

**다음 글:** [ROS 2 + AI 에이전트: 로봇의 두뇌를 LLM으로 교체한 실험](/ko/study/E_edge-ai/ros2-llm-agent)
