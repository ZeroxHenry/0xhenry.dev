# 멀티 에이전트 충돌 — 두 에이전트가 같은 DB를 동시에 수정할 때

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


이 글은 **에이전트 신뢰성 시리즈** 8편입니다.
→ 7편: [Human-in-the-Loop의 진짜 구현법 — 단순 승인 버튼이 아니다](/ko/study/A_agent-reliability/human-in-the-loop-design)

---

에이전트가 하나일 때는 평화로웠습니다. 하지만 에이전트들이 팀을 이루어 협업하기 시작하면, 전통적인 소프트웨어 공학의 난제 중 하나인 **동시성(Concurrency) 문제**가 고개를 듭니다.

상상해 보세요.
- **에이전트 A**: "재고가 10개 있네? 하나 팔아야지." (재고를 9로 업데이트 시도)
- **에이전트 B**: (거의 동시에) "재고가 10개네? 하나 팔아야지." (재고를 9로 업데이트 시도)

결과는 어떻게 될까요? 재고는 9가 되지만, 실제로는 2개가 팔린 셈입니다. 데이터가 꼬인 것이죠. 이를 방지하기 위한 기술적 가드레일이 필요합니다.

---

### 1. 낙관적 잠금 (Optimistic Locking)

가장 권장되는 방식입니다. 데이터를 수정할 때 **'버전(Version)'** 혹은 **'타임스탬프'**를 함께 확인하는 것입니다.

```python
# 에이전트가 데이터를 업데이트할 때
def update_inventory(item_id, new_count, old_version):
    success = db.execute(
        "UPDATE items SET count = ?, version = version + 1 "
        "WHERE id = ? AND version = ?",
        (new_count, item_id, old_version)
    )
    if not success:
        # 에이전트에게 "누군가 먼저 수정했어. 다시 시도해"라고 알려줌
        raise ConcurrentUpdateError("데이터가 이미 변경되었습니다.")
```

에이전트가 업데이트에 실패하면, 다시 현재 값을 읽어와서(Read) 작업을 재시도(Retry)하게 유도합니다.

---

### 2. 세밀한 권한 분리 (Role-based Data Isolation)

근본적으로 충돌을 피하는 방법은 에이전트마다 **'수정 권한'을 수직으로 쪼개는 것**입니다.

- **에이전트 A**: 오직 `inventory_count`만 수정 가능.
- **에이전트 B**: 오직 `item_description`만 수정 가능.

서로 다른 필드를 건드린다면 동시 수정이 일어나더라도 최종 결과는 안전합니다. 이를 위해 에이전트의 도구(Tool) 설계 단계에서 `UpdateInventoryTool`과 `UpdateTextTool`을 엄격히 분리해야 합니다.

---

### 3. 세마포어(Semaphore)와 락(Lock)

만약 파일 시스템처럼 버전 관리가 어려운 자원을 공유한다면, 전통적인 **뮤텍스(Mutex)**를 써야 합니다.

```python
async with redis_lock.acquire("resource_key"):
    # 이 안에서는 오직 하나의 에이전트만 작업 가능
    await agent.execute_critical_task()
```

하지만 이 방식은 한 에이전트가 작업을 마칠 때까지 다른 에이전트들이 줄을 서서 기다려야 하므로(Waiting), 시스템의 전체 처리 속도가 느려질 수 있다는 점을 유의해야 합니다.

---

### Henry의 팁: 에이전트에게 '충돌'을 가르쳐라

단순히 시스템이 에러를 뱉는 것으로는 부족합니다. 에이전트의 프롬프트에 다음과 같은 지침을 포함하세요.

> "당신의 작업이 데이터 충돌로 인해 실패할 수 있습니다. 만약 `ConcurrentUpdateError`가 발생한다면, 당황하지 말고 최신 데이터를 다시 읽어와서 당신의 논리를 재검토한 후 다시 시도하십시오."

---

### 결론

자율성은 에이전트의 축복이지만, 충돌은 개발자의 저주입니다. **낙관적 잠금**과 **엄격한 도구 격리**를 통해 에이전트들이 서로의 발을 밟지 않고도 완벽한 군무를 출 수 있도록 아키텍처를 설계하세요.

---

**다음 글:** [에이전트 비용 계산서 — GPT-4o 에이전트 운영 1개월 청구서 공개](/ko/study/A_agent-reliability/agent-cost-breakdown)