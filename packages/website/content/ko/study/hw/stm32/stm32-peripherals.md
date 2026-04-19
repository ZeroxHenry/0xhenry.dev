---
title: "STM32 핵심 페리페럴 — FDCAN, UART, SPI, ADC, PWM 총정리"
date: 2026-04-06
draft: false
tags: ["stm32", "can-bus", "uart", "spi", "pwm"]
description: "로봇 보드에 필요한 STM32 페리페럴: FDCAN, UART, SPI, I2C, ADC, PWM 타이머를 HAL 코드와 함께 정리."
author: "Henry"
categories: ["STM32 로봇 보드 개발"]
---

## 로봇에 필요한 핵심 페리페럴

![CAN 버스 토폴로지](/images/study/stm32/can-topology.png)
*CAN 버스 통신 구조*

### 5.1 FDCAN (모터 CAN 통신)

AR_Walker의 T-Motor (AK60, AK70, AK80) 모터들은 CAN 버스로 통신한다.
STM32H7은 FDCAN (Flexible Data-rate CAN)을 지원하여 기존 CAN 2.0과 CAN FD 모두 사용 가능.

#### CAN vs CAN FD 비교

| 항목 | CAN 2.0 | CAN FD |
|------|---------|--------|
| 데이터 길이 | 최대 8 바이트 | 최대 64 바이트 |
| 비트레이트 | 최대 1 Mbps | Nominal 1M + Data 최대 8 Mbps |
| 현재 모터 사용 | **CAN 2.0** | (향후 확장 가능) |

> AR_Walker의 T-Motor는 CAN 2.0 (1Mbps, 8바이트)을 사용한다.
> FDCAN 페리페럴은 하위 호환성이 있어 CAN 2.0 모드로 동작 가능.

#### FDCAN 핀 옵션 (LQFP-100)

| 페리페럴 | TX 핀 옵션 | RX 핀 옵션 | AF |
|----------|-----------|-----------|-----|
| **FDCAN1** | PD1, PA12, PB9 | PD0, PA11, PB8 | **AF9** |
| **FDCAN2** | PB13, PB6 | PB5, PB12 | **AF9** |

**AR_Walker 권장 매핑:**
- FDCAN1: **PD1** (TX), **PD0** (RX) → AF9
- 이유: Port D에 배치하면 Port A의 ADC/SPI 핀과 충돌 없음

#### CubeMX 설정

1. Connectivity → FDCAN1 활성화
2. Parameter Settings:
   - Frame Format: **Classic** (CAN 2.0 모드)
   - Mode: **Normal** (루프백은 테스트용)
   - Nominal Prescaler: **3**
   - Nominal Time Seg1: **13**
   - Nominal Time Seg2: **2**
   - Nominal Sync Jump Width: **1**
   - → Nominal Bit Rate = **APB1_CLK / (Prescaler * (1 + Seg1 + Seg2))**
   - → 120MHz / (3 * (1+13+2)) = 120/48 = **2.5Mbps**... → 조정 필요
   - Prescaler: **10**, Seg1: **5**, Seg2: **6** → 120/(10*(1+5+6)) = **1 Mbps**

#### HAL 코드 예제

```c
/* FDCAN 초기화 — CubeMX가 자동 생성 */
FDCAN_HandleTypeDef hfdcan1;

/* USER CODE BEGIN: 필터 설정 + 시작 */
void FDCAN1_Start(void)
{
    FDCAN_FilterTypeDef filter;
    filter.IdType       = FDCAN_STANDARD_ID;
    filter.FilterIndex  = 0;
    filter.FilterType   = FDCAN_FILTER_MASK;
    filter.FilterConfig = FDCAN_FILTER_TO_RXFIFO0;
    filter.FilterID1    = 0x000;    // 모든 ID 수신
    filter.FilterID2    = 0x000;    // 마스크: 모든 비트 무시 (= 전부 수신)
    HAL_FDCAN_ConfigFilter(&hfdcan1, &filter);

    // FIFO0 수신 인터럽트 활성화
    HAL_FDCAN_ActivateNotification(&hfdcan1, FDCAN_IT_RX_FIFO0_NEW_MESSAGE, 0);

    // CAN 시작
    HAL_FDCAN_Start(&hfdcan1);
}

/* CAN 메시지 송신 — 모터 명령 전송 */
void CAN_SendMotorCommand(uint16_t motor_id, float torque)
{
    FDCAN_TxHeaderTypeDef tx_header;
    uint8_t tx_data[8];

    tx_header.Identifier          = motor_id;       // 예: 0x01 (모터 ID)
    tx_header.IdType              = FDCAN_STANDARD_ID;
    tx_header.TxFrameType         = FDCAN_DATA_FRAME;
    tx_header.DataLength          = FDCAN_DLC_BYTES_8;
    tx_header.ErrorStateIndicator = FDCAN_ESI_ACTIVE;
    tx_header.BitRateSwitch       = FDCAN_BRS_OFF;  // CAN 2.0 모드
    tx_header.FDFormat            = FDCAN_CLASSIC_CAN;
    tx_header.TxEventFifoControl  = FDCAN_NO_TX_EVENTS;
    tx_header.MessageMarker       = 0;

    // 토크 값을 CAN 데이터로 인코딩 (모터 프로토콜에 따라)
    // T-Motor AK 시리즈의 CAN 프로토콜:
    // [pos(15:8)] [pos(7:0)] [vel(11:4)] [vel(3:0)|kp(11:8)]
    // [kp(7:0)] [kd(11:4)] [kd(3:0)|torque(11:8)] [torque(7:0)]
    encode_motor_command(tx_data, 0.0f, 0.0f, 0.0f, 0.0f, torque);

    HAL_FDCAN_AddMessageToTxFifoQ(&hfdcan1, &tx_header, tx_data);
}

/* CAN 수신 콜백 — 모터 응답 처리 */
void HAL_FDCAN_RxFifo0Callback(FDCAN_HandleTypeDef *hfdcan, uint32_t RxFifo0ITs)
{
    FDCAN_RxHeaderTypeDef rx_header;
    uint8_t rx_data[8];

    if (HAL_FDCAN_GetRxMessage(hfdcan, FDCAN_RX_FIFO0, &rx_header, rx_data) == HAL_OK)
    {
        uint16_t motor_id = rx_header.Identifier;
        // 모터 응답 파싱: 위치, 속도, 전류
        float position, velocity, current;
        decode_motor_response(rx_data, &position, &velocity, &current);

        // ExoData 구조체에 저장
        update_motor_data(motor_id, position, velocity, current);
    }
}
```

> 🔧 **하드웨어 참고**: CAN 버스에는 **CAN 트랜시버 IC** (예: MCP2562, SN65HVD230)가 필요하다.
> MCU의 FDCAN TX/RX 핀 → 트랜시버 → CAN_H/CAN_L 차동 신호 → 모터.
> 버스 양 끝에 **120Ω 종단 저항** 필수.

---

### 5.2 UART/USART (IMU 통신)

AR_Walker의 IMU는 UART 시리얼 통신으로 데이터를 전송한다.
현재 Teensy에서는 Serial4 (RX4 = pin 16)을 사용.

#### UART 핀 옵션 (LQFP-100에서 자주 사용)

| 페리페럴 | TX 핀 | RX 핀 | AF | 버스 |
|----------|-------|-------|-----|------|
| **USART1** | PA9, PB6 | PA10, PB7 | AF7 | APB2 |
| **USART2** | PA2, PD5 | PA3, PD6 | AF7 | APB1 |
| **USART3** | PB10, PC10, PD8 | PB11, PC11, PD9 | AF7 | APB1 |
| **USART6** | PC6 | PC7 | AF7 | APB2 |
| **UART4** | PA0, PC10 | PA1, PC11 | AF8 | APB1 |
| **UART5** | PC12 | PD2 | AF8/AF14 | APB1 |
| **UART7** | PE8 | PE7 | AF7 | APB1 |
| **UART8** | PE1 | PE0 | AF8 | APB1 |

**AR_Walker IMU 매핑 권장:**
- UART4: **PA1** (RX) → AF8 (TX 불필요, RX만 사용)
- 또는 USART3: **PD9** (RX), PD8 (TX) → AF7

> 💡 **USART vs UART 차이**: USART는 동기 모드(클럭 동기화) 지원, UART는 비동기만.
> IMU 통신은 비동기이므로 어느 것이든 가능.

#### CubeMX 설정

1. Connectivity → UART4 (또는 원하는 UART) 활성화
2. Mode: **Asynchronous**
3. Parameter Settings:
   - Baud Rate: **115200** (또는 IMU 스펙에 맞춤)
   - Word Length: **8 Bits**
   - Stop Bits: **1**
   - Parity: **None**
   - Over Sampling: **16**

#### HAL 코드 예제

```c
UART_HandleTypeDef huart4;

/* === DMA를 사용한 효율적 수신 (권장) === */

uint8_t imu_rx_buffer[24];  // IMU 패킷 크기에 맞춤

void IMU_StartReceive(void)
{
    // DMA로 순환 수신 시작 — CPU를 블로킹하지 않음
    HAL_UARTEx_ReceiveToIdle_DMA(&huart4, imu_rx_buffer, sizeof(imu_rx_buffer));
    __HAL_DMA_DISABLE_IT(huart4.hdmarx, DMA_IT_HT);  // Half-Transfer 인터럽트 비활성화
}

/* DMA 수신 완료 또는 Idle Line 감지 시 콜백 */
void HAL_UARTEx_RxEventCallback(UART_HandleTypeDef *huart, uint16_t Size)
{
    if (huart == &huart4)
    {
        // IMU 데이터 파싱
        parse_imu_data(imu_rx_buffer, Size);

        // 다음 수신 재시작
        HAL_UARTEx_ReceiveToIdle_DMA(&huart4, imu_rx_buffer, sizeof(imu_rx_buffer));
        __HAL_DMA_DISABLE_IT(huart4.hdmarx, DMA_IT_HT);
    }
}

/* === 간단한 폴링 방식 (디버깅용) === */
void IMU_ReadPolling(void)
{
    uint8_t byte;
    if (HAL_UART_Receive(&huart4, &byte, 1, 1) == HAL_OK)
    {
        // 바이트 단위 처리
        process_imu_byte(byte);
    }
}

/* === 디버그 UART 출력 (printf 리다이렉트) === */
// USART3를 디버그용으로 사용하는 경우:
int _write(int file, char *ptr, int len)
{
    HAL_UART_Transmit(&huart3, (uint8_t *)ptr, len, HAL_MAX_DELAY);
    return len;
}
// 이후 printf("Hello STM32!\n"); 로 시리얼 출력 가능
```

> 💡 **DMA 수신이 중요한 이유**: IMU가 500Hz로 데이터를 보내면, 폴링 방식은 제어 루프(500Hz)와 타이밍이 충돌할 수 있다.
> DMA를 사용하면 CPU 개입 없이 백그라운드로 수신되므로 제어 루프에 영향을 주지 않는다.

---

### 5.3 SPI (MCU 간 통신)

현재 AR_Walker는 Teensy 4.1 (Logic MCU)과 Arduino Nano 33 BLE (Coms MCU) 간 SPI 통신을 사용.
STM32로 전환 시에도 SPI 통신 유지.

#### SPI 핀 옵션

| 페리페럴 | SCK | MOSI | MISO | NSS | AF | 버스 |
|----------|-----|------|------|-----|-----|------|
| **SPI1** | PA5, PB3 | PA7, PB5 | PA6, PB4 | PA4, PA15 | AF5 | APB2 |
| **SPI2** | PB10, PB13 | PB15, PC3 | PB14, PC2 | PB12, PB4 | AF5 | APB1 |
| **SPI3** | PB3, PC10 | PB5, PC12 | PB4, PC11 | PA4, PA15 | AF6 | APB1 |
| **SPI4** | PE2, PE12 | PE6, PE14 | PE5, PE13 | PE4, PE11 | AF5 | APB2 |

**AR_Walker 권장 매핑:**
- SPI1 (Master):
  - SCK: **PA5** (AF5)
  - MOSI: **PA7** (AF5)
  - MISO: **PA6** (AF5)
  - CS: **PA4** (GPIO, 소프트웨어 제어)
  - IRQ: **PC13** (GPIO 인터럽트 입력)

#### CubeMX 설정

1. Connectivity → SPI1 활성화
2. Mode: **Full-Duplex Master**
3. Parameter Settings:
   - Data Size: **8 bit**
   - First Bit: **MSB First**
   - Prescaler: **16** (APB2 120MHz / 16 = 7.5 MHz)
   - Clock Polarity (CPOL): **Low** (모드 0에 맞춤)
   - Clock Phase (CPHA): **1 Edge** (모드 0) 또는 **2 Edge** (모드 1)
   - NSS: **Software** (CS를 GPIO로 직접 제어)

> **CPOL/CPHA 모드**: Coms MCU의 SPI 설정 (CPOL/CPHA)에 맞춰야 한다.
> SPI Mode 0 = CPOL:0 CPHA:0, Mode 1 = CPOL:0 CPHA:1,
> Mode 2 = CPOL:1 CPHA:0, Mode 3 = CPOL:1 CPHA:1

#### HAL 코드 예제

```c
SPI_HandleTypeDef hspi1;

/* SPI 송수신 (블로킹) */
void SPI_TransmitReceive(uint8_t *tx_data, uint8_t *rx_data, uint16_t size)
{
    // CS LOW (통신 시작)
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);

    HAL_SPI_TransmitReceive(&hspi1, tx_data, rx_data, size, 100);

    // CS HIGH (통신 종료)
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);
}

/* SPI DMA 송수신 (비블로킹, 권장) */
void SPI_TransmitReceive_DMA(uint8_t *tx_data, uint8_t *rx_data, uint16_t size)
{
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_RESET);
    HAL_SPI_TransmitReceive_DMA(&hspi1, tx_data, rx_data, size);
}

void HAL_SPI_TxRxCpltCallback(SPI_HandleTypeDef *hspi)
{
    if (hspi == &hspi1)
    {
        HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, GPIO_PIN_SET);
        // 수신 데이터 처리
        process_coms_mcu_data();
    }
}
```

---

### 5.4 ADC (토크 센서, 각도 센서)

AR_Walker의 로드셀(토크 센서)과 각도 센서는 아날로그 전압을 출력한다.
STM32H7의 ADC는 최대 16비트 분해능을 지원 (현재 Teensy는 12비트 사용).

#### ADC 채널과 핀 매핑

| ADC | 채널 | 핀 | 용도 (AR_Walker) |
|-----|------|-----|-----------------|
| ADC1 | IN0 | PA0 | 토크센서 Left (현재 A16) |
| ADC1 | IN1 | PA1 | Maxon 전류 Left |
| ADC1 | IN2 | PA2 | Maxon 전류 Right |
| ADC1 | IN6 | PA6 | 토크센서 Right (현재 A6) |
| ADC1 | IN12 | PC2 | 각도센서 Right (현재 A12) |
| ADC1 | IN13 | PC3 | 각도센서 Left (현재 A13) |
| ADC1 | IN14 | PC4 | (예비) |
| ADC1 | IN15 | PC5 | (예비) |

> ⚠️ **주의**: PA6를 ADC로 사용하면 SPI1_MISO로는 사용 불가.
> 이 경우 SPI1_MISO를 PB4로 재배치하거나, 토크센서를 다른 ADC 채널(PC4 등)로 이동해야 한다.
> → 7장 핀 매핑 전략에서 이 충돌을 해결한다.

#### CubeMX 설정

1. Analog → ADC1 활성화
2. IN0, IN6, IN12, IN13 등 필요한 채널 체크
3. Parameter Settings:
   - Clock Prescaler: **Asynchronous clock mode divided by 4**
   - Resolution: **12 bit** (Teensy와 동일) 또는 **16 bit** (더 정밀)
   - Scan Conversion Mode: **Enable** (여러 채널 순차 변환)
   - Continuous Conversion Mode: **Enable** (계속 변환)
   - DMA Continuous Requests: **Enable**
   - Number of Conversions: **4** (사용할 채널 수)
4. DMA Settings → ADC1 → DMA Stream 추가 → Circular 모드

#### HAL 코드 예제

```c
ADC_HandleTypeDef hadc1;
DMA_HandleTypeDef hdma_adc1;

// DMA로 수신할 버퍼 (채널 4개 × 값)
// D2 SRAM에 배치해야 DMA가 접근 가능!
__attribute__((section(".RAM_D2")))
volatile uint16_t adc_values[4];
// [0]=토크L, [1]=토크R, [2]=각도R, [3]=각도L

/* ADC + DMA 시작 */
void ADC_Start(void)
{
    HAL_ADC_Start_DMA(&hadc1, (uint32_t *)adc_values, 4);
    // 이후 adc_values[]는 자동으로 업데이트됨
}

/* ADC 값 읽기 (아무 때나 호출 가능) */
float get_torque_left_voltage(void)
{
    // 12비트 ADC: 0~4095 → 0~3.3V
    return (float)adc_values[0] * 3.3f / 4096.0f;
}

float get_torque_left_Nm(void)
{
    float voltage = get_torque_left_voltage();
    // 로드셀 캘리브레이션 적용
    // 현재 Config.h: AI_CNT_TO_V = 3.3 / 4096
    return (voltage - bias) * sensitivity;
}

/* ADC 변환 완료 콜백 (DMA 사용 시 자동 호출) */
void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef *hadc)
{
    if (hadc == &hadc1)
    {
        // 새로운 ADC 데이터 준비됨
        // DMA Circular 모드이므로 자동으로 다음 변환 시작
    }
}
```

> **중요: DMA 버퍼 위치**
> STM32H7에서 DMA1/2는 **D2 도메인의 SRAM**에만 접근 가능하다.
> AXI SRAM이나 DTCM에 DMA 버퍼를 배치하면 동작하지 않는다!
> 링커 스크립트에 `.RAM_D2` 섹션을 추가하고, `__attribute__((section(".RAM_D2")))`로 배치한다.

---

### 5.5 PWM / Timer (모터 제어 신호)

Maxon 모터 드라이버는 PWM 신호로 속도/토크 명령을 받는다.
현재 Teensy에서 `analogWrite()`로 PWM을 출력하는 것을 STM32 타이머로 구현한다.

#### 타이머 종류

| 분류 | 타이머 | 특징 | PWM 채널 |
|------|--------|------|---------|
| **Advanced** | TIM1, TIM8 | 데드타임, 브레이크 기능 | 각 4채널 |
| **General Purpose (32bit)** | TIM2, TIM5 | 32비트 카운터 | 각 4채널 |
| **General Purpose (16bit)** | TIM3, TIM4 | 범용 | 각 4채널 |
| **General Purpose (1ch)** | TIM15, TIM16, TIM17 | 단일 채널 | 각 1~2채널 |
| **Basic** | TIM6, TIM7 | PWM 불가, 인터럽트/DAC 트리거용 | 없음 |

**AR_Walker 권장:**
- Maxon PWM Left: **TIM1_CH1** → **PE9** (AF1)
- Maxon PWM Right: **TIM1_CH2** → **PE11** (AF1)
- TIM1은 Advanced 타이머로 정밀한 PWM 출력에 적합

#### CubeMX 설정

1. Timers → TIM1 → Channel 1: **PWM Generation CH1**
2. Timers → TIM1 → Channel 2: **PWM Generation CH2**
3. Parameter Settings:
   - Prescaler: **239** (타이머 클럭 240MHz / (239+1) = 1 MHz)
   - Counter Period (ARR): **999** (1MHz / (999+1) = **1 kHz** PWM 주파수)
   - Pulse (CCR): **500** (50% 듀티 = 중립값)
   - PWM Mode: **PWM Mode 1**
   - CH Polarity: **High** (Active High)

> **PWM 주파수 계산:**
> `PWM_freq = Timer_CLK / ((PSC+1) * (ARR+1))`
> `= 240MHz / (240 * 1000) = 1 kHz`
>
> **듀티 사이클 계산:**
> `Duty = CCR / (ARR+1) * 100%`
> `= 500 / 1000 * 100% = 50%` (중립)

#### HAL 코드 예제

```c
TIM_HandleTypeDef htim1;

/* PWM 시작 */
void Motor_PWM_Start(void)
{
    HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_1);  // Left motor
    HAL_TIM_PWM_Start(&htim1, TIM_CHANNEL_2);  // Right motor
}

/* 듀티 사이클 변경 (토크 명령) */
void Motor_SetDuty(uint32_t channel, float duty_percent)
{
    // duty_percent: 0.0 ~ 100.0
    uint32_t pulse = (uint32_t)(duty_percent / 100.0f * (htim1.Init.Period + 1));
    __HAL_TIM_SET_COMPARE(&htim1, channel, pulse);
}

/* Maxon 모터 토크 명령 → PWM 변환 */
void Maxon_SetTorque(float torque_left, float torque_right)
{
    // 현재 Board.h의 중립값 기준으로 듀티 계산
    // maxon_pwm_neutral_val을 50%로 가정
    float duty_left  = 50.0f + torque_left * scale_factor;
    float duty_right = 50.0f + torque_right * scale_factor;

    // 상한/하한 제한 (안전)
    duty_left  = fminf(fmaxf(duty_left,  10.0f), 90.0f);
    duty_right = fminf(fmaxf(duty_right, 10.0f), 90.0f);

    Motor_SetDuty(TIM_CHANNEL_1, duty_left);
    Motor_SetDuty(TIM_CHANNEL_2, duty_right);
}

/* 모터 정지 (안전 함수) */
void Motor_Stop(void)
{
    // 중립값으로 복귀
    __HAL_TIM_SET_COMPARE(&htim1, TIM_CHANNEL_1, 500);  // 50%
    __HAL_TIM_SET_COMPARE(&htim1, TIM_CHANNEL_2, 500);

    // PWM 출력 정지
    HAL_TIM_PWM_Stop(&htim1, TIM_CHANNEL_1);
    HAL_TIM_PWM_Stop(&htim1, TIM_CHANNEL_2);
}
```

---
