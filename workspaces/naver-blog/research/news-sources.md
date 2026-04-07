# AI 뉴스 소스 목록

## Tier 1 — 글로벌 (영문, 신뢰도 높음)
| 소스 | URL | 특징 |
|---|---|---|
| OpenAI Blog | https://openai.com/news/ | GPT/DALL-E 공식 발표 |
| Anthropic News | https://www.anthropic.com/news | Claude 관련 공식 |
| Google AI Blog | https://blog.google/technology/ai/ | Gemini, DeepMind |
| TechCrunch AI | https://techcrunch.com/category/artificial-intelligence/ | 업계 뉴스 종합 |
| The Verge AI | https://www.theverge.com/ai-artificial-intelligence | 일반인 대상 AI 뉴스 |
| Ars Technica AI | https://arstechnica.com/ai/ | 기술 심층 분석 |
| MIT Technology Review | https://www.technologyreview.com/topic/artificial-intelligence/ | 학술/연구 관점 |

## Tier 2 — 한국 (한국어)
| 소스 | URL | 특징 |
|---|---|---|
| AI타임스 | https://www.aitimes.com/ | 국내 AI 전문 매체 |
| 디지털투데이 | https://www.digitaltoday.co.kr/ | IT 전반 뉴스 |
| 지디넷코리아 | https://zdnet.co.kr/ | IT/AI 뉴스 |
| 블로터 | https://www.bloter.net/ | 테크 뉴스 |

## Tier 3 — WebSearch 쿼리 (당일 뉴스)
```
"AI 뉴스 2026" 오늘
"artificial intelligence news" today 2026
"ChatGPT" OR "Claude" OR "Gemini" release 2026
```

## 수집 루틴
1. WebSearch로 Tier 1-2 중 2-3개 확인
2. 가장 임팩트 있는 소식 1-2개 선택
3. index.json과 중복 체크
4. 한국 독자 관점에서 관심도 높은 주제 우선
