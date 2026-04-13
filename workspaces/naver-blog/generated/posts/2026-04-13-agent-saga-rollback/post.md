# 에이전트에게 Ctrl+Z를 — Saga 패턴으로 롤백 구현하기

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


이 글은 **에이전트 신뢰성 시리즈** 3편입니다.
→ 2편: [내 AI 에이전트가 서서히 멍청해졌다 — LLM Drift 감지법](/ko/study/A_agent-reliability/llm-agent-drift-detection)

---

대부분의 AI 에이전트 데모는 "성공하는 경로(Happy Path)"만 보여줍니다.

- "내일 오전 10시 회의 잡아줘" → 회의 생성 완료!
- "비행기 티켓 예매해줘" → 예매 성공!

하지만 실제 프로덕션에서 에이전트를 운영하면 이런 일이 벌어집니다.

1. 회의는 잡았는데, 참여자들에게 보낼 초대 이메일 발송이 실패함.
2. 예매는 성공했는데, 회사 비용 시스템에 영수증 업로드가 안 됨.
3. **더 최악**: AI가 중간에 판단을 잘못해서 엉뚱한 사람에게 민감한 메일을 보냄.

사용자는 소리칩니다. **"아, 아까 그거 취소해!"**

---

### 왜 AI에게 '롤백'이 어려운가?

데이터베이스라면 `ROLLBACK` 한 번이면 끝납니다. 하지만 에이전트가 처리하는 일들은 이메일 발송, Slack 메시지 전송, 외부 API 호출 등 **되돌릴 수 없는 외부 효과(Side Effects)**를 가집니다.

이런 "결과적 일관성(Eventual Consistency)"이 필요한 상황에서 소프트웨어 공학이 내놓은 답이 바로 **Saga 패턴**입니다.

---

### Saga 패턴이란?

Saga는 긴 비즈니스 로직을 여러 개의 작은 **로비트(Local Transaction)**로 쪼개고, 각 단계마다 **보상 트랜잭션(Compensating Transaction)**을 정의하는 디자인 패턴입니다.

- **실행**: A 수행 → B 수행 → C 수행 (성공!)
- **실패/롤백**: A 수행 → B 수행 → C 실패! → **B 취소 수행 → A 취소 수행**

핵심은 "C를 없었던 일로 만드는 것"이 아니라, "C가 실패했으니 B와 A를 논리적으로 되돌리는 동작을 수행하는 것"입니다.

---

### Python으로 구현하는 에이전트 Saga 매니저

에이전트가 도구를 사용할 때마다 나중에 되돌릴 수 있는 '기록'과 '방법'을 함께 저장해야 합니다.

```python
from abc import ABC, abstractmethod
from typing import Any, Callable, List
import logging

class SagaStep:
    def __init__(self, name: str, action: Callable, compensate: Callable):
        self.name = name
        self.action = action
        self.compensate = compensate
        self.status = "pending"  # pending, completed, failed, compensated

class SagaManager:
    def __init__(self):
        self.steps: List[SagaStep] = []
        self.completed_steps: List[SagaStep] = []

    def add_step(self, name: str, action: Callable, compensate: Callable):
        self.steps.append(SagaStep(name, action, compensate))

    def execute(self):
        for step in self.steps:
            try:
                logging.info(f"실행 중: {step.name}")
                step.action()
                step.status = "completed"
                self.completed_steps.append(step)
            except Exception as e:
                logging.error(f"실패: {step.name}, 원인: {e}")
                step.status = "failed"
                self.rollback()
                raise e

    def rollback(self):
        logging.warning("롤백(보상 트랜잭션) 시작...")
        # 완료된 단계의 역순으로 보상 트랜잭션 실행
        for step in reversed(self.completed_steps):
            try:
                logging.info(f"보상 실행 중: {step.name}")
                step.compensate()
                step.status = "compensated"
            except Exception as e:
                # 보상 트랜잭션 자체가 실패하는 경우 - 매우 위험!
                logging.critical(f"보상 실패!! 관리자 개입 필요: {step.name}, 원인: {e}")
        logging.warning("롤백 완료.")

# --- 실제 에이전트 도구 예시 ---

def create_calendar_event():
    print("✅ 캘린더 이벤트 생성 완료 (id: 123)")

def delete_calendar_event():
    print("🔙 캘린더 이벤트 삭제 완료 (id: 123)")

def charge_payment():
    print("✅ 결제 10,000원 성공")
    # 인위적 실패 발생
    raise Exception("포인트 적립 시스템 장애!")

def refund_payment():
    print("🔙 결제 환불 10,000원 처리 완료")

# --- 사용법 ---

saga = SagaManager()
saga.add_step("캘린더 예약", create_calendar_event, delete_calendar_event)
saga.add_step("결제 처리", charge_payment, refund_payment)

try:
    saga.execute()
except:
    print("❌ 전체 프로세스 실패 및 복구 완료")
```

---

### 에이전트 워크플로우에서의 Saga 활용

AI 에이전트 프레임워크(CrewAI, LangGraph 등)를 쓸 때, 각 도구(Tool)를 정의할 때 `undo` 함수를 함께 정의하는 습관을 가져야 합니다.

```python
class CancellableTool:
    def __init__(self, name, func, undo_func):
        self.name = name
        self.func = func
        self.undo_func = undo_func

    def run(self, **kwargs):
        # 1. 실행 전 상태 저장/스냅샷 (필요시)
        # 2. 기능 실행
        result = self.func(**kwargs)
        # 3. Saga 매니저에 롤백 정보 등록
        register_to_saga(self.name, self.undo_func, kwargs)
        return result
```

#### 실제 시나리오: 여행 예약 에이전트

1. **호텔 예약**: `book_hotel(hotel_id)` / 보상: `cancel_hotel(booking_id)`
2. **항공권 결제**: `pay_flight(flight_id)` / 보상: `refund_flight(payment_id)`
3. **렌터카 예약**: `book_car(car_id)` (실패!)

이때 Saga 매니저는 항공권을 환불하고, 호텔 예약을 취소합니다. 사용자는 "예약 실패"라는 최종 결과만 보게 되며, 지갑이나 캘린더에는 쓰레기 데이터가 남지 않습니다.

---

### 보상 트랜잭션 설계의 골치 아픈 점 3가지

1. **멱등성(Idempotency)**: 롤백 함수는 여러 번 실행해도 안전해야 합니다. 이미 취소된 예약을 다시 취소하려고 할 때 에러가 나면 롤백 프로세스가 멈출 수 있습니다.
2. **가시성(Visibility)**: 이메일을 이미 보냈다면 "삭제"할 방법이 없습니다. 이때의 보상 트랜잭션은 **"이전 메일은 시스템 오류로 잘못 발송되었습니다"라는 사과 메일을 보내는 것**이 될 수 있습니다.
3. **시간차(Timeliness)**: 예약을 하고 30분 뒤에 실패했다면? 그 사이 다른 사람이 그 방을 예약할 수도 있고, 취소 수수료가 발생할 수도 있습니다.

---

### 결론: 신뢰받는 에이전트의 조건

에이전트에게 권한(Agency)을 줄수록, 우리는 에이전트가 저지른 사고를 수습할 방법(Ctrl+Z)을 더 튼튼하게 만들어야 합니다.

"우리 AI는 실수를 안 해요"라고 말하는 대신, **"우리 AI는 실수하면 스스로 안전하게 되돌려요"**라고 말할 수 있어야 진짜 프로덕션용 에이전트입니다.

---

**다음 글:** [도구 호출 실패를 "성공했다"고 우기는 AI — Truthy Text 문제](/ko/study/A_agent-reliability/agent-truthy-text-failure)