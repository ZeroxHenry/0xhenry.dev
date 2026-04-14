---
title: "STM32 보드 브링업 — 처음 전원 넣기부터 동작 확인까지"
date: 2026-04-06
draft: false
tags: ["stm32", "bringup", "hal", "debugging"]
description: "STM32 커스텀 보드의 첫 전원 투입, LED 점멸, 페리페럴 검증, 통합 테스트까지의 브링업 과정과 HAL 함수 레퍼런스."
author: "Henry"
categories: ["STM32 로봇 보드 개발"]
---

## 보드 브링업

![보드 브링업 프로세스](/images/study/stm32/bringup-flow.png)
*보드 브링업 9단계 플로차트*

보드를 제작한 후, 페리페럴을 하나씩 테스트하며 정상 동작을 확인하는 과정이다.
**절대 모든 것을 한 번에 테스트하지 마라** — 문제 발생 시 원인을 찾을 수 없다.

### 8.1 단계별 테스트 순서

```
┌─────────────────────────────────────────────────┐
│  Step 1: 전원 확인                                │
│  → VDD, VDDA, VCAP 전압 측정                     │
│  → 쇼트 없는지 확인                               │
├─────────────────────────────────────────────────┤
│  Step 2: 클럭 확인                                │
│  → HSE 크리스탈 발진 확인                          │
│  → MCO 핀으로 클럭 출력하여 오실로스코프 측정       │
├─────────────────────────────────────────────────┤
│  Step 3: LED 테스트 (GPIO Output)                │
│  → LED 깜빡이기 = 전원+클럭+Flash+GPIO 정상       │
├─────────────────────────────────────────────────┤
│  Step 4: UART 테스트 (PC 통신)                    │
│  → printf 출력 확인                               │
│  → 양방향 에코 테스트                              │
├─────────────────────────────────────────────────┤
│  Step 5: CAN 테스트                               │
│  → 루프백 모드 (자기 자신에게 송수신)               │
│  → 외부 CAN 장치 연결 테스트                       │
├─────────────────────────────────────────────────┤
│  Step 6: SPI 테스트                               │
│  → 로직 분석기로 SCK/MOSI 파형 확인                │
│  → Coms MCU와 데이터 교환                         │
├─────────────────────────────────────────────────┤
│  Step 7: ADC 테스트                               │
│  → 알려진 전압 (예: 1.65V) 입력 후 읽기            │
│  → 모든 채널 순차 확인                             │
├─────────────────────────────────────────────────┤
│  Step 8: PWM 테스트                               │
│  → 오실로스코프로 주파수/듀티 확인                  │
│  → 모터 드라이버 연결 전 파형만 먼저 확인           │
├─────────────────────────────────────────────────┤
│  Step 9: 통합 테스트                               │
│  → 모든 페리페럴 동시 동작                         │
│  → 500Hz 제어 루프 타이밍 측정                     │
└─────────────────────────────────────────────────┘
```

### 8.2 Step 1: 전원 확인

**전원 인가 전:**
- 멀티미터로 VDD-VSS, VDDA-VSSA 간 **저항 측정** → 쇼트 확인
- PCB 납땜 상태 육안 검사 (브릿지, 미납 등)

**전원 인가 후:**
| 핀 | 기대 전압 | 허용 범위 | 비고 |
|-----|----------|----------|------|
| VDD (여러 핀) | 3.3V | 3.0~3.6V | 디지털 전원 |
| VDDA | 3.3V | 3.0~3.6V | 아날로그 전원 (노이즈 주의) |
| VREF+ | 3.3V | = VDDA | ADC 기준 전압 |
| VCAP1 | ~1.2V | 자동 | 내부 레귤레이터 출력, 1uF 캡 연결 |

> **VCAP1이 ~1.2V가 아니면** 내부 레귤레이터가 동작하지 않는 것 → 코어가 동작 불가.
> 원인: VCAP 핀에 캐패시터 미연결, 또는 VDD 전원 불량.

### 8.3 Step 2: 클럭 확인

LED 테스트 전에 클럭이 정상인지 먼저 확인:

```c
/* CubeMX에서 MCO1 출력 활성화: RCC → MCO1 → HSE */
/* PA8 (MCO1 핀)에서 8MHz 클럭 출력 → 오실로스코프로 측정 */

/* 또는 코드에서 직접 설정: */
HAL_RCC_MCOConfig(RCC_MCO1, RCC_MCO1SOURCE_HSE, RCC_MCODIV_1);
// PA8에서 8MHz 사각파가 나오면 HSE 크리스탈 정상!

HAL_RCC_MCOConfig(RCC_MCO1, RCC_MCO1SOURCE_PLL1QCLK, RCC_MCODIV_4);
// PLL1Q / 4 출력 → 240MHz/4 = 60MHz 확인 가능
```

### 8.4 Step 3: LED 테스트

4.7절의 LED 깜빡이기 코드 사용.

**확인 사항:**
- [ ] LED가 정확히 500ms 간격으로 깜빡이는가?
- [ ] 다른 GPIO 핀의 LED도 동작하는가? (RGB LED 각 색상)
- [ ] SWD 디버거로 코드 다운로드 및 디버깅이 되는가?

### 8.5 Step 4: UART 테스트

```c
/* USER CODE BEGIN 2 */
printf("AR_Walker STM32 Board Test\r\n");
printf("SYSCLK: %lu MHz\r\n", HAL_RCC_GetSysClockFreq() / 1000000);
printf("HCLK:   %lu MHz\r\n", HAL_RCC_GetHCLKFreq() / 1000000);
/* USER CODE END 2 */

while (1)
{
    /* USER CODE BEGIN 3 */
    // 에코 테스트: 수신한 데이터를 그대로 송신
    uint8_t rx_byte;
    if (HAL_UART_Receive(&huart3, &rx_byte, 1, 10) == HAL_OK)
    {
        HAL_UART_Transmit(&huart3, &rx_byte, 1, 10);
    }
    /* USER CODE END 3 */
}
```

**PC에서 확인**: 시리얼 터미널 (PuTTY, minicom, Arduino Serial Monitor)로 115200 baud 연결.

### 8.6 Step 5: CAN 루프백 테스트

```c
/* CubeMX에서 FDCAN1 Mode를 "Internal LoopBack"으로 설정 */
/* → 외부 CAN 트랜시버 없이 자기 자신에게 메시지를 보내 수신 확인 */

void CAN_LoopbackTest(void)
{
    FDCAN_TxHeaderTypeDef tx_header;
    FDCAN_RxHeaderTypeDef rx_header;
    uint8_t tx_data[8] = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08};
    uint8_t rx_data[8] = {0};

    tx_header.Identifier = 0x123;
    tx_header.IdType = FDCAN_STANDARD_ID;
    tx_header.TxFrameType = FDCAN_DATA_FRAME;
    tx_header.DataLength = FDCAN_DLC_BYTES_8;
    tx_header.BitRateSwitch = FDCAN_BRS_OFF;
    tx_header.FDFormat = FDCAN_CLASSIC_CAN;

    // 메시지 송신
    HAL_FDCAN_AddMessageToTxFifoQ(&hfdcan1, &tx_header, tx_data);
    HAL_Delay(10);

    // 메시지 수신 확인
    if (HAL_FDCAN_GetRxMessage(&hfdcan1, FDCAN_RX_FIFO0, &rx_header, rx_data) == HAL_OK)
    {
        if (rx_header.Identifier == 0x123 && rx_data[0] == 0x01)
        {
            printf("CAN Loopback Test: PASSED!\r\n");
        }
    }
    else
    {
        printf("CAN Loopback Test: FAILED!\r\n");
    }
}
```

### 8.7 Step 6~8: SPI, ADC, PWM 테스트

각각 독립적으로 테스트한다. 순서는 중요하지 않지만, 하나씩 확인한다.

**SPI 테스트:**
```c
// 루프백: MOSI와 MISO를 점퍼 와이어로 연결
uint8_t tx = 0xA5, rx = 0x00;
HAL_SPI_TransmitReceive(&hspi1, &tx, &rx, 1, 100);
printf("SPI Loopback: TX=0x%02X, RX=0x%02X %s\r\n",
       tx, rx, (tx == rx) ? "PASS" : "FAIL");
```

**ADC 테스트:**
```c
// PA0에 1.65V (VDD/2) 연결 후:
HAL_ADC_Start(&hadc1);
HAL_ADC_PollForConversion(&hadc1, 100);
uint32_t adc_val = HAL_ADC_GetValue(&hadc1);
float voltage = adc_val * 3.3f / 4096.0f;
printf("ADC IN0: %lu (%.3f V, expected ~1.65V)\r\n", adc_val, voltage);
```

**PWM 테스트:**
```c
// PE9에서 1kHz, 50% 듀티 PWM 출력
HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_1);
// → 오실로스코프로 PE9 핀 측정: 1kHz, 50% 확인
// 듀티 변경 테스트:
__HAL_TIM_SET_COMPARE(&htim1, TIM_CHANNEL_1, 250);  // 25%
HAL_Delay(2000);
__HAL_TIM_SET_COMPARE(&htim1, TIM_CHANNEL_1, 750);  // 75%
```

### 8.8 Step 9: 통합 테스트

모든 개별 테스트 통과 후, 전체를 동시에 구동:

```c
/* 500Hz 제어 루프 (TIM6 인터럽트 사용) */
// CubeMX: TIM6, Prescaler=239, Period=1999 → 240MHz/(240*2000) = 500Hz
// 인터럽트에서 500Hz 카운터 사용

volatile uint8_t control_loop_flag = 0;

void HAL_TIM_PeriodElapsedCallback(TIM_HandleTypeDef *htim)
{
    if (htim == &htim6)
    {
        control_loop_flag = 1;
    }
}

/* main.c while(1) 내부 */
while (1)
{
    if (control_loop_flag)
    {
        control_loop_flag = 0;

        // 타이밍 측정 시작
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_8, GPIO_PIN_SET);  // Speed Check 핀

        // 1. ADC 읽기 (DMA이므로 즉시 사용 가능)
        float torque_L = get_torque_left_Nm();
        float torque_R = get_torque_right_Nm();

        // 2. IMU 데이터 확인 (DMA 수신 완료된 최신 값)
        float gyro_z = get_imu_gyro_z();

        // 3. 제어 알고리즘 실행
        float cmd_L = controller_update(torque_L, gyro_z);
        float cmd_R = controller_update(torque_R, gyro_z);

        // 4. 모터 명령 송신 (CAN 또는 PWM)
        CAN_SendMotorCommand(0x01, cmd_L);
        CAN_SendMotorCommand(0x02, cmd_R);

        // 5. SPI로 Coms MCU에 상태 전송
        SPI_SendStatus(torque_L, torque_R, cmd_L, cmd_R);

        // 타이밍 측정 끝
        HAL_GPIO_WritePin(GPIOC, GPIO_PIN_8, GPIO_PIN_RESET);
    }
}
```

**통합 테스트 확인 사항:**
- [ ] Speed Check 핀(PC8)의 HIGH 구간이 2ms(= 500Hz 주기) 미만인가? (제어 루프가 시간 내 완료)
- [ ] 모든 ADC 채널이 정상 값을 읽는가?
- [ ] CAN 송수신이 제어 루프와 동기화되어 동작하는가?
- [ ] UART 디버그 출력이 제어 루프에 영향을 주지 않는가?
- [ ] SPI 통신이 정상인가?
- [ ] 장시간 (수 분~수 시간) 운행해도 안정적인가?

---

## HAL 함수 레퍼런스

| 카테고리 | 함수 | 설명 |
|---------|------|------|
| **시스템** | `HAL_Init()` | HAL 초기화, SysTick 설정 |
| | `HAL_Delay(ms)` | 밀리초 대기 (블로킹) |
| | `HAL_GetTick()` | 시스템 시작 후 밀리초 카운터 |
| **GPIO** | `HAL_GPIO_Init(port, &init)` | GPIO 초기화 |
| | `HAL_GPIO_WritePin(port, pin, state)` | 핀 출력 |
| | `HAL_GPIO_ReadPin(port, pin)` | 핀 읽기 |
| | `HAL_GPIO_TogglePin(port, pin)` | 핀 토글 |
| **UART** | `HAL_UART_Transmit(&h, data, len, timeout)` | 송신 (블로킹) |
| | `HAL_UART_Receive(&h, data, len, timeout)` | 수신 (블로킹) |
| | `HAL_UART_Transmit_DMA(&h, data, len)` | DMA 송신 |
| | `HAL_UARTEx_ReceiveToIdle_DMA(&h, data, len)` | DMA 수신 (Idle 감지) |
| **SPI** | `HAL_SPI_TransmitReceive(&h, tx, rx, len, timeout)` | 송수신 |
| | `HAL_SPI_TransmitReceive_DMA(&h, tx, rx, len)` | DMA 송수신 |
| **ADC** | `HAL_ADC_Start(&h)` | ADC 변환 시작 |
| | `HAL_ADC_Start_DMA(&h, data, len)` | DMA ADC 시작 |
| | `HAL_ADC_GetValue(&h)` | 변환 결과 읽기 |
| **CAN** | `HAL_FDCAN_Start(&h)` | FDCAN 시작 |
| | `HAL_FDCAN_AddMessageToTxFifoQ(&h, &hdr, data)` | 메시지 송신 |
| | `HAL_FDCAN_GetRxMessage(&h, fifo, &hdr, data)` | 메시지 수신 |
| | `HAL_FDCAN_ConfigFilter(&h, &filter)` | 수신 필터 설정 |
| **Timer** | `HAL_TIM_PWM_Start(&h, ch)` | PWM 출력 시작 |
| | `__HAL_TIM_SET_COMPARE(&h, ch, val)` | PWM 듀티 변경 |
| | `HAL_TIM_Base_Start_IT(&h)` | 타이머 인터럽트 시작 |
| **클럭** | `HAL_RCC_GetSysClockFreq()` | SYSCLK 주파수 확인 |
| | `HAL_RCC_GetHCLKFreq()` | AHB 클럭 확인 |

---

## 참고 자료

| 자료 | 설명 |
|------|------|
| **STM32H743 Datasheet** (DS12110) | 핀아웃, AF 테이블, 전기적 특성 |
| **STM32H7 Reference Manual** (RM0433) | 레지스터, 페리페럴 상세 동작 |
| **STM32H7 HAL User Manual** (UM2217) | HAL 함수 API 문서 |
| **AN5293** | STM32H7 FDCAN 사용 가이드 |
| **AN4031** | DMA 컨트롤러 사용 가이드 |
| **AR_Walker STM32_Setup/README.md** | 멀티 PC 개발 환경, USER CODE 관리 |
| **AR_Walker STM32_Setup/project_structure.md** | 모노레포 프로젝트 구조 |
| **AR_Walker Board.h** | 현재 Teensy 핀 설정 (매핑 원본) |

---

> **최종 업데이트**: 2026-04-06
> **작성 기준 칩**: STM32H743VITx (LQFP-100)
> **프로젝트**: AR_Walker (보행 보조 로봇 외골격)

---

이전 글: [STM32 핀 매핑 전략](/ko/study/stm32-pin-mapping) | [시리즈 처음으로](/ko/study/stm32-architecture)
