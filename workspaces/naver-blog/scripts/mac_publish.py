import os
import re
import argparse
import asyncio
import time
from playwright.async_api import async_playwright

class MacPublisher:
    """
    Automates Naver Blog publishing from Mac.
    Based on the PUBLISH-GUIDE.md and SmartEditor ONE selectors.
    """
    
    CONTEXT_DIR = os.path.expanduser("~/0xhenry.dev/workspaces/naver-blog/.naver_context")

    def __init__(self, debug=True):
        self.debug = debug

    def parse_markdown(self, file_path):
        """Parses frontmatter and content from markdown."""
        with open(file_path, "r", encoding="utf-8") as f:
            raw = f.read()

        # Split Frontmatter
        parts = re.split(r'---\s*\n', raw, 2)
        if len(parts) < 3:
            return None
        
        fm_text = parts[1]
        content = parts[2]
        
        # Simple metadata extract
        title = re.search(r'title:\s*"(.*)"', fm_text).group(1)
        category = re.search(r'category:\s*"(.*)"', fm_text).group(1)
        tags_raw = re.search(r'tags:\s*\[(.*)\]', fm_text).group(1)
        tags = [t.strip().strip('"') for t in tags_raw.split(",")]
        
        # Identify images
        # Format: ![Caption](../infographics/cleaned/photo1_architecture.jpg)
        images = re.findall(r'!\[.*?\]\((.*?)\)', content)
        
        # Convert relative image paths to absolute if needed
        base_path = os.path.dirname(os.path.abspath(file_path))
        abs_images = []
        for img in images:
            if img.startswith(".."):
                # Handle relative paths based on draft location
                # Example: ../infographics/cleaned/photo1.jpg from drafts/
                full_path = os.path.abspath(os.path.join(base_path, img))
                abs_images.append(full_path)
            else:
                abs_images.append(img)
                
        # Clean text: Remove image markers from text for sequential injection
        clean_body = re.split(r'!\[.*?\]\(.*?\)', content)
        
        return {
            "title": title,
            "category": category,
            "tags": tags,
            "body_sections": [s.strip() for s in clean_body if s.strip()],
            "images": abs_images
        }

    async def publish(self, data):
        async with async_playwright() as p:
            # 1. Launch Persistent Context
            context = await p.chromium.launch_persistent_context(
                self.CONTEXT_DIR,
                headless=False, # Visible browser
                viewport={'width': 1280, 'height': 800}
            )
            page = await context.new_page()
            
            # 2. Go to Naver Blog Write
            print("🚀 Navigating to Naver Blog Editor...")
            await page.goto("https://blog.naver.com/0xhenry/postwrite")
            
            # Login Check
            try:
                await page.wait_for_selector(".gnb_name_area, .nick", timeout=10000)
                print("✅ Logged in.")
            except:
                print("⚠️ Login required. Please log in manually in the opened browser window...")
                # Wait longer for manual login
                await page.wait_for_selector(".gnb_name_area, .nick", timeout=120000)
            
            # 3. Handle Title
            print(f"📝 Typing Title: {data['title']}")
            title_selector = ".se-documentTitle .se-text-paragraph, [contenteditable][data-placeholder*='제목']"
            await page.click(title_selector)
            await page.keyboard.press("Control+A") # Linux/Win but Mac uses Command sometimes. 
            await page.keyboard.press("Backspace")
            await page.keyboard.type(data['title'], delay=50) # Human-like
            
            # 4. Handle Body & Images (Sequential)
            print("🖋 Building content sections...")
            for i, section in enumerate(data['body_sections']):
                # Type Text
                await page.keyboard.press("Enter")
                await page.keyboard.type(section, delay=30)
                await page.keyboard.press("Enter")
                
                # Upload Image if exists
                if i < len(data['images']):
                    img_path = data['images'][i]
                    if os.path.exists(img_path):
                        print(f"🖼 Uploading image: {os.path.basename(img_path)}")
                        # Use file input or click photo button
                        # Note: Naver uses a file input hidden in the UI
                        file_input = await page.wait_for_selector("input[type='file']", state="attached")
                        await file_input.set_input_files(img_path)
                        await page.wait_for_timeout(3000) # Wait for upload
            
            # 5. Handle Tags
            print(f"🏷 Adding Tags: {', '.join(data['tags'])}")
            tag_input_selector = ".post_tag_input input, [placeholder*='태그']"
            for tag in data['tags']:
                await page.type(tag_input_selector, tag)
                await page.keyboard.press("Enter")
                await page.wait_for_timeout(500)

            # 6. Select Category (Simple approach by text)
            print(f"📂 Setting Category: {data['category']}")
            await page.click(".post_set_wrap .category_btn, [class*='category']")
            await page.wait_for_timeout(1000)
            await page.click(f"text='{data['category']}'")
            
            print("\n🏁 Automation complete. Please review and click 'PUBLISH' manually to confirm.")
            # Keep browser open for user review
            await page.wait_for_timeout(300000) # 5 minutes

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--post", required=True, help="Filename of the markdown draft")
    args = parser.parse_args()
    
    base_dir = os.path.expanduser("~/0xhenry.dev/workspaces/visual-infographic-engine/generated/drafts/")
    file_path = os.path.join(base_dir, args.post)
    
    if not os.path.exists(file_path):
        print(f"❌ File not found: {file_path}")
        return

    publisher = MacPublisher()
    data = publisher.parse_markdown(file_path)
    
    if data:
        asyncio.run(publisher.publish(data))
    else:
        print("❌ Failed to parse markdown.")

if __name__ == "__main__":
    main()
