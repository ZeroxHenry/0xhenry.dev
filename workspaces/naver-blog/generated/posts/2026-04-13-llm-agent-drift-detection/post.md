# 내 AI 에이전트가 서서히 멍청해졌다 — LLM Drift 감지법

---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---


AI 고객 지원 에이전트를 출시하고 6주 후, 불만 티켓이 들어오기 시작했습니다.

"봇이 환불 정책에 대해 완전히 틀린 정보를 줬어요."
"한국어로 물었더니 영어로 답하는데요?"
"지난달에 단종된 제품을 추천해줬어요."

로그를 봤습니다. 프롬프트는 바뀐 게 없었습니다. 모델도 바뀐 게 없었습니다. 시스템 모니터링은 전부 초록색이었습니다.

에이전트가 **드리프트**하고 있었습니다.

---

### LLM Drift란 무엇인가?

**LLM Drift**는 AI 시스템의 출력 품질이나 행동 일관성이 시간이 지나면서 서서히 저하되는 현상입니다. 단 하나의 명확한 원인을 특정하기 어렵다는 게 특징입니다.

감지를 더 어렵게 만드는 것들:
- 어떤 배포 하나가 원인이 아님
- 개별 테스트 케이스는 여전히 통과
- 모델 자체는 바뀐 게 없음
- 저하 속도가 너무 완만해서 일반 모니터링에 안 잡힘

드리프트에는 4가지 유형이 있고, 보통 동시에 발생합니다.

**1. 데이터 드리프트** — 실제 사용자 입력이 시스템이 설계된 분포에서 멀어집니다.

RAG 파이프라인은 정형화된 업무 문의에 최적화됐습니다. 그런데 사용자들이 욕설 없는 반말, 줄임말, 음성 인식 텍스트로 질문하기 시작했습니다. 검색 품질이 조용히 떨어집니다.

**2. 개념 드리프트** — 입력의 현실 세계 의미가 바뀌어, 과거에 맞던 출력이 틀리게 됩니다.

"최신 모델이 뭐예요?"는 1월에 정답이 있었습니다. 4월에는 정답이 바뀌었는데 지식 베이스가 업데이트되지 않았습니다.

**3. 모델 드리프트** — LLM 제공사가 조용히 모델을 업데이트합니다.

OpenAI, Anthropic, Google은 같은 API 엔드포인트 뒤에서 모델을 정기적으로 업데이트합니다. 오늘의 `gpt-4o`는 3개월 전의 `gpt-4o`와 동일하지 않습니다. 공들여 튜닝한 프롬프트가 서서히 어긋납니다.

**4. 컨텍스트 드리프트** — 대화가 쌓이면서 컨텍스트가 오염돼 세션별 품질이 저하됩니다.

[Context Rot 포스트](/ko/study/C_context-memory/context-rot-lost-in-middle)에서 다뤘습니다. "대화가 길어지면 AI가 멍청해진다"의 가장 흔한 원인입니다.

---

### 측정 문제

일반 업타임 모니터링으로는 드리프트를 잡지 못합니다. **HTTP 200 ≠ 정확한 답변**입니다.

시간별로 추적하는 **행동 지표**가 필요합니다:

```python
from dataclasses import dataclass
from datetime import datetime
import statistics

@dataclass
class DriftMetrics:
    timestamp: datetime
    quality_score: float          # 0-1: 평가 모델이 채점한 품질
    instruction_compliance: float  # 0-1: 시스템 프롬프트 규칙 준수율
    response_consistency: float    # 0-1: 같은 질문 → 비슷한 답 유지율
    factual_accuracy: float        # 0-1: 사실 점검 결과

class DriftMonitor:
    def __init__(self, window_days: int = 7):
        self.window_days = window_days
        self.history: list[DriftMetrics] = []

    def record(self, metrics: DriftMetrics):
        self.history.append(metrics)
        self._check_drift()

    def _check_drift(self):
        if len(self.history) < 14:  # 최소 2주치 데이터 필요
            return

        recent   = [m.quality_score for m in self.history[-7:]]
        baseline = [m.quality_score for m in self.history[-14:-7]]

        drift_magnitude = statistics.mean(baseline) - statistics.mean(recent)

        if drift_magnitude > 0.05:  # 5%p 이상 하락
            self._alert(f"DRIFT 감지: 7일간 품질 {drift_magnitude:.1%} 하락")

    def _alert(self, message: str):
        print(f"🚨 {message}")
        # PagerDuty, Slack 연동
```

---

### 드리프트 감지 파이프라인 구축

핵심은 **고정된 골든 데이터셋**을 상시 평가하는 자동화된 루프입니다.

```python
class DriftDetectionPipeline:
    def __init__(self, agent, evaluator_llm, golden_dataset: list[dict]):
        self.agent = agent
        self.evaluator = evaluator_llm
        # 골든 데이터셋: [{question, expected_answer, tags}]
        # 시스템 출시 당시 품질이 좋을 때 수집한 테스트 케이스들
        self.golden_dataset = golden_dataset
        self.monitor = DriftMonitor()

    def run_evaluation(self) -> DriftMetrics:
        """골든 데이터셋 전체를 에이전트에 통과시키고 점수를 매깁니다."""
        scores = []
        compliance_scores = []

        for example in self.golden_dataset:
            response = self.agent.chat(example["question"])

            # LLM-as-judge 평가
            eval_result = self.evaluator.evaluate(
                question=example["question"],
                expected=example["expected_answer"],
                actual=response,
                rubric=EVALUATION_RUBRIC
            )

            scores.append(eval_result.quality)
            compliance_scores.append(
                self._check_compliance(response, example.get("rules", []))
            )

        metrics = DriftMetrics(
            timestamp=datetime.now(),
            quality_score=statistics.mean(scores),
            instruction_compliance=statistics.mean(compliance_scores),
            response_consistency=self._measure_consistency(),
            factual_accuracy=self._spot_check_facts()
        )

        self.monitor.record(metrics)
        return metrics

    def _check_compliance(self, response: str, rules: list[str]) -> float:
        """특정 규칙 준수 여부 확인 ('경쟁사 언급 금지' 등)"""
        violations = sum(
            1 for rule in rules
            if self.evaluator.check_violation(response, rule)
        )
        return 1.0 - (violations / max(len(rules), 1))

    def _measure_consistency(self) -> float:
        """같은 질문을 3번 던져 답변 간 의미적 유사도 측정"""
        test_q = "환불 정책이 어떻게 되나요?"
        responses = [self.agent.chat(test_q) for _ in range(3)]
        embeddings = [embed(r) for r in responses]
        similarities = [
            cosine_similarity(embeddings[i], embeddings[j])
            for i in range(3) for j in range(i+1, 3)
        ]
        return statistics.mean(similarities)
```

---

### 근본 원인 진단: 어떤 유형의 드리프트인가?

드리프트를 감지했으면, 고치기 전에 **왜** 발생했는지 알아야 합니다.

```python
class DriftDiagnostics:

    def diagnose(self, agent) -> dict:
        return {
            "model_drift":   self._test_model_drift(agent),
            "data_drift":    self._test_data_drift(agent),
            "context_drift": self._test_context_drift(agent),
        }

    def _test_model_drift(self, agent) -> dict:
        """시스템 건강 시점에 저장한 기준 응답과 현재 응답 비교."""
        FROZEN_TEST_CASES = load_baseline_responses()  # 출시 당시 저장

        current_responses  = [agent.chat(tc["question"]) for tc in FROZEN_TEST_CASES]
        baseline_responses = [tc["baseline_response"]    for tc in FROZEN_TEST_CASES]

        similarities = [
            semantic_similarity(curr, base)
            for curr, base in zip(current_responses, baseline_responses)
        ]
        avg = statistics.mean(similarities)

        return {
            "detected": avg < 0.80,
            "similarity_score": avg,
            "recommendation": (
                "모델 버전 고정: model='gpt-4o-2024-11-20'"
                if avg < 0.80 else "정상"
            )
        }

    def _test_context_drift(self, agent) -> dict:
        """Context Rot 검사: 1턴 품질 vs 15턴 후 품질 비교."""
        STANDARD_Q = "영업시간이 어떻게 되나요?"  # 단순하고 변하지 않는 질문

        fresh_score = evaluate_quality(agent.chat(STANDARD_Q, history=[]))
        noisy_history = generate_filler_turns(15)
        long_score = evaluate_quality(agent.chat(STANDARD_Q, history=noisy_history))

        degradation = fresh_score - long_score
        return {
            "detected": degradation > 0.10,
            "degradation": degradation,
            "recommendation": (
                "Context Engineering 패턴 적용 필요 (롤링 요약, 지시 재주입)"
                if degradation > 0.10 else "정상"
            )
        }
```

---

### 유형별 대응책

| 드리프트 유형 | 징후 | 대응책 |
|------------|------|--------|
| **모델 드리프트** | 고정 프롬프트의 출력이 의미적으로 달라짐 | 모델 버전 고정: `gpt-4o-2024-11-20` |
| **데이터 드리프트** | 검색 정밀도 하락, 유저 입력이 인덱스와 불일치 | 분기별 재청킹 + 재임베딩 |
| **개념 드리프트** | 시간 민감 주제에서 사실 정확도 하락 | 지식 신선도 점수 + 자동 업데이트 스케줄 |
| **컨텍스트 드리프트** | 긴 세션에서만 품질 저하 | 롤링 요약 + 지시 재주입 패턴 적용 |

---

### 모델 버전 고정 (가장 쉬운 첫 번째 대응)

지금 당장 안 하고 있다면, 오늘 해야 합니다.

```python
# ❌ 위험: 조용한 모델 업데이트에 무방비
client.chat.completions.create(
    model="gpt-4o",  # 어떤 버전? 아무도 모름.
    messages=messages
)

# ✅ 안전: 명시적 버전 고정
client.chat.completions.create(
    model="gpt-4o-2024-11-20",  # 테스트 완료, 안정적
    messages=messages
)

# 업그레이드 프로세스:
# 1. 새 버전 출시 (예: gpt-4o-2025-03-15)
# 2. 골든 데이터셋으로 새 버전 평가
# 3. 현재 버전 이상 품질이면 업그레이드 일정
# 4. 저트래픽 시간대에 배포
# 5. 48시간 모니터링 후 완전 전환
```

---

### 알림 설정

드리프트 감지는 알림 없이 쓸모없습니다.

```python
THRESHOLDS = {
    "quality_score":           {"warning": 0.75, "critical": 0.65},
    "instruction_compliance":  {"warning": 0.80, "critical": 0.70},
    "response_consistency":    {"warning": 0.75, "critical": 0.65},
    "factual_accuracy":        {"warning": 0.85, "critical": 0.75},
}

def evaluate_alerts(metrics: DriftMetrics) -> list[str]:
    alerts = []
    for name, thresholds in THRESHOLDS.items():
        value = getattr(metrics, name)
        if value < thresholds["critical"]:
            alerts.append(f"🔴 긴급: {name} = {value:.1%} (임계값: {thresholds['critical']:.0%})")
        elif value < thresholds["warning"]:
            alerts.append(f"🟡 경고: {name} = {value:.1%}")
    return alerts
```

---

### 결론

드리프트는 조용하고, 점진적이며, 비쌉니다. 사용자가 AI를 불신하기 시작하면 신뢰를 되찾기 매우 어렵습니다.

해결책은 복잡하지 않습니다. 세 가지:

1. **업타임이 아닌 행동을 측정하세요** — 품질 점수, 지시 준수율, 일관성
2. **고정된 기준선과 비교하세요** — 출시 당시 "좋았을 때"가 어땠는지 항상 알고 있어야 합니다
3. **모델 버전을 고정하세요** — 조용한 업데이트에 무너지지 않도록

AI 시스템의 신뢰성은, 그 시스템이 언제 저하되는지 감지하는 능력만큼만 높습니다.

---

**이전 글:** [AI 에이전트가 이메일을 두 번 보낸 이유 — Idempotency 설계](/ko/study/A_agent-reliability/agent-idempotency)
**다음 글:** [에이전트에게 Ctrl+Z를 — Saga 패턴으로 롤백 구현하기](/ko/study/A_agent-reliability/agent-saga-rollback)