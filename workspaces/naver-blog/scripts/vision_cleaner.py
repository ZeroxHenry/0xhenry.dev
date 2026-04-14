import os
import sys
from PIL import Image

def clean_image(input_path, output_path, crop_bottom_percent=0.12, crop_top_percent=0.0):
    """
    Crops the portion of an image to remove branding or watermarks.
    
    Args:
        input_path (str): Path to the source image.
        output_path (str): Path to save the cleaned image.
        crop_bottom_percent (float): Percentage to crop from bottom.
        crop_top_percent (float): Percentage to crop from top.
    """
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    try:
        with Image.open(input_path) as img:
            width, height = img.size
            top = int(height * crop_top_percent)
            bottom = int(height * (1 - crop_bottom_percent))
            
            # Crop box: (left, upper, right, lower)
            img_cleaned = img.crop((0, top, width, bottom))
            
            # Save the result
            img_format = img.format if img.format else 'PNG'
            img_cleaned.save(output_path, format=img_format, quality=95)
            print(f"✅ Cleaned image saved to: {output_path} (Top: {crop_top_percent}, Bottom: {crop_bottom_percent})")
            return True
    except Exception as e:
        print(f"❌ Error cleaning image {input_path}: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 vision_cleaner.py [input_path] [output_path] [bottom_pct] [top_pct]")
        sys.exit(1)
    
    inp = sys.argv[1]
    out = sys.argv[2]
    bpct = float(sys.argv[3]) if len(sys.argv) > 3 else 0.12
    tpct = float(sys.argv[4]) if len(sys.argv) > 4 else 0.0
    
    clean_image(inp, out, bpct, tpct)
