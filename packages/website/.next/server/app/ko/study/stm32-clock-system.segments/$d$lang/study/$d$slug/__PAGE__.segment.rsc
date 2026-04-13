1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T17bb,<p><img src="/images/study/stm32/clock-tree.png" alt="클럭 트리">
<em>HSE → PLL → SYSCLK 클럭 트리</em></p>
<h3>3.1 클럭 소스</h3>
<p>STM32H743에는 4가지 클럭 소스가 있다:</p>
<table>
<thead>
<tr>
<th>클럭 소스</th>
<th>주파수</th>
<th>정밀도</th>
<th>용도</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>HSE</strong> (High-Speed External)</td>
<td>4~50 MHz (보통 8 또는 25 MHz)</td>
<td>높음 (크리스탈)</td>
<td>PLL 입력 → SYSCLK</td>
</tr>
<tr>
<td><strong>HSI</strong> (High-Speed Internal)</td>
<td>64 MHz 고정</td>
<td>보통 (RC 발진기)</td>
<td>리셋 후 기본 클럭</td>
</tr>
<tr>
<td><strong>LSE</strong> (Low-Speed External)</td>
<td>32.768 kHz</td>
<td>높음</td>
<td>RTC, 저전력 모드</td>
</tr>
<tr>
<td><strong>LSI</strong> (Low-Speed Internal)</td>
<td>32 kHz</td>
<td>낮음</td>
<td>독립 워치독 (IWDG)</td>
</tr>
</tbody>
</table>
<p><strong>로봇 보드에서의 선택:</strong></p>
<ul>
<li><strong>HSE 8MHz 크리스탈 사용 권장</strong> → PLL을 통해 480MHz SYSCLK 생성</li>
<li>LSE 32.768kHz는 선택사항 (RTC 필요 시)</li>
<li>HSI는 비상용 (크리스탈 고장 시 자동 전환 가능)</li>
</ul>
<h3>3.2 PLL 설정: 8MHz → 480MHz 달성 경로</h3>
<p>STM32H7에는 3개의 PLL이 있다. 메인 PLL1으로 SYSCLK을 생성한다:</p>
<pre><code>HSE (8 MHz)
    │
    ▼
  DIVM1 = /1        ← PLL 입력 분주기
    │
    ▼
  8 MHz (PLL 입력)  ← 반드시 1~16 MHz 범위
    │
    ▼
  DIVN1 = x120      ← VCO 체배기 (곱하기)
    │
    ▼
  960 MHz (VCO)     ← VCO 범위: 192~960 MHz
    │
    ├─ DIVP1 = /2 ──→ 480 MHz ──→ SYSCLK (시스템 클럭)
    │
    ├─ DIVQ1 = /4 ──→ 240 MHz ──→ 일부 페리페럴 (FDCAN 등)
    │
    └─ DIVR1 = /2 ──→ 480 MHz ──→ (사용하지 않으면 비활성화)
</code></pre>
<p><strong>CubeMX에서의 설정값:</strong></p>
<table>
<thead>
<tr>
<th>파라미터</th>
<th>값</th>
<th>의미</th>
</tr>
</thead>
<tbody>
<tr>
<td>PLL Source</td>
<td>HSE</td>
<td>외부 크리스탈 사용</td>
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
<td>960MHz / 2 = 480MHz (비활성화 가능)</td>
</tr>
</tbody>
</table>
<h3>3.3 클럭 트리: SYSCLK에서 각 버스로 분배</h3>
<pre><code>SYSCLK (480 MHz)
    │
    ▼
  D1CPRE = /1
    │
    ▼
  CPU 클럭 = 480 MHz
    │
    ├── HPRE = /2 ──→ AHB 클럭 = 240 MHz
    │                    │
    │                    ├── D1PPRE = /2 ──→ APB3 = 120 MHz (타이머는 x2 = 240 MHz)
    │                    │
    │                    ├── D2PPRE1 = /2 ──→ APB1 = 120 MHz (타이머는 x2 = 240 MHz)
    │                    │                      └── TIM2-7, TIM12-14
    │                    │                      └── USART2/3, UART4/5/7/8
    │                    │                      └── SPI2/3, I2C1-3
    │                    │                      └── **FDCAN1/2**
    │                    │
    │                    ├── D2PPRE2 = /2 ──→ APB2 = 120 MHz (타이머는 x2 = 240 MHz)
    │                    │                      └── TIM1, TIM8, TIM15-17
    │                    │                      └── USART1/6
    │                    │                      └── SPI1/4/5
    │                    │                      └── ADC1/2
    │                    │
    │                    └── D3PPRE = /2 ──→ APB4 = 120 MHz
    │                                        └── I2C4, SPI6
    │                                        └── EXTI, RTC
    │
    └── SysTick = 480 MHz (기본) 또는 AHB/8
</code></pre>
<p><strong>핵심 정리:</strong></p>
<table>
<thead>
<tr>
<th>버스</th>
<th>주파수</th>
<th>타이머 클럭</th>
<th>연결된 주요 페리페럴</th>
</tr>
</thead>
<tbody>
<tr>
<td>CPU</td>
<td>480 MHz</td>
<td>—</td>
<td>Cortex-M7 코어</td>
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
<p>🔴 <strong>중요</strong>: APB 버스에 연결된 <strong>타이머</strong>는 APB 분주 비율이 1이 아닌 경우 자동으로 <strong>x2</strong> 된다.
APB1 = 120MHz이고 분주비 /2이므로, TIM2~7의 실제 클럭은 240MHz이다.</p>
</blockquote>
<h3>3.4 CubeMX 클럭 설정 실전</h3>
<p><img src="/images/study/stm32/cubemx-clock.png" alt="CubeMX 클럭 설정">
<em>CubeMX Clock Configuration 탭 설정 화면</em></p>
<p>CubeMX의 Clock Configuration 탭에서:</p>
<ol>
<li><strong>좌측</strong>: HSE → PLL Source Mux에서 "HSE" 선택</li>
<li><strong>가운데</strong>: PLL1 파라미터 입력 (DIVM=1, N=120, P=2, Q=4)</li>
<li><strong>System Clock Mux</strong>: "PLLCLK" 선택</li>
<li><strong>우측</strong>: 각 버스 분주기가 자동 설정됨</li>
<li><strong>확인</strong>: "Resolve Clock Issues" 버튼으로 문제 없는지 확인</li>
</ol>
<blockquote>
<p>CubeMX가 빨간색으로 표시하면 주파수가 최대값을 초과한 것이다.
이 경우 분주기를 조절하여 각 버스의 최대 주파수 이하로 맞춘다.</p>
</blockquote>
<hr>
<p>이전 글: <a href="/ko/study/stm32-pin-system">STM32 핀 시스템</a> | 다음 글: <a href="/ko/study/stm32-gpio">STM32 GPIO 설정</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/ko/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","스터디 목록"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 클럭 시스템 — HSE, PLL, 클럭 트리 설정 가이드"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"STM32H7 클럭 소스(HSE/HSI), PLL 설정, 클럭 트리 구조를 이해하고 480MHz로 설정하는 방법."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"5분 읽기"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","clock-tree",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"clock-tree"}],["$","span","cubemx",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"cubemx"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — 로봇 교육 창시자"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"모두를 위한 로봇 교육을 꿈꾸는 엔지니어입니다. 하드웨어 브링업부터 AI 지능형 로봇까지, 실제 학습 과정을 기록하고 공유합니다."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["기술 여정 함께하기",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 클럭 시스템 — HSE, PLL, 클럭 트리 설정 가이드","slug":"stm32-clock-system","lang":"ko"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-clock-system","lang":"ko"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
