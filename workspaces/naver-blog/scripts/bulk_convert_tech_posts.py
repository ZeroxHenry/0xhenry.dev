import os
import json
import shutil
import re
from datetime import datetime

# Configuration
# Script is in workspaces/naver-blog/scripts/ -> 4 levels up to reach root (0xhenry.dev)
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
SOURCE_DIR = os.path.join(REPO_ROOT, 'packages/website/content/ko/study')
TARGET_DIR = os.path.join(REPO_ROOT, 'workspaces/naver-blog/generated/posts')
INDEX_FILE = os.path.join(REPO_ROOT, 'workspaces/naver-blog/generated/index.json')
TASKS_FILE = os.path.join(REPO_ROOT, 'workspaces/naver-blog/image_bridge/tasks.json')

BRANDING_HEADER = """---
# 🚀 0xHenry 기술 리포트
# 본 포스트는 엔지니어 Henry의 기술 블로그(0xhenry.dev)에서 발행된 고품질 기술 콘텐츠를 네이버 블로그 환경에 맞게 재구성한 리포트입니다.
---
"""

def parse_simple_yaml(yaml_text):
    """Dependency-free simple YAML parser for frontmatter."""
    data = {}
    lines = yaml_text.split('\n')
    current_key = None
    in_list = False
    
    for line in lines:
        if not line.strip() or line.strip().startswith('#'):
            continue
            
        # List items (tags: ["a", "b"] or - a)
        if line.strip().startswith('- '):
            val = line.strip()[2:].strip().strip('"').strip("'")
            if current_key and isinstance(data.get(current_key), list):
                data[current_key].append(val)
            continue

        if ':' in line:
            key_part, val_part = line.split(':', 1)
            key = key_part.strip().strip('"').strip("'")
            val = val_part.strip().strip('"').strip("'")
            
            # Simple list detection: tags: ["a", "b"]
            if val.startswith('[') and val.endswith(']'):
                items = [i.strip().strip('"').strip("'") for i in val[1:-1].split(',')]
                data[key] = items
            elif not val: # Might be start of a block list
                data[key] = []
                current_key = key
            else:
                data[key] = val
                current_key = key
                
    return data

def extract_images_needed(content):
    """Extract patterns of images_needed manually if YAML parsing is too simple."""
    # This is a fallback if the YAML parser misses the complex images_needed structure
    images = []
    # Simplified search for images_needed block
    match = re.search(r'images_needed:(.*?)---', content, re.DOTALL)
    if match:
        block = match.group(1)
        # Find prompts and files
        prompts = re.findall(r'prompt:\s*"(.*?)"', block)
        files = re.findall(r'file:\s*"(.*?)"', block)
        positions = re.findall(r'position:\s*"(.*?)"', block)
        
        for i in range(len(prompts)):
            images.append({
                'prompt': prompts[i],
                'file': files[i] if i < len(files) else f"image-{i}.png",
                'position': positions[i] if i < len(positions) else "hero"
            })
    return images

def convert_posts():
    if not os.path.exists(TARGET_DIR):
        os.makedirs(TARGET_DIR)

    with open(INDEX_FILE, 'r', encoding='utf-8') as f:
        index_data = json.load(f)
    
    existing_ids = {p['id'] for p in index_data['posts']}
    new_posts_count = 0
    image_tasks = []

    md_files = []
    for root, dirs, files in os.walk(SOURCE_DIR):
        for file in files:
            if file.endswith('.md'):
                md_files.append(os.path.join(root, file))

    print(f"Found {len(md_files)} files. Converting...")

    for file_path in sorted(md_files):
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        parts = content.split('---', 2)
        if len(parts) < 3:
            continue
            
        frontmatter_text = parts[1]
        body = parts[2].strip()
        
        frontmatter = parse_simple_yaml(frontmatter_text)
        title = frontmatter.get('title', 'Unknown Title')
        date_str = str(frontmatter.get('date', datetime.now().date()))
        slug = os.path.splitext(os.path.basename(file_path))[0]
        post_id = f"{date_str}-{slug}"

        # Folder setup
        post_folder = os.path.join(TARGET_DIR, post_id)
        os.makedirs(post_folder, exist_ok=True)
        
        final_content = f"# {title}\n\n{BRANDING_HEADER}\n\n{body}"
        
        with open(os.path.join(post_folder, 'post.md'), 'w', encoding='utf-8') as f:
            f.write(final_content)

        # Image Extraction (Using refined logic)
        images_needed = extract_images_needed(content)
        for img in images_needed:
            image_tasks.append({
                'post_id': post_id,
                'title': title,
                'position': img.get('position', 'hero'),
                'prompt': img['prompt'],
                'target_path': img['file'],
                'status': 'pending'
            })

        if post_id not in existing_ids:
            cat = frontmatter.get('categories', ['AI/Tech'])
            if isinstance(cat, list): cat = cat[0]
            
            index_data['posts'].append({
                'id': post_id,
                'title': title,
                'category': cat,
                'status': 'ready',
                'generated_at': f"{date_str}T09:00:00+09:00",
                'published_at': None,
                'tags': frontmatter.get('tags', ['AI', '인공지능']),
                'char_count': len(body),
                'image_count': len(images_needed),
                'images_ready': False,
                'folder': f"generated/posts/{post_id}"
            })
            new_posts_count += 1
            existing_ids.add(post_id)

    # Save Results
    index_data['stats']['total_generated'] = len(index_data['posts'])
    with open(INDEX_FILE, 'w', encoding='utf-8') as f:
        json.dump(index_data, f, indent=2, ensure_ascii=False)

    if os.path.exists(TASKS_FILE):
        with open(TASKS_FILE, 'r', encoding='utf-8') as f:
            existing_tasks = json.load(f).get('queue', [])
    else:
        existing_tasks = []
    
    task_keys = {f"{t['post_id']}_{t['target_path']}" for t in existing_tasks}
    for t in image_tasks:
        key = f"{t['post_id']}_{t['target_path']}"
        if key not in task_keys:
            existing_tasks.append(t)
            task_keys.add(key)
            
    with open(TASKS_FILE, 'w', encoding='utf-8') as f:
        json.dump({'queue': existing_tasks}, f, indent=2, ensure_ascii=False)

    print(f"✅ Success: {new_posts_count} new posts, TOTAL {len(index_data['posts'])} indexed.")
    print(f"📸 {len(image_tasks)} image tasks updated.")

if __name__ == "__main__":
    convert_posts()
