1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T11a3,<p><img src="/images/study/stm32/cortex-m7-block.png" alt="ARM Cortex-M7 Architecture">
<em>Cortex-M7 core block diagram</em></p>
<h3>1.1 ARM Cortex-M7 Core</h3>
<p>The STM32H743VITx is a high-performance microcontroller built around the ARM Cortex-M7 core.</p>
<p><strong>Core Specifications:</strong></p>
<table>
<thead>
<tr>
<th>Item</th>
<th>Spec</th>
</tr>
</thead>
<tbody>
<tr>
<td>Architecture</td>
<td>ARMv7E-M</td>
</tr>
<tr>
<td>Pipeline</td>
<td>6-stage superscalar (dual-issue)</td>
</tr>
<tr>
<td>FPU</td>
<td>Single-precision (SP) + Double-precision (DP) floating-point</td>
</tr>
<tr>
<td>DSP</td>
<td>Single-cycle MAC, SIMD instructions</td>
</tr>
<tr>
<td>I-Cache</td>
<td>16 KB (instruction cache)</td>
</tr>
<tr>
<td>D-Cache</td>
<td>16 KB (data cache)</td>
</tr>
<tr>
<td>MPU</td>
<td>16-region Memory Protection Unit</td>
</tr>
<tr>
<td>Max Clock</td>
<td>480 MHz</td>
</tr>
</tbody>
</table>
<p><strong>Why Cortex-M7 for a robot board?</strong></p>
<ul>
<li>Reliably drives a 500 Hz control loop (same core as the Teensy 4.1)</li>
<li>FPU handles PID calculations, torque computations, and other floating-point math in hardware</li>
<li>DSP instructions accelerate sensor data filtering (IMU, load cells)</li>
<li>Cache ensures high-speed execution even when running code from Flash</li>
</ul>
<h3>1.2 STM32H743VITx Chip Spec Summary</h3>
<table>
<thead>
<tr>
<th>Item</th>
<th>Spec</th>
<th>Notes</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Package</strong></td>
<td>LQFP-100</td>
<td>100-pin, 14x14mm</td>
</tr>
<tr>
<td><strong>Flash</strong></td>
<td>2 MB</td>
<td>Dual-bank</td>
</tr>
<tr>
<td><strong>Total RAM</strong></td>
<td>1 MB</td>
<td>See breakdown below</td>
</tr>
<tr>
<td><strong>ITCM</strong></td>
<td>64 KB</td>
<td>Instruction-only (0 wait state)</td>
</tr>
<tr>
<td><strong>DTCM</strong></td>
<td>128 KB</td>
<td>Fastest RAM (0 wait-state)</td>
</tr>
<tr>
<td><strong>AXI SRAM</strong></td>
<td>512 KB</td>
<td>General-purpose, large capacity</td>
</tr>
<tr>
<td><strong>SRAM1</strong></td>
<td>128 KB</td>
<td>D2 domain</td>
</tr>
<tr>
<td><strong>SRAM2</strong></td>
<td>128 KB</td>
<td>D2 domain</td>
</tr>
<tr>
<td><strong>SRAM3</strong></td>
<td>32 KB</td>
<td>D2 domain</td>
</tr>
<tr>
<td><strong>SRAM4</strong></td>
<td>64 KB</td>
<td>D3 domain</td>
</tr>
<tr>
<td><strong>Backup SRAM</strong></td>
<td>4 KB</td>
<td>Battery-backed</td>
</tr>
<tr>
<td><strong>GPIO</strong></td>
<td>Up to 82</td>
<td>Available on LQFP-100</td>
</tr>
<tr>
<td><strong>ADC</strong></td>
<td>3 (ADC1/2/3)</td>
<td>16-bit, 3.6 MSPS</td>
</tr>
<tr>
<td><strong>FDCAN</strong></td>
<td>2</td>
<td>CAN FD support</td>
</tr>
<tr>
<td><strong>UART/USART</strong></td>
<td>8</td>
<td>USART1-3,6 + UART4,5,7,8</td>
</tr>
<tr>
<td><strong>SPI</strong></td>
<td>6</td>
<td>SPI1-6</td>
</tr>
<tr>
<td><strong>I2C</strong></td>
<td>4</td>
<td>I2C1-4</td>
</tr>
<tr>
<td><strong>Timer</strong></td>
<td>Many</td>
<td>TIM1-17 (Advanced, GP, Basic)</td>
</tr>
<tr>
<td><strong>Operating Voltage</strong></td>
<td>1.62V – 3.6V</td>
<td>Typically 3.3V</td>
</tr>
</tbody>
</table>
<h3>1.3 Memory Map</h3>
<p>In the STM32H7, memory and peripherals are organized by power domain.</p>
<p><img src="/images/study/stm32/memory-map.png" alt="Memory Map">
<em>STM32H743 memory map — regions by address</em></p>
<p><strong>Memory strategy for the robot board:</strong></p>
<ul>
<li><strong>DTCM (128 KB)</strong>: Control loop variables, PID parameters, motor command buffers → fastest access</li>
<li><strong>AXI SRAM (512 KB)</strong>: ExoData structs, sensor data arrays, config file parse buffers</li>
<li><strong>SRAM1/2 (256 KB)</strong>: DMA transfer buffers (ADC, UART, SPI) → directly accessible by the D2-domain DMA</li>
<li><strong>SRAM4 (64 KB)</strong>: Data that must persist through low-power modes</li>
</ul>
<h3>1.4 Bus Architecture</h3>
<p>The STM32H7 bus is divided into three power domains (D1, D2, D3):</p>
<p><img src="/images/study/stm32/bus-domains.png" alt="Bus Domains">
<em>D1/D2/D3 power domains and bus architecture</em></p>
<p><strong>Key points:</strong></p>
<ul>
<li>GPIO is connected to AHB4 (D3 domain), making it accessible from all domains</li>
<li>FDCAN1/2 sits on APB1 (D2 domain) — when used with DMA1/2, place buffers in SRAM1/2</li>
<li>ADC1/2 is on APB2 while ADC3 is on AHB4, putting them in different domains — be careful about DMA buffer placement</li>
</ul>
<hr>
<p>Next post: <a href="/en/study/stm32-pin-system">STM32 Pin System Deep Dive</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/en/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","Back to Study"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 Architecture Basics — Cortex-M7, Memory Map, Bus Architecture"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"A deep dive into STM32H743VITx's ARM Cortex-M7 core, memory map, and bus architecture."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"3 min read"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","arm-cortex-m7",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"arm-cortex-m7"}],["$","span","embedded",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"embedded"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — Robot Education Founder"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"Engineer dedicated to democratizing robot education for everyone. From hardware bring-up to AI integration, I document real learning."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["Follow the journey",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 Architecture Basics — Cortex-M7, Memory Map, Bus Architecture","slug":"stm32-architecture","lang":"en"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-architecture","lang":"en"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
