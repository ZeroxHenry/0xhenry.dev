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

async def run(data, draft_only=True):
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

        # ── 2. Login check (URL-based, not selector-based) ────────────
        if "nidlogin" in page.url or "login" in page.url:
            print("⚠️  Login required — please log in in the browser window.")
            print("    Waiting up to 3 minutes...")
            # Poll URL until we leave the login page
            for _ in range(180):
                await page.wait_for_timeout(1000)
                if "nidlogin" not in page.url and "login" not in page.url:
                    break
            else:
                print("❌ Login timeout. Exiting.")
                await ctx.close()
                return
            # After login redirect, go back to editor
            await page.goto("https://blog.naver.com/0xhenry/postwrite", wait_until="domcontentloaded")
            await page.wait_for_timeout(5000)

        print(f"✅ Ready — URL: {page.url}")

        # Switch to SmartEditor iframe if present
        frame = page
        for f in page.frames:
            if "editor" in f.url or "PostWrite" in f.url:
                frame = f
                break

        # ── 3. Title ──────────────────────────────────────────────────
        print(f"📝 Title: {data['title']}")
        try:
            title_sel = "iframe[id*='editor']"
            # Try direct input first (some layouts expose title outside iframe)
            t = await page.query_selector("input[id*='title'], .se-documentTitle [contenteditable]")
            if t:
                await t.click()
                await page.keyboard.press("Control+a")
                await page.keyboard.type(data["title"], delay=40)
        except Exception as e:
            print(f"  ⚠️  Title input failed: {e}")

        # ── 4. Body sections + images ─────────────────────────────────
        print("🖋  Typing body content...")
        try:
            body_sel = ".se-content [contenteditable='true'], .smart_editor [contenteditable]"
            body_el = await page.query_selector(body_sel)
            if body_el:
                await body_el.click()
            for i, section in enumerate(data["sections"]):
                await page.keyboard.press("Enter")
                await page.keyboard.type(section[:500], delay=20)  # cap length for speed
                await page.keyboard.press("Enter")
                if i < len(data["images"]) and os.path.exists(data["images"][i]):
                    print(f"  🖼  Uploading: {os.path.basename(data['images'][i])}")
                    fi = await page.query_selector("input[type='file']")
                    if fi:
                        await fi.set_input_files(data["images"][i])
                        await page.wait_for_timeout(4000)
        except Exception as e:
            print(f"  ⚠️  Body input failed: {e}")

        # ── 5. Tags ───────────────────────────────────────────────────
        print(f"🏷  Adding {len(data['tags'])} tags...")
        try:
            for tag in data["tags"][:8]:
                ti = await page.query_selector("[placeholder*='태그'], .post_tag_input input")
                if ti:
                    await ti.click()
                    await ti.type(tag)
                    await page.keyboard.press("Enter")
                    await page.wait_for_timeout(400)
        except Exception as e:
            print(f"  ⚠️  Tag input failed: {e}")

        # ── 6. Draft Save ─────────────────────────────────────────────
        print("\n💾 Saving as draft (임시저장)...")
        saved = False
        try:
            draft_btn = await page.query_selector("button:has-text('임시저장'), .btn_save_temp, [class*='tempsave']")
            if draft_btn:
                await draft_btn.click()
                await page.wait_for_timeout(3000)
                print("✅ 임시저장 완료!")
                saved = True
        except Exception:
            pass

        if not saved:
            # Fallback: keyboard shortcut
            await page.keyboard.press("Escape")
            await page.wait_for_timeout(500)
            await page.keyboard.press("Control+s")
            await page.wait_for_timeout(2000)
            print("✅ 임시저장 시도 (단축키 Ctrl+S)")

        print("\n✨ 완료. 브라우저를 직접 확인하세요.")
        await page.wait_for_timeout(15000)  # 15초 열어둠
        await ctx.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--post", required=True, help="Draft markdown filename")
    args = parser.parse_args()

    path = os.path.join(DRAFTS_DIR, args.post)
    if not os.path.exists(path):
        print(f"❌ File not found: {path}")
        return

    data = parse_markdown(path)
    if not data:
        print("❌ Failed to parse markdown.")
        return

    print(f"📄 Post: {data['title']}")
    asyncio.run(run(data))

if __name__ == "__main__":
    main()
