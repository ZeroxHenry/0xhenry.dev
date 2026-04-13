1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T3b26,<p><img src="/images/study/stm32/lqfp100-pinout.png" alt="LQFP-100 핀아웃">
<em>STM32H743VITx LQFP-100 핀아웃 다이어그램</em></p>
<h3>2.1 물리적 핀 vs GPIO 포트</h3>
<p>STM32의 핀 시스템을 이해하려면 두 가지 "핀 번호"의 차이를 알아야 한다:</p>
<ol>
<li><strong>물리적 핀 번호</strong>: IC 패키지의 다리 번호 (LQFP-100: 1번~100번)</li>
<li><strong>GPIO 포트 이름</strong>: PA0, PB3, PC13 등 소프트웨어에서 사용하는 이름</li>
</ol>
<p><strong>GPIO 포트 명명 규칙:</strong></p>
<pre><code>P + [포트 문자] + [핀 번호]
│    │              │
│    A~K            0~15
│    (포트 그룹)    (그룹 내 핀 번호)
GPIO
</code></pre>
<p>예시:</p>
<ul>
<li><code>PA0</code> = Port A, Pin 0</li>
<li><code>PB7</code> = Port B, Pin 7</li>
<li><code>PD1</code> = Port D, Pin 1</li>
</ul>
<p>STM32H743VITx (LQFP-100)에서 사용 가능한 GPIO 포트:</p>
<table>
<thead>
<tr>
<th>포트</th>
<th>사용 가능한 핀</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td>GPIOA</td>
<td>PA0~PA15</td>
<td>16핀 전부 사용 가능</td>
</tr>
<tr>
<td>GPIOB</td>
<td>PB0~PB15</td>
<td>16핀 전부 사용 가능</td>
</tr>
<tr>
<td>GPIOC</td>
<td>PC0~PC13</td>
<td>14핀 (PC14/15는 OSC32)</td>
</tr>
<tr>
<td>GPIOD</td>
<td>PD0~PD15</td>
<td>16핀 전부 사용 가능</td>
</tr>
<tr>
<td>GPIOE</td>
<td>PE0~PE15</td>
<td>16핀 전부 사용 가능</td>
</tr>
</tbody>
</table>
<blockquote>
<p>⚠️ <strong>주의</strong>: LQFP-100 패키지에서는 GPIOF~GPIOK는 사용 불가 (핀이 없음).
144핀 이상의 패키지에서만 사용 가능.</p>
</blockquote>
<h3>2.2 LQFP-100 핀 번호와 GPIO 매핑</h3>
<p>LQFP-100 패키지에서 물리적 핀 번호와 GPIO 이름의 매핑 (STM32H743VITx 기준):</p>
<pre><code>                      핀 76~100 (상단)
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
</code></pre>
<p><strong>주요 핀 매핑 (자주 사용하는 것들):</strong></p>
<table>
<thead>
<tr>
<th>물리 핀</th>
<th>GPIO</th>
<th>주요 기능</th>
<th>AF 예시</th>
</tr>
</thead>
<tbody>
<tr>
<td>14</td>
<td>PA0</td>
<td>ADC1_IN0, TIM2_CH1</td>
<td>AF1(TIM2), AF-(Analog)</td>
</tr>
<tr>
<td>15</td>
<td>PA1</td>
<td>ADC1_IN1, TIM2_CH2</td>
<td>AF1(TIM2), AF-(Analog)</td>
</tr>
<tr>
<td>16</td>
<td>PA2</td>
<td>ADC1_IN2, USART2_TX</td>
<td>AF7(USART2), AF-(Analog)</td>
</tr>
<tr>
<td>17</td>
<td>PA3</td>
<td>ADC1_IN3, USART2_RX</td>
<td>AF7(USART2), AF-(Analog)</td>
</tr>
<tr>
<td>20</td>
<td>PA4</td>
<td>ADC1_IN4, SPI1_NSS, DAC1_OUT1</td>
<td>AF5(SPI1)</td>
</tr>
<tr>
<td>21</td>
<td>PA5</td>
<td>ADC1_IN5, SPI1_SCK, DAC1_OUT2</td>
<td>AF5(SPI1)</td>
</tr>
<tr>
<td>22</td>
<td>PA6</td>
<td>ADC1_IN6, SPI1_MISO, TIM3_CH1</td>
<td>AF5(SPI1)</td>
</tr>
<tr>
<td>23</td>
<td>PA7</td>
<td>ADC1_IN7, SPI1_MOSI, TIM3_CH2</td>
<td>AF5(SPI1)</td>
</tr>
<tr>
<td>68</td>
<td>PA8</td>
<td>TIM1_CH1, MCO1</td>
<td>AF1(TIM1), AF0(MCO1)</td>
</tr>
<tr>
<td>69</td>
<td>PA9</td>
<td>USART1_TX, TIM1_CH2</td>
<td>AF7(USART1)</td>
</tr>
<tr>
<td>70</td>
<td>PA10</td>
<td>USART1_RX, TIM1_CH3</td>
<td>AF7(USART1)</td>
</tr>
<tr>
<td>71</td>
<td>PA11</td>
<td>USB_OTG_FS_DM, FDCAN1_RX</td>
<td>AF9(FDCAN1)</td>
</tr>
<tr>
<td>72</td>
<td>PA12</td>
<td>USB_OTG_FS_DP, FDCAN1_TX</td>
<td>AF9(FDCAN1)</td>
</tr>
<tr>
<td>76</td>
<td>PA13</td>
<td><strong>SWDIO</strong> (디버거)</td>
<td>디버깅 전용 — 변경 금지!</td>
</tr>
<tr>
<td>77</td>
<td>PA14</td>
<td><strong>SWCLK</strong> (디버거)</td>
<td>디버깅 전용 — 변경 금지!</td>
</tr>
<tr>
<td>78</td>
<td>PA15</td>
<td>SPI3_NSS, TIM2_CH1</td>
<td>AF6(SPI3)</td>
</tr>
<tr>
<td>35</td>
<td>PB0</td>
<td>ADC1_IN8, TIM3_CH3</td>
<td>AF2(TIM3)</td>
</tr>
<tr>
<td>36</td>
<td>PB1</td>
<td>ADC1_IN9, TIM3_CH4</td>
<td>AF2(TIM3)</td>
</tr>
<tr>
<td>37</td>
<td>PB2</td>
<td>QUADSPI_CLK</td>
<td>AF9(QUADSPI)</td>
</tr>
<tr>
<td>89</td>
<td>PB3</td>
<td>SPI3_SCK, TIM2_CH2</td>
<td>AF6(SPI3)</td>
</tr>
<tr>
<td>90</td>
<td>PB4</td>
<td>SPI3_MISO, TIM3_CH1</td>
<td>AF6(SPI3)</td>
</tr>
<tr>
<td>91</td>
<td>PB5</td>
<td>SPI3_MOSI, FDCAN2_RX</td>
<td>AF6(SPI3), AF9(FDCAN2)</td>
</tr>
<tr>
<td>92</td>
<td>PB6</td>
<td>USART1_TX, FDCAN2_TX, I2C1_SCL</td>
<td>AF7(USART1), AF9(FDCAN2)</td>
</tr>
<tr>
<td>93</td>
<td>PB7</td>
<td>USART1_RX, I2C1_SDA</td>
<td>AF7(USART1), AF4(I2C1)</td>
</tr>
<tr>
<td>95</td>
<td>PB8</td>
<td>FDCAN1_RX, I2C1_SCL, TIM4_CH3</td>
<td>AF9(FDCAN1), AF4(I2C1)</td>
</tr>
<tr>
<td>96</td>
<td>PB9</td>
<td>FDCAN1_TX, I2C1_SDA, TIM4_CH4</td>
<td>AF9(FDCAN1), AF4(I2C1)</td>
</tr>
<tr>
<td>47</td>
<td>PB10</td>
<td>USART3_TX, I2C2_SCL, TIM2_CH3</td>
<td>AF7(USART3)</td>
</tr>
<tr>
<td>48</td>
<td>PB11</td>
<td>USART3_RX, I2C2_SDA, TIM2_CH4</td>
<td>AF7(USART3)</td>
</tr>
<tr>
<td>51</td>
<td>PB12</td>
<td>SPI2_NSS, USART3_CK</td>
<td>AF5(SPI2)</td>
</tr>
<tr>
<td>52</td>
<td>PB13</td>
<td>SPI2_SCK, FDCAN2_TX</td>
<td>AF5(SPI2), AF9(FDCAN2)</td>
</tr>
<tr>
<td>53</td>
<td>PB14</td>
<td>SPI2_MISO, USART3_RTS</td>
<td>AF5(SPI2)</td>
</tr>
<tr>
<td>54</td>
<td>PB15</td>
<td>SPI2_MOSI, TIM12_CH2</td>
<td>AF5(SPI2)</td>
</tr>
<tr>
<td>8</td>
<td>PC0</td>
<td>ADC1_IN10</td>
<td>AF-(Analog)</td>
</tr>
<tr>
<td>9</td>
<td>PC1</td>
<td>ADC1_IN11</td>
<td>AF-(Analog)</td>
</tr>
<tr>
<td>10</td>
<td>PC2</td>
<td>ADC1_IN12, SPI2_MISO</td>
<td>AF5(SPI2)</td>
</tr>
<tr>
<td>11</td>
<td>PC3</td>
<td>ADC1_IN13, SPI2_MOSI</td>
<td>AF5(SPI2)</td>
</tr>
<tr>
<td>33</td>
<td>PC4</td>
<td>ADC1_IN14</td>
<td>AF-(Analog)</td>
</tr>
<tr>
<td>34</td>
<td>PC5</td>
<td>ADC1_IN15</td>
<td>AF-(Analog)</td>
</tr>
<tr>
<td>63</td>
<td>PC6</td>
<td>USART6_TX, TIM8_CH1</td>
<td>AF7(USART6)</td>
</tr>
<tr>
<td>64</td>
<td>PC7</td>
<td>USART6_RX, TIM8_CH2</td>
<td>AF7(USART6)</td>
</tr>
<tr>
<td>65</td>
<td>PC8</td>
<td>TIM8_CH3, SDMMC1_D0</td>
<td>AF3(TIM8)</td>
</tr>
<tr>
<td>66</td>
<td>PC9</td>
<td>TIM8_CH4, SDMMC1_D1</td>
<td>AF3(TIM8)</td>
</tr>
<tr>
<td>67</td>
<td>PC10</td>
<td>USART3_TX, SPI3_SCK</td>
<td>AF7(USART3)</td>
</tr>
<tr>
<td>79</td>
<td>PC11</td>
<td>USART3_RX, SPI3_MISO</td>
<td>AF7(USART3)</td>
</tr>
<tr>
<td>80</td>
<td>PC12</td>
<td>SPI3_MOSI, UART5_TX</td>
<td>AF6(SPI3)</td>
</tr>
<tr>
<td>7</td>
<td>PC13</td>
<td>RTC_TAMP, WKUP</td>
<td>범용 GPIO</td>
</tr>
<tr>
<td>82</td>
<td>PD0</td>
<td>FDCAN1_RX, FMC_D2</td>
<td>AF9(FDCAN1)</td>
</tr>
<tr>
<td>83</td>
<td>PD1</td>
<td>FDCAN1_TX, FMC_D3</td>
<td>AF9(FDCAN1)</td>
</tr>
<tr>
<td>84</td>
<td>PD2</td>
<td>UART5_RX, TIM3_ETR</td>
<td>AF8(UART5)</td>
</tr>
<tr>
<td>85</td>
<td>PD3</td>
<td>USART2_CTS, FMC_CLK</td>
<td>AF7(USART2)</td>
</tr>
<tr>
<td>86</td>
<td>PD4</td>
<td>USART2_RTS, FMC_NOE</td>
<td>AF7(USART2)</td>
</tr>
<tr>
<td>87</td>
<td>PD5</td>
<td>USART2_TX, FMC_NWE</td>
<td>AF7(USART2)</td>
</tr>
<tr>
<td>88</td>
<td>PD6</td>
<td>USART2_RX, FMC_NWAIT</td>
<td>AF7(USART2)</td>
</tr>
<tr>
<td>55</td>
<td>PD8</td>
<td>USART3_TX</td>
<td>AF7(USART3)</td>
</tr>
<tr>
<td>56</td>
<td>PD9</td>
<td>USART3_RX</td>
<td>AF7(USART3)</td>
</tr>
<tr>
<td>100</td>
<td>PE0</td>
<td>UART8_RX, TIM4_ETR</td>
<td>AF8(UART8)</td>
</tr>
<tr>
<td>1</td>
<td>PE1</td>
<td>UART8_TX</td>
<td>AF8(UART8)</td>
</tr>
<tr>
<td>2</td>
<td>PE2</td>
<td>SPI4_SCK, UART8_TX</td>
<td>AF5(SPI4)</td>
</tr>
<tr>
<td>98</td>
<td>PE9</td>
<td>TIM1_CH1, FMC_D6</td>
<td><strong>AF1(TIM1)</strong> — PWM용</td>
</tr>
<tr>
<td>99</td>
<td>PE11</td>
<td>TIM1_CH2, FMC_D8</td>
<td><strong>AF1(TIM1)</strong> — PWM용</td>
</tr>
</tbody>
</table>
<h3>2.3 핀 기능 분류</h3>
<p>LQFP-100의 100개 핀은 크게 4종류로 나뉜다:</p>
<table>
<thead>
<tr>
<th>분류</th>
<th>핀</th>
<th>개수</th>
<th>설명</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>전원</strong></td>
<td>VDD, VSS, VDDA, VSSA, VREF+, VCAP</td>
<td>~18개</td>
<td>전원 공급 (3.3V, GND)</td>
</tr>
<tr>
<td><strong>클럭</strong></td>
<td>OSC_IN, OSC_OUT (PH0/PH1)</td>
<td>2개</td>
<td>외부 크리스탈 연결</td>
</tr>
<tr>
<td><strong>리셋</strong></td>
<td>NRST</td>
<td>1개</td>
<td>시스템 리셋 (액티브 로우)</td>
</tr>
<tr>
<td><strong>디버그</strong></td>
<td>PA13 (SWDIO), PA14 (SWCLK)</td>
<td>2개</td>
<td>SWD 디버거 전용</td>
</tr>
<tr>
<td><strong>부트</strong></td>
<td>BOOT0</td>
<td>1개</td>
<td>부트 모드 선택</td>
</tr>
<tr>
<td><strong>GPIO</strong></td>
<td>PA0~PE15</td>
<td>~76개</td>
<td>범용 입출력 + AF</td>
</tr>
</tbody>
</table>
<blockquote>
<p>🔴 <strong>절대 규칙</strong>: PA13/PA14는 SWD 디버거 핀이다. 이 핀을 다른 용도로 사용하면 디버깅/프로그래밍이 불가능해진다. 반드시 SWD 전용으로 남겨둘 것!</p>
</blockquote>
<h3>2.4 Alternate Function (AF) 시스템</h3>
<p>STM32에서 가장 중요한 개념 중 하나. 하나의 GPIO 핀이 최대 16가지 다른 기능을 수행할 수 있다.</p>
<p><strong>AF 번호 체계 (AF0 ~ AF15):</strong></p>
<table>
<thead>
<tr>
<th>AF 번호</th>
<th>주요 기능</th>
</tr>
</thead>
<tbody>
<tr>
<td>AF0</td>
<td>SYS (MCO, SWD, TRACE)</td>
</tr>
<tr>
<td>AF1</td>
<td>TIM1, TIM2</td>
</tr>
<tr>
<td>AF2</td>
<td>TIM3, TIM4, TIM5</td>
</tr>
<tr>
<td>AF3</td>
<td>TIM8, TIM15-17</td>
</tr>
<tr>
<td>AF4</td>
<td>I2C1-4</td>
</tr>
<tr>
<td>AF5</td>
<td>SPI1-6</td>
</tr>
<tr>
<td>AF6</td>
<td>SPI2/3, SAI1/2</td>
</tr>
<tr>
<td>AF7</td>
<td>USART1-3, USART6</td>
</tr>
<tr>
<td>AF8</td>
<td>UART4/5, UART7/8, LPUART1</td>
</tr>
<tr>
<td>AF9</td>
<td>FDCAN1/2, QUADSPI, TIM12-14</td>
</tr>
<tr>
<td>AF10</td>
<td>USB OTG, SAI2</td>
</tr>
<tr>
<td>AF11</td>
<td>ETH, UART7</td>
</tr>
<tr>
<td>AF12</td>
<td>FMC, SDMMC, MDIOS</td>
</tr>
<tr>
<td>AF13</td>
<td>DCMI, COMP</td>
</tr>
<tr>
<td>AF14</td>
<td>LTDC, UART5</td>
</tr>
<tr>
<td>AF15</td>
<td>EVENTOUT</td>
</tr>
</tbody>
</table>
<p><img src="/images/study/stm32/af-mux.png" alt="AF 멀티플렉서">
<em>AF0~AF15 멀티플렉서 — 하나의 핀에 16가지 기능 선택</em></p>
<p><strong>AF 사용 예시 — PA7 핀:</strong></p>
<p>PA7에는 다음 기능들이 할당 가능:</p>
<ul>
<li>AF0: MCO (마이크로컨트롤러 클럭 출력)</li>
<li>AF2: TIM3_CH2 (타이머3 채널2 = PWM 출력)</li>
<li>AF5: SPI1_MOSI (SPI1 마스터 출력)</li>
<li>Analog: ADC1_IN7 (아날로그 입력)</li>
</ul>
<p><strong>한 번에 하나의 AF만 선택 가능!</strong> 만약 PA7을 SPI1_MOSI로 사용하면 이 핀에서 ADC나 TIM3는 동시에 사용할 수 없다.</p>
<p><strong>AF 충돌 예방법:</strong></p>
<ol>
<li>필요한 페리페럴 목록 작성 (CAN, UART, SPI, ADC, PWM 등)</li>
<li>각 페리페럴의 핀 옵션 확인 (데이터시트 Table 9-12)</li>
<li>AF가 겹치지 않도록 핀 배치 → CubeMX가 자동으로 충돌 검사해줌</li>
</ol>
<h3>2.5 핀 설정 레지스터</h3>
<p>각 GPIO 핀은 다음 레지스터들로 제어된다:</p>
<pre><code>레지스터          비트 수/핀    기능
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
</code></pre>
<p><strong>레지스터 직접 조작 예시 (PA7을 SPI1_MOSI AF5로 설정):</strong></p>
<pre><code class="language-c">// 1. GPIOA 클럭 활성화
RCC->AHB4ENR |= RCC_AHB4ENR_GPIOAEN;

// 2. PA7을 Alternate Function 모드로 설정
GPIOA->MODER &#x26;= ~(0x3 &#x3C;&#x3C; (7 * 2));     // 비트 클리어
GPIOA->MODER |=  (0x2 &#x3C;&#x3C; (7 * 2));     // 10 = AF 모드

// 3. AF5 (SPI1) 선택 — PA7은 핀 0~7이므로 AFRL 사용
GPIOA->AFR[0] &#x26;= ~(0xF &#x3C;&#x3C; (7 * 4));    // 비트 클리어
GPIOA->AFR[0] |=  (0x5 &#x3C;&#x3C; (7 * 4));    // AF5 = SPI1

// 4. Push-Pull, Very High Speed
GPIOA->OTYPER &#x26;= ~(1 &#x3C;&#x3C; 7);            // Push-Pull
GPIOA->OSPEEDR |= (0x3 &#x3C;&#x3C; (7 * 2));    // Very High Speed
</code></pre>
<blockquote>
<p><strong>실무에서는 HAL 라이브러리를 사용하므로 레지스터를 직접 다룰 일은 드물다.</strong>
하지만 레지스터 구조를 이해하면 디버깅 시 레지스터 값을 읽고 문제를 진단할 수 있다.</p>
</blockquote>
<h3>2.6 데이터시트에서 핀 정보 찾는 법</h3>
<p>STM32H743VITx의 핀 정보를 찾으려면 두 문서가 필요하다:</p>
<table>
<thead>
<tr>
<th>문서</th>
<th>내용</th>
<th>찾을 정보</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Datasheet</strong> (DS12110)</td>
<td>핀아웃, 전기적 특성, 패키지</td>
<td>물리적 핀 번호, AF 테이블, 전압/전류 스펙</td>
</tr>
<tr>
<td><strong>Reference Manual</strong> (RM0433)</td>
<td>레지스터, 페리페럴 동작</td>
<td>GPIO 레지스터, 타이머 설정, CAN 프로토콜 등</td>
</tr>
</tbody>
</table>
<p><strong>데이터시트에서 핵심적으로 봐야 할 섹션:</strong></p>
<ul>
<li><strong>Table 9~12</strong>: "Alternate function mapping" — 각 핀의 AF0~AF15 매핑 전체 표</li>
<li><strong>Figure 1</strong>: LQFP-100 핀아웃 다이어그램</li>
<li><strong>Table 7</strong>: "Pin definitions" — 각 핀의 전원/IO 타입, 5V 톨러런트 여부</li>
</ul>
<blockquote>
<p>💡 <strong>팁</strong>: CubeMX를 사용하면 이 테이블을 GUI로 편하게 볼 수 있지만,
데이터시트를 직접 읽는 습관을 들이면 하드웨어 설계 시 큰 도움이 된다.</p>
</blockquote>
<hr>
<p>이전 글: <a href="/ko/study/stm32-architecture">STM32 아키텍처 기초</a> | 다음 글: <a href="/ko/study/stm32-clock-system">STM32 클럭 시스템</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/ko/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","스터디 목록"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 핀 시스템 완전 정복 — AF, GPIO 포트, 핀맵"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"STM32 GPIO 포트 명명 규칙, LQFP-100 핀 매핑, Alternate Function 멀티플렉서를 완전 정복하는 가이드."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"13분 읽기"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","gpio",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"gpio"}],["$","span","pin-mapping",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"pin-mapping"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — 로봇 교육 창시자"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"모두를 위한 로봇 교육을 꿈꾸는 엔지니어입니다. 하드웨어 브링업부터 AI 지능형 로봇까지, 실제 학습 과정을 기록하고 공유합니다."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["기술 여정 함께하기",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 핀 시스템 완전 정복 — AF, GPIO 포트, 핀맵","slug":"stm32-pin-system","lang":"ko"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-pin-system","lang":"ko"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
