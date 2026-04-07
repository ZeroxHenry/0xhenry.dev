---
title: "STM32 GPIO 설정 — Push-Pull, Open-Drain, 속도, 풀업/풀다운"
date: 2026-04-06
draft: false
tags: ["stm32", "gpio", "embedded"]
description: "STM32 GPIO 모드(Input/Output/AF/Analog), Push-Pull vs Open-Drain, 속도 설정, 풀업/풀다운 완전 정리."
author: "Henry"
categories: ["STM32 로봇 보드 개발"]
---

## GPIO 설정 상세

![GPIO 4가지 모드](/images/study/stm32/gpio-modes.png)
*GPIO Input/Output/AF/Analog 모드 비교 — Gemini로 생성 필요*


### 4.1 GPIO 4가지 모드

모든 GPIO 핀은 4가지 모드 중 하나로 설정된다:

| 모드 | MODER 값 | 설명 | 사용 예시 |
|------|---------|------|----------|
| **Input** | 00 | 외부 신호 읽기 | 버튼, 모터 에러 핀, 인터럽트 입력 |
| **Output** | 01 | 신호 내보내기 | LED, 모터 Enable, Motor Stop |
| **Alternate Function** | 10 | 페리페럴에 핀 연결 | UART TX/RX, SPI, CAN, PWM |
| **Analog** | 11 | 아날로그 입출력 | ADC 입력 (토크센서, 각도센서), DAC |

### 4.2 Output Type: Push-Pull vs Open-Drain

![Push-Pull vs Open-Drain](/images/study/stm32/push-pull-od.png)
*Push-Pull과 Open-Drain 출력 비교*

Output 또는 AF 모드에서 출력 타입을 선택한다:

**Push-Pull (PP):**
```
VDD ─── [P-FET] ─┬── 핀 출력
                  │
GND ─── [N-FET] ─┘

출력 HIGH → P-FET ON, N-FET OFF → VDD 출력 (3.3V)
출력 LOW  → P-FET OFF, N-FET ON → GND 출력 (0V)
```
- 능동적으로 HIGH/LOW 모두 구동
- **대부분의 경우 Push-Pull 사용** (LED, SPI, UART TX, PWM 등)

**Open-Drain (OD):**
```
         ┌── 외부 풀업 저항 ── VDD (또는 5V!)
핀 출력 ──┤
         └── [N-FET] ── GND

출력 LOW  → N-FET ON → GND 출력
출력 HIGH → N-FET OFF → 풀업 저항에 의해 VDD로 올라감
```
- LOW만 능동 구동, HIGH는 외부 풀업에 의존
- **I2C 통신에 필수** (SDA/SCL)
- **레벨 시프팅**: 3.3V MCU에서 5V 장치와 통신 시 사용

### 4.3 Pull 설정

| 설정 | 효과 | 사용 시기 |
|------|------|----------|
| **No Pull** | 풀업/풀다운 없음 | AF 모드 (페리페럴이 제어), 외부 풀업/풀다운 있을 때 |
| **Pull-Up** | 내부 ~40kΩ 저항으로 VDD 연결 | 버튼 입력 (액티브 로우), UART RX 유휴 상태 |
| **Pull-Down** | 내부 ~40kΩ 저항으로 GND 연결 | 플로팅 방지, 기본값 LOW 필요 시 |

### 4.4 출력 속도

| 속도 | 최대 주파수 | 사용 시기 |
|------|-----------|----------|
| **Low** | ~12 MHz | GPIO 토글 (LED), 저속 신호 |
| **Medium** | ~60 MHz | UART, I2C |
| **High** | ~85 MHz | SPI, SDMMC |
| **Very High** | ~100 MHz | 고속 SPI, FMC |

> ⚠️ **규칙**: 필요한 최소 속도를 선택한다. 속도가 높을수록 EMI(전자파 간섭)가 증가하고 소비전류가 늘어난다.
> - LED, Enable 핀 → Low
> - CAN, UART → Medium
> - SPI → High 또는 Very High

### 4.5 HAL 라이브러리로 GPIO 설정

CubeMX가 자동 생성하는 코드의 구조:

```c
/* Core/Src/main.c — MX_GPIO_Init() 함수 내부 */

static void MX_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    /* GPIO 포트 클럭 활성화 */
    __HAL_RCC_GPIOA_CLK_ENABLE();
    __HAL_RCC_GPIOB_CLK_ENABLE();
    __HAL_RCC_GPIOC_CLK_ENABLE();
    __HAL_RCC_GPIOD_CLK_ENABLE();
    __HAL_RCC_GPIOE_CLK_ENABLE();

    /* === 예시 1: LED 출력 (PB0) === */
    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_RESET);  // 초기값 LOW
    GPIO_InitStruct.Pin   = GPIO_PIN_0;
    GPIO_InitStruct.Mode  = GPIO_MODE_OUTPUT_PP;    // Output Push-Pull
    GPIO_InitStruct.Pull  = GPIO_NOPULL;            // 풀업/풀다운 없음
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;    // 저속 (LED니까)
    HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);

    /* === 예시 2: 버튼 입력 + 인터럽트 (PC13) === */
    GPIO_InitStruct.Pin   = GPIO_PIN_13;
    GPIO_InitStruct.Mode  = GPIO_MODE_IT_FALLING;   // 하강 에지 인터럽트
    GPIO_InitStruct.Pull  = GPIO_PULLUP;             // 내부 풀업
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

    /* EXTI 인터럽트 활성화 */
    HAL_NVIC_SetPriority(EXTI15_10_IRQn, 5, 0);
    HAL_NVIC_EnableIRQ(EXTI15_10_IRQn);

    /* === 예시 3: 모터 Enable 핀 (PD3) === */
    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_3, GPIO_PIN_RESET);
    GPIO_InitStruct.Pin   = GPIO_PIN_3;
    GPIO_InitStruct.Mode  = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull  = GPIO_PULLDOWN;           // 기본 OFF (안전)
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOD, &GPIO_InitStruct);
}
```

### 4.6 GPIO 제어 함수

```c
/* 핀 출력 HIGH */
HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_SET);

/* 핀 출력 LOW */
HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_RESET);

/* 핀 토글 */
HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0);

/* 핀 읽기 */
GPIO_PinState state = HAL_GPIO_ReadPin(GPIOC, GPIO_PIN_13);
if (state == GPIO_PIN_SET) {
    // HIGH 상태
}
```

### 4.7 실습: LED 깜빡이기 (첫 번째 테스트)

보드를 만들고 가장 먼저 해야 할 테스트:

```c
/* Core/Src/main.c */

/* USER CODE BEGIN Includes */
/* USER CODE END Includes */

int main(void)
{
    HAL_Init();
    SystemClock_Config();
    MX_GPIO_Init();

    /* USER CODE BEGIN 2 */
    // (추가 초기화 코드)
    /* USER CODE END 2 */

    while (1)
    {
        /* USER CODE BEGIN 3 */
        HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0);  // LED 토글
        HAL_Delay(500);                           // 500ms 대기
        /* USER CODE END 3 */
    }
}
```

> LED가 0.5초 간격으로 깜빡이면 다음을 확인한 것이다:
> 1. 전원이 정상 (VDD 3.3V)
> 2. 클럭이 정상 (HSE → PLL → SYSCLK)
> 3. GPIO가 정상 (출력 동작)
> 4. HAL 라이브러리가 정상 (HAL_Delay 동작 = SysTick 정상)
> 5. 플래시 프로그래밍이 정상 (코드가 실행됨)

---

이전 글: [STM32 클럭 시스템](/ko/study/stm32-clock-system) | 다음 글: [STM32 핵심 페리페럴](/ko/study/stm32-peripherals)
