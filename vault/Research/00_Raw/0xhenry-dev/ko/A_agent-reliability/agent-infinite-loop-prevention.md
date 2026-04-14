---
title: "AI 에이전트의 무한 루프 — 비용 폭탄 방지 설계"
date: 2026-04-13
draft: false
tags: ["AI 에이전트", "비용최적화", "무한루프", "에이전트보안", "에러핸들링", "LLM"]
description: "자율 에이전트가 루프에 빠져 API 비용을 순식간에 소진해버린다면? 프로덕션 환경에서 반드시 구현해야 하는 '비용 폭탄' 방지용 3단계 안전 장치를 소개합니다."
author: "Henry"
categories: ["에이전트 신뢰성"]
series: ["에이전트 신뢰성 시리즈"]
series_order: 5
images_needed:
  - position: "hero"
    prompt: "A robotic hand desperately trying to reach a 'STOP' button as an infinite coil of film (representing data loops) wraps around it. Bills and dollars are flying out of a digital screen. Dark background #0d1117, alarming red and neon yellow, 16:9"
    file: "images/A/agent-infinite-loop-prevention-hero.png"
  - position: "diagram"
    prompt: "Diagram showing 3 safety layers: 1. Max Iterations (Integer count), 2. Token Budget (Hard limit), 3. Pattern Recognition (Similarity check). If any triggered -> Termination. Labeled in Korean. 16:9"
    file: "images/A/agent-loop-prevention-layers.png"
---

이 글은 **에이전트 신뢰성 시리즈** 5편입니다.
→ 4편: [도구 호출 실패를 \"성공했다\"고 우기는 AI — Truthy Text 문제](/ko/study/A_agent-reliability/agent-truthy-text-failure)

---

자율 에이전트(Autonomous Agent) 개발을 시작하고 나서 제가 겪은 가장 끔찍한 악몽은 자는 동안 에이전트가 **무한 루프**에 빠진 것이었습니다.

- 에이전트: "파일을 못 읽겠어. 다시 시도할게." (도구 호출)
- 시스템: "파일이 없어." (에러 반환)
- 에이전트: "어? 다시 시도할게." (도구 호출)
- ... (1,000번 반복) ...

아침에 일어났을 때 제 이메일함에는 $500가 결제되었다는 API 청구 알람이 와 있었습니다. 

에이전트에게 자율성을 준다는 것은 곧 **"비용을 쓸 권한을 준다"**는 뜻입니다. 오늘은 이런 '비용 폭탄'을 방지하기 위한 3단계 안전 설계법을 공유합니다.

---

### 1단계: 최대 반복 횟수(Max Iterations) 하드 리밋

가장 기본이지만 가장 강력한 방법입니다. 루프의 내용과 상관없이 무조건 컷오프하는 장치입니다.

```python
class AgentRunner:
    def run(self, task, max_steps=10):
        current_step = 0
        while current_step < max_steps:
            action = self.agent.decide(task)
            if action.is_final():
                return action.result
            
            self.execute_tool(action)
            current_step += 1
            
        return "ERROR: 최대 실행 횟수 초과. 작업을 중단합니다."
```

프로덕션에서는 보통 **5~8회** 정도로 설정하는 것이 안전합니다. 그 이상 넘어간다면 에이전트가 길을 잃었을 확률이 매우 높습니다.

---

### 2단계: 토큰 예산(Token Budget) 관리

단순 횟수뿐만 아니라, 해당 요청 하나가 쓸 수 있는 **누적 토큰량**을 제한해야 합니다. 특히 컨텍스트가 길어지는 에이전트의 경우, 한 번 호출할 때마다 비용이 기하급수적으로 늘어나기 때문입니다.

```python
# $1.00 이상 소모 시 강제 종료 로직 예시
if current_session_cost > 1.00: 
    terminate_agent("Budget Exceeded")
```

---

### 3단계: 루프 패턴 감지 (Similarity Check)

에이전트가 똑같은 행동을 반복하고 있는지 감지하는 지능형 가드레일입니다. 
지난 3단계의 행동(Thought/Action)을 저장하고, 현재 행동과 **의미적 유사도**가 너무 높다면(예: 지난번과 똑같이 파일 열기 시도) 강제로 개입해야 합니다.

```python
def check_for_loops(history):
    latest_action = history[-1]
    repeated_count = sum(1 for h in history[-5:] if h == latest_action)
    
    if repeated_count >= 3:
        return "LOOP_DETECTED: 동일한 행동이 반복되고 있습니다. 전략을 수정하세요."
```

---

### Henry의 제안: 에이전트의 '포기할 권리'

우리는 에이전트가 모든 일을 완수하기를 바랍니다. 하지만 신뢰성 있는 시스템은 **"해봤는데 도저히 안 되겠어. 여기서 멈추고 사람에게 물어볼게"**라고 말할 줄 아는 시스템입니다. 

- **Self-Correction**: 3회 실패 시 자동으로 프롬프트에 "당신은 현재 같은 실수를 반복하고 있습니다. 새로운 접근 방식을 찾으세요"라는 경고 주입.
- **Human-in-the-Loop**: 5회 실패 시 실행을 멈추고 사용자에게 상태 보고 후 승인 대기.

---

### 결론

무한 루프는 단순한 버그가 아니라 비즈니스의 치명적인 리스크입니다. **Max Iteration, Token Budget, Loop Detection**이라는 3중 잠금 장치를 갖추지 않은 에이전트는 결코 혼자 두지 마세요.

---

**다음 글:** [에이전트 트레이싱 — 복잡한 멀티스텝 오류를 추적하는 법](/ko/study/A_agent-reliability/agent-distributed-tracing)
