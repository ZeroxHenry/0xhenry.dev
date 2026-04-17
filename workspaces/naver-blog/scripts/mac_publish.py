import os
import re
import argparse
import asyncio
from playwright.async_api import async_playwright

CONTEXT_DIR = os.path.expanduser("~/0xhenry.dev/workspaces/naver-blog/.naver_context")
DRAFTS_DIR  = os.path.expanduser("~/0xhenry.dev/workspaces/naver-blog/generated/posts")

def parse_markdown(file_path):
    with open(file_path, encoding="utf-8") as f:
        raw = f.read()
    parts = re.split(r'---\s*\n', raw, 2)
    if len(parts) < 3:
        return None
    fm, content = parts[1], parts[2]

    title_m    = re.search(r'title:\s*["\']?(.*?)["\']?\s*$', fm, re.M)
    category_m = re.search(r'category:\s*["\']?(.*?)["\']?\s*$', fm, re.M)
    tags_m     = re.search(r'tags:\s*\[(.*?)\]', fm)

    title    = title_m.group(1).strip()    if title_m    else "제목 없음"
    category = category_m.group(1).strip() if category_m else ""
    tags     = [t.strip().strip('"') for t in tags_m.group(1).split(",")] if tags_m else []

    images   = re.findall(r'!\[.*?\]\((.*?)\)', content)
    base     = os.path.dirname(os.path.abspath(file_path))
    abs_imgs = [os.path.abspath(os.path.join(base, i)) if i.startswith("..") else i for i in images]

    body = re.split(r'!\[.*?\]\(.*?\)', content)
    return {
        "title":    title,
        "category": category,
        "tags":     tags,
        "sections": [s.strip() for s in body if s.strip()],
        "images":   abs_imgs,
    }

async def run(data, actual_publish=False):
    async with async_playwright() as p:
        ctx = await p.chromium.launch_persistent_context(
            CONTEXT_DIR,
            headless=False,
            viewport={"width": 1280, "height": 900},
            args=["--start-maximized"],
        )
        page = await ctx.new_page()

        # ── 1. Navigate ───────────────────────────────────────────────
        print("🚀 Opening Naver Blog editor...")
        await page.goto("https://blog.naver.com/0xhenry/postwrite", wait_until="domcontentloaded")
        await page.wait_for_timeout(3000)

        # ── 2. Login check ───────────────────────────────────────────
        if "nidlogin" in page.url or "login" in page.url:
            print("⚠️  Login required — please log in in the browser window.")
            for _ in range(180):
                await page.wait_for_timeout(1000)
                if "nidlogin" not in page.url and "login" not in page.url:
                    break
            else:
                print("❌ Login timeout. Exiting.")
                await ctx.close()
                return
            await page.goto("https://blog.naver.com/0xhenry/postwrite", wait_until="domcontentloaded")
            await page.wait_for_timeout(5000)

        print(f"✅ Ready — URL: {page.url}")

        # ── 3. Title ──────────────────────────────────────────────────
        print(f"📝 Title: {data['title']}")
        try:
            # Click and type title
            title_el = await page.wait_for_selector(".se-documentTitle [contenteditable='true']", timeout=10000)
            if title_el:
                await title_el.click()
                await page.keyboard.press("Meta+a")
                await page.keyboard.press("Backspace")
                await page.keyboard.type(data["title"], delay=30)
        except Exception as e:
            print(f"  ⚠️  Title input failed: {e}")

        # ── 4. Body content ───────────────────────────────────────────
        print("🖋  Typing body content...")
        try:
            # Initial focus
            await page.click(".se-content [contenteditable='true']")
            
            for i, section in enumerate(data["sections"]):
                await page.keyboard.type(section, delay=5)
                await page.keyboard.press("Enter")
                
                # Image upload if exists
                if i < len(data["images"]) and os.path.exists(data["images"][i]):
                    print(f"  🖼  Uploading: {os.path.basename(data['images'][i])}")
                    # Click image icon to trigger file input (if needed) or just set file
                    file_input = await page.query_selector("input[type='file']")
                    if file_input:
                        await file_input.set_input_files(data["images"][i])
                        await page.wait_for_timeout(5000)  # Wait for upload
                        await page.keyboard.press("ArrowDown")  # Move past image
                        await page.keyboard.press("Enter")
        except Exception as e:
            print(f"  ⚠️  Body input failed: {e}")

        # ── 5. Tags ───────────────────────────────────────────────────
        print(f"🏷  Adding {len(data['tags'])} tags...")
        try:
            tag_input = await page.query_selector(".post_tag_input input, [placeholder*='태그']")
            if tag_input:
                for tag in data["tags"][:10]:
                    await tag_input.type(tag)
                    await page.keyboard.press("Enter")
                    await page.wait_for_timeout(300)
        except Exception as e:
            print(f"  ⚠️  Tag input failed: {e}")

        # ── 6. Category & Settings ────────────────────────────────────
        if actual_publish:
            print("⚙️  Configuring category and settings...")
            try:
                # Click 'Publish' options button (발행 버튼 옆 화살표나 설정)
                btn_publish_setting = await page.query_selector("button.btn_publish, .btn_save_go")
                if btn_publish_setting:
                    await btn_publish_setting.click()
                    await page.wait_for_timeout(2000)

                    # Select category
                    if data["category"]:
                        category_list = await page.query_selector(".list_category")
                        if category_list:
                            cat_item = await category_list.query_selector(f"text={data['category']}")
                            if cat_item:
                                await cat_item.click()
                    
                    # Ensure public & comment settings
                    # (Standard selectors for Naver SmartEditor One)
                    await page.click("label:has-text('전체공개')", no_wait_after=True)
                    await page.click("label:has-text('댓글허용')", no_wait_after=True)
                    
                    # FINAL PUBLISH
                    print("🚀 FINAL PUBLISH!")
                    final_btn = await page.query_selector(".btn_confirm, .btn_publish")
                    if final_btn:
                        await final_btn.click()
                        await page.wait_for_timeout(5000)
                        print(f"✨ Successfully published! URL: {page.url}")
            except Exception as e:
                print(f"  ⚠️  Publishing phase failed: {e}")
        else:
            # SAVE AS DRAFT
            print("💾 Saving as draft...")
            try:
                draft_btn = await page.query_selector(".btn_save_temp, button:has-text('임시저장')")
                if draft_btn:
                    await draft_btn.click()
                    await page.wait_for_timeout(3000)
                    print("✅ Saved to 0xhenry's drafts.")
            except Exception as e:
                print(f"  ⚠️  Draft save failed: {e}")

        await ctx.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--post", required=True, help="Draft markdown filename")
    parser.add_argument("--publish", action="store_true", help="Actually publish the post")
    args = parser.parse_args()

    path = os.path.join(DRAFTS_DIR, args.post)
    if not os.path.exists(path):
        # Check if it's a full path
        if os.path.exists(args.post):
            path = args.post
        else:
            print(f"❌ File not found: {args.post}")
            return

    data = parse_markdown(path)
    if not data:
        print("❌ Failed to parse markdown.")
        return

    print(f"📄 Post: {data['title']}")
    asyncio.run(run(data, actual_publish=args.publish))

if __name__ == "__main__":
    main()
