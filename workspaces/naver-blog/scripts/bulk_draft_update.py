import os
import re

content_path = "/Users/chobyeongjun/0xhenry.dev/packages/website/content/ko/study"

def update_to_draft(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
        # Match frontmatter
        frontmatter_match = re.search(r'^(---\s*\n)(.*?)(\n---\s*\n)', content, re.DOTALL)
        if not frontmatter_match:
            return False
            
        header = frontmatter_match.group(1)
        fm_content = frontmatter_match.group(2)
        footer = frontmatter_match.group(3)
        body = content[frontmatter_match.end():]
        
        # Update or add draft: true
        if re.search(r'^draft:\s*', fm_content, re.MULTILINE):
            new_fm = re.sub(r'^draft:\s*.*', 'draft: true', fm_content, flags=re.MULTILINE)
        else:
            new_fm = fm_content.strip() + "\ndraft: true"
            
        new_content = header + new_fm + footer + body
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        return True
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

# Re-run scan to get definitive list again (buffer safety)
def check_images(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception: return True
    has_markdown_img = re.search(r'!\[.*?\]\(.*?\)', content)
    has_html_img = re.search(r'<img\s+.*?>', content, re.IGNORECASE)
    has_fm_img = False
    frontmatter_match = re.search(r'^---\s*\n(.*?)\n---\s*\n', content, re.DOTALL)
    if frontmatter_match:
        fm_content = frontmatter_match.group(1)
        img_keys = ['image', 'thumbnail', 'featureImage', 'hero', 'cover', 'ogImage']
        for key in img_keys:
            if re.search(fr'^{key}:\s*\S+', fm_content, re.MULTILINE):
                has_fm_img = True; break
    return has_markdown_img or has_html_img or has_fm_img

count = 0
for root, dirs, files in os.walk(content_path):
    for file in files:
        if file.endswith(".md"):
            full_path = os.path.join(root, file)
            if not check_images(full_path):
                if update_to_draft(full_path):
                    count += 1

print(f"Successfully set draft: true for {count} posts.")
