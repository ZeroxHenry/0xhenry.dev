---
title: "ROS 2 + AI 에이전트: 로봇의 두뇌를 LLM으로 교체한 실험"
date: 2026-04-14
draft: false
tags: ["ROS2", "로봇공학", "LLM", "AI에이전트", "로보틱스", "제어시스템"]
description: "복잡한 코드로 로봇의 움직임을 정의하는 시대는 지났습니다. 자연어로 된 명령을 이해하고 ROS 2 명령어로 변환하여 로봇을 움직이는 'LLM 주도형 로봇 제어'의 가능성을 실험했습니다."
author: "Henry"
categories: ["Edge AI"]
series: ["Edge AI & 임베디드 시리즈"]
series_order: 7
images_needed:
  - position: "hero"
    prompt: "A robotic arm following instructions written on a floating digital tablet. The tablet says 'Pick up the blue ball'. The robot is glowing with neural network lines. Dark mode #0d1117, 16:9"
    file: "images/E/ros2-llm-agent-hero.png"
---

이 글은 **Edge AI & 임베디드 시리즈** 7편입니다.
→ 6편: [Raspberry Pi 5로 로컬 LLM: 실제 토큰/초 속도 측정 결과](/ko/study/E_edge-ai/rpi5-llm-speed-test)

---

전통적인 로보틱스에서 "거실에 가서 빨간 공을 가져와"라는 명령을 내리려면, 수천 줄의 `if-else` 문과 복잡한 상태 머신(State Machine)이 필요했습니다. 하지만 2026년 우리는 더 우아한 방법을 알고 있습니다. 모델에게 **로봇의 통제권**을 주는 것이죠.

오늘은 로봇 운영체제인 **ROS 2**와 **LLM**을 결합하여, 말귀를 알아듣는 로봇 에이전트를 구축한 실험기를 공유합니다.

---

### 1. 시스템 아키텍처: LLM AS OUPUT

핵심은 LLM이 단순히 '말'을 하는 것이 아니라, **'코드나 메시지'를 생성하게** 만드는 것입니다.
1. **User Input**: "Henry, 부엌에 가서 커피 좀 가져다줘."
2. **LLM Reasoning**: "부엌의 좌표는 (X, Y)다. Navigation 2 스택에 이 좌표를 전송해야겠다."
3. **ROS 2 Action**: 가공된 JSON 명령어가 ROS 2 Topic으로 발행되고 로봇이 이동합니다.

---

### 2. 왜 ROS 2인가?

ROS 2는 강력한 미들웨어입니다. 센서 데이터, 모터 제어, 슬램(SLAM) 등이 표준화된 인터페이스로 되어 있죠. LLM에게 로봇의 각 기능을 **'Tool(도구)'**로 정의해주면, LLM은 상황에 맞춰 이 도구들을 조합하기만 하면 됩니다.

---

### 3. 실험 중 마주한 난제: 안전(Safety)

LLM이 환각(Hallucination)을 일으켜 "벽을 뚫고 지나가라"는 명령을 내리면 어떨까요? 이를 막기 위해 **'안전 가드레일 레이어'**를 ROS 2 노드 단에 두어야 합니다. LLM의 명령을 물리적인 제약 조건(장애물 감지 등)과 대조하여 최종적으로 실행할지 판단하는 단계가 필수입니다.

---

### Henry의 결론: "로봇 개발 언어의 변화"

이제 로봇 개발자는 `C++`로 모든 상황을 코딩하는 사람이 아니라, 로봇이 가진 기능을 **LLM이 잘 이해할 수 있게 API로 정의하는 사람**이 될 것입니다. 로봇에 고성능 NPU가 탑재되면서, 클라우드 연결 없이도 실시간으로 사고하는 독립형 로봇들이 우리 곁으로 다가오고 있습니다.

---

**다음 글:** [ESP32 S3 + OpenAI Whisper: 저가형 칩으로 음성 인식 에이전트 만들기](/ko/study/E_edge-ai/esp32-whisper-voice-agent)
