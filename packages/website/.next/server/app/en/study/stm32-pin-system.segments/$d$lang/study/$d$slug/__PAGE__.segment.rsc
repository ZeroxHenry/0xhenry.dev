1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T39f8,<p><img src="/images/study/stm32/lqfp100-pinout.png" alt="LQFP-100 Pinout">
<em>STM32H743VITx LQFP-100 pinout diagram</em></p>
<h3>2.1 Physical Pins vs. GPIO Ports</h3>
<p>To understand the STM32 pin system, you need to distinguish between two different "pin numbers":</p>
<ol>
<li><strong>Physical pin number</strong>: The leg number on the IC package (LQFP-100: pins 1–100)</li>
<li><strong>GPIO port name</strong>: The software name like PA0, PB3, PC13</li>
</ol>
<p><strong>GPIO port naming convention:</strong></p>
<pre><code>P + [Port letter] + [Pin number]
│    │              │
│    A~K            0~15
│    (port group)   (pin number within group)
GPIO
</code></pre>
<p>Examples:</p>
<ul>
<li><code>PA0</code> = Port A, Pin 0</li>
<li><code>PB7</code> = Port B, Pin 7</li>
<li><code>PD1</code> = Port D, Pin 1</li>
</ul>
<p>Available GPIO ports on the STM32H743VITx (LQFP-100):</p>
<table>
<thead>
<tr>
<th>Port</th>
<th>Available Pins</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>GPIOA</td>
<td>PA0–PA15</td>
<td>All 16 pins available</td>
</tr>
<tr>
<td>GPIOB</td>
<td>PB0–PB15</td>
<td>All 16 pins available</td>
</tr>
<tr>
<td>GPIOC</td>
<td>PC0–PC13</td>
<td>14 pins (PC14/15 are OSC32)</td>
</tr>
<tr>
<td>GPIOD</td>
<td>PD0–PD15</td>
<td>All 16 pins available</td>
</tr>
<tr>
<td>GPIOE</td>
<td>PE0–PE15</td>
<td>All 16 pins available</td>
</tr>
</tbody>
</table>
<blockquote>
<p>⚠️ <strong>Note</strong>: GPIOF–GPIOK are not available on the LQFP-100 package (no physical pins).
These ports are only accessible on packages with 144 pins or more.</p>
</blockquote>
<h3>2.2 LQFP-100 Physical Pin to GPIO Mapping</h3>
<p>Mapping between physical pin numbers and GPIO names for the STM32H743VITx (LQFP-100):</p>
<pre><code>                      Pins 76–100 (top)
                ┌──────────────────────┐
                │  76 77 78 ... 99 100 │
        Pins    │                      │  Pins
       51–75    │                      │  1–25
       (right)  │    STM32H743VITx     │  (left)
                │      LQFP-100        │
                │                      │
                │  51 50 49 ... 27 26  │
                └──────────────────────┘
                      Pins 26–50 (bottom)
</code></pre>
<p><strong>Key pin mappings (commonly used):</strong></p>
<table>
<thead>
<tr>
<th>Physical Pin</th>
<th>GPIO</th>
<th>Main Functions</th>
<th>AF Examples</th>
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
<td><strong>SWDIO</strong> (debugger)</td>
<td>Debug only — do not reassign!</td>
</tr>
<tr>
<td>77</td>
<td>PA14</td>
<td><strong>SWCLK</strong> (debugger)</td>
<td>Debug only — do not reassign!</td>
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
<td>General-purpose GPIO</td>
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
<td><strong>AF1(TIM1)</strong> — for PWM</td>
</tr>
<tr>
<td>99</td>
<td>PE11</td>
<td>TIM1_CH2, FMC_D8</td>
<td><strong>AF1(TIM1)</strong> — for PWM</td>
</tr>
</tbody>
</table>
<h3>2.3 Pin Function Categories</h3>
<p>The 100 pins on the LQFP-100 fall into four broad categories:</p>
<table>
<thead>
<tr>
<th>Category</th>
<th>Pins</th>
<th>Count</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Power</strong></td>
<td>VDD, VSS, VDDA, VSSA, VREF+, VCAP</td>
<td>~18</td>
<td>Power supply (3.3V, GND)</td>
</tr>
<tr>
<td><strong>Clock</strong></td>
<td>OSC_IN, OSC_OUT (PH0/PH1)</td>
<td>2</td>
<td>External crystal connection</td>
</tr>
<tr>
<td><strong>Reset</strong></td>
<td>NRST</td>
<td>1</td>
<td>System reset (active low)</td>
</tr>
<tr>
<td><strong>Debug</strong></td>
<td>PA13 (SWDIO), PA14 (SWCLK)</td>
<td>2</td>
<td>SWD debugger only</td>
</tr>
<tr>
<td><strong>Boot</strong></td>
<td>BOOT0</td>
<td>1</td>
<td>Boot mode selection</td>
</tr>
<tr>
<td><strong>GPIO</strong></td>
<td>PA0–PE15</td>
<td>~76</td>
<td>General-purpose I/O + AF</td>
</tr>
</tbody>
</table>
<blockquote>
<p>🔴 <strong>Hard rule</strong>: PA13/PA14 are the SWD debugger pins. Reassigning them to any other function will make debugging and programming impossible. Always reserve them for SWD.</p>
</blockquote>
<h3>2.4 Alternate Function (AF) System</h3>
<p>One of the most important concepts in STM32. A single GPIO pin can be configured for up to 16 different functions.</p>
<p><strong>AF numbering (AF0–AF15):</strong></p>
<table>
<thead>
<tr>
<th>AF Number</th>
<th>Main Functions</th>
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
<p><img src="/images/study/stm32/af-mux.png" alt="AF Multiplexer">
<em>AF0–AF15 multiplexer — select one of 16 functions per pin</em></p>
<p><strong>AF example — PA7:</strong></p>
<p>PA7 can be assigned any of the following:</p>
<ul>
<li>AF0: MCO (microcontroller clock output)</li>
<li>AF2: TIM3_CH2 (Timer 3 channel 2 = PWM output)</li>
<li>AF5: SPI1_MOSI (SPI1 master output)</li>
<li>Analog: ADC1_IN7 (analog input)</li>
</ul>
<p><strong>Only one AF can be active at a time.</strong> If PA7 is configured as SPI1_MOSI, ADC and TIM3 cannot be used on that pin simultaneously.</p>
<p><strong>How to avoid AF conflicts:</strong></p>
<ol>
<li>List all the peripherals you need (CAN, UART, SPI, ADC, PWM, etc.)</li>
<li>Check the pin options for each peripheral (Datasheet Tables 9–12)</li>
<li>Arrange pins so AFs don't overlap → CubeMX checks for conflicts automatically</li>
</ol>
<h3>2.5 Pin Configuration Registers</h3>
<p>Each GPIO pin is controlled through the following registers:</p>
<pre><code>Register          Bits/pin    Function
──────────────────────────────────────────────
GPIOx_MODER      2 bits/pin  Mode selection
                              00 = Input
                              01 = Output
                              10 = Alternate Function
                              11 = Analog

GPIOx_OTYPER     1 bit/pin   Output type
                              0 = Push-Pull
                              1 = Open-Drain

GPIOx_OSPEEDR    2 bits/pin  Output speed
                              00 = Low (up to 12 MHz)
                              01 = Medium (up to 60 MHz)
                              10 = High (up to 85 MHz)
                              11 = Very High (up to 100 MHz)

GPIOx_PUPDR      2 bits/pin  Pull-up/pull-down
                              00 = No Pull
                              01 = Pull-Up
                              10 = Pull-Down
                              11 = Reserved

GPIOx_AFRL       4 bits/pin  AF select (pins 0–7)
GPIOx_AFRH       4 bits/pin  AF select (pins 8–15)
                              0000 = AF0
                              0001 = AF1
                              ...
                              1111 = AF15
</code></pre>
<p><strong>Direct register example (configure PA7 as SPI1_MOSI with AF5):</strong></p>
<pre><code class="language-c">// 1. Enable GPIOA clock
RCC->AHB4ENR |= RCC_AHB4ENR_GPIOAEN;

// 2. Set PA7 to Alternate Function mode
GPIOA->MODER &#x26;= ~(0x3 &#x3C;&#x3C; (7 * 2));     // clear bits
GPIOA->MODER |=  (0x2 &#x3C;&#x3C; (7 * 2));     // 10 = AF mode

// 3. Select AF5 (SPI1) — PA7 is pin 0–7, so use AFRL
GPIOA->AFR[0] &#x26;= ~(0xF &#x3C;&#x3C; (7 * 4));    // clear bits
GPIOA->AFR[0] |=  (0x5 &#x3C;&#x3C; (7 * 4));    // AF5 = SPI1

// 4. Push-Pull, Very High Speed
GPIOA->OTYPER &#x26;= ~(1 &#x3C;&#x3C; 7);            // Push-Pull
GPIOA->OSPEEDR |= (0x3 &#x3C;&#x3C; (7 * 2));    // Very High Speed
</code></pre>
<blockquote>
<p><strong>In practice you'll use the HAL library, so direct register manipulation is rare.</strong>
That said, understanding the register layout lets you read register values during debugging and diagnose problems quickly.</p>
</blockquote>
<h3>2.6 Finding Pin Information in the Datasheet</h3>
<p>You need two documents to look up pin information for the STM32H743VITx:</p>
<table>
<thead>
<tr>
<th>Document</th>
<th>Contents</th>
<th>What to look for</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Datasheet</strong> (DS12110)</td>
<td>Pinout, electrical characteristics, package</td>
<td>Physical pin numbers, AF tables, voltage/current specs</td>
</tr>
<tr>
<td><strong>Reference Manual</strong> (RM0433)</td>
<td>Registers, peripheral operation</td>
<td>GPIO registers, timer config, CAN protocol, etc.</td>
</tr>
</tbody>
</table>
<p><strong>Key sections to read in the datasheet:</strong></p>
<ul>
<li><strong>Tables 9–12</strong>: "Alternate function mapping" — full AF0–AF15 mapping for every pin</li>
<li><strong>Figure 1</strong>: LQFP-100 pinout diagram</li>
<li><strong>Table 7</strong>: "Pin definitions" — power/IO type and 5V-tolerance for each pin</li>
</ul>
<blockquote>
<p>💡 <strong>Tip</strong>: CubeMX lets you browse these tables in a GUI, but getting comfortable reading
the datasheet directly pays off significantly when doing hardware design.</p>
</blockquote>
<hr>
<p>Previous post: <a href="/en/study/stm32-architecture">STM32 Architecture Basics</a> | Next post: <a href="/en/study/stm32-clock-system">STM32 Clock System</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/en/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","Back to Study"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 Pin System Deep Dive — AF, GPIO Ports, Pin Mapping"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"Complete guide to STM32 GPIO port naming, LQFP-100 pin mapping, and Alternate Function multiplexer."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"9 min read"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","gpio",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"gpio"}],["$","span","pin-mapping",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"pin-mapping"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — Robot Education Founder"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"Engineer dedicated to democratizing robot education for everyone. From hardware bring-up to AI integration, I document real learning."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["Follow the journey",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 Pin System Deep Dive — AF, GPIO Ports, Pin Mapping","slug":"stm32-pin-system","lang":"en"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-pin-system","lang":"en"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
