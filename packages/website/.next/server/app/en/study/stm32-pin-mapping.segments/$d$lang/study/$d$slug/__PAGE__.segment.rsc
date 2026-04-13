1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T243c,<h2>Robot Board Pin Mapping Strategy</h2>
<p><img src="/images/study/stm32/pin-mapping.png" alt="Teensy → STM32 Pin Mapping">
<em>Pin mapping comparison between Teensy 4.1 and STM32H743</em></p>
<h3>7.1 Pin Assignment Principles</h3>
<ol>
<li><strong>Prevent AF conflicts</strong>: Only one AF can be used per pin</li>
<li><strong>Secure power/ground connections</strong>: All 18 power pins on LQFP-100 must be properly connected</li>
<li><strong>Noise isolation</strong>: ADC input pins must be physically separated from high-speed digital signals (CAN, SPI)</li>
<li><strong>Protect debugger pins</strong>: PA13 (SWDIO) and PA14 (SWCLK) must never be repurposed</li>
<li><strong>Handle unused pins</strong>: Set to Analog mode (minimizes current draw) or Output Low</li>
<li><strong>BOOT0 pin</strong>: Connect to GND (normal boot = execute from Flash)</li>
</ol>
<h3>7.2 Teensy → STM32 Pin Mapping Table</h3>
<p>Final mapping table from the current <code>Board.h</code> Teensy 4.1 pin configuration to STM32H743VITx:</p>
<h4>Communication Peripherals</h4>
<table>
<thead>
<tr>
<th>Function</th>
<th>Teensy Pin</th>
<th>STM32 Pin</th>
<th>AF</th>
<th>Peripheral</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>CAN TX</td>
<td>22</td>
<td><strong>PD1</strong></td>
<td>AF9</td>
<td>FDCAN1_TX</td>
<td>Motor CAN bus</td>
</tr>
<tr>
<td>CAN RX</td>
<td>23</td>
<td><strong>PD0</strong></td>
<td>AF9</td>
<td>FDCAN1_RX</td>
<td>Motor CAN bus</td>
</tr>
<tr>
<td>IMU UART RX</td>
<td>16 (RX4)</td>
<td><strong>PD9</strong></td>
<td>AF7</td>
<td>USART3_RX</td>
<td>IMU data receive</td>
</tr>
<tr>
<td>IMU UART TX</td>
<td>N/C</td>
<td><strong>PD8</strong></td>
<td>AF7</td>
<td>USART3_TX</td>
<td>(can double as debug)</td>
</tr>
<tr>
<td>SPI SCK</td>
<td>(implicit)</td>
<td><strong>PA5</strong></td>
<td>AF5</td>
<td>SPI1_SCK</td>
<td>Coms MCU communication</td>
</tr>
<tr>
<td>SPI MOSI</td>
<td>11</td>
<td><strong>PB5</strong></td>
<td>AF5</td>
<td>SPI1_MOSI</td>
<td>PA7 reserved for ADC</td>
</tr>
<tr>
<td>SPI MISO</td>
<td>(implicit)</td>
<td><strong>PB4</strong></td>
<td>AF5</td>
<td>SPI1_MISO</td>
<td>PA6 reserved for ADC</td>
</tr>
<tr>
<td>SPI CS</td>
<td>10</td>
<td><strong>PA15</strong></td>
<td>GPIO</td>
<td>—</td>
<td>Software CS</td>
</tr>
<tr>
<td>SPI IRQ</td>
<td>34</td>
<td><strong>PE0</strong></td>
<td>GPIO</td>
<td>EXTI0</td>
<td>Interrupt input</td>
</tr>
<tr>
<td>SPI RST</td>
<td>4</td>
<td><strong>PE1</strong></td>
<td>GPIO</td>
<td>—</td>
<td>Coms MCU reset</td>
</tr>
<tr>
<td>Serial TX</td>
<td>1</td>
<td><strong>PA9</strong></td>
<td>AF7</td>
<td>USART1_TX</td>
<td>(debug/PC communication)</td>
</tr>
<tr>
<td>Serial RX</td>
<td>0</td>
<td><strong>PA10</strong></td>
<td>AF7</td>
<td>USART1_RX</td>
<td>(debug/PC communication)</td>
</tr>
</tbody>
</table>
<h4>Analog Inputs (ADC)</h4>
<table>
<thead>
<tr>
<th>Function</th>
<th>Teensy Pin</th>
<th>STM32 Pin</th>
<th>Channel</th>
<th>Peripheral</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>Torque Sensor Left</td>
<td>A16</td>
<td><strong>PA0</strong></td>
<td>IN0</td>
<td>ADC1</td>
<td>Load cell L</td>
</tr>
<tr>
<td>Torque Sensor Right</td>
<td>A6</td>
<td><strong>PA3</strong></td>
<td>IN3</td>
<td>ADC1</td>
<td>Load cell R (PA3 instead of PA6)</td>
</tr>
<tr>
<td>Angle Sensor Left</td>
<td>A13</td>
<td><strong>PC3</strong></td>
<td>IN13</td>
<td>ADC1</td>
<td>Left ankle angle</td>
</tr>
<tr>
<td>Angle Sensor Right</td>
<td>A12</td>
<td><strong>PC2</strong></td>
<td>IN12</td>
<td>ADC1</td>
<td>Right ankle angle</td>
</tr>
<tr>
<td>Maxon Current Left</td>
<td>(maxon_current)</td>
<td><strong>PA1</strong></td>
<td>IN1</td>
<td>ADC1</td>
<td>Left motor current</td>
</tr>
<tr>
<td>Maxon Current Right</td>
<td>(maxon_current)</td>
<td><strong>PA2</strong></td>
<td>IN2</td>
<td>ADC1</td>
<td>Right motor current</td>
</tr>
<tr>
<td>(Spare 1)</td>
<td>—</td>
<td><strong>PC4</strong></td>
<td>IN14</td>
<td>ADC1</td>
<td>For expansion</td>
</tr>
<tr>
<td>(Spare 2)</td>
<td>—</td>
<td><strong>PC5</strong></td>
<td>IN15</td>
<td>ADC1</td>
<td>For expansion</td>
</tr>
</tbody>
</table>
<h4>PWM Outputs</h4>
<table>
<thead>
<tr>
<th>Function</th>
<th>Teensy Pin</th>
<th>STM32 Pin</th>
<th>AF</th>
<th>Peripheral</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>Maxon PWM Left</td>
<td>(maxon_ctrl_L)</td>
<td><strong>PE9</strong></td>
<td>AF1</td>
<td>TIM1_CH1</td>
<td>Left motor</td>
</tr>
<tr>
<td>Maxon PWM Right</td>
<td>(maxon_ctrl_R)</td>
<td><strong>PE11</strong></td>
<td>AF1</td>
<td>TIM1_CH2</td>
<td>Right motor</td>
</tr>
</tbody>
</table>
<h4>GPIO Outputs</h4>
<table>
<thead>
<tr>
<th>Function</th>
<th>Teensy Pin</th>
<th>STM32 Pin</th>
<th>Configuration</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>Status LED Red</td>
<td>14</td>
<td><strong>PB0</strong></td>
<td>Output PP, Low Speed</td>
<td>RGB LED</td>
</tr>
<tr>
<td>Status LED Green</td>
<td>25</td>
<td><strong>PB1</strong></td>
<td>Output PP, Low Speed</td>
<td>RGB LED</td>
</tr>
<tr>
<td>Status LED Blue</td>
<td>24</td>
<td><strong>PB2</strong></td>
<td>Output PP, Low Speed</td>
<td>RGB LED</td>
</tr>
<tr>
<td>Sync LED</td>
<td>15</td>
<td><strong>PB10</strong></td>
<td>Output PP, Low Speed</td>
<td>Sync LED</td>
</tr>
<tr>
<td>Motor Stop</td>
<td>9</td>
<td><strong>PC6</strong></td>
<td>Output PP, Pull-Down</td>
<td>Emergency stop</td>
</tr>
<tr>
<td>Motor Enable L0</td>
<td>28</td>
<td><strong>PD3</strong></td>
<td>Output PP, Pull-Down</td>
<td>Left joint 0</td>
</tr>
<tr>
<td>Motor Enable L1</td>
<td>29</td>
<td><strong>PD4</strong></td>
<td>Output PP, Pull-Down</td>
<td>Left joint 1</td>
</tr>
<tr>
<td>Motor Enable R0</td>
<td>8</td>
<td><strong>PD5</strong></td>
<td>Output PP, Pull-Down</td>
<td>Right joint 0</td>
</tr>
<tr>
<td>Motor Enable R1</td>
<td>7</td>
<td><strong>PD6</strong></td>
<td>Output PP, Pull-Down</td>
<td>Right joint 1</td>
</tr>
<tr>
<td>Sync Default</td>
<td>5</td>
<td><strong>PC7</strong></td>
<td>Output PP</td>
<td>Sync default</td>
</tr>
<tr>
<td>Speed Check</td>
<td>33</td>
<td><strong>PC8</strong></td>
<td>Output PP</td>
<td>Toggle pin for timing measurement</td>
</tr>
</tbody>
</table>
<h4>GPIO Inputs</h4>
<table>
<thead>
<tr>
<th>Function</th>
<th>Teensy Pin</th>
<th>STM32 Pin</th>
<th>Configuration</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>Maxon Error Left</td>
<td>(maxon_err_L)</td>
<td><strong>PE2</strong></td>
<td>Input, Pull-Up</td>
<td>Error detection (active low)</td>
</tr>
<tr>
<td>Maxon Error Right</td>
<td>(maxon_err_R)</td>
<td><strong>PE3</strong></td>
<td>Input, Pull-Up</td>
<td>Error detection (active low)</td>
</tr>
</tbody>
</table>
<h4>System Pins (Do Not Change)</h4>
<table>
<thead>
<tr>
<th>Function</th>
<th>STM32 Pin</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>SWDIO (Debugger)</td>
<td>PA13</td>
<td>Never reassign</td>
</tr>
<tr>
<td>SWCLK (Debugger)</td>
<td>PA14</td>
<td>Never reassign</td>
</tr>
<tr>
<td>HSE Crystal IN</td>
<td>PH0 (pin 12)</td>
<td>8MHz crystal</td>
</tr>
<tr>
<td>HSE Crystal OUT</td>
<td>PH1 (pin 13)</td>
<td>8MHz crystal</td>
</tr>
<tr>
<td>NRST</td>
<td>pin 14 (NRST)</td>
<td>Reset button</td>
</tr>
<tr>
<td>BOOT0</td>
<td>pin 94</td>
<td>Connected to GND (Flash boot)</td>
</tr>
</tbody>
</table>
<h3>7.3 AF Conflict Verification</h3>
<p>Key conflict resolutions in the above mapping:</p>
<table>
<thead>
<tr>
<th>Issue</th>
<th>Cause</th>
<th>Resolution</th>
</tr>
</thead>
<tbody>
<tr>
<td>PA6 cannot be used for both ADC and SPI1_MISO</td>
<td>AF conflict</td>
<td>Move SPI1_MISO to <strong>PB4</strong> (AF5)</td>
</tr>
<tr>
<td>PA7 cannot be used for both ADC and SPI1_MOSI</td>
<td>AF conflict</td>
<td>Move SPI1_MOSI to <strong>PB5</strong> (AF5)</td>
</tr>
<tr>
<td>PA1 cannot be used for both ADC (current sensing) and UART4_RX</td>
<td>AF conflict</td>
<td>Move IMU UART to <strong>USART3</strong> (PD8/PD9)</td>
</tr>
<tr>
<td>PA6 used for torque sensor R ADC conflicts with SPI</td>
<td>AF conflict</td>
<td>Move torque sensor R to <strong>PA3</strong> (ADC1_IN3)</td>
</tr>
</tbody>
</table>
<h3>7.4 Pin Usage Summary</h3>
<table>
<thead>
<tr>
<th>Port</th>
<th>Used Pins</th>
<th>Unused Pins</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td>GPIOA</td>
<td>PA0-5, PA9-10, PA13-15</td>
<td>PA6-8, PA11-12</td>
<td>PA11/12 reserved for USB</td>
</tr>
<tr>
<td>GPIOB</td>
<td>PB0-2, PB4-5, PB10</td>
<td>PB3, PB6-9, PB11-15</td>
<td>Plenty of room</td>
</tr>
<tr>
<td>GPIOC</td>
<td>PC2-8</td>
<td>PC0-1, PC9-13</td>
<td>PC13 can be WKUP</td>
</tr>
<tr>
<td>GPIOD</td>
<td>PD0-1, PD3-6, PD8-9</td>
<td>PD2, PD7, PD10-15</td>
<td>Plenty of room</td>
</tr>
<tr>
<td>GPIOE</td>
<td>PE0-3, PE9, PE11</td>
<td>PE4-8, PE10, PE12-15</td>
<td>Plenty of room</td>
</tr>
</tbody>
</table>
<blockquote>
<p><strong>Total pins used</strong>: ~40 / <strong>Spare pins</strong>: ~36 — plenty of room for future expansion</p>
</blockquote>
<h3>7.5 Pin Map Documentation</h3>
<p>The finalized pin mapping should be written to <code>Documentation/Hardware/AR_Walker_STM32_Pinmap.md</code>
using the <code>templates/hardware_pinmap_template.md</code> template.</p>
<hr>
<p>Previous post: <a href="/en/study/stm32-cubemx">STM32CubeMX Practical Configuration</a> | Next post: <a href="/en/study/stm32-bringup">STM32 Board Bringup</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/en/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","Back to Study"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 Robot Board Pin Mapping Strategy — Migrating from Teensy"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"Pin mapping strategy and actual layout results from migrating a robot board from Teensy 4.1 to STM32H743."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"6 min read"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","pin-mapping",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"pin-mapping"}],["$","span","robotics",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"robotics"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — Robot Education Founder"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"Engineer dedicated to democratizing robot education for everyone. From hardware bring-up to AI integration, I document real learning."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["Follow the journey",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 Robot Board Pin Mapping Strategy — Migrating from Teensy","slug":"stm32-pin-mapping","lang":"en"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-pin-mapping","lang":"en"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
