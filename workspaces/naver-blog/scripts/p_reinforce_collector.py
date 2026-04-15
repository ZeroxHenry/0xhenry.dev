#!/usr/bin/env python3
"""
p_reinforce_collector.py — Naver Blog Statistics Scraper
Collects per-post performance data (views, read time, traffic source)
and stores it in vault/20_Meta/Performance_Memory.json.

Usage:
  python3 scripts/p_reinforce_collector.py           # Collect all post stats
  python3 scripts/p_reinforce_collector.py --days 7  # Last 7 days only
"""

import json
import asyncio
import argparse
import os
from datetime import datetime, timedelta
from playwright.async_api import async_playwright

CONTEXT_DIR = os.path.expanduser("~/0xhenry.dev/workspaces/naver-blog/.naver_context")
MEMORY_FILE = os.path.expanduser("~/0xhenry.dev/vault/20_Meta/Performance_Memory.json")
INDEX_FILE  = os.path.expanduser("~/0xhenry.dev/workspaces/naver-blog/generated/index.json")
BLOG_ID     = "0xhenry"

def load_memory() -> dict:
    if os.path.exists(MEMORY_FILE):
        with open(MEMORY_FILE, encoding="utf-8") as f:
            return json.load(f)
    return {"posts": {}, "collected_at": None}

def save_memory(data: dict):
    data["collected_at"] = datetime.now().isoformat()
    with open(MEMORY_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"💾 Saved to {MEMORY_FILE}")

def load_index() -> list:
    with open(INDEX_FILE, encoding="utf-8") as f:
        return json.load(f).get("posts", [])

async def collect_stats(days: int = 30):
    async with async_playwright() as p:
        context = await p.chromium.launch_persistent_context(
            CONTEXT_DIR,
            headless=True,
            viewport={"width": 1280, "height": 800}
        )
        page = await context.new_page()
        memory = load_memory()
        posts  = load_index()
        published = [post for post in posts if post.get("naver_url")]

        print(f"📊 Collecting stats for {len(published)} published posts...")

        for post in published:
            url = post.get("naver_url")
            post_id = post.get("id")
            if not url:
                continue

            try:
                # Navigate to the post's stats page
                # Naver blog stats URL pattern: add /stat suffix
                stats_url = url.rstrip("/") + "?stats=1"
                await page.goto(stats_url, wait_until="networkidle", timeout=15000)
                await page.wait_for_timeout(2000)

                # Extract views from the blog Statistics sidebar widget
                # Naver shows "이 글 조회수" on the post stats page
                views_el = await page.query_selector(".se-module-viewer-count, .cnt_view, [class*='viewCount']")
                views = 0
                if views_el:
                    views_text = await views_el.inner_text()
                    views = int("".join(filter(str.isdigit, views_text)))

                memory["posts"][post_id] = {
                    "title":       post.get("title"),
                    "url":         url,
                    "category":    post.get("category"),
                    "tags":        post.get("tags", []),
                    "published_at": post.get("published_at"),
                    "char_count":  post.get("char_count", 0),
                    "image_count": post.get("image_count", 0),
                    "views":       views,
                    "collected_at": datetime.now().isoformat()
                }
                print(f"  ✅ {post.get('title', '')[:40]} → {views} views")

            except Exception as e:
                print(f"  ⚠️ Failed for {post_id}: {e}")
                continue

        await context.close()
        save_memory(memory)
        return memory

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--days", type=int, default=30, help="Collect stats for last N days")
    args = parser.parse_args()
    asyncio.run(collect_stats(args.days))

if __name__ == "__main__":
    main()
