1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T1add,<p><img src="/images/study/stm32/gpio-modes.png" alt="GPIO 4가지 모드">
<em>GPIO Input/Output/AF/Analog 모드 비교</em></p>
<h3>4.1 GPIO 4가지 모드</h3>
<p>모든 GPIO 핀은 4가지 모드 중 하나로 설정된다:</p>
<table>
<thead>
<tr>
<th>모드</th>
<th>MODER 값</th>
<th>설명</th>
<th>사용 예시</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Input</strong></td>
<td>00</td>
<td>외부 신호 읽기</td>
<td>버튼, 모터 에러 핀, 인터럽트 입력</td>
</tr>
<tr>
<td><strong>Output</strong></td>
<td>01</td>
<td>신호 내보내기</td>
<td>LED, 모터 Enable, Motor Stop</td>
</tr>
<tr>
<td><strong>Alternate Function</strong></td>
<td>10</td>
<td>페리페럴에 핀 연결</td>
<td>UART TX/RX, SPI, CAN, PWM</td>
</tr>
<tr>
<td><strong>Analog</strong></td>
<td>11</td>
<td>아날로그 입출력</td>
<td>ADC 입력 (토크센서, 각도센서), DAC</td>
</tr>
</tbody>
</table>
<h3>4.2 Output Type: Push-Pull vs Open-Drain</h3>
<p><img src="/images/study/stm32/push-pull-od.png" alt="Push-Pull vs Open-Drain">
<em>Push-Pull과 Open-Drain 출력 비교</em></p>
<p>Output 또는 AF 모드에서 출력 타입을 선택한다:</p>
<p><strong>Push-Pull (PP):</strong></p>
<pre><code>VDD ─── [P-FET] ─┬── 핀 출력
                  │
GND ─── [N-FET] ─┘

출력 HIGH → P-FET ON, N-FET OFF → VDD 출력 (3.3V)
출력 LOW  → P-FET OFF, N-FET ON → GND 출력 (0V)
</code></pre>
<ul>
<li>능동적으로 HIGH/LOW 모두 구동</li>
<li><strong>대부분의 경우 Push-Pull 사용</strong> (LED, SPI, UART TX, PWM 등)</li>
</ul>
<p><strong>Open-Drain (OD):</strong></p>
<pre><code>         ┌── 외부 풀업 저항 ── VDD (또는 5V!)
핀 출력 ──┤
         └── [N-FET] ── GND

출력 LOW  → N-FET ON → GND 출력
출력 HIGH → N-FET OFF → 풀업 저항에 의해 VDD로 올라감
</code></pre>
<ul>
<li>LOW만 능동 구동, HIGH는 외부 풀업에 의존</li>
<li><strong>I2C 통신에 필수</strong> (SDA/SCL)</li>
<li><strong>레벨 시프팅</strong>: 3.3V MCU에서 5V 장치와 통신 시 사용</li>
</ul>
<h3>4.3 Pull 설정</h3>
<table>
<thead>
<tr>
<th>설정</th>
<th>효과</th>
<th>사용 시기</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>No Pull</strong></td>
<td>풀업/풀다운 없음</td>
<td>AF 모드 (페리페럴이 제어), 외부 풀업/풀다운 있을 때</td>
</tr>
<tr>
<td><strong>Pull-Up</strong></td>
<td>내부 ~40kΩ 저항으로 VDD 연결</td>
<td>버튼 입력 (액티브 로우), UART RX 유휴 상태</td>
</tr>
<tr>
<td><strong>Pull-Down</strong></td>
<td>내부 ~40kΩ 저항으로 GND 연결</td>
<td>플로팅 방지, 기본값 LOW 필요 시</td>
</tr>
</tbody>
</table>
<h3>4.4 출력 속도</h3>
<table>
<thead>
<tr>
<th>속도</th>
<th>최대 주파수</th>
<th>사용 시기</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>Low</strong></td>
<td>~12 MHz</td>
<td>GPIO 토글 (LED), 저속 신호</td>
</tr>
<tr>
<td><strong>Medium</strong></td>
<td>~60 MHz</td>
<td>UART, I2C</td>
</tr>
<tr>
<td><strong>High</strong></td>
<td>~85 MHz</td>
<td>SPI, SDMMC</td>
</tr>
<tr>
<td><strong>Very High</strong></td>
<td>~100 MHz</td>
<td>고속 SPI, FMC</td>
</tr>
</tbody>
</table>
<blockquote>
<p>⚠️ <strong>규칙</strong>: 필요한 최소 속도를 선택한다. 속도가 높을수록 EMI(전자파 간섭)가 증가하고 소비전류가 늘어난다.</p>
<ul>
<li>LED, Enable 핀 → Low</li>
<li>CAN, UART → Medium</li>
<li>SPI → High 또는 Very High</li>
</ul>
</blockquote>
<h3>4.5 HAL 라이브러리로 GPIO 설정</h3>
<p>CubeMX가 자동 생성하는 코드의 구조:</p>
<pre><code class="language-c">/* Core/Src/main.c — MX_GPIO_Init() 함수 내부 */

static void MX_GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    /* GPIO 포트 클럭 활성화 */
    __HAL_RCC_GPIOA_CLK_ENABLE();
    __HAL_RCC_GPIOB_CLK_ENABLE();
    __HAL_RCC_GPIOC_CLK_ENABLE();
    __HAL_RCC_GPIOD_CLK_ENABLE();
    __HAL_RCC_GPIOE_CLK_ENABLE();

    /* === 예시 1: LED 출력 (PB0) === */
    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_RESET);  // 초기값 LOW
    GPIO_InitStruct.Pin   = GPIO_PIN_0;
    GPIO_InitStruct.Mode  = GPIO_MODE_OUTPUT_PP;    // Output Push-Pull
    GPIO_InitStruct.Pull  = GPIO_NOPULL;            // 풀업/풀다운 없음
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;    // 저속 (LED니까)
    HAL_GPIO_Init(GPIOB, &#x26;GPIO_InitStruct);

    /* === 예시 2: 버튼 입력 + 인터럽트 (PC13) === */
    GPIO_InitStruct.Pin   = GPIO_PIN_13;
    GPIO_InitStruct.Mode  = GPIO_MODE_IT_FALLING;   // 하강 에지 인터럽트
    GPIO_InitStruct.Pull  = GPIO_PULLUP;             // 내부 풀업
    HAL_GPIO_Init(GPIOC, &#x26;GPIO_InitStruct);

    /* EXTI 인터럽트 활성화 */
    HAL_NVIC_SetPriority(EXTI15_10_IRQn, 5, 0);
    HAL_NVIC_EnableIRQ(EXTI15_10_IRQn);

    /* === 예시 3: 모터 Enable 핀 (PD3) === */
    HAL_GPIO_WritePin(GPIOD, GPIO_PIN_3, GPIO_PIN_RESET);
    GPIO_InitStruct.Pin   = GPIO_PIN_3;
    GPIO_InitStruct.Mode  = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull  = GPIO_PULLDOWN;           // 기본 OFF (안전)
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOD, &#x26;GPIO_InitStruct);
}
</code></pre>
<h3>4.6 GPIO 제어 함수</h3>
<pre><code class="language-c">/* 핀 출력 HIGH */
HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_SET);

/* 핀 출력 LOW */
HAL_GPIO_WritePin(GPIOB, GPIO_PIN_0, GPIO_PIN_RESET);

/* 핀 토글 */
HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0);

/* 핀 읽기 */
GPIO_PinState state = HAL_GPIO_ReadPin(GPIOC, GPIO_PIN_13);
if (state == GPIO_PIN_SET) {
    // HIGH 상태
}
</code></pre>
<h3>4.7 실습: LED 깜빡이기 (첫 번째 테스트)</h3>
<p>보드를 만들고 가장 먼저 해야 할 테스트:</p>
<pre><code class="language-c">/* Core/Src/main.c */

/* USER CODE BEGIN Includes */
/* USER CODE END Includes */

int main(void)
{
    HAL_Init();
    SystemClock_Config();
    MX_GPIO_Init();

    /* USER CODE BEGIN 2 */
    // (추가 초기화 코드)
    /* USER CODE END 2 */

    while (1)
    {
        /* USER CODE BEGIN 3 */
        HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_0);  // LED 토글
        HAL_Delay(500);                           // 500ms 대기
        /* USER CODE END 3 */
    }
}
</code></pre>
<blockquote>
<p>LED가 0.5초 간격으로 깜빡이면 다음을 확인한 것이다:</p>
<ol>
<li>전원이 정상 (VDD 3.3V)</li>
<li>클럭이 정상 (HSE → PLL → SYSCLK)</li>
<li>GPIO가 정상 (출력 동작)</li>
<li>HAL 라이브러리가 정상 (HAL_Delay 동작 = SysTick 정상)</li>
<li>플래시 프로그래밍이 정상 (코드가 실행됨)</li>
</ol>
</blockquote>
<hr>
<p>이전 글: <a href="/ko/study/stm32-clock-system">STM32 클럭 시스템</a> | 다음 글: <a href="/ko/study/stm32-peripherals">STM32 핵심 페리페럴</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/ko/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","스터디 목록"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 GPIO 설정 — Push-Pull, Open-Drain, 속도, 풀업/풀다운"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"STM32 GPIO 모드(Input/Output/AF/Analog), Push-Pull vs Open-Drain, 속도 설정, 풀업/풀다운 완전 정리."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"7분 읽기"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","gpio",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"gpio"}],["$","span","embedded",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"embedded"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — 로봇 교육 창시자"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"모두를 위한 로봇 교육을 꿈꾸는 엔지니어입니다. 하드웨어 브링업부터 AI 지능형 로봇까지, 실제 학습 과정을 기록하고 공유합니다."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["기술 여정 함께하기",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 GPIO 설정 — Push-Pull, Open-Drain, 속도, 풀업/풀다운","slug":"stm32-gpio","lang":"ko"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-gpio","lang":"ko"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
