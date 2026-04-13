# STM32 클럭 시스템 — HSE, PLL, 클럭 트리 설정 가이드

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


![클럭 트리](/images/study/stm32/clock-tree.png)
*HSE → PLL → SYSCLK 클럭 트리*


### 3.1 클럭 소스

STM32H743에는 4가지 클럭 소스가 있다:

| 클럭 소스 | 주파수 | 정밀도 | 용도 |
|-----------|--------|--------|------|
| **HSE** (High-Speed External) | 4~50 MHz (보통 8 또는 25 MHz) | 높음 (크리스탈) | PLL 입력 → SYSCLK |
| **HSI** (High-Speed Internal) | 64 MHz 고정 | 보통 (RC 발진기) | 리셋 후 기본 클럭 |
| **LSE** (Low-Speed External) | 32.768 kHz | 높음 | RTC, 저전력 모드 |
| **LSI** (Low-Speed Internal) | 32 kHz | 낮음 | 독립 워치독 (IWDG) |

**로봇 보드에서의 선택:**
- **HSE 8MHz 크리스탈 사용 권장** → PLL을 통해 480MHz SYSCLK 생성
- LSE 32.768kHz는 선택사항 (RTC 필요 시)
- HSI는 비상용 (크리스탈 고장 시 자동 전환 가능)

### 3.2 PLL 설정: 8MHz → 480MHz 달성 경로

STM32H7에는 3개의 PLL이 있다. 메인 PLL1으로 SYSCLK을 생성한다:

```
HSE (8 MHz)
    │
    ▼
  DIVM1 = /1        ← PLL 입력 분주기
    │
    ▼
  8 MHz (PLL 입력)  ← 반드시 1~16 MHz 범위
    │
    ▼
  DIVN1 = x120      ← VCO 체배기 (곱하기)
    │
    ▼
  960 MHz (VCO)     ← VCO 범위: 192~960 MHz
    │
    ├─ DIVP1 = /2 ──→ 480 MHz ──→ SYSCLK (시스템 클럭)
    │
    ├─ DIVQ1 = /4 ──→ 240 MHz ──→ 일부 페리페럴 (FDCAN 등)
    │
    └─ DIVR1 = /2 ──→ 480 MHz ──→ (사용하지 않으면 비활성화)
```

**CubeMX에서의 설정값:**

| 파라미터 | 값 | 의미 |
|---------|-----|------|
| PLL Source | HSE | 외부 크리스탈 사용 |
| DIVM1 | 1 | 8MHz / 1 = 8MHz |
| DIVN1 | 120 | 8MHz x 120 = 960MHz (VCO) |
| DIVP1 | 2 | 960MHz / 2 = **480MHz** (SYSCLK) |
| DIVQ1 | 4 | 960MHz / 4 = 240MHz |
| DIVR1 | 2 | 960MHz / 2 = 480MHz (비활성화 가능) |

### 3.3 클럭 트리: SYSCLK에서 각 버스로 분배

```
SYSCLK (480 MHz)
    │
    ▼
  D1CPRE = /1
    │
    ▼
  CPU 클럭 = 480 MHz
    │
    ├── HPRE = /2 ──→ AHB 클럭 = 240 MHz
    │                    │
    │                    ├── D1PPRE = /2 ──→ APB3 = 120 MHz (타이머는 x2 = 240 MHz)
    │                    │
    │                    ├── D2PPRE1 = /2 ──→ APB1 = 120 MHz (타이머는 x2 = 240 MHz)
    │                    │                      └── TIM2-7, TIM12-14
    │                    │                      └── USART2/3, UART4/5/7/8
    │                    │                      └── SPI2/3, I2C1-3
    │                    │                      └── **FDCAN1/2**
    │                    │
    │                    ├── D2PPRE2 = /2 ──→ APB2 = 120 MHz (타이머는 x2 = 240 MHz)
    │                    │                      └── TIM1, TIM8, TIM15-17
    │                    │                      └── USART1/6
    │                    │                      └── SPI1/4/5
    │                    │                      └── ADC1/2
    │                    │
    │                    └── D3PPRE = /2 ──→ APB4 = 120 MHz
    │                                        └── I2C4, SPI6
    │                                        └── EXTI, RTC
    │
    └── SysTick = 480 MHz (기본) 또는 AHB/8
```

**핵심 정리:**

| 버스 | 주파수 | 타이머 클럭 | 연결된 주요 페리페럴 |
|------|--------|------------|---------------------|
| CPU | 480 MHz | — | Cortex-M7 코어 |
| AHB | 240 MHz | — | DMA, GPIO, Flash |
| APB1 | 120 MHz | 240 MHz | FDCAN, UART4/5/7/8, SPI2/3, TIM2-7 |
| APB2 | 120 MHz | 240 MHz | USART1/6, SPI1, ADC1/2, TIM1/8 |
| APB3 | 120 MHz | — | LTDC |
| APB4 | 120 MHz | — | I2C4, SPI6 |

> 🔴 **중요**: APB 버스에 연결된 **타이머**는 APB 분주 비율이 1이 아닌 경우 자동으로 **x2** 된다.
> APB1 = 120MHz이고 분주비 /2이므로, TIM2~7의 실제 클럭은 240MHz이다.

### 3.4 CubeMX 클럭 설정 실전

![CubeMX 클럭 설정](/images/study/stm32/cubemx-clock.png)
*CubeMX Clock Configuration 탭 설정 화면*

CubeMX의 Clock Configuration 탭에서:

1. **좌측**: HSE → PLL Source Mux에서 "HSE" 선택
2. **가운데**: PLL1 파라미터 입력 (DIVM=1, N=120, P=2, Q=4)
3. **System Clock Mux**: "PLLCLK" 선택
4. **우측**: 각 버스 분주기가 자동 설정됨
5. **확인**: "Resolve Clock Issues" 버튼으로 문제 없는지 확인

> CubeMX가 빨간색으로 표시하면 주파수가 최대값을 초과한 것이다.
> 이 경우 분주기를 조절하여 각 버스의 최대 주파수 이하로 맞춘다.

---

이전 글: [STM32 핀 시스템](/ko/study/stm32-pin-system) | 다음 글: [STM32 GPIO 설정](/ko/study/stm32-gpio)