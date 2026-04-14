# E_edge-ai — 이미지 프롬프트 가이드
# P_career — 이미지 프롬프트 가이드
# M_models — 이미지 프롬프트 가이드
# U_ux-design — 이미지 프롬프트 가이드

> **공통 스타일**: Dark background #0d1117, electric blue #58a6ff accent, 16:9 ratio

---

# ── E: EDGE AI & EMBEDDED ────────────────────────────────────────────────────

## E-01: stm32-architecture.md

### 이미지 1 — STM32 내부 아키텍처
```
프롬프트:
"STM32 microcontroller internal architecture diagram:
Center: ARM Cortex-M4 Core (blue box, labeled: 32-bit, 168MHz, FPU)
Connected components:
- Flash Memory (green): 512KB, stores firmware
- SRAM (orange): 128KB, runtime data
- APB1/APB2 Buses (gray lines): peripheral connections
- Peripherals (bottom row): USART, SPI, I2C, TIM, ADC, GPIO, DAC
Clock tree simplified: HSE (external) → PLL → SYSCLK distributing to buses
Professional embedded systems diagram style. Dark background (#0d1117), colored blocks, 16:9"

파일명: images/E/stm32-architecture.png
```

### 이미지 2 — STM32 vs Arduino 비교 (입문자용)
```
프롬프트:
"Hardware comparison table as infographic:
Rows: Platform, Core, Speed, Flash, SRAM, GPIO, Price, Best For
Arduino Uno: ATmega328P, 8-bit, 16MHz, 32KB, 2KB, 14 pins, $5, beginner projects
STM32F4: ARM Cortex-M4, 32-bit, 168MHz, 512KB, 128KB, up to 140 pins, $8-15, professional embedded
Bar charts showing performance ratios (STM32 dramatically leads).
Dark background, comparison-focused, 16:9"

파일명: images/E/stm32-vs-arduino.png
```

---

## E-02: stm32-bringup.md

### 이미지 1 — Bring-up 체크리스트 다이어그램
```
프롬프트:
"Hardware bring-up checklist visualization as a vertical numbered flow:
1. Power Rails Check (green ✓): 3.3V, 1.8V measured with icon of multimeter
2. Crystal/Clock Check (green ✓): oscilloscope showing clean clock waveform
3. JTAG/SWD Connection (green ✓): debug probe connected, MCU responds
4. Bootloader Flash (green ✓): firmware loaded, device enumerates
5. Peripheral Init Test (orange !): UART echoes back, SPI reads incorrect — debug needed
6. Full System Test (gray □): pending
Step 5 expanded below with error analysis. 
Dark background, engineering checklist aesthetic, 16:9"

파일명: images/E/stm32-bringup-checklist.png
```

---

## E-03: stm32-clock-system.md

### 이미지 1 — STM32 Clock Tree 다이어그램
```
프롬프트:
"STM32 clock tree diagram:
Source clocks (left column): HSI (16MHz internal RC), HSE (external crystal, up to 25MHz), LSI (32kHz), LSE (32.768kHz)
PLL block (center): HSE/HSI → PLL → SYSCLK (up to 168MHz)
Distribution (right): SYSCLK splits into:
- AHB Bus (168MHz) → Core, DMA, Flash
- APB1 Bus (/4 = 42MHz) → USART2-5, SPI2-3, I2C, TIM2-7
- APB2 Bus (/2 = 84MHz) → USART1, SPI1, ADC, TIM1/8
Clock divider values shown on each path. Professional clock tree diagram style.
White lines on dark background, clean engineering diagram, 16:9"

파일명: images/E/stm32-clock-tree.png
```

---

## E-04: stm32-cubemx.md

### 이미지 1 — CubeMX 핀 설정 워크플로우
```
프롬프트:
"STM32CubeMX workflow visualization:
Step 1: MCU selection screen (chip preview icon)
Step 2: Pinout Configuration (IC chip top-view with colored pin assignments: 
  - green = GPIO Output, blue = UART TX/RX, orange = SPI CLK/MOSI/MISO, red = power pins)
Step 3: Clock Configuration (simplified clock tree slider UI)
Step 4: Code Generation settings (language: C, IDE: STM32CubeIDE)
Step 5: Generated file tree (Src/, Inc/, Drivers/ folders shown)
Linear flow diagram with screenshots-within-diagram. Dark background, 16:9"

파일명: images/E/cubemx-workflow.png
```

---

## E-05: stm32-gpio.md

### 이미지 1 — GPIO 모드 일람표
```
프롬프트:
"GPIO mode configuration reference diagram:
4 columns: Input Modes | Output Modes | Analog | Alternate Function
Input modes (left): Floating, Pull-up, Pull-down — electrical circuit symbols for each
Output modes: Push-pull, Open-drain — transistor circuit symbols
Each mode: schematic symbol + typical use case label + register bits shown
Horizontal dividers, clean reference card style.
Dark background, electrical engineering diagram meets software documentation, 16:9"

파일명: images/E/gpio-modes.png
```

---

## E-06: quantization-gguf-exl2.md

### 이미지 1 — 양자화 비교 (BF16 vs INT8 vs INT4)
```
프롬프트:
"Quantization comparison bar chart:
Model: Llama 3 8B, X-axis: Quantization Level (BF16, Q8, Q6, Q5, Q4, Q3, Q2)
Metrics shown as grouped bars:
- Model Size (GB): BF16=16GB, Q8=8.5GB, Q6=6.1GB, Q5=5.3GB, Q4=4.1GB, Q3=3.2GB, Q2=2.2GB  
- Perplexity Score (lower=better): rises from 6.8 (BF16) to ~14.2 (Q2)
- Inference Speed tokens/sec: rises from 12 (BF16) to 48 (Q2) on same hardware
Sweet spot arrow highlighting Q4-Q5 range as best quality/speed tradeoff.
Dark background, professional benchmark chart, 16:9"

파일명: images/E/quantization-comparison.png
```

### 이미지 2 — GGUF vs EXL2 vs AWQ 포맷 비교
```
프롬프트:
"Format comparison table as visual infographic:
Three format cards side by side:
GGUF card (blue): 
  - Runtime: llama.cpp, Ollama
  - Hardware: CPU-optimized, any hardware
  - Quantization: Q2_K to Q8
  - Best for: local CPU inference, wide compatibility

EXL2 card (green):
  - Runtime: ExLlamaV2
  - Hardware: NVIDIA GPU only
  - Quantization: 2.0-8.0 bpw (arbitrary precision)  
  - Best for: maximum GPU throughput

AWQ card (orange):
  - Runtime: AutoAWQ, vLLM
  - Hardware: NVIDIA GPU
  - Quantization: INT4 optimized
  - Best for: production serving, RTX cards

Dark background, card UI style, 16:9"

파일명: images/E/gguf-exl2-awq-comparison.png
```

---

## E-07: speculative-decoding.md

### 이미지 1 — Speculative Decoding 메커니즘
```
프롬프트:
"Speculative decoding mechanism diagram:
Two models shown:
- Draft Model (small, fast, cheap): generates 5 candidate tokens in one pass
- Target Model (large, slow, accurate): verifies all 5 tokens in ONE forward pass

Timeline comparison:
Standard (top): [T=0.8s: generate token 1] [T=0.8s: token 2] [T=0.8s: token 3]... 
  → 3 tokens = 2.4 seconds

Speculative (bottom): Draft model [T=0.1s: 5 candidates] → Target [T=0.8s: verifies all 5] 
  → accept first 3 (or 4 or 5 if all correct) → repeat
  → 3-5 tokens in ~0.9 seconds = ~2.5x speedup

Timeline bars clearly showing speedup. Dark background, 16:9"

파일명: images/E/speculative-decoding.png
```

---

## E-08: zed-x-mini-jetson-setup.md

### 이미지 1 — Jetson + ZED 카메라 시스템 구성
```
프롬프트:
"Hardware system diagram: 
NVIDIA Jetson Orin (center, GPU chip icon with 'Orin NX 16GB' label)
Connected hardware:
- ZED X Mini Stereo Camera (top): depth perception, 120fps, Left/Right lens visible
- Power supply (right): DC barrel jack, power specs
- NVMe SSD (bottom): M.2 2280, high-speed storage
- USB-C hub (left): peripherals connection
Data flow arrows:
Camera → MIPI/USB3 → Jetson → GPU Processing → Depth map + RGB stream → Application
Render as technical hardware diagram with silhouettes of actual components. Dark background, 16:9"

파일명: images/E/jetson-zed-system.png
```

### 이미지 2 — Jetson 성능 벤치마크
```
프롬프트:
"Benchmark comparison chart:
Hardware platforms compared: Jetson Nano, Jetson Orin NX 16GB, Raspberry Pi 5, RTX 3060 (reference)
Tasks:
- Llama 3 1B inference (tokens/sec): Nano=0.8, Orin=12.4, RPi5=1.2, RTX3060=45.8
- YOLOv8 object detection (fps): Nano=8, Orin=62, RPi5=4, RTX3060=280
- Power consumption (watts): Nano=5W, Orin=15W, RPi5=8W, RTX3060=170W
Grouped bar chart with power efficiency annotations (tokens/watt).
Dark background, benchmark report style, 16:9"

파일명: images/E/jetson-benchmark.png
```

---

## E-09: moe-architecture-explained.md

### 이미지 1 — Mixture of Experts 구조
```
프롬프트:
"Mixture of Experts (MoE) architecture diagram:
Input token → Router/Gating Network (small neural network icon)
Router selects top-2 out of 8 experts based on token type:
- Expert 1 (Code): activated (bright blue) for 'function' token
- Expert 2 (Math): not activated (dim)
- Expert 3 (Language): not activated (dim)
- Expert 4 (Reasoning): activated (bright blue) for 'function' token
- Experts 5-8: not activated (dim)
Selected experts process token → weighted combination → output
Sparse activation shown clearly (only 2/8 = 25% active).
Dense model comparison: all parameters always active (inefficient).
Dark background, neural architecture diagram, 16:9"

파일명: images/E/moe-architecture.png
```

---

## E-10: local-finetuning-unsloth.md

### 이미지 1 — LoRA 파인튜닝 메커니즘
```
프롬프트:
"LoRA (Low-Rank Adaptation) fine-tuning diagram:
Original weight matrix W (large, frozen, gray): 4096 x 4096 = 16M parameters
LoRA low-rank decomposition:
  Matrix A (small, blue): 4096 x 16 = 65K parameters
  Matrix B (small, blue): 16 x 4096 = 65K parameters  
  ΔW = A × B = 130K parameters (0.8% of original)
During training: only A and B are updated (backprop shown in blue)
During inference: W' = W + ΔW (merge, no overhead)
Comparison: Full fine-tune = 16M trainable params | LoRA = 130K trainable params (99.2% reduction)
Dark background, linear algebra visualization, 16:9"

파일명: images/E/lora-mechanism.png
```

---

## E-11: vllm-deployment.md

### 이미지 1 — vLLM 아키텍처 (PagedAttention)
```
프롬프트:
"vLLM PagedAttention architecture diagram:
Physical GPU memory (large bar) divided into fixed-size 'pages' (small blocks).
Each active sequence gets non-contiguous pages (shown with color-coded dotted connections).
Compare:
Standard KV Cache: Each sequence claims large contiguous block. Many 'wasted' gaps between sequences.
PagedAttention: Same memory serves 3x more concurrent sequences through efficient page allocation.
Utilization bars: Standard = 42% utilization, PagedAttention = 90% utilization.
Dark background, memory management visualization, 16:9"

파일명: images/E/vllm-paged-attention.png
```

---

## E-12: client-side-ai-browser.md

### 이미지 1 — WebGPU + transformers.js 아키텍처
```
프롬프트:
"Browser-based AI inference architecture:
Traditional (top): User → ☁️ Server API → GPU cluster → response → User [high latency, data leaves device]
Client-side AI (bottom): User → Browser → WebGPU → Local GPU/CPU → Inference → Response [fast, private]
WebGPU pipeline shown:
JS code → transformers.js → ONNX Runtime Web → WebGPU compute shaders → GPU execution
Benchmark comparison: TTFT 2.1s (server) vs 3.4s (browser), tokens/sec 45 vs 8
Trade-off annotations: 'Privacy' (browser wins), 'Speed' (server wins), 'No API cost' (browser wins)
Dark background, browser-tech diagram, 16:9"

파일명: images/E/webgpu-browser-ai.png
```

---

# ── P: CAREER & PERSPECTIVE ──────────────────────────────────────────────────

## P-01: cursor-ide-lessons.md

### 이미지 1 — Cursor IDE AI 통합 기능 맵
```
프롬프트:
"Cursor IDE feature map diagram:
Central: Code Editor interface (dark IDE screenshot style)
Surrounding AI features as labeled callout boxes:
- Tab Completion (top): 'Predicts next code block, not just token'
- Ctrl+K Inline Edit (left): 'Natural language → code change in selection'
- Ctrl+L Chat (right): 'Codebase-aware conversation'
- @ Context (bottom-left): '@file, @web, @docs references'
- Composer (bottom-right): 'Multi-file changes from single prompt'
Connection lines from editor to each feature. Cursor logo in header.
Dark background, feature showcase style, 16:9"

파일명: images/P/cursor-features.png
```

### 이미지 2 — Cursor vs 기존 GitHub Copilot 비교
```
프롬프트:
"Developer productivity comparison:
X-axis: Task complexity (Simple autocomplete → Complex refactoring)
Y-axis: Time saved (minutes)
Two lines:
- GitHub Copilot (blue dashed): strong at simple tasks, plateaus quickly
- Cursor (orange solid): strong all-around, especially excels at complex multi-file tasks
Specific data points labeled:
  'Simple function': Copilot saves 2min, Cursor saves 2.5min
  'Multi-file refactor': Copilot saves 5min, Cursor saves 28min
Dark background, line chart, 16:9"

파일명: images/P/cursor-vs-copilot.png
```

---

## P-02: swe-bench-explained.md

### 이미지 1 — SWE-bench 평가 방법론
```
프롬프트:
"SWE-bench evaluation methodology diagram:
Input: Real GitHub Issues from popular Python repos (Django, Flask, scikit-learn...)
Process: AI coding agent reads issue → browses codebase → writes patches → submits PR
Evaluation: Automated test suite runs → pass/fail on official repo test cases
Scoring: % of issues where submitted patch passes all tests (Resolved Rate)
Current leaderboard bar chart (horizontal):
- Claude 3.7 Sonnet: 62.3%
- GPT-4o: 38.8%
- Human baseline: ~94%
Gap to human baseline highlighted. Dark background, benchmark methodology diagram, 16:9"

파일명: images/P/swe-bench-methodology.png
```

---

## P-03: future-of-programming-natural-language.md

### 이미지 1 — 프로그래밍 추상화 레이어의 진화
```
프롬프트:
"Historical progression of programming abstraction levels:
Timeline (left to right, each era as a layer in a pyramid growing taller):
1950s: Machine Code (binary 01010101...) — lowest level, hardest
1960s: Assembly (MOV AX, 01h) — slightly above
1970s: C (for loop, malloc) — structured programming
1990s: Python/Java (classes, garbage collection) — high level
2010s: Frameworks (React, TensorFlow) — abstraction over language
2024+: Natural Language (current block, glowing) — 'Build me a REST API that...'
Arrow showing direction: 'Increasing abstraction, decreasing precision required'
Question at top: 'What's next?'
Dark background, pyramid/timeline hybrid, 16:9"

파일명: images/P/programming-abstraction-levels.png
```

---

## P-04: frontend-developer-ai-future.md

### 이미지 1 — AI가 대체한 vs 새로 생긴 프론트엔드 업무
```
프롬프트:
"Before/After job responsibility chart for frontend developers:
LEFT 'Tasks AI now handles' (dimmed, crossed out):
- Boilerplate component generation
- CSS utility class recommendations
- Unit test scaffolding
- API response type definitions
- Repetitive form validation

RIGHT 'New tasks that emerged' (highlighted, growing):
- AI component behavior design
- Prompt engineering for UI generation
- AI output quality review
- Context Engineering for coding agents
- Human-AI collaboration design patterns

Visual: scales balancing old tasks (lighter) vs new tasks (heavier = more valuable).
Dark background, job role evolution diagram, 16:9"

파일명: images/P/frontend-ai-job-shift.png
```

---

# ── M: MODELS & ARCHITECTURE ─────────────────────────────────────────────────

## M-01: multimodal-ai-intro.md

### 이미지 1 — 멀티모달 AI 입력/출력 매트릭스
```
프롬프트:
"Multimodal AI input/output matrix:
Grid table:
Rows (Input types): Text, Image, Audio, Video, Code
Columns (Output types): Text, Image, Audio, Code, Structured data
Cells filled when model supports that combination:
- GPT-4o: Text+Image → Text, Text → Text (green checks)
- Claude 3.7: Text+Image → Text (partial)
- Gemini: Text+Image+Audio+Video → Text+Image (comprehensive)
Color coding by model. Center cell highlighted: 'True Multimodal = any-to-any'
Dark background, matrix/heatmap style, 16:9"

파일명: images/M/multimodal-matrix.png
```

---

## M-02: clip-explained.md

### 이미지 1 — CLIP 대조 학습 메커니즘
```
프롬프트:
"CLIP contrastive learning diagram:
Training phase:
- Image batch (top row): 4 images (dog, car, sunset, city)
- Text batch (left column): 4 captions ('a photo of a dog', 'red sports car', etc.)
- Similarity matrix (4x4 grid): diagonal highlighted green (matching pairs), 
  off-diagonal in red (non-matching, pushed apart)
- Image Encoder (blue ViT icon) and Text Encoder (orange transformer icon)
Inference phase (below):
Query: 'a golden retriever' → text embedding
Compare against image embeddings in database → closest = golden retriever photo
Dark background, contrastive learning visualization, 16:9"

파일명: images/M/clip-contrastive-learning.png
```

---

## M-03: whisper-diarization.md

### 이미지 1 — Whisper 파이프라인 + Speaker Diarization
```
프롬프트:
"Audio processing pipeline with speaker diarization:
Input: Audio waveform visualization (multiple speakers visible as amplitude patterns)
Step 1: Whisper STT → text transcript (raw, no speaker labels)
Step 2: Speaker Diarization (pyannote.audio) → speaker segments timeline:
  [0:00-0:15] Speaker A (blue), [0:15-0:42] Speaker B (orange), [0:42-1:05] Speaker A (blue)...
Step 3: Align transcript with diarization → labeled output:
  'Speaker A: Good morning everyone...'
  'Speaker B: Thanks for joining us today...'
Timeline visualization with colored speaker bars. Dark background, audio tech style, 16:9"

파일명: images/M/whisper-diarization.png
```

---

## M-04: vqa-llava.md

### 이미지 1 — LLaVA 아키텍처 (Vision-Language Model)
```
프롬프트:
"LLaVA (Large Language and Vision Assistant) architecture:
Input: Image + Text Question
Image path: Image → CLIP Vision Encoder → Visual embeddings → Projection Layer (MLP)
Text path: Question tokens → Tokenizer → Text embeddings
Merge: Visual embeddings projected to same space as text embeddings → concatenated
LLM (Vicuna/Mistral): processes combined sequence → generates answer
Output: Text answer about image content
Architecture diagram with labeled boxes and arrows.
Dark background, model architecture diagram, 16:9"

파일명: images/M/llava-architecture.png
```

---

# ── U: UX DESIGN ─────────────────────────────────────────────────────────────

## U-01: generative-ui-intro.md

### 이미지 1 — Generative UI 컨셉
```
프롬프트:
"Generative UI concept diagram:
Traditional UI (left, rigid): Static form fields, fixed layout, same for all users.
Code defines what UI elements appear.

Generative UI (right, fluid): User intent '도쿄 여행 계획 짜줘' typed → 
AI generates custom UI: interactive map component, date picker, budget slider, 
hotel comparison cards — all dynamically created for this specific intent.
Different user: '파이썬 코드 디버깅해줘' → AI generates code editor component with test runner.

Transformation arrow showing static → dynamic generation.
Dark background, UI mockup elements, 16:9"

파일명: images/U/generative-ui-concept.png
```

---

## U-02: v0-dev-design-systems.md

### 이미지 1 — v0.dev 워크플로우
```
프롬프트:
"v0.dev workflow diagram:
Step 1: Designer types natural language prompt: 'Create a SaaS pricing page with 3 tiers...'
Step 2: v0 generates: React + Tailwind component code + live preview side by side
Step 3: Iteration: 'Make the Pro tier highlighted with a badge' → instant update
Step 4: Options (fork paths): 
  - Export to Next.js project
  - Copy component code
  - Further refine with more prompts
Step 5: Production-ready component delivered
Before/After at bottom: Hours of manual CSS → Minutes with v0
Dark background, product workflow, 16:9"

파일명: images/U/v0-workflow.png
```

---

## U-03: ai-driven-accessibility.md

### 이미지 1 — AI 접근성 자동화 레이어
```
프롬프트:
"AI accessibility automation stack diagram:
Layer 1 'Perception' (bottom): Screen reader signals, cursor tracking, keyboard navigation events
Layer 2 'AI Analysis': User behavior pattern recognition → identify struggles
Layer 3 'Adaptation': Real-time UI modifications:
  - Font size increase for reading difficulty detection
  - High contrast mode for squinting behavior
  - Simplified layout for cognitive load indicators
  - Voice control activation on motor difficulty signals
Layer 4 'Output' (top): Personalized, adapted UI
Traditional: Same UI for everyone → AI-powered: Adaptive UI per user needs
Dark background, horizontal layer stack, 16:9"

파일명: images/U/ai-accessibility-layers.png
```
