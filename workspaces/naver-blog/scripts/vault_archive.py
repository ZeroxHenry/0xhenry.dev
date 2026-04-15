#!/usr/bin/env python3
"""
vault_archive.py — Archive published blog posts into Obsidian vault.

Called automatically by mac_publish.py after successful publishing,
OR manually to archive a completed post:

  python3 scripts/vault_archive.py --post cloudflare_openai_post.md
"""

import os
import re
import shutil
import argparse
from datetime import datetime
from pathlib import Path

DRAFTS_DIR  = Path.home() / "0xhenry.dev" / "workspaces" / "visual-infographic-engine" / "generated" / "drafts"
VAULT_LIFE  = Path.home() / "0xhenry.dev" / "vault" / "Life" / "10_Wiki"
INDEX_FILE  = Path.home() / "0xhenry.dev" / "workspaces" / "naver-blog" / "generated" / "index.json"

def parse_frontmatter(content: str) -> dict:
    if not content.startswith("---"):
        return {}
    end = content.find("---", 3)
    if end == -1:
        return {}
    fm_text = content[3:end]
    result = {}
    for line in fm_text.split("\n"):
        if ":" in line and not line.startswith(" "):
            k, _, v = line.partition(":")
            result[k.strip()] = v.strip().strip('"\'')
    return result

def archive_post(draft_filename: str, naver_url: str = None):
    draft_path = DRAFTS_DIR / draft_filename
    if not draft_path.exists():
        print(f"❌ Draft not found: {draft_path}")
        return False

    content = draft_path.read_text(encoding="utf-8")
    fm = parse_frontmatter(content)
    
    title    = fm.get("title", draft_filename.replace(".md", ""))
    category = fm.get("category", "Life")
    tags_raw = fm.get("tags", "")
    date_str = datetime.now().strftime("%Y-%m-%d")

    # Create target folder inside vault/Life/10_Wiki/[category]/
    target_dir = VAULT_LIFE / category
    target_dir.mkdir(parents=True, exist_ok=True)
    
    # Slug for filename
    slug = re.sub(r'[^\w-]', '', draft_filename.replace(".md", "").lower().replace(" ", "-"))
    target_md = target_dir / f"{date_str}-{slug}.md"

    # Build enriched frontmatter for Obsidian
    obsidian_fm = f"""---
title: "{title}"
category: "{category}"
tags: [{tags_raw}]
published_at: "{date_str}"
naver_url: "{naver_url or ''}"
status: "published"
source: "naver-blog"
created: "{date_str}"
summary: ""
---

"""
    # Strip original frontmatter and prepend Obsidian one
    body = re.sub(r'^---.*?---\s*', '', content, flags=re.DOTALL).strip()
    
    # Add backlinks footer
    footer = f"\n\n---\n*발행 아카이브 — {date_str}*\n[[naver-blog-published-index]]\n"
    
    final_content = obsidian_fm + body + footer
    target_md.write_text(final_content, encoding="utf-8")

    # Copy associated images
    images_dir = DRAFTS_DIR.parent / "infographics" / "cleaned"
    if images_dir.exists():
        img_dest = target_dir / f"{date_str}-{slug}-images"
        img_dest.mkdir(exist_ok=True)
        for img in images_dir.glob("*.jpg"):
            shutil.copy2(img, img_dest / img.name)
            print(f"  🖼 Copied image: {img.name}")

    print(f"✅ Archived to vault: {target_md.relative_to(Path.home() / '0xhenry.dev')}")
    
    # Update naver-blog published index
    _update_published_index(title, str(target_md.relative_to(Path.home() / "0xhenry.dev")), naver_url, date_str)
    
    return True

def _update_published_index(title: str, vault_path: str, naver_url: str, date_str: str):
    """Append entry to vault/Life/10_Wiki/naver-blog-published-index.md"""
    index_path = VAULT_LIFE / "naver-blog-published-index.md"
    
    if not index_path.exists():
        index_path.write_text("""---
title: "Naver Blog — Published Archive"
tags: [blog, archive, published, index]
created: 2026-04-15
---

# 📚 네이버 블로그 발행 아카이브

> 발행 완료된 포스트 목록. [[vault_lint.py]]로 자동 업데이트.

| 발행일 | 제목 | Vault | 네이버 URL |
|--------|------|-------|-----------|
""", encoding="utf-8")
    
    with open(index_path, "a", encoding="utf-8") as f:
        url_display = f"[링크]({naver_url})" if naver_url else "-"
        f.write(f"| {date_str} | {title} | [[{vault_path}]] | {url_display} |\n")
    
    print(f"✅ Published index updated")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--post",    required=True, help="Draft markdown filename")
    parser.add_argument("--url",     default="",    help="Naver blog post URL after publishing")
    args = parser.parse_args()
    
    archive_post(args.post, args.url or None)

if __name__ == "__main__":
    main()
