1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T16d7,<p><img src="/images/study/stm32/clock-tree.png" alt="Clock Tree">
<em>HSE → PLL → SYSCLK clock tree</em></p>
<h3>3.1 Clock Sources</h3>
<p>The STM32H743 has four clock sources:</p>
<table>
<thead>
<tr>
<th>Clock Source</th>
<th>Frequency</th>
<th>Accuracy</th>
<th>Usage</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>HSE</strong> (High-Speed External)</td>
<td>4~50 MHz (typically 8 or 25 MHz)</td>
<td>High (crystal)</td>
<td>PLL input → SYSCLK</td>
</tr>
<tr>
<td><strong>HSI</strong> (High-Speed Internal)</td>
<td>64 MHz fixed</td>
<td>Moderate (RC oscillator)</td>
<td>Default clock after reset</td>
</tr>
<tr>
<td><strong>LSE</strong> (Low-Speed External)</td>
<td>32.768 kHz</td>
<td>High</td>
<td>RTC, low-power modes</td>
</tr>
<tr>
<td><strong>LSI</strong> (Low-Speed Internal)</td>
<td>32 kHz</td>
<td>Low</td>
<td>Independent watchdog (IWDG)</td>
</tr>
</tbody>
</table>
<p><strong>Choice for the robot board:</strong></p>
<ul>
<li><strong>Recommended: HSE 8MHz crystal</strong> → generates 480MHz SYSCLK via PLL</li>
<li>LSE 32.768kHz is optional (only if RTC is needed)</li>
<li>HSI is a fallback (can auto-switch if crystal fails)</li>
</ul>
<h3>3.2 PLL Configuration: Path from 8MHz to 480MHz</h3>
<p>The STM32H7 has three PLLs. PLL1 (main) generates SYSCLK:</p>
<pre><code>HSE (8 MHz)
    │
    ▼
  DIVM1 = /1        ← PLL input prescaler
    │
    ▼
  8 MHz (PLL input)  ← must be within 1~16 MHz range
    │
    ▼
  DIVN1 = x120      ← VCO multiplier
    │
    ▼
  960 MHz (VCO)     ← VCO range: 192~960 MHz
    │
    ├─ DIVP1 = /2 ──→ 480 MHz ──→ SYSCLK (system clock)
    │
    ├─ DIVQ1 = /4 ──→ 240 MHz ──→ some peripherals (FDCAN, etc.)
    │
    └─ DIVR1 = /2 ──→ 480 MHz ──→ (disable if unused)
</code></pre>
<p><strong>CubeMX settings:</strong></p>
<table>
<thead>
<tr>
<th>Parameter</th>
<th>Value</th>
<th>Meaning</th>
</tr>
</thead>
<tbody>
<tr>
<td>PLL Source</td>
<td>HSE</td>
<td>Use external crystal</td>
</tr>
<tr>
<td>DIVM1</td>
<td>1</td>
<td>8MHz / 1 = 8MHz</td>
</tr>
<tr>
<td>DIVN1</td>
<td>120</td>
<td>8MHz x 120 = 960MHz (VCO)</td>
</tr>
<tr>
<td>DIVP1</td>
<td>2</td>
<td>960MHz / 2 = <strong>480MHz</strong> (SYSCLK)</td>
</tr>
<tr>
<td>DIVQ1</td>
<td>4</td>
<td>960MHz / 4 = 240MHz</td>
</tr>
<tr>
<td>DIVR1</td>
<td>2</td>
<td>960MHz / 2 = 480MHz (can be disabled)</td>
</tr>
</tbody>
</table>
<h3>3.3 Clock Tree: Distribution from SYSCLK to Each Bus</h3>
<pre><code>SYSCLK (480 MHz)
    │
    ▼
  D1CPRE = /1
    │
    ▼
  CPU clock = 480 MHz
    │
    ├── HPRE = /2 ──→ AHB clock = 240 MHz
    │                    │
    │                    ├── D1PPRE = /2 ──→ APB3 = 120 MHz (timers x2 = 240 MHz)
    │                    │
    │                    ├── D2PPRE1 = /2 ──→ APB1 = 120 MHz (timers x2 = 240 MHz)
    │                    │                      └── TIM2-7, TIM12-14
    │                    │                      └── USART2/3, UART4/5/7/8
    │                    │                      └── SPI2/3, I2C1-3
    │                    │                      └── **FDCAN1/2**
    │                    │
    │                    ├── D2PPRE2 = /2 ──→ APB2 = 120 MHz (timers x2 = 240 MHz)
    │                    │                      └── TIM1, TIM8, TIM15-17
    │                    │                      └── USART1/6
    │                    │                      └── SPI1/4/5
    │                    │                      └── ADC1/2
    │                    │
    │                    └── D3PPRE = /2 ──→ APB4 = 120 MHz
    │                                        └── I2C4, SPI6
    │                                        └── EXTI, RTC
    │
    └── SysTick = 480 MHz (default) or AHB/8
</code></pre>
<p><strong>Key summary:</strong></p>
<table>
<thead>
<tr>
<th>Bus</th>
<th>Frequency</th>
<th>Timer Clock</th>
<th>Key Peripherals</th>
</tr>
</thead>
<tbody>
<tr>
<td>CPU</td>
<td>480 MHz</td>
<td>—</td>
<td>Cortex-M7 core</td>
</tr>
<tr>
<td>AHB</td>
<td>240 MHz</td>
<td>—</td>
<td>DMA, GPIO, Flash</td>
</tr>
<tr>
<td>APB1</td>
<td>120 MHz</td>
<td>240 MHz</td>
<td>FDCAN, UART4/5/7/8, SPI2/3, TIM2-7</td>
</tr>
<tr>
<td>APB2</td>
<td>120 MHz</td>
<td>240 MHz</td>
<td>USART1/6, SPI1, ADC1/2, TIM1/8</td>
</tr>
<tr>
<td>APB3</td>
<td>120 MHz</td>
<td>—</td>
<td>LTDC</td>
</tr>
<tr>
<td>APB4</td>
<td>120 MHz</td>
<td>—</td>
<td>I2C4, SPI6</td>
</tr>
</tbody>
</table>
<blockquote>
<p>🔴 <strong>Important</strong>: <strong>Timers</strong> connected to an APB bus are automatically <strong>doubled (x2)</strong> when the APB prescaler is not 1.
Since APB1 = 120MHz with a /2 prescaler, the actual clock for TIM2~7 is 240MHz.</p>
</blockquote>
<h3>3.4 Clock Configuration in CubeMX</h3>
<p><img src="/images/study/stm32/cubemx-clock.png" alt="CubeMX Clock Configuration">
<em>CubeMX Clock Configuration tab</em></p>
<p>In the CubeMX Clock Configuration tab:</p>
<ol>
<li><strong>Left side</strong>: Select "HSE" in the PLL Source Mux</li>
<li><strong>Middle</strong>: Enter PLL1 parameters (DIVM=1, N=120, P=2, Q=4)</li>
<li><strong>System Clock Mux</strong>: Select "PLLCLK"</li>
<li><strong>Right side</strong>: Bus prescalers are configured automatically</li>
<li><strong>Verify</strong>: Click "Resolve Clock Issues" to check for problems</li>
</ol>
<blockquote>
<p>If CubeMX shows red, the frequency exceeds the maximum for that bus.
Adjust the prescalers to bring each bus frequency within its allowed maximum.</p>
</blockquote>
<hr>
<p>Previous: <a href="/en/study/stm32-pin-system">STM32 Pin System</a> | Next: <a href="/en/study/stm32-gpio">STM32 GPIO Configuration</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/en/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","Back to Study"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 Clock System — HSE, PLL, and Clock Tree Configuration"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"Understanding STM32H7 clock sources (HSE/HSI), PLL configuration, and how to set up the clock tree for 480MHz."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"4 min read"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","clock-tree",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"clock-tree"}],["$","span","cubemx",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"cubemx"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — Robot Education Founder"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"Engineer dedicated to democratizing robot education for everyone. From hardware bring-up to AI integration, I document real learning."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["Follow the journey",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 Clock System — HSE, PLL, and Clock Tree Configuration","slug":"stm32-clock-system","lang":"en"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-clock-system","lang":"en"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
