---
title: "STM32CubeMX 실전 설정 — 프로젝트 생성부터 코드 생성까지"
date: 2026-04-06
draft: false
tags: ["stm32", "cubemx", "hal"]
description: "STM32CubeMX로 클럭, 핀, 페리페럴을 설정하고 HAL 프로젝트를 생성하는 실전 과정."
author: "Henry"
categories: ["STM32 로봇 보드 개발"]
---

## STM32CubeMX 실전 설정 과정

![CubeMX 핀 설정 화면](/images/study/stm32/cubemx-pinout.png)
*CubeMX 핀 설정 화면 — 스크린샷 또는 Gemini로 생성 필요*


CubeMX는 STM32의 핀 배치, 클럭, 페리페럴을 GUI로 설정하고 초기화 코드를 자동 생성하는 도구이다.
STM32CubeIDE에 내장되어 있다.

### Step 1: 프로젝트 생성 & 칩 선택

1. STM32CubeIDE → **File** → **New** → **STM32 Project**
2. **MCU/MPU Selector** 탭에서 검색: `STM32H743VITx`
3. 칩 선택 후 **Next**
4. Project Name: `AR_Walker_STM32` (또는 `H-Walker_STM32_Test`)
5. Targeted Language: **C**
6. Targeted Binary Type: **Executable**
7. Targeted Project Type: **STM32Cube**
8. **Finish** → `.ioc` 파일이 열리며 핀 설정 화면 표시

### Step 2: 핀 할당 (Pinout & Configuration)

`.ioc` 에디터의 칩 그래픽에서 핀을 클릭하여 기능을 할당한다.

**설정 순서 (권장):**

1. **디버그 핀 확보**: System Core → SYS → Debug: **Serial Wire** (PA13/PA14 자동 할당)
2. **클럭 소스**: System Core → RCC → HSE: **Crystal/Ceramic Resonator**
3. **FDCAN1**: Connectivity → FDCAN1 → Activated
   - TX: PD1, RX: PD0 (자동 또는 수동 선택)
4. **UART (IMU)**: Connectivity → UART4 → Mode: Asynchronous
   - RX: PA1 (TX 불필요하면 비활성화)
5. **UART (디버그)**: Connectivity → USART3 → Mode: Asynchronous
   - TX: PD8, RX: PD9
6. **SPI1**: Connectivity → SPI1 → Mode: Full-Duplex Master
   - SCK: PA5, MOSI: PB5, MISO: PB4 (PA6/PA7 ADC용으로 남겨두기)
7. **ADC1**: Analog → ADC1 → IN0, IN1, IN2, IN6 (또는 IN14/IN15) 활성화
   - PA0, PA1 주의: UART4 RX와 충돌 시 ADC 채널 재배치
8. **TIM1 PWM**: Timers → TIM1 → CH1: PWM Generation, CH2: PWM Generation
   - CH1: PE9, CH2: PE11
9. **GPIO 출력**: 각 핀을 클릭 → GPIO_Output 선택
   - LED, Motor Enable, Motor Stop 핀들
10. **GPIO 입력**: 모터 에러 핀 등

**핀 충돌 확인:**
- CubeMX에서 핀이 **노란색** = 경고 (대체 가능)
- **빨간색** = 충돌 (해결 필수)
- 좌측 패널에서 **"Pinout Conflict"** 메시지 확인

### Step 3: 클럭 설정 (Clock Configuration)

1. 상단 탭에서 **Clock Configuration** 클릭
2. 좌측 Input frequency: **8** (MHz, 사용할 크리스탈에 맞춤)
3. PLL Source Mux: **HSE** 선택
4. DIVM1: 1, DIVN1: 120, DIVP1: 2 입력
5. System Clock Mux: **PLLCLK** 선택
6. HCLK: **240 MHz** 확인 (자동 계산)
7. 각 APB 클럭이 120 MHz인지 확인
8. 빨간색 경고가 있으면 **"Resolve Clock Issues"** 버튼 클릭

### Step 4: 페리페럴 파라미터 설정

좌측 **Configuration** 패널에서 각 페리페럴의 상세 설정:

#### FDCAN1 파라미터
```
Mode                    : Normal
Frame Format            : Classic (CAN 2.0)
Auto Retransmission     : Enable
Nominal Prescaler       : 10
Nominal Sync Jump Width : 1
Nominal Time Seg1       : 5
Nominal Time Seg2       : 6
→ Bit Rate = 120MHz / (10 × (1+5+6)) = 1 Mbps
```

#### ADC1 파라미터
```
Clock Prescaler         : Asynchronous clock mode divided by 4
Resolution              : ADC 12-bit resolution (또는 16-bit)
Scan Conversion Mode    : Enable
Continuous Conv Mode    : Enable
DMA Continuous Requests : Enable
Number of Conversion    : (사용할 채널 수)
```

#### DMA 설정
각 페리페럴의 DMA Settings 탭에서:
- ADC1 → DMA Stream 추가 → Mode: **Circular**
- UART4_RX → DMA Stream 추가 → Mode: **Circular**

#### NVIC (인터럽트 우선순위)
```
인터럽트           우선순위(0=최고)  용도
FDCAN1_IT0         1               CAN 수신 (모터 응답 — 최우선)
TIM6_DAC           2               제어 루프 타이머 (500Hz)
DMA_ADCx           3               ADC 변환 완료
UART4_IRQn         4               IMU 데이터 수신
SPI1_IRQn          5               통신 MCU 데이터
EXTI_IRQn          6               GPIO 인터럽트 (에러 등)
```

### Step 5: 프로젝트 설정

1. **Project Manager** 탭 클릭
2. Project Settings:
   - Toolchain: **STM32CubeIDE**
   - Generate Under Root: 체크
3. Code Generator:
   - **"Generate peripheral initialization as a pair of '.c/.h' files per peripheral"** → 체크 (권장)
   - **"Keep User Code when re-generating"** → 체크 (필수!)
   - **"Delete previously generated files when not re-generated"** → 체크

### Step 6: 코드 생성

1. **Project** → **Generate Code** (또는 Alt+K, Cmd+K)
2. 생성되는 파일 구조:

```
AR_Walker_STM32/
├── Core/
│   ├── Inc/
│   │   ├── main.h              ← GPIO 핀 define (CubeMX 자동)
│   │   ├── stm32h7xx_hal_conf.h
│   │   └── stm32h7xx_it.h
│   └── Src/
│       ├── main.c              ← ★ 메인 코드 여기에 작성
│       ├── stm32h7xx_hal_msp.c ← 페리페럴 MSP 초기화
│       └── stm32h7xx_it.c      ← 인터럽트 핸들러
├── Drivers/
│   ├── CMSIS/                  ← ARM 코어 헤더
│   └── STM32H7xx_HAL_Driver/   ← HAL 라이브러리
└── STM32H743VITX_FLASH.ld      ← 링커 스크립트
```

### USER CODE 블록 규칙

CubeMX가 코드를 재생성해도 보존되는 영역:

```c
/* USER CODE BEGIN Includes */
#include "motor_control.h"    // ✅ 안전!
/* USER CODE END Includes */

// ❌ 여기에 쓰면 재생성 시 삭제됨!

/* USER CODE BEGIN 0 */
void my_init(void) { }        // ✅ 안전!
/* USER CODE END 0 */
```

> **최선의 방법**: `Core/Src/`에 별도 `.c` 파일을 만들어 유저 코드를 작성한다.
> 예: `motor_control.c`, `sensor_read.c`, `can_protocol.c`
> → CubeMX가 건드리지 않으므로 100% 안전.
> (자세한 내용은 [README.md](README.md)의 "자동 생성 코드와 유저 코드 관리" 섹션 참고)

---

이전 글: [STM32 핵심 페리페럴](/ko/study/stm32-peripherals) | 다음 글: [STM32 핀 매핑 전략](/ko/study/stm32-pin-mapping)
