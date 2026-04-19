import os
import re

content_path = "/Users/chobyeongjun/0xhenry.dev/packages/website/content/ko/study"

def check_images(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception:
        return True # Skip files that can't be read
    
    # Check for image markdown: ![...](...) or <img> tag
    has_markdown_img = re.search(r'!\[.*?\]\(.*?\)', content)
    has_html_img = re.search(r'<img\s+.*?>', content, re.IGNORECASE)
    
    # Check for frontmatter image fields
    has_fm_img = False
    frontmatter_match = re.search(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
    if frontmatter_match:
        fm_content = frontmatter_match.group(1)
        # Look for common image keys
        img_keys = ['image', 'thumbnail', 'featureImage', 'hero', 'cover', 'ogImage']
        for key in img_keys:
            if re.search(fr'^{key}:\s*\S+', fm_content, re.MULTILINE):
                has_fm_img = True
                break
            
    return has_markdown_img or has_html_img or has_fm_img

no_image_files = []

if os.path.exists(content_path):
    for root, dirs, files in os.walk(content_path):
        for file in files:
            if file.endswith(".md") or file.endswith(".markdown"):
                full_path = os.path.join(root, file)
                if not check_images(full_path):
                    rel_path = os.path.relpath(full_path, content_path)
                    no_image_files.append(rel_path)

if no_image_files:
    print("### [사진 없는 기사 목록]")
    for f in no_image_files:
        print(f"- {f}")
else:
    print("No image-less files found.")
