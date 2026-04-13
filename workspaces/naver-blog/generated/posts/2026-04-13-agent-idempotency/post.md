# AI 에이전트가 이메일을 두 번 보낸 이유 — Idempotency 설계의 모든 것

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


실제로 있었던 일입니다.

AI 에이전트를 이용해 고객에게 자동으로 견적 이메일을 보내는 시스템을 구축했습니다. 테스트 때는 완벽하게 작동했습니다. 런칭 첫 날, 네트워크 타임아웃이 하나 발생했고 — 에이전트는 "실패했다"고 판단하고 이메일을 다시 보냈습니다.

결과: 고객 한 명이 같은 견적서를 세 번 받았습니다.

이건 가벼운 실수가 아닙니다. 만약 그게 이메일이 아니라 결제 요청이었다면? 계약서 서명이었다면?

이 문제의 이름은 **Idempotency(멱등성)**입니다. 그리고 AI 에이전트 시대에는 이 개념이 그 어느 때보다 중요해졌습니다.

---

### Idempotency란 무엇인가?

수학에서 멱등성은 "같은 연산을 여러 번 적용해도 결과가 바뀌지 않는 성질"을 말합니다.

```
f(f(x)) = f(x)  ← 여러 번 해도 결과가 같다
```

소프트웨어에서는 이렇게 말할 수 있습니다:

> **같은 요청을 여러 번 실행해도, 결과가 한 번 실행한 것과 동일해야 한다.**

예를 들어:

```python
# 멱등하지 않은 함수 (위험)
def send_email(customer_id: str, content: str):
    email = get_email(customer_id)
    send(email, content)  # 호출할 때마다 이메일이 한 번씩 더 간다

# 멱등한 함수 (안전)
def send_email_idempotent(customer_id: str, content: str, idempotency_key: str):
    if already_sent(idempotency_key):
        return {"status": "already_sent"}  # 이미 보냈으면 그냥 성공 반환
    
    email = get_email(customer_id)
    send(email, content)
    mark_as_sent(idempotency_key)
    return {"status": "sent"}
```

---

### 왜 AI 에이전트에서 이게 특히 위험한가?

일반 API는 사람이 명시적으로 "다시 보내기" 버튼을 누릅니다. 하지만 AI 에이전트는 다릅니다.

AI 에이전트는 다음 상황에서 **자동으로 재시도**합니다:
1. 네트워크 타임아웃 발생 시
2. 도구 호출 응답이 애매할 때 ("성공인지 실패인지 모르겠어서" 다시 시도)
3. 멀티 에이전트 시스템에서 같은 작업을 두 에이전트가 동시에 수행할 때
4. 에이전트가 중간에 강제 종료된 후 재시작될 때

AI는 자신이 "방금 한 일"을 완벽하게 기억하고 추적하지 않습니다. 네트워크 응답이 조금만 느려도 "이게 성공한 건가? 아직 안 한 건가?"를 착각할 수 있습니다.

---

### 현실적인 위험 시나리오 세 가지

#### 시나리오 1: 결제 이중 실행
```
에이전트: 고객의 결제 처리 요청을 받음
에이전트: payment_tool을 호출 → 응답 없음 (타임아웃)
에이전트: "아직 안 된 것 같은데?" → 다시 호출
결제 시스템: 두 번 청구 완료
고객: 이중 청구 항의
```

#### 시나리오 2: 계약서 이중 서명 요청
```
에이전트 A: 계약서 서명을 법무팀에 요청 이메일 발송
에이전트 B: (같은 작업을 맡은 백업 에이전트) 같은 이메일 재발송
법무팀: 같은 계약서 요청이 두 번 와서 혼란
```

#### 시나리오 3: 데이터베이스 중복 레코드
```
에이전트: 새 고객 데이터를 DB에 INSERT
에이전트: 응답 지연 → 다시 INSERT
DB: 중복 레코드 두 개 생성 (기본키가 없으면 발견도 어려움)
```

---

### 실전 Idempotency 구현 패턴

#### 패턴 1: Idempotency Key 기반 중복 방지

가장 범용적인 방법입니다. 각 에이전트 작업에 고유 키를 부여하고, 이 키로 중복 실행을 막습니다.

```python
import uuid
import hashlib

class IdempotencyGuard:
    def __init__(self, store):
        self.store = store  # Redis, DB 등
    
    def generate_key(self, action: str, payload: dict) -> str:
        """같은 액션 + 같은 데이터는 항상 같은 키 = 자연스러운 멱등성"""
        content = f"{action}:{json.dumps(payload, sort_keys=True)}"
        return hashlib.sha256(content.encode()).hexdigest()[:16]
    
    def execute_once(self, key: str, action_fn, *args, **kwargs):
        """키가 이미 있으면 저장된 결과 반환, 없으면 실행 후 저장"""
        existing = self.store.get(key)
        if existing:
            return json.loads(existing)  # 이미 실행된 결과 반환
        
        result = action_fn(*args, **kwargs)
        self.store.set(key, json.dumps(result), ex=86400)  # 24시간 보관
        return result

# 에이전트 도구에 적용
guard = IdempotencyGuard(redis_client)

def send_contract_email(customer_id: str, contract_id: str):
    key = guard.generate_key("send_contract_email", {
        "customer_id": customer_id,
        "contract_id": contract_id
    })
    
    return guard.execute_once(
        key,
        _actually_send_email,  # 실제 전송 함수
        customer_id,
        contract_id
    )
```

#### 패턴 2: 상태 머신 기반 작업 추적

복잡한 멀티 스텝 작업에 적합합니다. 각 작업의 상태를 명시적으로 저장합니다.

```python
from enum import Enum

class TaskStatus(Enum):
    PENDING = "pending"
    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    FAILED = "failed"

class AgentTask:
    def __init__(self, task_id: str, db):
        self.task_id = task_id
        self.db = db
    
    def execute(self, steps: list):
        task = self.db.get_task(self.task_id)
        
        if task["status"] == TaskStatus.COMPLETED:
            return task["result"]  # 이미 완료됨, 다시 실행 금지
        
        if task["status"] == TaskStatus.IN_PROGRESS:
            # 다른 에이전트가 이미 실행 중
            raise ConflictError("이 작업은 이미 실행 중입니다")
        
        self.db.update_status(self.task_id, TaskStatus.IN_PROGRESS)
        
        try:
            result = self._execute_steps(steps)
            self.db.update_status(self.task_id, TaskStatus.COMPLETED, result)
            return result
        except Exception as e:
            self.db.update_status(self.task_id, TaskStatus.FAILED, error=str(e))
            raise
    
    def _execute_steps(self, steps: list):
        results = []
        for step in steps:
            # 각 스텝의 완료 여부를 개별적으로 기록
            step_result = self._execute_step_once(step)
            results.append(step_result)
        return results
```

#### 패턴 3: Saga 패턴 — 실패 시 롤백

에이전트가 여러 시스템에 걸쳐 작업을 수행할 때, 중간에 실패하면 이미 완료된 단계를 되돌려야 합니다.

```python
class AgentSaga:
    """단계별 실행 + 실패 시 역순 보상(롤백)"""
    
    def __init__(self):
        self.steps = []
        self.compensations = []
    
    def add_step(self, action, compensation):
        """action: 실제 작업, compensation: 롤백 함수"""
        self.steps.append(action)
        self.compensations.append(compensation)
    
    def execute(self):
        completed = []
        
        for i, (step, compensation) in enumerate(zip(self.steps, self.compensations)):
            try:
                result = step()
                completed.append((i, compensation, result))
            except Exception as e:
                print(f"스텝 {i} 실패: {e}")
                print("롤백 시작...")
                
                # 완료된 단계를 역순으로 롤백
                for idx, comp, res in reversed(completed):
                    try:
                        comp(res)
                        print(f"스텝 {idx} 롤백 완료")
                    except Exception as rollback_error:
                        print(f"롤백 실패 (수동 처리 필요): {rollback_error}")
                
                raise

# 사용 예시: 계약 처리 에이전트
saga = AgentSaga()

saga.add_step(
    action=lambda: create_contract_record(customer_id, contract_data),
    compensation=lambda result: delete_contract_record(result["contract_id"])
)

saga.add_step(
    action=lambda: charge_payment(customer_id, amount),
    compensation=lambda result: refund_payment(result["charge_id"])
)

saga.add_step(
    action=lambda: send_confirmation_email(customer_id),
    compensation=lambda result: None  # 이메일 취소는 불가, 로그만
)

saga.execute()  # 중간 실패 시 자동 롤백
```

---

### 요약: AI 에이전트 개발자를 위한 핵심 원칙

| 원칙 | 설명 |
|------|------|
| **중복 확인 우선** | 실행 전 항상 "이미 했는가?"를 확인 |
| **Idempotency Key 부여** | 모든 외부 작업에 고유 키 발급 |
| **상태 외부화** | 에이전트 내부가 아닌 외부 DB에 상태 저장 |
| **보상 트랜잭션 준비** | 모든 작업에 롤백 로직 설계 |
| **재시도 ≠ 재실행** | 재시도는 같은 결과가 보장될 때만 허용 |

---

### 마무리

AI 에이전트가 자율적으로 행동하는 시대, 개발자는 "에이전트가 실수할 수 있다"는 가정을 기본 전제로 깔아야 합니다.

에이전트가 실수 없이 완벽하게 동작하도록 만드는 것보다, **실수가 생겨도 부작용이 없도록 설계하는 것**이 훨씬 현실적입니다.

다음에 AI 에이전트에 외부 API 호출 도구를 붙일 때, 꼭 물어보세요.

> **"이 도구가 두 번 실행되면 어떻게 되는가?"**

답이 바로 나오지 않는다면, 아직 설계가 덜 된 겁니다.

---

**다음 주제:** [내 AI 에이전트가 서서히 멍청해졌다 — LLM Drift 감지법](/ko/study/llm-agent-drift-detection)