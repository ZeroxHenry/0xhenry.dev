#!/usr/bin/env python3
"""
obsidian_sync.py — 블로그 포스트 ↔ Obsidian 볼트 동기화

기능:
1. generated/posts/ 에서 포스트를 읽어 ~/vault/00_Raw/naver-blog/ 에 복사
2. Obsidian YAML frontmatter 자동 추가 (Dataview 호환)
3. 발행 상태(status) 업데이트 반영
4. index.json과 동기화

사용법:
  python3 scripts/obsidian_sync.py           # 전체 동기화
  python3 scripts/obsidian_sync.py --new     # 새 포스트만
  python3 scripts/obsidian_sync.py --status  # 현황만 출력
"""

import os
import json
import shutil
import argparse
import datetime
import re

# ── 경로 설정 ──────────────────────────────────────────
BASE_DIR    = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
POSTS_DIR   = os.path.join(BASE_DIR, "generated", "posts")
INDEX_FILE  = os.path.join(BASE_DIR, "generated", "index.json")
VAULT_DIR   = os.path.expanduser("~/vault/00_Raw/naver-blog")
DASH_FILE   = os.path.expanduser("~/vault/20_Meta/naver-blog-dashboard.md")


def load_index() -> dict:
    with open(INDEX_FILE, encoding="utf-8") as f:
        return json.load(f)


def save_index(data: dict):
    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def build_frontmatter(post: dict) -> str:
    """Obsidian YAML frontmatter 생성 (Dataview/Properties 호환)"""
    tags = post.get("tags", [])
    tag_str = "\n".join(f'  - "{t}"' for t in tags)
    
    generated = post.get("generated_at", "")[:10]
    published = post.get("published_at") or ""
    naver_url = post.get("naver_url") or ""
    status    = post.get("status", "draft")
    category  = post.get("category", "AI 뉴스")
    
    # status → 한국어 뱃지
    status_label = {
        "draft":     "📝 초안",
        "ready":     "✅ 발행 대기",
        "published": "🚀 발행완료",
        "skip":      "⛔ 건너뜀",
    }.get(status, status)

    fm = f"""---
title: "{post.get('title', '')}"
category: "{category}"
status: "{status}"
status_label: "{status_label}"
generated: {generated}
published: "{published}"
naver_url: "{naver_url}"
tags:
{tag_str}
source: naver-blog-pipeline
---

"""
    return fm


def sync_post(post: dict, force: bool = False) -> bool:
    """단일 포스트를 Obsidian 볼트로 동기화"""
    folder_key = post.get("folder") or post.get("file", "")
    
    # folder vs file 경로 처리
    if folder_key.startswith("generated/posts/"):
        folder_name = folder_key.replace("generated/posts/", "")
        src_post = os.path.join(POSTS_DIR, folder_name, "post.md")
    elif folder_key.startswith("generated/2026-04/"):
        # 구형 포스트: 파일 직접 경로
        src_post = os.path.join(BASE_DIR, folder_key)
        folder_name = os.path.basename(folder_key).replace(".md", "")
    else:
        return False

    if not os.path.exists(src_post):
        return False

    # 출력 파일 경로
    safe_name = re.sub(r'[^\w가-힣\-]', '-', post.get("id", folder_name))
    dest_file = os.path.join(VAULT_DIR, f"{safe_name}.md")

    # 이미 존재하고 force 아니면 스킵
    if os.path.exists(dest_file) and not force:
        return False

    with open(src_post, encoding="utf-8") as f:
        content = f.read()

    # 기존 --- frontmatter 제거 후 새로 붙이기
    if content.startswith("---"):
        end = content.find("---", 3)
        if end != -1:
            content = content[end + 3:].lstrip()

    # 제목 H1이 있으면 유지, 없으면 추가
    fm = build_frontmatter(post)
    final = fm + content

    with open(dest_file, "w", encoding="utf-8") as f:
        f.write(final)

    return True


def build_dashboard(index: dict):
    """Obsidian Dataview 대시보드 생성"""
    stats = index.get("stats", {})
    total = stats.get("total_generated", 0)
    published = stats.get("total_published", 0)
    target = stats.get("adpost_target", 50)
    
    posts = index.get("posts", [])
    ready   = [p for p in posts if p.get("status") == "ready"]
    drafted = [p for p in posts if p.get("status") == "draft"]
    done    = [p for p in posts if p.get("status") == "published"]

    today = datetime.date.today().isoformat()

    content = f"""---
title: "네이버 블로그 대시보드"
updated: {today}
tags:
  - "dashboard"
  - "naver-blog"
---

# 네이버 블로그 파이프라인 대시보드

> 마지막 업데이트: {today}

## 현황

| 항목 | 수치 |
|---|---|
| 총 생성 | {total}편 |
| 발행 완료 | {published}편 |
| 발행 대기 | {len(ready)}편 |
| 초안 | {len(drafted)}편 |
| 애드포스트 목표 | {target}편 |
| 달성률 | {published}/{target} ({int(published/target*100) if target else 0}%) |

---

## 발행 대기 목록

```dataview
TABLE title, category, generated
FROM "00_Raw/naver-blog"
WHERE status = "ready"
SORT generated DESC
```

## 최근 초안

```dataview
TABLE title, category, generated
FROM "00_Raw/naver-blog"
WHERE status = "draft"
SORT generated DESC
LIMIT 10
```

## 발행 완료

```dataview
TABLE title, naver_url, published
FROM "00_Raw/naver-blog"
WHERE status = "published"
SORT published DESC
```

---

## 카테고리별 분포

```dataview
TABLE length(rows) AS 개수
FROM "00_Raw/naver-blog"
GROUP BY category
SORT length(rows) DESC
```

---

## 빠른 명령어

```bash
# 오늘 뉴스 스카우팅
python3 ~/0xhenry.dev/workspaces/naver-blog/scripts/news_scout.py

# Obsidian 동기화 (새 포스트만)
python3 ~/0xhenry.dev/workspaces/naver-blog/scripts/obsidian_sync.py --new

# 발행 대기 목록 확인
python3 ~/0xhenry.dev/workspaces/naver-blog/scripts/obsidian_sync.py --status
```

---

## 차별화 전략 체크리스트

- [ ] Platformer / Import AI 오늘 헤드라인 확인
- [ ] 포화 주제 블랙리스트 점검
- [ ] 사건·사고·논란 각도 우선 검토
- [ ] 글로벌 → 한국 연결 각도 적용
- [ ] 댓글 유도 문구 포함 여부 확인
"""
    os.makedirs(os.path.dirname(DASH_FILE), exist_ok=True)
    with open(DASH_FILE, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"📊 대시보드 생성: {DASH_FILE}")


def print_status(index: dict):
    posts = index.get("posts", [])
    stat_counts = {}
    for p in posts:
        s = p.get("status", "draft")
        stat_counts[s] = stat_counts.get(s, 0) + 1

    print("\n📋 현재 포스트 현황")
    print("=" * 40)
    for status, count in sorted(stat_counts.items()):
        print(f"  {status:12s} {count:3d}편")
    print(f"  {'합계':12s} {len(posts):3d}편")
    print()


def main():
    parser = argparse.ArgumentParser(description="Obsidian 동기화")
    parser.add_argument("--new",    action="store_true", help="새 포스트만 동기화")
    parser.add_argument("--force",  action="store_true", help="전체 강제 덮어쓰기")
    parser.add_argument("--status", action="store_true", help="현황만 출력")
    parser.add_argument("--dashboard", action="store_true", help="대시보드만 재생성")
    args = parser.parse_args()

    index = load_index()

    if args.status:
        print_status(index)
        return

    if args.dashboard:
        build_dashboard(index)
        return

    os.makedirs(VAULT_DIR, exist_ok=True)

    synced = 0
    skipped = 0
    for post in index.get("posts", []):
        result = sync_post(post, force=args.force)
        if result:
            synced += 1
            print(f"  ✅ {post.get('title', '')[:50]}")
        else:
            skipped += 1

    print(f"\n🔄 동기화 완료: {synced}편 추가 / {skipped}편 스킵")

    # 대시보드 항상 업데이트
    build_dashboard(index)


if __name__ == "__main__":
    main()
