---
title: "STM32 로봇 보드 핀 매핑 전략 — Teensy에서 STM32로"
date: 2026-04-06
draft: false
tags: ["stm32", "pin-mapping", "robotics"]
description: "Teensy 4.1에서 STM32H743으로 마이그레이션하면서 세운 핀 매핑 전략과 실제 배치 결과."
author: "Henry"
categories: ["STM32 로봇 보드 개발"]
---

## 로봇 보드 핀 매핑 전략

![Teensy → STM32 핀 매핑](/images/study/stm32/pin-mapping.png)
*Teensy 4.1에서 STM32H743으로의 핀 매핑 비교도 — Gemini로 생성 필요*


### 7.1 핀 배치 원칙

1. **AF 충돌 방지**: 하나의 핀에는 하나의 AF만 사용 가능
2. **전원/그라운드 확보**: LQFP-100의 18개 전원 핀 모두 적절히 연결
3. **노이즈 분리**: ADC 입력 핀은 고속 디지털 신호(CAN, SPI)와 물리적으로 분리
4. **디버거 보호**: PA13 (SWDIO), PA14 (SWCLK)는 절대 다른 용도로 사용하지 않음
5. **미사용 핀 처리**: Analog 모드 (소비전류 최소화) 또는 Output Low로 설정
6. **BOOT0 핀**: GND에 연결 (일반 부트 = Flash에서 실행)

### 7.2 Teensy → STM32 핀 매핑 테이블

현재 `Board.h`의 Teensy 4.1 핀 설정을 STM32H743VITx로 매핑한 최종 테이블:

#### 통신 페리페럴

| 기능 | Teensy 핀 | STM32 핀 | AF | 페리페럴 | 비고 |
|------|-----------|----------|-----|---------|------|
| CAN TX | 22 | **PD1** | AF9 | FDCAN1_TX | 모터 CAN 버스 |
| CAN RX | 23 | **PD0** | AF9 | FDCAN1_RX | 모터 CAN 버스 |
| IMU UART RX | 16 (RX4) | **PD9** | AF7 | USART3_RX | IMU 데이터 수신 |
| IMU UART TX | N/C | **PD8** | AF7 | USART3_TX | (디버그 겸용 가능) |
| SPI SCK | (implicit) | **PA5** | AF5 | SPI1_SCK | Coms MCU 통신 |
| SPI MOSI | 11 | **PB5** | AF5 | SPI1_MOSI | PA7은 ADC용으로 보존 |
| SPI MISO | (implicit) | **PB4** | AF5 | SPI1_MISO | PA6은 ADC용으로 보존 |
| SPI CS | 10 | **PA15** | GPIO | — | 소프트웨어 CS |
| SPI IRQ | 34 | **PE0** | GPIO | EXTI0 | 인터럽트 입력 |
| SPI RST | 4 | **PE1** | GPIO | — | Coms MCU 리셋 |
| Serial TX | 1 | **PA9** | AF7 | USART1_TX | (디버그/PC 통신) |
| Serial RX | 0 | **PA10** | AF7 | USART1_RX | (디버그/PC 통신) |

#### 아날로그 입력 (ADC)

| 기능 | Teensy 핀 | STM32 핀 | 채널 | 페리페럴 | 비고 |
|------|-----------|----------|------|---------|------|
| 토크센서 Left | A16 | **PA0** | IN0 | ADC1 | 로드셀 L |
| 토크센서 Right | A6 | **PA3** | IN3 | ADC1 | 로드셀 R (PA6 대신 PA3) |
| 각도센서 Left | A13 | **PC3** | IN13 | ADC1 | 좌측 발목 각도 |
| 각도센서 Right | A12 | **PC2** | IN12 | ADC1 | 우측 발목 각도 |
| Maxon 전류 Left | (maxon_current) | **PA1** | IN1 | ADC1 | 좌측 모터 전류 |
| Maxon 전류 Right | (maxon_current) | **PA2** | IN2 | ADC1 | 우측 모터 전류 |
| (예비 1) | — | **PC4** | IN14 | ADC1 | 확장용 |
| (예비 2) | — | **PC5** | IN15 | ADC1 | 확장용 |

#### PWM 출력

| 기능 | Teensy 핀 | STM32 핀 | AF | 페리페럴 | 비고 |
|------|-----------|----------|-----|---------|------|
| Maxon PWM Left | (maxon_ctrl_L) | **PE9** | AF1 | TIM1_CH1 | 좌측 모터 |
| Maxon PWM Right | (maxon_ctrl_R) | **PE11** | AF1 | TIM1_CH2 | 우측 모터 |

#### GPIO 출력

| 기능 | Teensy 핀 | STM32 핀 | 설정 | 비고 |
|------|-----------|----------|------|------|
| Status LED Red | 14 | **PB0** | Output PP, Low Speed | RGB LED |
| Status LED Green | 25 | **PB1** | Output PP, Low Speed | RGB LED |
| Status LED Blue | 24 | **PB2** | Output PP, Low Speed | RGB LED |
| Sync LED | 15 | **PB10** | Output PP, Low Speed | 동기화 LED |
| Motor Stop | 9 | **PC6** | Output PP, Pull-Down | 긴급 정지 |
| Motor Enable L0 | 28 | **PD3** | Output PP, Pull-Down | 좌측 관절 0 |
| Motor Enable L1 | 29 | **PD4** | Output PP, Pull-Down | 좌측 관절 1 |
| Motor Enable R0 | 8 | **PD5** | Output PP, Pull-Down | 우측 관절 0 |
| Motor Enable R1 | 7 | **PD6** | Output PP, Pull-Down | 우측 관절 1 |
| Sync Default | 5 | **PC7** | Output PP | 동기화 기본 |
| Speed Check | 33 | **PC8** | Output PP | 속도 측정용 토글 핀 |

#### GPIO 입력

| 기능 | Teensy 핀 | STM32 핀 | 설정 | 비고 |
|------|-----------|----------|------|------|
| Maxon Error Left | (maxon_err_L) | **PE2** | Input, Pull-Up | 에러 감지 (액티브 로우) |
| Maxon Error Right | (maxon_err_R) | **PE3** | Input, Pull-Up | 에러 감지 (액티브 로우) |

#### 시스템 핀 (변경 불가)

| 기능 | STM32 핀 | 비고 |
|------|----------|------|
| SWDIO (디버거) | PA13 | 절대 변경 금지 |
| SWCLK (디버거) | PA14 | 절대 변경 금지 |
| HSE 크리스탈 IN | PH0 (pin 12) | 8MHz 크리스탈 |
| HSE 크리스탈 OUT | PH1 (pin 13) | 8MHz 크리스탈 |
| NRST | pin 14 (NRST) | 리셋 버튼 |
| BOOT0 | pin 94 | GND 연결 (Flash 부트) |

### 7.3 AF 충돌 검증

위 매핑에서 주요 충돌 해결 사항:

| 문제 | 원인 | 해결 |
|------|------|------|
| PA6을 ADC와 SPI1_MISO에 동시 사용 불가 | AF 충돌 | SPI1_MISO를 **PB4** (AF5)로 이동 |
| PA7을 ADC와 SPI1_MOSI에 동시 사용 불가 | AF 충돌 | SPI1_MOSI를 **PB5** (AF5)로 이동 |
| PA1을 ADC(전류센싱)와 UART4_RX에 동시 불가 | AF 충돌 | IMU UART를 **USART3** (PD8/PD9)로 변경 |
| PA6을 토크센서 R ADC로 사용 시 SPI 불가 | AF 충돌 | 토크센서 R을 **PA3** (ADC1_IN3)로 이동 |

### 7.4 핀 사용 현황 요약

| 포트 | 사용된 핀 | 미사용 핀 | 비고 |
|------|----------|----------|------|
| GPIOA | PA0-5, PA9-10, PA13-15 | PA6-8, PA11-12 | PA11/12는 USB용으로 예비 |
| GPIOB | PB0-2, PB4-5, PB10 | PB3, PB6-9, PB11-15 | 여유 있음 |
| GPIOC | PC2-8 | PC0-1, PC9-13 | PC13은 WKUP 가능 |
| GPIOD | PD0-1, PD3-6, PD8-9 | PD2, PD7, PD10-15 | 여유 있음 |
| GPIOE | PE0-3, PE9, PE11 | PE4-8, PE10, PE12-15 | 여유 있음 |

> **총 사용 핀**: 약 40개 / **여유 핀**: 약 36개 — 향후 확장 충분

### 7.5 핀맵 문서화

최종 확정된 핀 매핑은 `templates/hardware_pinmap_template.md` 양식에 맞춰
`Documentation/Hardware/AR_Walker_STM32_Pinmap.md`로 작성한다.

---

이전 글: [STM32CubeMX 실전 설정](/ko/study/stm32-cubemx) | 다음 글: [STM32 보드 브링업](/ko/study/stm32-bringup)
