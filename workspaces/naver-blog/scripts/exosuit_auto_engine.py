import os
import json
import datetime
import shutil
from vision_cleaner import clean_image

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX_FILE = os.path.join(BASE_DIR, "generated", "index.json")
VAULT_DRAFTS_DIR = "/Users/chobyeongjun/0xhenry.dev/vault/Life/00_Raw/naver-blog/"
GENERATED_DIR = os.path.join(BASE_DIR, "generated")

def load_index():
    if os.path.exists(INDEX_FILE):
        with open(INDEX_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {"posts": []}

def save_index(index_data):
    with open(INDEX_FILE, "w", encoding="utf-8") as f:
        json.dump(index_data, f, indent=4, ensure_ascii=False)

def pick_next_draft():
    """Picks a draft from the vault that hasn't been processed yet."""
    drafts = [f for f in os.listdir(VAULT_DRAFTS_DIR) if f.endswith(".md")]
    if not drafts:
        return None
    
    index = load_index()
    processed_titles = {p["title"] for p in index["posts"]}
    
    for draft in drafts:
        title = draft.replace(".md", "")
        if title not in processed_titles:
            return os.path.join(VAULT_DRAFTS_DIR, draft)
    return None

def process_and_queue_draft(draft_path):
    """Reads a vault draft and prepares it for the generated queue."""
    title = os.path.basename(draft_path).replace(".md", "")
    with open(draft_path, "r", encoding="utf-8") as f:
        content = f.read()
    
    # Metadata for the engine
    post_id = datetime.datetime.now().strftime("%Y%m%d%H%M%S")
    post_dir = os.path.join(GENERATED_DIR, post_id)
    os.makedirs(post_dir, exist_ok=True)
    
    # Save content
    with open(os.path.join(post_dir, "content.md"), "w", encoding="utf-8") as f:
        f.write(content)
        
    print(f"✅ Draft '{title}' processed into {post_dir}")
    return post_id

if __name__ == "__main__":
    next_draft = pick_next_draft()
    if next_draft:
        process_and_queue_draft(next_draft)
    else:
        print("📭 No new drafts found in the vault.")
