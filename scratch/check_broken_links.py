import os
import re
from pathlib import Path

CONTENT_DIR = Path("/Users/chobyeongjun/0xhenry.dev/packages/website/content")

def check_link(link_path, current_file_path):
    # Remove leading / and ko/en prefix for checking
    clean_path = link_path.lstrip('/')
    if clean_path.startswith('ko/study/'):
        clean_path = clean_path.replace('ko/study/', 'ko/study/')
    elif clean_path.startswith('en/study/'):
        clean_path = clean_path.replace('en/study/', 'en/study/')
    
    # Path logic in this Hugo/Next.js site seems to map /study/CATEGORY/slug to content/LANG/study/CATEGORY/slug.md
    # Let's try to find the file
    
    parts = clean_path.split('/')
    if len(parts) < 3: return True # Ignore root/category links for now
    
    lang = parts[0]
    category = parts[2]
    slug = parts[-1]
    
    # Try common patterns
    possible_paths = [
        CONTENT_DIR / lang / "study" / category / f"{slug}.md",
        CONTENT_DIR / lang / "study" / f"{slug}.md",
    ]
    
    for p in possible_paths:
        if p.exists():
            return True
    return False

broken_links = []
for root, dirs, files in os.walk(CONTENT_DIR):
    for file in files:
        if file.endswith(".md"):
            path = Path(root) / file
            content = path.read_text()
            
            # Find markdown links [Text](URL)
            links = re.findall(r'\[([^\]]+)\]\((/?[^)]+)\)', content)
            for text, url in links:
                if url.startswith('/ko/study') or url.startswith('/en/study'):
                    if not check_link(url, path):
                        broken_links.append((path.relative_to(CONTENT_DIR), text, url))

if broken_links:
    print(f"Found {len(broken_links)} broken links:")
    for f, t, u in broken_links:
        print(f"File: {f} | Link Text: {t} | URL: {u}")
else:
    print("No broken internal study links found.")
