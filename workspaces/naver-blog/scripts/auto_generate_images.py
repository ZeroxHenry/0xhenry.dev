import json
import os
import re

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX_FILE = os.path.join(BASE_DIR, "generated", "index.json")
POSTS_DIR = os.path.join(BASE_DIR, "generated", "posts")
PENDING_FILE = os.path.join(BASE_DIR, "generated", "pending_images.json")
PROCESS_SCRIPT = os.path.join(BASE_DIR, "scripts", "process_image.py")

# Premium enrichment tags (Minimalist 3D / Sleek Tech)
# Added "wide margins, subject centered" to protect content from watermark cropping
ENRICHMENT = ", minimalist 3d render, claymation style, soft studio lighting, pastel colors, high detail, isometric perspective, clean background, wide margins, subject centered, high resolution, octanerender, trending on behance"

def extract_prompts(post_id):
    post_md = os.path.join(POSTS_DIR, post_id, "post.md")
    if not os.path.exists(post_md):
        return []

    with open(post_md, encoding='utf-8') as f:
        content = f.read()

    # Pattern: **English:** ... or similar
    # The new niche posts might not have them, so we'll look for placeholders like [이미지 삽입 권장] 
    # and generate prompts based on the surrounding context if none are found.
    # Pattern: **English:** or **Prompt (English):**
    # Using a more robust regex to catch variants
    eng_prompts = re.findall(r"\*\*\s*(?:English|Prompt\s*\(English\))\s*:\*\*\s*(.+)", content)
    
    # Fallback to the older simple pattern if needed
    if not eng_prompts:
        eng_prompts = re.findall(r'\*\s+\*\*English:\*\*\s+(.+)', content)
        
    return eng_prompts[:3] # Max 3

def prepare_pending():
    # PROMPT_STYLE.json 로드
    style_file = os.path.join(BASE_DIR, "scripts", "PROMPT_STYLE.json")
    if os.path.exists(style_file):
        with open(style_file, encoding='utf-8') as f:
            style_template = json.load(f)
    else:
        style_template = {}

    with open(INDEX_FILE, encoding='utf-8') as f:
        data = json.load(f)
    
    pending_queue = []
    
    for post in data['posts']:
        if not post.get('images_ready', False) and post.get('status') != 'published':
            post_id = post['id']
            prompts = extract_prompts(post_id)
            
            if prompts:
                post_assets = []
                for i, p in enumerate(prompts):
                    # JSON-AI 구조로 래핑
                    asset = {
                        "role": f"image_{i+1}",
                        "original_prompt": p,
                        "style_metadata": {
                            "template": "image_generation",
                            "enrichment": style_template.get("enrichment_tags", []),
                            "constraints": ["wide margins", "subject centered"]
                        },
                        "final_prompt": f"{p}, {', '.join(style_template.get('enrichment_tags', []))}"
                    }
                    post_assets.append(asset)
                
                pending_queue.append({
                    "id": post_id,
                    "title": post.get("title"),
                    "assets": post_assets
                })
    
    with open(PENDING_FILE, 'w', encoding='utf-8') as f:
        json.dump(pending_queue, f, ensure_ascii=False, indent=2)
    
    print(f"✅ Pending image queue created: {len(pending_queue)} posts found.")
    return len(pending_queue)

if __name__ == "__main__":
    prepare_pending()
