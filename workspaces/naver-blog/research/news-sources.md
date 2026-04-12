# AI 뉴스 소스 — 차별화 전략 가이드

> **핵심 원칙**: Tier S 소스에서 나온 뉴스를 Tier 2(한국 매체)가 다루기 전에 올려야 한다.
> 한국 블로그가 TechCrunch 번역으로 올릴 때, 우리는 Platformer 단독 취재를 한국어로.

---

## Tier S — 한국 블로그가 거의 안 보는 소스 ⭐

이 소스들에서 나온 뉴스 = 한국어 공백 = 차별화 가능

| 소스 | URL / RSS | 왜 특별한가 |
|---|---|---|
| **Platformer** | platformer.news/rss | Casey Newton의 인사이더 취재. 대기업 내부 스토리. 단독 多 |
| **Import AI** (Jack Clark) | importai.substack.com/feed | AI 연구 + 지정학. 전 Anthropic 공동창립자 분석 |
| **The Batch** (Andrew Ng) | read.deeplearning.ai/the-batch | 연구 논문 → 일반 언어. 한국 블로그 아무도 참고 안 함 |
| **Ben's Bites** | bensbites.com | 실제 기업 AI 활용 사례. 수익화 각도가 독특함 |
| **AI Tidbits** | aitidbitsnewsletter.com | 연구논문 요약. 기술적 차별화 강함 |
| **The Information** | theinformation.com | 단독 스쿱. 유료지만 헤드라인은 X(트위터)에서 확인 가능 |
| **CSET** | cset.georgetown.edu | AI 정책·안보 학술 분석. 한국 매체 거의 인용 안 함 |

## Tier A — 공식 발표 소스 (당일 한국어 해석이 없음)

| 소스 | URL / RSS | 활용 방법 |
|---|---|---|
| **Anthropic Blog** | anthropic.com/news | 공식 발표 당일 = 골든 타임. 2-3일 후엔 경쟁자 몰림 |
| **OpenAI Blog** | openai.com/blog | 발표 당일 올리면 차별화. 다음날은 포화 |
| **Google DeepMind** | deepmind.google/discover/blog | 연구 발표. 한국 블로그 거의 소화 못함 |
| **Meta AI** | ai.meta.com/blog | 오픈소스 AI. Llama 계열 소식 독점 |
| **Mistral AI** | mistral.ai/news | 유럽 AI 시각. 국내에서 거의 안 다뤄짐 |

## Tier B — 심층 분석 소스

| 소스 | URL | 특징 |
|---|---|---|
| MIT Technology Review | technologyreview.com | 학문적 관점. "왜"를 설명함 |
| Ars Technica AI | arstechnica.com/ai | 기술 심층. 빠르고 정확 |
| IEEE Spectrum AI | spectrum.ieee.org/topic/artificial-intelligence | 공학자 관점 |

## Tier C — 보조 확인 소스 (경쟁 심함, 단독 사용 금지)

이 소스 단독으로 쓰면 = 남들이랑 똑같은 블로그가 됨.
Tier S/A 소스로 각도를 잡고, 사실 확인용으로만 활용.

| 소스 | 문제점 |
|---|---|
| TechCrunch AI | 한국 블로그 대부분 여기 번역. 경쟁 극심 |
| The Verge AI | 같은 문제. 포화 |
| AI타임스 (한국) | 한국 독자가 이미 봄. 차별화 없음 |
| 지디넷코리아 | 같은 문제 |

---

## 포화 주제 블랙리스트 (작성 금지)

아래 키워드가 들어간 주제는 이미 네이버에 수백 편 존재함.
**작성하면 노출 안 됨. 절대 건드리지 말 것.**

- ChatGPT 사용법 / 활용법 / 꿀팁
- 무료 AI 도구 / 추천 / 모음
- AI 란 무엇인가 / AI 뜻 / AI 개념
- 미드저니 사용법 / Stable Diffusion 설치
- GPT vs Claude vs Gemini 비교
- 프롬프트 엔지니어링이란
- AI로 이미지 만들기 (일반적)
- AI 초보 / 입문 가이드 (일반적)
- AI 도구 TOP N

---

## 차별화 가능성 높은 주제 유형 ✅

### 1. 사건·사고형
- 소송, 규제, 서비스 종료, 내부 유출
- 예: "Sora 종료", "Getty vs Stability AI", "IMF AI 경고"
- 타이밍이 핵심 — 사건 발생 24시간 내 올려야 함

### 2. "나쁜 소식" 각도
- "AI 쓰다가 망한 사례", "AI 저작권 걸린 실례", "이렇게 하면 안 됨"
- 한국 블로그는 긍정 일색 → 부정 각도 = 비어있는 시장

### 3. 직군 특화
- 공무원, 프리랜서, 의료인, 교사 + AI
- 예: "공무원 ChatGPT 보안 규정", "병원 AI 개인정보 문제"
- 검색 키워드 경쟁 거의 없음

### 4. 글로벌 → 한국 연결
- 미국/유럽 사건을 한국 현실로 해석
- 예: "미국 병원 AI 소송 → 한국 의료 AI는?"
- 이 각도 쓰는 블로그 거의 없음

### 5. 연구 논문 쉽게 설명
- ArXiv, Nature 등 최신 논문 → 일반인 언어
- 경쟁: 사실상 없음

---

## 매일 뉴스 수집 루틴

```
1. [자동] python3 scripts/news_scout.py 실행 (RSS 스캔)
2. [수동] Platformer + Import AI 헤드라인 확인 (5분)
3. [수동] X(트위터)에서 @sama, @AnthropicAI, @GoogleDeepMind 확인 (3분)
4. 차별화 점수 25점 이상인 주제만 선택
5. 포화 주제 블랙리스트 체크 후 작성
```

## 뉴스 스카우트 실행 방법

```bash
# 프로젝트 루트에서
python3 scripts/news_scout.py

# 결과 확인
cat research/scout-log.md
```

---

*마지막 업데이트: 2026-04-13*
