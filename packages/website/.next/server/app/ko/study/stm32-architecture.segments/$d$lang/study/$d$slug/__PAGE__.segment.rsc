1:"$Sreact.fragment"
2:I[3134,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],""]
9:I[46610,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"Image"]
a:I[41696,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
b:I[58380,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js","/_next/static/chunks/0j.4u96-16gse.js","/_next/static/chunks/0~i14~xm6f2np.js"],"default"]
c:I[84309,["/_next/static/chunks/0hm1~db~o32ab.js","/_next/static/chunks/11cggpb33wwo3.js"],"OutletBoundary"]
d:"$Sreact.suspense"
3:T125e,<p><img src="/images/study/stm32/cortex-m7-block.png" alt="ARM Cortex-M7 아키텍처">
<em>Cortex-M7 코어 블록 다이어그램</em></p>
<h3>1.1 ARM Cortex-M7 코어</h3>
<p>STM32H743VITx는 ARM Cortex-M7 코어를 탑재한 고성능 마이크로컨트롤러이다.</p>
<p><strong>코어 특성:</strong></p>
<table>
<thead>
<tr>
<th>항목</th>
<th>사양</th>
</tr>
</thead>
<tbody>
<tr>
<td>아키텍처</td>
<td>ARMv7E-M</td>
</tr>
<tr>
<td>파이프라인</td>
<td>6단계 슈퍼스칼라 (듀얼 이슈)</td>
</tr>
<tr>
<td>FPU</td>
<td>단정밀도(SP) + 배정밀도(DP) 부동소수점 연산</td>
</tr>
<tr>
<td>DSP</td>
<td>단일 사이클 MAC, SIMD 명령어</td>
</tr>
<tr>
<td>I-Cache</td>
<td>16 KB (명령어 캐시)</td>
</tr>
<tr>
<td>D-Cache</td>
<td>16 KB (데이터 캐시)</td>
</tr>
<tr>
<td>MPU</td>
<td>16 리전 메모리 보호 유닛</td>
</tr>
<tr>
<td>최대 클럭</td>
<td>480 MHz</td>
</tr>
</tbody>
</table>
<p><strong>왜 로봇 보드에 Cortex-M7인가?</strong></p>
<ul>
<li>500Hz 제어 루프를 안정적으로 구동 (현재 Teensy 4.1과 동일 코어)</li>
<li>FPU로 PID 연산, 토크 계산 등 실수 연산을 하드웨어로 처리</li>
<li>DSP 명령어로 센서 데이터 필터링 (IMU, 로드셀) 가속</li>
<li>캐시로 Flash에서 코드 실행 시에도 고속 동작 보장</li>
</ul>
<h3>1.2 STM32H743VITx 칩 스펙 요약</h3>
<table>
<thead>
<tr>
<th>항목</th>
<th>사양</th>
<th>비고</th>
</tr>
</thead>
<tbody>
<tr>
<td><strong>패키지</strong></td>
<td>LQFP-100</td>
<td>100핀, 14x14mm</td>
</tr>
<tr>
<td><strong>Flash</strong></td>
<td>2 MB</td>
<td>듀얼 뱅크</td>
</tr>
<tr>
<td><strong>RAM 총합</strong></td>
<td>1 MB</td>
<td>아래 상세</td>
</tr>
<tr>
<td><strong>ITCM</strong></td>
<td>64 KB</td>
<td>명령어 전용 (0사이클 대기)</td>
</tr>
<tr>
<td><strong>DTCM</strong></td>
<td>128 KB</td>
<td>가장 빠른 RAM (0사이클 대기)</td>
</tr>
<tr>
<td><strong>AXI SRAM</strong></td>
<td>512 KB</td>
<td>범용 대용량</td>
</tr>
<tr>
<td><strong>SRAM1</strong></td>
<td>128 KB</td>
<td>D2 도메인</td>
</tr>
<tr>
<td><strong>SRAM2</strong></td>
<td>128 KB</td>
<td>D2 도메인</td>
</tr>
<tr>
<td><strong>SRAM3</strong></td>
<td>32 KB</td>
<td>D2 도메인</td>
</tr>
<tr>
<td><strong>SRAM4</strong></td>
<td>64 KB</td>
<td>D3 도메인</td>
</tr>
<tr>
<td><strong>Backup SRAM</strong></td>
<td>4 KB</td>
<td>배터리 백업</td>
</tr>
<tr>
<td><strong>GPIO</strong></td>
<td>최대 82개</td>
<td>LQFP-100에서 사용 가능</td>
</tr>
<tr>
<td><strong>ADC</strong></td>
<td>3개 (ADC1/2/3)</td>
<td>16비트, 3.6 MSPS</td>
</tr>
<tr>
<td><strong>FDCAN</strong></td>
<td>2개</td>
<td>CAN FD 지원</td>
</tr>
<tr>
<td><strong>UART/USART</strong></td>
<td>8개</td>
<td>USART1-3,6 + UART4,5,7,8</td>
</tr>
<tr>
<td><strong>SPI</strong></td>
<td>6개</td>
<td>SPI1-6</td>
</tr>
<tr>
<td><strong>I2C</strong></td>
<td>4개</td>
<td>I2C1-4</td>
</tr>
<tr>
<td><strong>Timer</strong></td>
<td>다수</td>
<td>TIM1-17 (Advanced, GP, Basic)</td>
</tr>
<tr>
<td><strong>동작 전압</strong></td>
<td>1.62V ~ 3.6V</td>
<td>일반적으로 3.3V 사용</td>
</tr>
</tbody>
</table>
<h3>1.3 메모리 맵</h3>
<p>STM32H7은 전원 도메인(Power Domain)별로 메모리와 페리페럴이 구분된다.</p>
<p><img src="/images/study/stm32/memory-map.png" alt="메모리 맵">
<em>STM32H743 메모리 맵 — 주소별 영역 구분</em></p>
<p><strong>로봇 보드에서의 메모리 활용 전략:</strong></p>
<ul>
<li><strong>DTCM (128KB)</strong>: 제어 루프 변수, PID 파라미터, 모터 명령 버퍼 → 가장 빠른 접근</li>
<li><strong>AXI SRAM (512KB)</strong>: ExoData 구조체, 센서 데이터 배열, 설정 파일 파싱 버퍼</li>
<li><strong>SRAM1/2 (256KB)</strong>: DMA 전송 버퍼 (ADC, UART, SPI) → D2 도메인의 DMA가 직접 접근</li>
<li><strong>SRAM4 (64KB)</strong>: 저전력 모드에서도 유지해야 할 데이터</li>
</ul>
<h3>1.4 버스 아키텍처</h3>
<p>STM32H7의 버스는 3개의 전원 도메인(D1, D2, D3)으로 나뉜다:</p>
<p><img src="/images/study/stm32/bus-domains.png" alt="버스 도메인">
<em>D1/D2/D3 전원 도메인과 버스 아키텍처</em></p>
<p><strong>핵심 포인트:</strong></p>
<ul>
<li>GPIO는 AHB4 (D3 도메인)에 연결되어 있어 모든 도메인에서 접근 가능</li>
<li>FDCAN1/2는 APB1 (D2 도메인)에 있으므로 DMA1/2와 함께 사용 시 SRAM1/2에 버퍼 배치</li>
<li>ADC1/2는 APB2에, ADC3는 AHB4에 있어 서로 다른 도메인 → DMA 버퍼 위치 주의</li>
</ul>
<hr>
<p>다음 글: <a href="/ko/study/stm32-pin-system">STM32 핀 시스템 완전 정복</a></p>
0:{"rsc":["$","$1","c",{"children":[["$","article",null,{"className":"max-w-3xl mx-auto px-5 py-16","children":[["$","$L2",null,{"href":"/ko/study","className":"text-sm text-gray-500 hover:text-[var(--accent)] transition-colors mb-6 inline-block","children":["← ","스터디 목록"]}],["$","header",null,{"className":"mb-10","children":[["$","h1",null,{"className":"text-3xl md:text-4xl font-black tracking-tight mb-3","children":"STM32 아키텍처 기초 — Cortex-M7, 메모리, 버스 완전 정리"}],["$","p",null,{"className":"text-lg text-gray-600 dark:text-gray-400 mb-4","children":"STM32H743VITx의 ARM Cortex-M7 코어, 메모리 맵, 버스 아키텍처를 상세히 정리한 스터디 노트."}],["$","div",null,{"className":"flex flex-wrap items-center gap-3 text-sm text-gray-500","children":[["$","time",null,{"children":"2026-04-06"}],["$","span",null,{"children":"4분 읽기"}],["$","span",null,{"children":"by Henry"}],"$undefined"]}],["$","div",null,{"className":"flex flex-wrap gap-2 mt-4","children":[["$","span","stm32",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"stm32"}],["$","span","arm-cortex-m7",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"arm-cortex-m7"}],["$","span","embedded",{"className":"px-2.5 py-0.5 bg-[var(--accent)]/10 text-[var(--accent)] rounded-md text-xs font-medium","children":"embedded"}]]}]]}],"$undefined",["$","div",null,{"className":"prose","dangerouslySetInnerHTML":{"__html":"$3"}}],"$L4","$L5","$L6"]}],["$L7"],"$L8"]}],"isPartial":false,"staleTime":300,"varyParams":null,"buildId":"FVh-8WO-W0sG-ZqA-HZ3K"}
4:["$","div",null,{"className":"my-12 p-8 rounded-3xl bg-gradient-to-br from-indigo-50/50 via-white to-amber-50/30 dark:from-indigo-950/20 dark:via-gray-900 dark:to-amber-950/10 border border-indigo-100/50 dark:border-indigo-900/30 shadow-xl shadow-indigo-500/5","children":["$","div",null,{"className":"flex flex-col md:flex-row items-center gap-8","children":[["$","div",null,{"className":"relative group","children":[["$","div",null,{"className":"absolute -inset-1 bg-gradient-to-r from-indigo-500 to-blue-500 rounded-full blur opacity-25 group-hover:opacity-50 transition duration-1000 group-hover:duration-200"}],["$","div",null,{"className":"relative w-24 h-24 rounded-full overflow-hidden border-2 border-white dark:border-gray-800 shadow-sm","children":["$","$L9",null,{"src":"/favicon.svg","alt":"Henry","fill":true,"className":"object-cover"}]}]]}],["$","div",null,{"className":"flex-1 text-center md:text-left","children":[["$","h3",null,{"className":"text-xl font-black text-gray-900 dark:text-gray-100 mb-2 tracking-tight","children":"Henry — 로봇 교육 창시자"}],["$","p",null,{"className":"text-gray-600 dark:text-gray-400 text-base leading-relaxed mb-4 max-w-xl","children":"모두를 위한 로봇 교육을 꿈꾸는 엔지니어입니다. 하드웨어 브링업부터 AI 지능형 로봇까지, 실제 학습 과정을 기록하고 공유합니다."}],["$","div",null,{"className":"flex justify-center md:justify-start","children":["$","span",null,{"className":"inline-flex items-center text-sm font-bold text-indigo-600 dark:text-indigo-400 group cursor-pointer","children":["기술 여정 함께하기",["$","svg",null,{"className":"w-4 h-4 ml-1 transform group-hover:translate-x-1 transition-transform","fill":"none","viewBox":"0 0 24 24","stroke":"currentColor","children":["$","path",null,{"strokeLinecap":"round","strokeLinejoin":"round","strokeWidth":2,"d":"M9 5l7 7-7 7"}]}]]}]}]]}]]}]}]
5:["$","div",null,{"className":"mt-10 pt-6 border-t border-gray-200 dark:border-gray-800","children":["$","$La",null,{"title":"STM32 아키텍처 기초 — Cortex-M7, 메모리, 버스 완전 정리","slug":"stm32-architecture","lang":"ko"}]}]
6:["$","div",null,{"className":"mt-12","children":["$","$Lb",null,{"slug":"stm32-architecture","lang":"ko"}]}]
7:["$","script","script-0",{"src":"/_next/static/chunks/0~i14~xm6f2np.js","async":true}]
8:["$","$Lc",null,{"children":["$","$d",null,{"name":"Next.MetadataOutlet","children":"$@e"}]}]
e:null
