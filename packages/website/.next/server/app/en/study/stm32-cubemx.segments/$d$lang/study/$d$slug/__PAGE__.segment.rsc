1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T1cb6,<h2>STM32CubeMX Setup Walkthrough</h2>
<p><img src="/images/study/stm32/cubemx-pinout.png" alt="CubeMX Pinout View">
<em>CubeMX pinout view</em></p>
<p>CubeMX is a tool that lets you configure STM32 pin assignments, clocks, and peripherals through a GUI and automatically generates the initialization code. It is built into STM32CubeIDE.</p>
<h3>Step 1: Create Project &#x26; Select Chip</h3>
<ol>
<li>STM32CubeIDE → <strong>File</strong> → <strong>New</strong> → <strong>STM32 Project</strong></li>
<li>In the <strong>MCU/MPU Selector</strong> tab, search: <code>STM32H743VITx</code></li>
<li>Select the chip and click <strong>Next</strong></li>
<li>Project Name: <code>AR_Walker_STM32</code> (or <code>H-Walker_STM32_Test</code>)</li>
<li>Targeted Language: <strong>C</strong></li>
<li>Targeted Binary Type: <strong>Executable</strong></li>
<li>Targeted Project Type: <strong>STM32Cube</strong></li>
<li>Click <strong>Finish</strong> → the <code>.ioc</code> file opens and the pin configuration view appears</li>
</ol>
<h3>Step 2: Assign Pins (Pinout &#x26; Configuration)</h3>
<p>Click a pin in the chip graphic inside the <code>.ioc</code> editor to assign its function.</p>
<p><strong>Recommended configuration order:</strong></p>
<ol>
<li><strong>Reserve debug pins</strong>: System Core → SYS → Debug: <strong>Serial Wire</strong> (PA13/PA14 auto-assigned)</li>
<li><strong>Clock source</strong>: System Core → RCC → HSE: <strong>Crystal/Ceramic Resonator</strong></li>
<li><strong>FDCAN1</strong>: Connectivity → FDCAN1 → Activated
<ul>
<li>TX: PD1, RX: PD0 (auto-assigned or selected manually)</li>
</ul>
</li>
<li><strong>UART (IMU)</strong>: Connectivity → UART4 → Mode: Asynchronous
<ul>
<li>RX: PA1 (disable TX if not needed)</li>
</ul>
</li>
<li><strong>UART (Debug)</strong>: Connectivity → USART3 → Mode: Asynchronous
<ul>
<li>TX: PD8, RX: PD9</li>
</ul>
</li>
<li><strong>SPI1</strong>: Connectivity → SPI1 → Mode: Full-Duplex Master
<ul>
<li>SCK: PA5, MOSI: PB5, MISO: PB4 (leave PA6/PA7 free for ADC)</li>
</ul>
</li>
<li><strong>ADC1</strong>: Analog → ADC1 → Enable IN0, IN1, IN2, IN6 (or IN14/IN15)
<ul>
<li>Watch for PA0/PA1 conflicts with UART4 RX; reassign ADC channels if needed</li>
</ul>
</li>
<li><strong>TIM1 PWM</strong>: Timers → TIM1 → CH1: PWM Generation, CH2: PWM Generation
<ul>
<li>CH1: PE9, CH2: PE11</li>
</ul>
</li>
<li><strong>GPIO outputs</strong>: Click a pin → select GPIO_Output
<ul>
<li>LED, Motor Enable, Motor Stop pins</li>
</ul>
</li>
<li><strong>GPIO inputs</strong>: Motor error pins, etc.</li>
</ol>
<p><strong>Checking for pin conflicts:</strong></p>
<ul>
<li>A <strong>yellow</strong> pin in CubeMX = warning (can be resolved)</li>
<li>A <strong>red</strong> pin = conflict (must be fixed)</li>
<li>Check the <strong>"Pinout Conflict"</strong> message in the left panel</li>
</ul>
<h3>Step 3: Clock Configuration</h3>
<ol>
<li>Click the <strong>Clock Configuration</strong> tab at the top</li>
<li>Left side — Input frequency: <strong>8</strong> (MHz, match your crystal)</li>
<li>PLL Source Mux: select <strong>HSE</strong></li>
<li>Enter DIVM1: 1, DIVN1: 120, DIVP1: 2</li>
<li>System Clock Mux: select <strong>PLLCLK</strong></li>
<li>Confirm HCLK reads <strong>240 MHz</strong> (calculated automatically)</li>
<li>Verify each APB clock is at 120 MHz</li>
<li>If there are red warnings, click <strong>"Resolve Clock Issues"</strong></li>
</ol>
<h3>Step 4: Peripheral Parameter Settings</h3>
<p>Configure each peripheral in detail from the <strong>Configuration</strong> panel on the left.</p>
<h4>FDCAN1 Parameters</h4>
<pre><code>Mode                    : Normal
Frame Format            : Classic (CAN 2.0)
Auto Retransmission     : Enable
Nominal Prescaler       : 10
Nominal Sync Jump Width : 1
Nominal Time Seg1       : 5
Nominal Time Seg2       : 6
→ Bit Rate = 120MHz / (10 × (1+5+6)) = 1 Mbps
</code></pre>
<h4>ADC1 Parameters</h4>
<pre><code>Clock Prescaler         : Asynchronous clock mode divided by 4
Resolution              : ADC 12-bit resolution (or 16-bit)
Scan Conversion Mode    : Enable
Continuous Conv Mode    : Enable
DMA Continuous Requests : Enable
Number of Conversion    : (number of channels in use)
</code></pre>
<h4>DMA Settings</h4>
<p>In the DMA Settings tab of each peripheral:</p>
<ul>
<li>ADC1 → Add DMA Stream → Mode: <strong>Circular</strong></li>
<li>UART4_RX → Add DMA Stream → Mode: <strong>Circular</strong></li>
</ul>
<h4>NVIC (Interrupt Priorities)</h4>
<pre><code>Interrupt          Priority (0=highest)  Purpose
FDCAN1_IT0         1                     CAN receive (motor response — top priority)
TIM6_DAC           2                     Control loop timer (500 Hz)
DMA_ADCx           3                     ADC conversion complete
UART4_IRQn         4                     IMU data receive
SPI1_IRQn          5                     Coms MCU data
EXTI_IRQn          6                     GPIO interrupt (errors, etc.)
</code></pre>
<h3>Step 5: Project Settings</h3>
<ol>
<li>Click the <strong>Project Manager</strong> tab</li>
<li>Project Settings:
<ul>
<li>Toolchain: <strong>STM32CubeIDE</strong></li>
<li>Generate Under Root: checked</li>
</ul>
</li>
<li>Code Generator:
<ul>
<li><strong>"Generate peripheral initialization as a pair of '.c/.h' files per peripheral"</strong> → check (recommended)</li>
<li><strong>"Keep User Code when re-generating"</strong> → check (required!)</li>
<li><strong>"Delete previously generated files when not re-generated"</strong> → check</li>
</ul>
</li>
</ol>
<h3>Step 6: Generate Code</h3>
<ol>
<li><strong>Project</strong> → <strong>Generate Code</strong> (or Alt+K / Cmd+K)</li>
<li>The generated file structure:</li>
</ol>
<pre><code>AR_Walker_STM32/
├── Core/
│   ├── Inc/
│   │   ├── main.h              ← GPIO pin defines (auto-generated by CubeMX)
│   │   ├── stm32h7xx_hal_conf.h
│   │   └── stm32h7xx_it.h
│   └── Src/
│       ├── main.c              ← ★ write your main code here
│       ├── stm32h7xx_hal_msp.c ← peripheral MSP initialization
│       └── stm32h7xx_it.c      ← interrupt handlers
├── Drivers/
│   ├── CMSIS/                  ← ARM core headers
│   └── STM32H7xx_HAL_Driver/   ← HAL library
└── STM32H743VITX_FLASH.ld      ← linker script
</code></pre>
<h3>USER CODE Block Rules</h3>
<p>These regions are preserved when CubeMX regenerates code:</p>
<pre><code class="language-c">/* USER CODE BEGIN Includes */
#include "motor_control.h"    // ✅ safe!
/* USER CODE END Includes */

// ❌ Writing here will be deleted on regeneration!

/* USER CODE BEGIN 0 */
void my_init(void) { }        // ✅ safe!
/* USER CODE END 0 */
</code></pre>
<blockquote>
<p><strong>Best practice</strong>: Create separate <code>.c</code> files under <code>Core/Src/</code> for your own code.
Examples: <code>motor_control.c</code>, <code>sensor_read.c</code>, <code>can_protocol.c</code>
→ CubeMX never touches these files, so they are 100% safe.
(See the "Managing Auto-Generated and User Code" section in README.md for details.)</p>
</blockquote>
<hr>
<p>Previous: <a href="/en/study/stm32-peripherals">STM32 Essential Peripherals</a> | Next: <a href="/en/study/stm32-pin-mapping">STM32 Pin Mapping Strategy</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/en/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","Back to Study"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32CubeMX Practical Setup — From Project Creation to Code Generation"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"Step-by-step guide to configuring clocks, pins, and peripherals in STM32CubeMX and generating a HAL project."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"5 min read"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","cubemx",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"cubemx"}],["$","span","hal",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"hal"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — Robot Education Founder"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"Engineer dedicated to democratizing robot education for everyone. From hardware bring-up to AI integration, I document real learning."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["Follow the journey",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32CubeMX Practical Setup — From Project Creation to Code Generation","slug":"stm32-cubemx","lang":"en"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-cubemx","lang":"en"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
