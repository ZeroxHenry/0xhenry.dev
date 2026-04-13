import os
import sys
from PIL import Image

def crop_and_save(input_path, output_rel_path):
    # Path Configuration (Repo Root)
    base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    output_abs_path = os.path.join(base_dir, 'workspaces/naver-blog/generated', output_rel_path)
    
    os.makedirs(os.path.dirname(output_abs_path), exist_ok=True)

    try:
        with Image.open(input_path) as img:
            width, height = img.size
            # Crop bottom 60px (Gemini watermark)
            img_cropped = img.crop((0, 0, width, height - 60))
            img_cropped.save(output_abs_path, "PNG")
            print(f"Successfully saved to {output_rel_path}")
            # Optional: remove source
            # os.remove(input_path)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 crop_tool.py [input_path] [target_rel_path]")
    else:
        crop_and_save(sys.argv[1], sys.argv[2])
