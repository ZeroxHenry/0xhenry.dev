import os
import re

# Configuration
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
POSTS_DIR = os.path.join(REPO_ROOT, 'workspaces/naver-blog/generated/posts')
STATIC_IMG_DIR = os.path.join(REPO_ROOT, 'packages/website/public/images')
GENERATED_IMG_DIR = os.path.join(REPO_ROOT, 'workspaces/naver-blog/generated/images')

def normalize_paths():
    print(f"Starting path normalization for posts in: {POSTS_DIR}")
    
    post_folders = [f for f in os.listdir(POSTS_DIR) if os.path.isdir(os.path.join(POSTS_DIR, f))]
    fixed_count = 0
    
    for folder in post_folders:
        post_path = os.path.join(POSTS_DIR, folder, 'post.md')
        if not os.path.exists(post_path):
            continue
            
        with open(post_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Regex to find markdown images: ![alt](path)
        # We need to handle:
        # 1. /images/study/... (Website absolute)
        # 2. ../../images/... (Relative)
        # 3. images/2026-04/... (Relative generated)
        
        def path_replacer(match):
            alt = match.group(1)
            old_path = match.group(2).strip()
            
            # Case 1: Static website images
            if old_path.startswith('/images/study/') or 'study/' in old_path:
                # Map to absolute local path of the static asset
                # Note: For Naver uploader, absolute local path is best
                clean_path = old_path.replace('/images/study/', 'study/')
                # If it still has ../../ etc, clean it
                clean_path = re.sub(r'^(\.\./)+images/', '', clean_path)
                
                new_abs_path = os.path.join(STATIC_IMG_DIR, clean_path.lstrip('/'))
                return f"![{alt}]({new_abs_path})"
            
            # Case 2: Generated AI images (images/2026-04/...)
            if 'images/2026-' in old_path or old_path.startswith('images/'):
                clean_path = re.sub(r'^(\.\./)+images/', 'images/', old_path)
                # Ensure it points to the generated folder
                new_abs_path = os.path.join(REPO_ROOT, 'workspaces/naver-blog/generated', clean_path.lstrip('/'))
                return f"![{alt}]({new_abs_path})"
                
            return match.group(0) # Keep as is if unknown

        new_content = re.sub(r'!\[(.*?)\]\((.*?)\)', path_replacer, content)
        
        if new_content != content:
            with open(post_path, 'w', encoding='utf-8') as f:
                f.write(new_content)
            fixed_count += 1

    print(f"✅ Success: Updated image paths in {fixed_count} posts.")

if __name__ == "__main__":
    normalize_paths()
