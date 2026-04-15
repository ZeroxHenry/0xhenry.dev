---
title: "네이버 블로그 대시보드"
updated: 2026-04-13
tags:
  - "dashboard"
  - "naver-blog"
---

# 🚀 네이버 블로그 콘텐츠 허브

> 마지막 업데이트: `2026-04-13` | 🤖 **AI 파이프라인 가동 중**

## 📊 성과 및 통계

| 상태 | 개수 | 비중 |
|---|---|---|
| **🚀 발행 완료** | `0` | `0%` |
| **✅ 발행 대기** | `1` | `1%` |
| **📝 초안 작성** | `57` | `98%` |
| **📈 총 생성** | **`58`** | `100%` |

### 🎯 애드포스트 수익화 현황
**진행률: `0` / `50` (0%)**
`[                    ]`

---

## 📅 발행 스케줄링 (최근 생성순)

```dataview
TABLE status_label AS "상태", images_ready AS "🎨", category AS "카테고리", generated AS "생성일"
FROM "00_Raw/naver-blog"
WHERE status != "published"
SORT generated DESC
LIMIT 15
```

---

## 📑 카테고리별 전략 로드맵

```dataview
TABLE length(rows) AS "포스트 수", join(rows.status_label, ", ") AS "진행상태"
FROM "00_Raw/naver-blog"
GROUP BY category
SORT length(rows) DESC
```

---

## 🛠 파이프라인 컨트롤 패널

> [!TIP]
> **스크립트 실행 가이드**
> 1. `python3 scripts/news_scout.py` : 최신 해외 이슈 수집
> 2. `python3 scripts/obsidian_sync.py --new` : 새 글 Obsidian으로 가져오기
> 3. `python3 scripts/obsidian_publish.py` : 상태 변경사항 index.json에 반영
> 4. `git commit -m "update blog posts"` : 변경사항 저장

---

## 💡 차별화 유지 원칙
1. **Human-First**: AI 냄새나는 문체(결론적으로, 요약하면) 철저 배제.
2. **Niche-Focus**: 뉴스 소싱 시 'Platformer', 'Import AI' 등 독점 소스 우선.
3. **Experience-Base**: 반드시 본인의 생각이나 가정된 경험 1-2문장 추가.

---
