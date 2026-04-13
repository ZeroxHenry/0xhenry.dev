import os
import json
import shutil
from PIL import Image

# Path Configuration
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BRIDGE_DIR = os.path.join(BASE_DIR, 'workspaces/naver-blog/image_bridge')
INPUT_DIR = os.path.join(BRIDGE_DIR, 'input')
TASKS_FILE = os.path.join(BRIDGE_DIR, 'tasks.json')
POSTS_DIR = os.path.join(BASE_DIR, 'workspaces/naver-blog/generated')

def process_images():
    if not os.path.exists(TASKS_FILE):
        print("tasks.json not found.")
        return

    with open(TASKS_FILE, 'r') as f:
        data = json.load(f)
        queue = data.get('queue', [])

    # Get pending tasks
    pending_tasks = [t for t in queue if t['status'] == 'pending']
    if not pending_tasks:
        print("No pending tasks in queue.")
        return

    # Scan input directory for images
    input_files = sorted([f for f in os.listdir(INPUT_DIR) if f.lower().endswith(('.png', '.jpg', '.jpeg', '.webp'))])
    
    if not input_files:
        print(f"No image files found in {INPUT_DIR}.")
        return

    processed_count = 0
    for i, file_name in enumerate(input_files):
        if i >= len(pending_tasks):
            break
        
        task = pending_tasks[i]
        input_path = os.path.join(INPUT_DIR, file_name)
        
        # Determine target path
        # Note: tasks.json target_path is relative to workspace root (e.g. images/2026-04/...)
        target_rel_path = task['target_path']
        target_abs_path = os.path.join(BASE_DIR, 'workspaces/naver-blog/generated', target_rel_path)
        
        # Ensure target directory exists
        os.makedirs(os.path.dirname(target_abs_path), exist_ok=True)

        try:
            # Process Image (Crop Watermark)
            with Image.open(input_path) as img:
                width, height = img.size
                # Typical Gemini watermark is in the bottom right corner, let's crop bottom 60px
                # Adjusting to 16:9 if possible or just safe crop
                crop_height = height - 60 
                img_cropped = img.crop((0, 0, width, crop_height))
                
                # Save as PNG (high quality)
                img_cropped.save(target_abs_path, "PNG")
                print(f"Processed: {file_name} -> {target_rel_path}")

            # Update status in original data
            for t in queue:
                if t['target_path'] == task['target_path']:
                    t['status'] = 'completed'
            
            # Clean up input
            os.remove(input_path)
            processed_count += 1

        except Exception as e:
            print(f"Error processing {file_name}: {e}")

    # Write back updated tasks
    with open(TASKS_FILE, 'w') as f:
        json.dump({'queue': queue}, f, indent=2, ensure_ascii=False)

    print(f"\nSuccessfully processed {processed_count} images.")

if __name__ == "__main__":
    try:
        process_images()
    except ImportError:
        print("Pillow (PIL) not found. Please install it: python3 -m pip install Pillow")
