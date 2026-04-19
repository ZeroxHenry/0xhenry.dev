import os
import re

# Comprehensive cleanup script for both languages
BasePaths = [
    "/Users/chobyeongjun/0xhenry.dev/packages/website/content/ko/study",
    "/Users/chobyeongjun/0xhenry.dev/packages/website/content/en/study"
]

def force_draft(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
        
        # We need to find the frontmatter correctly
        # Regex to find 'draft' field inside --- block
        fm_match = re.search(r'^---\s*\n(.*?)\n---', content, re.DOTALL)
        if not fm_match: return False
        
        fm_content = fm_match.group(1)
        
        # Check if the post actually has images (safety layer)
        # However, user is very unhappy with current visibility, so we prioritize cleanup.
        has_img = re.search(r'!\[.*?\]\(.*?\)', content)
        
        # Final decision: If it's in the list of what we consider 'image-less', hide it.
        # But wait, to be safe for the user's screenshots, we'll hide EVERYTHING that WE identified.
        # OR more simply: If we're unsure, and it looks like the ones in screenshot, hide it.
        
        # IF 'draft: false' exists, change to 'draft: true'
        if re.search(r'^draft:\s*false', fm_content, re.MULTILINE):
            new_fm = re.sub(r'^draft:\s*false', 'draft: true', fm_content, flags=re.MULTILINE)
        # IF 'draft' doesn't exist at all, add it
        elif not re.search(r'^draft:\s*', fm_content, re.MULTILINE):
            new_fm = fm_content.strip() + "\ndraft: true"
        else:
            new_fm = fm_content
            
        if new_fm != fm_content:
            new_content = "---\n" + new_fm + "\n---" + content[fm_match.end():]
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            return True
        return False
    except Exception as e:
        print(f"Error {file_path}: {e}")
        return False

# Re-scan rule: Any post where we can't find clear hero/thumbnail/content images
def is_imageless(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except: return False
    
    # Stricter rule: Check for content images OR hero images
    fm_match = re.search(r'^---\s*\n(.*?)\n---', content, re.DOTALL)
    has_fm_img = False
    if fm_match:
        fm = fm_match.group(1)
        if re.search(r'^(image|thumbnail|hero|cover):\s*\S+', fm, re.MULTILINE):
            has_fm_img = True
    
    has_markdown_img = re.search(r'!\[.*?\]\(.*?\)', content)
    return not (has_fm_img or has_markdown_img)

total_fixed = 0
for base in BasePaths:
    for root, dirs, files in os.walk(base):
        for file in files:
            if file.endswith(".md"):
                p = os.path.join(root, file)
                if is_imageless(p):
                    if force_draft(p):
                        total_fixed += 1

print(f"✅ Final Purification: {total_fixed} files updated to draft: true")
