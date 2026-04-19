import os
import re
import argparse
import asyncio
from playwright.async_api import async_playwright

CONTEXT_DIR = os.path.expanduser("~/0xhenry.dev/workspaces/naver-blog/.naver_context")
DRAFTS_DIR  = os.path.expanduser("~/0xhenry.dev/workspaces/naver-blog/generated/posts")

def clean_markdown(text):
    """Final guard to remove AI-style markdown markers before typing."""
    text = text.replace("**", "")
    text = re.sub(r'^#+\s*', '', text, flags=re.M)
    text = re.sub(r'^[ \t]*[-*]\s*', '• ', text, flags=re.M)
    return text.strip()

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

    # Clean body sections
    body_raw = re.split(r'!\[.*?\]\(.*?\)', content)
    body_cleaned = [clean_markdown(s) for s in body_raw if s.strip()]

    return {
        "title":    title,
        "category": category,
        "tags":     tags,
        "sections": body_cleaned,
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
        await page.wait_for_timeout(4000)

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

        # ── 2a. Handle Pop-ups (Recover draft, etc.) ─────────────────
        print("🛡  Checking for blocking pop-ups...")
        try:
            # Handle "Load draft" alert
            # Case 1: Browser alert
            page.on("dialog", lambda dialog: dialog.dismiss())
            
            # Case 2: Naver custom pop-up (Cancel button for 'Load previous draft')
            cancel_btn = await page.query_selector(".se-popup-button-cancel, button:has-text('취소'), .btn_cancel")
            if cancel_btn:
                await cancel_btn.click()
                print("✅ Dismissed 'Load draft' pop-up.")
                await page.wait_for_timeout(1000)
            
            # Escape key as fallback
            await page.keyboard.press("Escape")
            await page.wait_for_timeout(500)
        except Exception as e:
            print(f"  (Pop-up check skipped or failed: {e})")

        print(f"✅ Ready — URL: {page.url}")

        # ── 3. Find Editor Frame ─────────────────────────────────────
        print("🔍 Searching for SmartEditor frame...")
        editor_frame = None
        for _ in range(30):  # Retry for up to 30 seconds
            for f in page.frames:
                if "postwrite" in f.url.lower() or "editor" in f.url.lower():
                    try:
                        # Try to find a core editor element
                        el = await f.query_selector(".se-content [contenteditable='true'], .se-documentTitle")
                        if el:
                            editor_frame = f
                            break
                    except:
                        continue
            if editor_frame:
                break
            await page.wait_for_timeout(1000)
        
        if not editor_frame:
            print("⚠️  Editor frame not found, using main page (might fail).")
            editor_frame = page
        else:
            print(f"✅ Found editor frame: {editor_frame.url[:50]}...")

        # ── 4. Title ──────────────────────────────────────────────────
        print(f"📝 Title: {data['title']}")
        try:
            # Multiple selector candidates for different editor versions/states
            title_selectors = [
                ".se-documentTitle [contenteditable='true']",
                "[id*='title']",
                ".se-placeholder",
                "h3.se-placeholder",
                ".se-ff-nanumsquare"
            ]
            
            title_el = None
            # Check both editor_frame and main page as fallback
            contexts = [editor_frame, page]
            for ctx_target in contexts:
                for sel in title_selectors:
                    try:
                        title_el = await ctx_target.query_selector(sel)
                        if title_el:
                            print(f"  ✅ Found title selector '{sel}' in {('iframe' if ctx_target == editor_frame else 'main page')}")
                            break
                    except:
                        continue
                if title_el:
                    break

            if title_el:
                await title_el.click()
                await page.keyboard.press("Meta+a")
                await page.keyboard.press("Backspace")
                await page.keyboard.type(data["title"], delay=45)
            else:
                print("  ⚠️  Could not find title input element. Proceeding with body only (Title might be missing!).")
        except Exception as e:
            print(f"  ⚠️  Title input phase failed: {e}")

        # ── 5. Body content ───────────────────────────────────────────
        print("🖋  Typing body content...")
        try:
            # Ensure focus on body - try multiple contexts and selectors
            body_selectors = [
                ".se-content [contenteditable='true']",
                ".smart_editor [contenteditable]",
                ".se-component-content [contenteditable='true']",
                "[class*='editor-area'] [contenteditable='true']",
                "div[id*='editor-body']"
            ]
            
            body_el = None
            # Wait for any of these to appear in either context
            for ctx_target in [editor_frame, page]:
                for sel in body_selectors:
                    try:
                        body_el = await ctx_target.query_selector(sel)
                        if body_el:
                            print(f"  ✅ Found body with '{sel}' in {('iframe' if ctx_target == editor_frame else 'main page')}")
                            await body_el.click()
                            break
                    except:
                        continue
                if body_el:
                    break
            
            if not body_el:
                # Emergency fallback: just click in the center of the editor frame
                print("  ⚠️  Body selector failed. Attempting coordinate-based click as fallback...")
                await editor_frame.click("body")
                await page.keyboard.press("Enter")
            
            # Type chunks
            for i, section in enumerate(data["sections"]):
                # Use clipboard-like typing for stability
                await page.keyboard.type(section, delay=1) 
                await page.keyboard.press("Enter")
                await page.wait_for_timeout(500)
                
                if i < len(data["images"]) and os.path.exists(data["images"][i]):
                    print(f"  🖼  Uploading: {os.path.basename(data['images'][i])}")
                    file_input = await page.query_selector("input[type='file']")
                    if file_input:
                        await file_input.set_input_files(data["images"][i])
                        await page.wait_for_timeout(6000)  # Wait for upload completion
                        await page.keyboard.press("ArrowDown")
                        await page.keyboard.press("Enter")
        except Exception as e:
            print(f"  ⚠️  Body input failed: {e}")

        # ── 6. Tags ───────────────────────────────────────────────────
        print(f"🏷  Adding {len(data['tags'])} tags...")
        try:
            # Tags are often in the main page, not the editor iframe
            tag_input = await page.query_selector(".post_tag_input input, [placeholder*='태그']")
            if tag_input:
                for tag in data["tags"][:10]:
                    await tag_input.type(tag)
                    await page.keyboard.press("Enter")
                    await page.wait_for_timeout(400)
        except Exception as e:
            print(f"  ⚠️  Tag input failed: {e}")

        # ── 7. Category & Settings ────────────────────────────────────
        if actual_publish:
            print("⚙️  Configuring category and settings...")
            try:
                # Click 'Publish' options button - main page
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
                    await page.click("label:has-text('전체공개')", no_wait_after=True)
                    await page.click("label:has-text('댓글허용')", no_wait_after=True)
                    
                    # FINAL PUBLISH
                    print("🚀 FINAL PUBLISH!")
                    final_btn = await page.query_selector(".btn_confirm, .btn_publish")
                    if final_btn:
                        await final_btn.click()
                        await page.wait_for_timeout(6000)
                        print(f"✨ Successfully published! URL: {page.url}")
            except Exception as e:
                print(f"  ⚠️  Publishing phase failed: {e}")
        else:
            # SAVE AS DRAFT - main page
            print("💾 Saving as draft...")
            try:
                draft_btn = await page.query_selector(".btn_save_temp, button:has-text('임시저장')")
                if draft_btn:
                    await draft_btn.click()
                    await page.wait_for_timeout(3000)
                    print("✅ Saved to 0xhenry's drafts.")
            except Exception as e:
                print(f"  ⚠️  Draft save failed: {e}")

        await page.wait_for_timeout(2000)
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
