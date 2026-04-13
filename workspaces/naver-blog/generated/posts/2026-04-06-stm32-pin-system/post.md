# STM32 핀 시스템 완전 정복 — AF, GPIO 포트, 핀맵

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


![LQFP-100 핀아웃](/images/study/stm32/lqfp100-pinout.png)
*STM32H743VITx LQFP-100 핀아웃 다이어그램*


### 2.1 물리적 핀 vs GPIO 포트

STM32의 핀 시스템을 이해하려면 두 가지 "핀 번호"의 차이를 알아야 한다:

1. **물리적 핀 번호**: IC 패키지의 다리 번호 (LQFP-100: 1번~100번)
2. **GPIO 포트 이름**: PA0, PB3, PC13 등 소프트웨어에서 사용하는 이름

**GPIO 포트 명명 규칙:**

```
P + [포트 문자] + [핀 번호]
│    │              │
│    A~K            0~15
│    (포트 그룹)    (그룹 내 핀 번호)
GPIO
```

예시:
- `PA0` = Port A, Pin 0
- `PB7` = Port B, Pin 7
- `PD1` = Port D, Pin 1

STM32H743VITx (LQFP-100)에서 사용 가능한 GPIO 포트:

| 포트 | 사용 가능한 핀 | 비고 |
|------|---------------|------|
| GPIOA | PA0~PA15 | 16핀 전부 사용 가능 |
| GPIOB | PB0~PB15 | 16핀 전부 사용 가능 |
| GPIOC | PC0~PC13 | 14핀 (PC14/15는 OSC32) |
| GPIOD | PD0~PD15 | 16핀 전부 사용 가능 |
| GPIOE | PE0~PE15 | 16핀 전부 사용 가능 |

> ⚠️ **주의**: LQFP-100 패키지에서는 GPIOF~GPIOK는 사용 불가 (핀이 없음).
> 144핀 이상의 패키지에서만 사용 가능.

### 2.2 LQFP-100 핀 번호와 GPIO 매핑

LQFP-100 패키지에서 물리적 핀 번호와 GPIO 이름의 매핑 (STM32H743VITx 기준):

```
                      핀 76~100 (상단)
                ┌──────────────────────┐
                │  76 77 78 ... 99 100 │
        핀      │                      │  핀
       51~75    │                      │  1~25
       (우측)   │    STM32H743VITx     │  (좌측)
                │      LQFP-100        │
                │                      │
                │  51 50 49 ... 27 26  │
                └──────────────────────┘
                      핀 26~50 (하단)
```

**주요 핀 매핑 (자주 사용하는 것들):**

| 물리 핀 | GPIO | 주요 기능 | AF 예시 |
|---------|------|----------|---------|
| 14 | PA0 | ADC1_IN0, TIM2_CH1 | AF1(TIM2), AF-(Analog) |
| 15 | PA1 | ADC1_IN1, TIM2_CH2 | AF1(TIM2), AF-(Analog) |
| 16 | PA2 | ADC1_IN2, USART2_TX | AF7(USART2), AF-(Analog) |
| 17 | PA3 | ADC1_IN3, USART2_RX | AF7(USART2), AF-(Analog) |
| 20 | PA4 | ADC1_IN4, SPI1_NSS, DAC1_OUT1 | AF5(SPI1) |
| 21 | PA5 | ADC1_IN5, SPI1_SCK, DAC1_OUT2 | AF5(SPI1) |
| 22 | PA6 | ADC1_IN6, SPI1_MISO, TIM3_CH1 | AF5(SPI1) |
| 23 | PA7 | ADC1_IN7, SPI1_MOSI, TIM3_CH2 | AF5(SPI1) |
| 68 | PA8 | TIM1_CH1, MCO1 | AF1(TIM1), AF0(MCO1) |
| 69 | PA9 | USART1_TX, TIM1_CH2 | AF7(USART1) |
| 70 | PA10 | USART1_RX, TIM1_CH3 | AF7(USART1) |
| 71 | PA11 | USB_OTG_FS_DM, FDCAN1_RX | AF9(FDCAN1) |
| 72 | PA12 | USB_OTG_FS_DP, FDCAN1_TX | AF9(FDCAN1) |
| 76 | PA13 | **SWDIO** (디버거) | 디버깅 전용 — 변경 금지! |
| 77 | PA14 | **SWCLK** (디버거) | 디버깅 전용 — 변경 금지! |
| 78 | PA15 | SPI3_NSS, TIM2_CH1 | AF6(SPI3) |
| 35 | PB0 | ADC1_IN8, TIM3_CH3 | AF2(TIM3) |
| 36 | PB1 | ADC1_IN9, TIM3_CH4 | AF2(TIM3) |
| 37 | PB2 | QUADSPI_CLK | AF9(QUADSPI) |
| 89 | PB3 | SPI3_SCK, TIM2_CH2 | AF6(SPI3) |
| 90 | PB4 | SPI3_MISO, TIM3_CH1 | AF6(SPI3) |
| 91 | PB5 | SPI3_MOSI, FDCAN2_RX | AF6(SPI3), AF9(FDCAN2) |
| 92 | PB6 | USART1_TX, FDCAN2_TX, I2C1_SCL | AF7(USART1), AF9(FDCAN2) |
| 93 | PB7 | USART1_RX, I2C1_SDA | AF7(USART1), AF4(I2C1) |
| 95 | PB8 | FDCAN1_RX, I2C1_SCL, TIM4_CH3 | AF9(FDCAN1), AF4(I2C1) |
| 96 | PB9 | FDCAN1_TX, I2C1_SDA, TIM4_CH4 | AF9(FDCAN1), AF4(I2C1) |
| 47 | PB10 | USART3_TX, I2C2_SCL, TIM2_CH3 | AF7(USART3) |
| 48 | PB11 | USART3_RX, I2C2_SDA, TIM2_CH4 | AF7(USART3) |
| 51 | PB12 | SPI2_NSS, USART3_CK | AF5(SPI2) |
| 52 | PB13 | SPI2_SCK, FDCAN2_TX | AF5(SPI2), AF9(FDCAN2) |
| 53 | PB14 | SPI2_MISO, USART3_RTS | AF5(SPI2) |
| 54 | PB15 | SPI2_MOSI, TIM12_CH2 | AF5(SPI2) |
| 8 | PC0 | ADC1_IN10 | AF-(Analog) |
| 9 | PC1 | ADC1_IN11 | AF-(Analog) |
| 10 | PC2 | ADC1_IN12, SPI2_MISO | AF5(SPI2) |
| 11 | PC3 | ADC1_IN13, SPI2_MOSI | AF5(SPI2) |
| 33 | PC4 | ADC1_IN14 | AF-(Analog) |
| 34 | PC5 | ADC1_IN15 | AF-(Analog) |
| 63 | PC6 | USART6_TX, TIM8_CH1 | AF7(USART6) |
| 64 | PC7 | USART6_RX, TIM8_CH2 | AF7(USART6) |
| 65 | PC8 | TIM8_CH3, SDMMC1_D0 | AF3(TIM8) |
| 66 | PC9 | TIM8_CH4, SDMMC1_D1 | AF3(TIM8) |
| 67 | PC10 | USART3_TX, SPI3_SCK | AF7(USART3) |
| 79 | PC11 | USART3_RX, SPI3_MISO | AF7(USART3) |
| 80 | PC12 | SPI3_MOSI, UART5_TX | AF6(SPI3) |
| 7 | PC13 | RTC_TAMP, WKUP | 범용 GPIO |
| 82 | PD0 | FDCAN1_RX, FMC_D2 | AF9(FDCAN1) |
| 83 | PD1 | FDCAN1_TX, FMC_D3 | AF9(FDCAN1) |
| 84 | PD2 | UART5_RX, TIM3_ETR | AF8(UART5) |
| 85 | PD3 | USART2_CTS, FMC_CLK | AF7(USART2) |
| 86 | PD4 | USART2_RTS, FMC_NOE | AF7(USART2) |
| 87 | PD5 | USART2_TX, FMC_NWE | AF7(USART2) |
| 88 | PD6 | USART2_RX, FMC_NWAIT | AF7(USART2) |
| 55 | PD8 | USART3_TX | AF7(USART3) |
| 56 | PD9 | USART3_RX | AF7(USART3) |
| 100 | PE0 | UART8_RX, TIM4_ETR | AF8(UART8) |
| 1 | PE1 | UART8_TX | AF8(UART8) |
| 2 | PE2 | SPI4_SCK, UART8_TX | AF5(SPI4) |
| 98 | PE9 | TIM1_CH1, FMC_D6 | **AF1(TIM1)** — PWM용 |
| 99 | PE11 | TIM1_CH2, FMC_D8 | **AF1(TIM1)** — PWM용 |

### 2.3 핀 기능 분류

LQFP-100의 100개 핀은 크게 4종류로 나뉜다:

| 분류 | 핀 | 개수 | 설명 |
|------|-----|------|------|
| **전원** | VDD, VSS, VDDA, VSSA, VREF+, VCAP | ~18개 | 전원 공급 (3.3V, GND) |
| **클럭** | OSC_IN, OSC_OUT (PH0/PH1) | 2개 | 외부 크리스탈 연결 |
| **리셋** | NRST | 1개 | 시스템 리셋 (액티브 로우) |
| **디버그** | PA13 (SWDIO), PA14 (SWCLK) | 2개 | SWD 디버거 전용 |
| **부트** | BOOT0 | 1개 | 부트 모드 선택 |
| **GPIO** | PA0~PE15 | ~76개 | 범용 입출력 + AF |

> 🔴 **절대 규칙**: PA13/PA14는 SWD 디버거 핀이다. 이 핀을 다른 용도로 사용하면 디버깅/프로그래밍이 불가능해진다. 반드시 SWD 전용으로 남겨둘 것!

### 2.4 Alternate Function (AF) 시스템

STM32에서 가장 중요한 개념 중 하나. 하나의 GPIO 핀이 최대 16가지 다른 기능을 수행할 수 있다.

**AF 번호 체계 (AF0 ~ AF15):**

| AF 번호 | 주요 기능 |
|---------|----------|
| AF0 | SYS (MCO, SWD, TRACE) |
| AF1 | TIM1, TIM2 |
| AF2 | TIM3, TIM4, TIM5 |
| AF3 | TIM8, TIM15-17 |
| AF4 | I2C1-4 |
| AF5 | SPI1-6 |
| AF6 | SPI2/3, SAI1/2 |
| AF7 | USART1-3, USART6 |
| AF8 | UART4/5, UART7/8, LPUART1 |
| AF9 | FDCAN1/2, QUADSPI, TIM12-14 |
| AF10 | USB OTG, SAI2 |
| AF11 | ETH, UART7 |
| AF12 | FMC, SDMMC, MDIOS |
| AF13 | DCMI, COMP |
| AF14 | LTDC, UART5 |
| AF15 | EVENTOUT |

![AF 멀티플렉서](/images/study/stm32/af-mux.png)
*AF0~AF15 멀티플렉서 — 하나의 핀에 16가지 기능 선택*

**AF 사용 예시 — PA7 핀:**

PA7에는 다음 기능들이 할당 가능:
- AF0: MCO (마이크로컨트롤러 클럭 출력)
- AF2: TIM3_CH2 (타이머3 채널2 = PWM 출력)
- AF5: SPI1_MOSI (SPI1 마스터 출력)
- Analog: ADC1_IN7 (아날로그 입력)

**한 번에 하나의 AF만 선택 가능!** 만약 PA7을 SPI1_MOSI로 사용하면 이 핀에서 ADC나 TIM3는 동시에 사용할 수 없다.

**AF 충돌 예방법:**
1. 필요한 페리페럴 목록 작성 (CAN, UART, SPI, ADC, PWM 등)
2. 각 페리페럴의 핀 옵션 확인 (데이터시트 Table 9-12)
3. AF가 겹치지 않도록 핀 배치 → CubeMX가 자동으로 충돌 검사해줌

### 2.5 핀 설정 레지스터

각 GPIO 핀은 다음 레지스터들로 제어된다:

```
레지스터          비트 수/핀    기능
──────────────────────────────────────────────
GPIOx_MODER      2비트/핀     모드 선택
                              00 = Input
                              01 = Output
                              10 = Alternate Function
                              11 = Analog

GPIOx_OTYPER     1비트/핀     출력 타입
                              0 = Push-Pull
                              1 = Open-Drain

GPIOx_OSPEEDR    2비트/핀     출력 속도
                              00 = Low (최대 12MHz)
                              01 = Medium (최대 60MHz)
                              10 = High (최대 85MHz)
                              11 = Very High (최대 100MHz)

GPIOx_PUPDR      2비트/핀     풀업/풀다운
                              00 = No Pull
                              01 = Pull-Up
                              10 = Pull-Down
                              11 = Reserved

GPIOx_AFRL       4비트/핀     AF 선택 (핀 0~7)
GPIOx_AFRH       4비트/핀     AF 선택 (핀 8~15)
                              0000 = AF0
                              0001 = AF1
                              ...
                              1111 = AF15
```

**레지스터 직접 조작 예시 (PA7을 SPI1_MOSI AF5로 설정):**

```c
// 1. GPIOA 클럭 활성화
RCC->AHB4ENR |= RCC_AHB4ENR_GPIOAEN;

// 2. PA7을 Alternate Function 모드로 설정
GPIOA->MODER &= ~(0x3 << (7 * 2));     // 비트 클리어
GPIOA->MODER |=  (0x2 << (7 * 2));     // 10 = AF 모드

// 3. AF5 (SPI1) 선택 — PA7은 핀 0~7이므로 AFRL 사용
GPIOA->AFR[0] &= ~(0xF << (7 * 4));    // 비트 클리어
GPIOA->AFR[0] |=  (0x5 << (7 * 4));    // AF5 = SPI1

// 4. Push-Pull, Very High Speed
GPIOA->OTYPER &= ~(1 << 7);            // Push-Pull
GPIOA->OSPEEDR |= (0x3 << (7 * 2));    // Very High Speed
```

> **실무에서는 HAL 라이브러리를 사용하므로 레지스터를 직접 다룰 일은 드물다.**
> 하지만 레지스터 구조를 이해하면 디버깅 시 레지스터 값을 읽고 문제를 진단할 수 있다.

### 2.6 데이터시트에서 핀 정보 찾는 법

STM32H743VITx의 핀 정보를 찾으려면 두 문서가 필요하다:

| 문서 | 내용 | 찾을 정보 |
|------|------|----------|
| **Datasheet** (DS12110) | 핀아웃, 전기적 특성, 패키지 | 물리적 핀 번호, AF 테이블, 전압/전류 스펙 |
| **Reference Manual** (RM0433) | 레지스터, 페리페럴 동작 | GPIO 레지스터, 타이머 설정, CAN 프로토콜 등 |

**데이터시트에서 핵심적으로 봐야 할 섹션:**
- **Table 9~12**: "Alternate function mapping" — 각 핀의 AF0~AF15 매핑 전체 표
- **Figure 1**: LQFP-100 핀아웃 다이어그램
- **Table 7**: "Pin definitions" — 각 핀의 전원/IO 타입, 5V 톨러런트 여부

> 💡 **팁**: CubeMX를 사용하면 이 테이블을 GUI로 편하게 볼 수 있지만,
> 데이터시트를 직접 읽는 습관을 들이면 하드웨어 설계 시 큰 도움이 된다.

---

이전 글: [STM32 아키텍처 기초](/ko/study/stm32-architecture) | 다음 글: [STM32 클럭 시스템](/ko/study/stm32-clock-system)