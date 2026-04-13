#!/usr/bin/env python3
"""
obsidian_publish.py — Obsidian에서 수정한 status를 index.json에 역반영

Obsidian에서 frontmatter의 status를 "ready"나 "published"로 바꾸면
이 스크립트가 index.json을 업데이트합니다.

사용법:
  python3 scripts/obsidian_publish.py          # Obsidian → index 동기화
  python3 scripts/obsidian_publish.py --ready  # 특정 포스트를 발행 대기로 변경
"""

import os
import json
import re
import argparse

BASE_DIR    = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX_FILE  = os.path.join(BASE_DIR, "generated", "index.json")
VAULT_DIR   = os.path.expanduser("~/vault/00_Raw/naver-blog")


def parse_frontmatter(content: str) -> dict:
    """마크다운에서 YAML frontmatter 파싱"""
    if not content.startswith("---"):
        return {}
    end = content.find("---", 3)
    if end == -1:
        return {}
    fm_text = content[3:end].strip()
    result = {}
    for line in fm_text.split("\n"):
        if ":" in line and not line.startswith(" "):
            k, _, v = line.partition(":")
            result[k.strip()] = v.strip().strip('"')
    return result


def sync_from_obsidian() -> int:
    """Obsidian 볼트 파일들의 status를 읽어 index.json에 반영"""
    with open(INDEX_FILE, encoding="utf-8") as f:
        index = json.load(f)

    posts = index.get("posts", [])
    updated = 0

    # 볼트의 모든 블로그 파일 읽기
    vault_statuses: dict[str, str] = {}
    vault_naver_urls: dict[str, str] = {}

    if os.path.isdir(VAULT_DIR):
        for fname in os.listdir(VAULT_DIR):
            if not fname.endswith(".md"):
                continue
            fpath = os.path.join(VAULT_DIR, fname)
            with open(fpath, encoding="utf-8") as f:
                content = f.read()
            fm = parse_frontmatter(content)
            title = fm.get("title", "")
            status = fm.get("status", "")
            naver_url = fm.get("naver_url", "")
            if title:
                vault_statuses[title] = status
                if naver_url:
                    vault_naver_urls[title] = naver_url

    # index 업데이트
    published_count = 0
    for post in posts:
        title = post.get("title", "")
        if title in vault_statuses:
            new_status = vault_statuses[title]
            if new_status and new_status != post.get("status"):
                print(f"  🔄 {title[:45]}")
                print(f"     {post.get('status')} → {new_status}")
                post["status"] = new_status
                updated += 1
            if title in vault_naver_urls and not post.get("naver_url"):
                post["naver_url"] = vault_naver_urls[title]
        if post.get("status") == "published":
            published_count += 1

    index["stats"]["total_published"] = published_count

    if updated:
        with open(INDEX_FILE, "w", encoding="utf-8") as f:
            json.dump(index, f, ensure_ascii=False, indent=2)
        print(f"\n✅ {updated}편 status 업데이트 완료")
        print(f"🚀 총 발행 완료: {published_count}편")
    else:
        print("변경사항 없음")

    return updated


def mark_ready(title_keyword: str):
    """제목 키워드로 포스트를 'ready'로 변경"""
    with open(INDEX_FILE, encoding="utf-8") as f:
        index = json.load(f)

    matched = []
    for post in index.get("posts", []):
        if title_keyword.lower() in post.get("title", "").lower():
            matched.append(post)

    if not matched:
        print(f"'{title_keyword}' 검색 결과 없음")
        return

    for post in matched:
        print(f"발행 대기로 변경: {post['title']}")
        post["status"] = "ready"

    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        json.dump(index, f, ensure_ascii=False, indent=2)

    # Obsidian 파일도 업데이트
    from obsidian_sync import sync_post
    for post in matched:
        sync_post(post, force=True)
    print("✅ 완료")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--ready", type=str, help="특정 포스트를 발행 대기로 변경 (제목 키워드)")
    args = parser.parse_args()

    if args.ready:
        mark_ready(args.ready)
    else:
        print("📥 Obsidian → index.json 역동기화 중...")
        sync_from_obsidian()


if __name__ == "__main__":
    main()
