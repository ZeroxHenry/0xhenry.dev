1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T1cb6,<h2>STM32CubeMX 실전 설정 과정</h2>
<p><img src="/images/study/stm32/cubemx-pinout.png" alt="CubeMX 핀 설정 화면">
<em>CubeMX 핀 설정 화면</em></p>
<p>CubeMX는 STM32의 핀 배치, 클럭, 페리페럴을 GUI로 설정하고 초기화 코드를 자동 생성하는 도구이다.
STM32CubeIDE에 내장되어 있다.</p>
<h3>Step 1: 프로젝트 생성 &#x26; 칩 선택</h3>
<ol>
<li>STM32CubeIDE → <strong>File</strong> → <strong>New</strong> → <strong>STM32 Project</strong></li>
<li><strong>MCU/MPU Selector</strong> 탭에서 검색: <code>STM32H743VITx</code></li>
<li>칩 선택 후 <strong>Next</strong></li>
<li>Project Name: <code>AR_Walker_STM32</code> (또는 <code>H-Walker_STM32_Test</code>)</li>
<li>Targeted Language: <strong>C</strong></li>
<li>Targeted Binary Type: <strong>Executable</strong></li>
<li>Targeted Project Type: <strong>STM32Cube</strong></li>
<li><strong>Finish</strong> → <code>.ioc</code> 파일이 열리며 핀 설정 화면 표시</li>
</ol>
<h3>Step 2: 핀 할당 (Pinout &#x26; Configuration)</h3>
<p><code>.ioc</code> 에디터의 칩 그래픽에서 핀을 클릭하여 기능을 할당한다.</p>
<p><strong>설정 순서 (권장):</strong></p>
<ol>
<li><strong>디버그 핀 확보</strong>: System Core → SYS → Debug: <strong>Serial Wire</strong> (PA13/PA14 자동 할당)</li>
<li><strong>클럭 소스</strong>: System Core → RCC → HSE: <strong>Crystal/Ceramic Resonator</strong></li>
<li><strong>FDCAN1</strong>: Connectivity → FDCAN1 → Activated
<ul>
<li>TX: PD1, RX: PD0 (자동 또는 수동 선택)</li>
</ul>
</li>
<li><strong>UART (IMU)</strong>: Connectivity → UART4 → Mode: Asynchronous
<ul>
<li>RX: PA1 (TX 불필요하면 비활성화)</li>
</ul>
</li>
<li><strong>UART (디버그)</strong>: Connectivity → USART3 → Mode: Asynchronous
<ul>
<li>TX: PD8, RX: PD9</li>
</ul>
</li>
<li><strong>SPI1</strong>: Connectivity → SPI1 → Mode: Full-Duplex Master
<ul>
<li>SCK: PA5, MOSI: PB5, MISO: PB4 (PA6/PA7 ADC용으로 남겨두기)</li>
</ul>
</li>
<li><strong>ADC1</strong>: Analog → ADC1 → IN0, IN1, IN2, IN6 (또는 IN14/IN15) 활성화
<ul>
<li>PA0, PA1 주의: UART4 RX와 충돌 시 ADC 채널 재배치</li>
</ul>
</li>
<li><strong>TIM1 PWM</strong>: Timers → TIM1 → CH1: PWM Generation, CH2: PWM Generation
<ul>
<li>CH1: PE9, CH2: PE11</li>
</ul>
</li>
<li><strong>GPIO 출력</strong>: 각 핀을 클릭 → GPIO_Output 선택
<ul>
<li>LED, Motor Enable, Motor Stop 핀들</li>
</ul>
</li>
<li><strong>GPIO 입력</strong>: 모터 에러 핀 등</li>
</ol>
<p><strong>핀 충돌 확인:</strong></p>
<ul>
<li>CubeMX에서 핀이 <strong>노란색</strong> = 경고 (대체 가능)</li>
<li><strong>빨간색</strong> = 충돌 (해결 필수)</li>
<li>좌측 패널에서 <strong>"Pinout Conflict"</strong> 메시지 확인</li>
</ul>
<h3>Step 3: 클럭 설정 (Clock Configuration)</h3>
<ol>
<li>상단 탭에서 <strong>Clock Configuration</strong> 클릭</li>
<li>좌측 Input frequency: <strong>8</strong> (MHz, 사용할 크리스탈에 맞춤)</li>
<li>PLL Source Mux: <strong>HSE</strong> 선택</li>
<li>DIVM1: 1, DIVN1: 120, DIVP1: 2 입력</li>
<li>System Clock Mux: <strong>PLLCLK</strong> 선택</li>
<li>HCLK: <strong>240 MHz</strong> 확인 (자동 계산)</li>
<li>각 APB 클럭이 120 MHz인지 확인</li>
<li>빨간색 경고가 있으면 <strong>"Resolve Clock Issues"</strong> 버튼 클릭</li>
</ol>
<h3>Step 4: 페리페럴 파라미터 설정</h3>
<p>좌측 <strong>Configuration</strong> 패널에서 각 페리페럴의 상세 설정:</p>
<h4>FDCAN1 파라미터</h4>
<pre><code>Mode                    : Normal
Frame Format            : Classic (CAN 2.0)
Auto Retransmission     : Enable
Nominal Prescaler       : 10
Nominal Sync Jump Width : 1
Nominal Time Seg1       : 5
Nominal Time Seg2       : 6
→ Bit Rate = 120MHz / (10 × (1+5+6)) = 1 Mbps
</code></pre>
<h4>ADC1 파라미터</h4>
<pre><code>Clock Prescaler         : Asynchronous clock mode divided by 4
Resolution              : ADC 12-bit resolution (또는 16-bit)
Scan Conversion Mode    : Enable
Continuous Conv Mode    : Enable
DMA Continuous Requests : Enable
Number of Conversion    : (사용할 채널 수)
</code></pre>
<h4>DMA 설정</h4>
<p>각 페리페럴의 DMA Settings 탭에서:</p>
<ul>
<li>ADC1 → DMA Stream 추가 → Mode: <strong>Circular</strong></li>
<li>UART4_RX → DMA Stream 추가 → Mode: <strong>Circular</strong></li>
</ul>
<h4>NVIC (인터럽트 우선순위)</h4>
<pre><code>인터럽트           우선순위(0=최고)  용도
FDCAN1_IT0         1               CAN 수신 (모터 응답 — 최우선)
TIM6_DAC           2               제어 루프 타이머 (500Hz)
DMA_ADCx           3               ADC 변환 완료
UART4_IRQn         4               IMU 데이터 수신
SPI1_IRQn          5               통신 MCU 데이터
EXTI_IRQn          6               GPIO 인터럽트 (에러 등)
</code></pre>
<h3>Step 5: 프로젝트 설정</h3>
<ol>
<li><strong>Project Manager</strong> 탭 클릭</li>
<li>Project Settings:
<ul>
<li>Toolchain: <strong>STM32CubeIDE</strong></li>
<li>Generate Under Root: 체크</li>
</ul>
</li>
<li>Code Generator:
<ul>
<li><strong>"Generate peripheral initialization as a pair of '.c/.h' files per peripheral"</strong> → 체크 (권장)</li>
<li><strong>"Keep User Code when re-generating"</strong> → 체크 (필수!)</li>
<li><strong>"Delete previously generated files when not re-generated"</strong> → 체크</li>
</ul>
</li>
</ol>
<h3>Step 6: 코드 생성</h3>
<ol>
<li><strong>Project</strong> → <strong>Generate Code</strong> (또는 Alt+K, Cmd+K)</li>
<li>생성되는 파일 구조:</li>
</ol>
<pre><code>AR_Walker_STM32/
├── Core/
│   ├── Inc/
│   │   ├── main.h              ← GPIO 핀 define (CubeMX 자동)
│   │   ├── stm32h7xx_hal_conf.h
│   │   └── stm32h7xx_it.h
│   └── Src/
│       ├── main.c              ← ★ 메인 코드 여기에 작성
│       ├── stm32h7xx_hal_msp.c ← 페리페럴 MSP 초기화
│       └── stm32h7xx_it.c      ← 인터럽트 핸들러
├── Drivers/
│   ├── CMSIS/                  ← ARM 코어 헤더
│   └── STM32H7xx_HAL_Driver/   ← HAL 라이브러리
└── STM32H743VITX_FLASH.ld      ← 링커 스크립트
</code></pre>
<h3>USER CODE 블록 규칙</h3>
<p>CubeMX가 코드를 재생성해도 보존되는 영역:</p>
<pre><code class="language-c">/* USER CODE BEGIN Includes */
#include "motor_control.h"    // ✅ 안전!
/* USER CODE END Includes */

// ❌ 여기에 쓰면 재생성 시 삭제됨!

/* USER CODE BEGIN 0 */
void my_init(void) { }        // ✅ 안전!
/* USER CODE END 0 */
</code></pre>
<blockquote>
<p><strong>최선의 방법</strong>: <code>Core/Src/</code>에 별도 <code>.c</code> 파일을 만들어 유저 코드를 작성한다.
예: <code>motor_control.c</code>, <code>sensor_read.c</code>, <code>can_protocol.c</code>
→ CubeMX가 건드리지 않으므로 100% 안전.
(자세한 내용은 README.md의 "자동 생성 코드와 유저 코드 관리" 섹션 참고)</p>
</blockquote>
<hr>
<p>이전 글: <a href="/ko/study/stm32-peripherals">STM32 핵심 페리페럴</a> | 다음 글: <a href="/ko/study/stm32-pin-mapping">STM32 핀 매핑 전략</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/ko/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","스터디 목록"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32CubeMX 실전 설정 — 프로젝트 생성부터 코드 생성까지"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"STM32CubeMX로 클럭, 핀, 페리페럴을 설정하고 HAL 프로젝트를 생성하는 실전 과정."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"7분 읽기"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","cubemx",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"cubemx"}],["$","span","hal",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"hal"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — 로봇 교육 창시자"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"모두를 위한 로봇 교육을 꿈꾸는 엔지니어입니다. 하드웨어 브링업부터 AI 지능형 로봇까지, 실제 학습 과정을 기록하고 공유합니다."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["기술 여정 함께하기",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32CubeMX 실전 설정 — 프로젝트 생성부터 코드 생성까지","slug":"stm32-cubemx","lang":"ko"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-cubemx","lang":"ko"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
