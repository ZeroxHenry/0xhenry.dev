1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T2485,<h2>로봇 보드 핀 매핑 전략</h2>
<p><img src="/images/study/stm32/pin-mapping.png" alt="Teensy → STM32 핀 매핑">
<em>Teensy 4.1에서 STM32H743으로의 핀 매핑 비교도</em></p>
<h3>7.1 핀 배치 원칙</h3>
<ol>
<li><strong>AF 충돌 방지</strong>: 하나의 핀에는 하나의 AF만 사용 가능</li>
<li><strong>전원/그라운드 확보</strong>: LQFP-100의 18개 전원 핀 모두 적절히 연결</li>
<li><strong>노이즈 분리</strong>: ADC 입력 핀은 고속 디지털 신호(CAN, SPI)와 물리적으로 분리</li>
<li><strong>디버거 보호</strong>: PA13 (SWDIO), PA14 (SWCLK)는 절대 다른 용도로 사용하지 않음</li>
<li><strong>미사용 핀 처리</strong>: Analog 모드 (소비전류 최소화) 또는 Output Low로 설정</li>
<li><strong>BOOT0 핀</strong>: GND에 연결 (일반 부트 = Flash에서 실행)</li>
</ol>
<h3>7.2 Teensy → STM32 핀 매핑 테이블</h3>
<p>현재 <code>Board.h</code>의 Teensy 4.1 핀 설정을 STM32H743VITx로 매핑한 최종 테이블:</p>
<h4>통신 페리페럴</h4>
<table>
<thead>
<tr>
<th>기능</th>
<th>Teensy 핀</th>
<th>STM32 핀</th>
<th>AF</th>
<th>페리페럴</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td>CAN TX</td>
<td>22</td>
<td><strong>PD1</strong></td>
<td>AF9</td>
<td>FDCAN1_TX</td>
<td>모터 CAN 버스</td>
</tr>
<tr>
<td>CAN RX</td>
<td>23</td>
<td><strong>PD0</strong></td>
<td>AF9</td>
<td>FDCAN1_RX</td>
<td>모터 CAN 버스</td>
</tr>
<tr>
<td>IMU UART RX</td>
<td>16 (RX4)</td>
<td><strong>PD9</strong></td>
<td>AF7</td>
<td>USART3_RX</td>
<td>IMU 데이터 수신</td>
</tr>
<tr>
<td>IMU UART TX</td>
<td>N/C</td>
<td><strong>PD8</strong></td>
<td>AF7</td>
<td>USART3_TX</td>
<td>(디버그 겸용 가능)</td>
</tr>
<tr>
<td>SPI SCK</td>
<td>(implicit)</td>
<td><strong>PA5</strong></td>
<td>AF5</td>
<td>SPI1_SCK</td>
<td>Coms MCU 통신</td>
</tr>
<tr>
<td>SPI MOSI</td>
<td>11</td>
<td><strong>PB5</strong></td>
<td>AF5</td>
<td>SPI1_MOSI</td>
<td>PA7은 ADC용으로 보존</td>
</tr>
<tr>
<td>SPI MISO</td>
<td>(implicit)</td>
<td><strong>PB4</strong></td>
<td>AF5</td>
<td>SPI1_MISO</td>
<td>PA6은 ADC용으로 보존</td>
</tr>
<tr>
<td>SPI CS</td>
<td>10</td>
<td><strong>PA15</strong></td>
<td>GPIO</td>
<td>—</td>
<td>소프트웨어 CS</td>
</tr>
<tr>
<td>SPI IRQ</td>
<td>34</td>
<td><strong>PE0</strong></td>
<td>GPIO</td>
<td>EXTI0</td>
<td>인터럽트 입력</td>
</tr>
<tr>
<td>SPI RST</td>
<td>4</td>
<td><strong>PE1</strong></td>
<td>GPIO</td>
<td>—</td>
<td>Coms MCU 리셋</td>
</tr>
<tr>
<td>Serial TX</td>
<td>1</td>
<td><strong>PA9</strong></td>
<td>AF7</td>
<td>USART1_TX</td>
<td>(디버그/PC 통신)</td>
</tr>
<tr>
<td>Serial RX</td>
<td>0</td>
<td><strong>PA10</strong></td>
<td>AF7</td>
<td>USART1_RX</td>
<td>(디버그/PC 통신)</td>
</tr>
</tbody>
</table>
<h4>아날로그 입력 (ADC)</h4>
<table>
<thead>
<tr>
<th>기능</th>
<th>Teensy 핀</th>
<th>STM32 핀</th>
<th>채널</th>
<th>페리페럴</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td>토크센서 Left</td>
<td>A16</td>
<td><strong>PA0</strong></td>
<td>IN0</td>
<td>ADC1</td>
<td>로드셀 L</td>
</tr>
<tr>
<td>토크센서 Right</td>
<td>A6</td>
<td><strong>PA3</strong></td>
<td>IN3</td>
<td>ADC1</td>
<td>로드셀 R (PA6 대신 PA3)</td>
</tr>
<tr>
<td>각도센서 Left</td>
<td>A13</td>
<td><strong>PC3</strong></td>
<td>IN13</td>
<td>ADC1</td>
<td>좌측 발목 각도</td>
</tr>
<tr>
<td>각도센서 Right</td>
<td>A12</td>
<td><strong>PC2</strong></td>
<td>IN12</td>
<td>ADC1</td>
<td>우측 발목 각도</td>
</tr>
<tr>
<td>Maxon 전류 Left</td>
<td>(maxon_current)</td>
<td><strong>PA1</strong></td>
<td>IN1</td>
<td>ADC1</td>
<td>좌측 모터 전류</td>
</tr>
<tr>
<td>Maxon 전류 Right</td>
<td>(maxon_current)</td>
<td><strong>PA2</strong></td>
<td>IN2</td>
<td>ADC1</td>
<td>우측 모터 전류</td>
</tr>
<tr>
<td>(예비 1)</td>
<td>—</td>
<td><strong>PC4</strong></td>
<td>IN14</td>
<td>ADC1</td>
<td>확장용</td>
</tr>
<tr>
<td>(예비 2)</td>
<td>—</td>
<td><strong>PC5</strong></td>
<td>IN15</td>
<td>ADC1</td>
<td>확장용</td>
</tr>
</tbody>
</table>
<h4>PWM 출력</h4>
<table>
<thead>
<tr>
<th>기능</th>
<th>Teensy 핀</th>
<th>STM32 핀</th>
<th>AF</th>
<th>페리페럴</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td>Maxon PWM Left</td>
<td>(maxon_ctrl_L)</td>
<td><strong>PE9</strong></td>
<td>AF1</td>
<td>TIM1_CH1</td>
<td>좌측 모터</td>
</tr>
<tr>
<td>Maxon PWM Right</td>
<td>(maxon_ctrl_R)</td>
<td><strong>PE11</strong></td>
<td>AF1</td>
<td>TIM1_CH2</td>
<td>우측 모터</td>
</tr>
</tbody>
</table>
<h4>GPIO 출력</h4>
<table>
<thead>
<tr>
<th>기능</th>
<th>Teensy 핀</th>
<th>STM32 핀</th>
<th>설정</th>
<th>비고</th>
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
<td>동기화 LED</td>
</tr>
<tr>
<td>Motor Stop</td>
<td>9</td>
<td><strong>PC6</strong></td>
<td>Output PP, Pull-Down</td>
<td>긴급 정지</td>
</tr>
<tr>
<td>Motor Enable L0</td>
<td>28</td>
<td><strong>PD3</strong></td>
<td>Output PP, Pull-Down</td>
<td>좌측 관절 0</td>
</tr>
<tr>
<td>Motor Enable L1</td>
<td>29</td>
<td><strong>PD4</strong></td>
<td>Output PP, Pull-Down</td>
<td>좌측 관절 1</td>
</tr>
<tr>
<td>Motor Enable R0</td>
<td>8</td>
<td><strong>PD5</strong></td>
<td>Output PP, Pull-Down</td>
<td>우측 관절 0</td>
</tr>
<tr>
<td>Motor Enable R1</td>
<td>7</td>
<td><strong>PD6</strong></td>
<td>Output PP, Pull-Down</td>
<td>우측 관절 1</td>
</tr>
<tr>
<td>Sync Default</td>
<td>5</td>
<td><strong>PC7</strong></td>
<td>Output PP</td>
<td>동기화 기본</td>
</tr>
<tr>
<td>Speed Check</td>
<td>33</td>
<td><strong>PC8</strong></td>
<td>Output PP</td>
<td>속도 측정용 토글 핀</td>
</tr>
</tbody>
</table>
<h4>GPIO 입력</h4>
<table>
<thead>
<tr>
<th>기능</th>
<th>Teensy 핀</th>
<th>STM32 핀</th>
<th>설정</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td>Maxon Error Left</td>
<td>(maxon_err_L)</td>
<td><strong>PE2</strong></td>
<td>Input, Pull-Up</td>
<td>에러 감지 (액티브 로우)</td>
</tr>
<tr>
<td>Maxon Error Right</td>
<td>(maxon_err_R)</td>
<td><strong>PE3</strong></td>
<td>Input, Pull-Up</td>
<td>에러 감지 (액티브 로우)</td>
</tr>
</tbody>
</table>
<h4>시스템 핀 (변경 불가)</h4>
<table>
<thead>
<tr>
<th>기능</th>
<th>STM32 핀</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td>SWDIO (디버거)</td>
<td>PA13</td>
<td>절대 변경 금지</td>
</tr>
<tr>
<td>SWCLK (디버거)</td>
<td>PA14</td>
<td>절대 변경 금지</td>
</tr>
<tr>
<td>HSE 크리스탈 IN</td>
<td>PH0 (pin 12)</td>
<td>8MHz 크리스탈</td>
</tr>
<tr>
<td>HSE 크리스탈 OUT</td>
<td>PH1 (pin 13)</td>
<td>8MHz 크리스탈</td>
</tr>
<tr>
<td>NRST</td>
<td>pin 14 (NRST)</td>
<td>리셋 버튼</td>
</tr>
<tr>
<td>BOOT0</td>
<td>pin 94</td>
<td>GND 연결 (Flash 부트)</td>
</tr>
</tbody>
</table>
<h3>7.3 AF 충돌 검증</h3>
<p>위 매핑에서 주요 충돌 해결 사항:</p>
<table>
<thead>
<tr>
<th>문제</th>
<th>원인</th>
<th>해결</th>
</tr>
</thead>
<tbody>
<tr>
<td>PA6을 ADC와 SPI1_MISO에 동시 사용 불가</td>
<td>AF 충돌</td>
<td>SPI1_MISO를 <strong>PB4</strong> (AF5)로 이동</td>
</tr>
<tr>
<td>PA7을 ADC와 SPI1_MOSI에 동시 사용 불가</td>
<td>AF 충돌</td>
<td>SPI1_MOSI를 <strong>PB5</strong> (AF5)로 이동</td>
</tr>
<tr>
<td>PA1을 ADC(전류센싱)와 UART4_RX에 동시 불가</td>
<td>AF 충돌</td>
<td>IMU UART를 <strong>USART3</strong> (PD8/PD9)로 변경</td>
</tr>
<tr>
<td>PA6을 토크센서 R ADC로 사용 시 SPI 불가</td>
<td>AF 충돌</td>
<td>토크센서 R을 <strong>PA3</strong> (ADC1_IN3)로 이동</td>
</tr>
</tbody>
</table>
<h3>7.4 핀 사용 현황 요약</h3>
<table>
<thead>
<tr>
<th>포트</th>
<th>사용된 핀</th>
<th>미사용 핀</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td>GPIOA</td>
<td>PA0-5, PA9-10, PA13-15</td>
<td>PA6-8, PA11-12</td>
<td>PA11/12는 USB용으로 예비</td>
</tr>
<tr>
<td>GPIOB</td>
<td>PB0-2, PB4-5, PB10</td>
<td>PB3, PB6-9, PB11-15</td>
<td>여유 있음</td>
</tr>
<tr>
<td>GPIOC</td>
<td>PC2-8</td>
<td>PC0-1, PC9-13</td>
<td>PC13은 WKUP 가능</td>
</tr>
<tr>
<td>GPIOD</td>
<td>PD0-1, PD3-6, PD8-9</td>
<td>PD2, PD7, PD10-15</td>
<td>여유 있음</td>
</tr>
<tr>
<td>GPIOE</td>
<td>PE0-3, PE9, PE11</td>
<td>PE4-8, PE10, PE12-15</td>
<td>여유 있음</td>
</tr>
</tbody>
</table>
<blockquote>
<p><strong>총 사용 핀</strong>: 약 40개 / <strong>여유 핀</strong>: 약 36개 — 향후 확장 충분</p>
</blockquote>
<h3>7.5 핀맵 문서화</h3>
<p>최종 확정된 핀 매핑은 <code>templates/hardware_pinmap_template.md</code> 양식에 맞춰
<code>Documentation/Hardware/AR_Walker_STM32_Pinmap.md</code>로 작성한다.</p>
<hr>
<p>이전 글: <a href="/ko/study/stm32-cubemx">STM32CubeMX 실전 설정</a> | 다음 글: <a href="/ko/study/stm32-bringup">STM32 보드 브링업</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/ko/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","스터디 목록"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 로봇 보드 핀 매핑 전략 — Teensy에서 STM32로"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"Teensy 4.1에서 STM32H743으로 마이그레이션하면서 세운 핀 매핑 전략과 실제 배치 결과."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"8분 읽기"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","pin-mapping",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"pin-mapping"}],["$","span","robotics",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"robotics"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — 로봇 교육 창시자"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"모두를 위한 로봇 교육을 꿈꾸는 엔지니어입니다. 하드웨어 브링업부터 AI 지능형 로봇까지, 실제 학습 과정을 기록하고 공유합니다."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["기술 여정 함께하기",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 로봇 보드 핀 매핑 전략 — Teensy에서 STM32로","slug":"stm32-pin-mapping","lang":"ko"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-pin-mapping","lang":"ko"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
