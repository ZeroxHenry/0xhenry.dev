# STM32 아키텍처 기초 — Cortex-M7, 메모리, 버스 완전 정리

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


![ARM Cortex-M7 아키텍처](/images/study/stm32/cortex-m7-block.png)
*Cortex-M7 코어 블록 다이어그램*


### 1.1 ARM Cortex-M7 코어

STM32H743VITx는 ARM Cortex-M7 코어를 탑재한 고성능 마이크로컨트롤러이다.

**코어 특성:**

| 항목 | 사양 |
|------|------|
| 아키텍처 | ARMv7E-M |
| 파이프라인 | 6단계 슈퍼스칼라 (듀얼 이슈) |
| FPU | 단정밀도(SP) + 배정밀도(DP) 부동소수점 연산 |
| DSP | 단일 사이클 MAC, SIMD 명령어 |
| I-Cache | 16 KB (명령어 캐시) |
| D-Cache | 16 KB (데이터 캐시) |
| MPU | 16 리전 메모리 보호 유닛 |
| 최대 클럭 | 480 MHz |

**왜 로봇 보드에 Cortex-M7인가?**
- 500Hz 제어 루프를 안정적으로 구동 (현재 Teensy 4.1과 동일 코어)
- FPU로 PID 연산, 토크 계산 등 실수 연산을 하드웨어로 처리
- DSP 명령어로 센서 데이터 필터링 (IMU, 로드셀) 가속
- 캐시로 Flash에서 코드 실행 시에도 고속 동작 보장

### 1.2 STM32H743VITx 칩 스펙 요약

| 항목 | 사양 | 비고 |
|------|------|------|
| **패키지** | LQFP-100 | 100핀, 14x14mm |
| **Flash** | 2 MB | 듀얼 뱅크 |
| **RAM 총합** | 1 MB | 아래 상세 |
| **ITCM** | 64 KB | 명령어 전용 (0사이클 대기) |
| **DTCM** | 128 KB | 가장 빠른 RAM (0사이클 대기) |
| **AXI SRAM** | 512 KB | 범용 대용량 |
| **SRAM1** | 128 KB | D2 도메인 |
| **SRAM2** | 128 KB | D2 도메인 |
| **SRAM3** | 32 KB | D2 도메인 |
| **SRAM4** | 64 KB | D3 도메인 |
| **Backup SRAM** | 4 KB | 배터리 백업 |
| **GPIO** | 최대 82개 | LQFP-100에서 사용 가능 |
| **ADC** | 3개 (ADC1/2/3) | 16비트, 3.6 MSPS |
| **FDCAN** | 2개 | CAN FD 지원 |
| **UART/USART** | 8개 | USART1-3,6 + UART4,5,7,8 |
| **SPI** | 6개 | SPI1-6 |
| **I2C** | 4개 | I2C1-4 |
| **Timer** | 다수 | TIM1-17 (Advanced, GP, Basic) |
| **동작 전압** | 1.62V ~ 3.6V | 일반적으로 3.3V 사용 |

### 1.3 메모리 맵

STM32H7은 전원 도메인(Power Domain)별로 메모리와 페리페럴이 구분된다.

![메모리 맵](/images/study/stm32/memory-map.png)
*STM32H743 메모리 맵 — 주소별 영역 구분*

**로봇 보드에서의 메모리 활용 전략:**
- **DTCM (128KB)**: 제어 루프 변수, PID 파라미터, 모터 명령 버퍼 → 가장 빠른 접근
- **AXI SRAM (512KB)**: ExoData 구조체, 센서 데이터 배열, 설정 파일 파싱 버퍼
- **SRAM1/2 (256KB)**: DMA 전송 버퍼 (ADC, UART, SPI) → D2 도메인의 DMA가 직접 접근
- **SRAM4 (64KB)**: 저전력 모드에서도 유지해야 할 데이터

### 1.4 버스 아키텍처

STM32H7의 버스는 3개의 전원 도메인(D1, D2, D3)으로 나뉜다:

![버스 도메인](/images/study/stm32/bus-domains.png)
*D1/D2/D3 전원 도메인과 버스 아키텍처*

**핵심 포인트:**
- GPIO는 AHB4 (D3 도메인)에 연결되어 있어 모든 도메인에서 접근 가능
- FDCAN1/2는 APB1 (D2 도메인)에 있으므로 DMA1/2와 함께 사용 시 SRAM1/2에 버퍼 배치
- ADC1/2는 APB2에, ADC3는 AHB4에 있어 서로 다른 도메인 → DMA 버퍼 위치 주의

---

다음 글: [STM32 핀 시스템 완전 정복](/ko/study/stm32-pin-system)