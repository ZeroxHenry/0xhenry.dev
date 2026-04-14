import os
import sys
import argparse
from PIL import Image

class VisionEnginePro:
    """
    Unified Image Processing Engine for 0xHenry's Blogging Pipeline.
    Handles watermark removal, smart cropping, and padding.
    """
    
    # Patterns for common AI watermarks (normalized to 1920x1080)
    GEMINI_BOTTOM_BAR_PX = 80
    NOTEBOOKLM_LOGO_REGION = (0.85, 0.85, 1.0, 1.0) # Bottom-right 15%
    
    def __init__(self, high_quality=True):
        self.quality = 95 if high_quality else 85

    def clean_watermark(self, img, mode='unified'):
        """
        Crops out known watermark regions.
        """
        width, height = img.size
        
        if mode == 'gemini':
            # Gemini typically has a bar at the bottom
            return img.crop((0, 0, width, height - self.GEMINI_BOTTOM_BAR_PX))
        
        elif mode == 'notebooklm':
            # NotebookLM has a logo at bottom right. 
            # Often safer to crop a small slice off bottom and right
            return img.crop((0, 0, int(width * 0.98), int(height * 0.96)))
            
        elif mode == 'unified' or mode == 'blog':
            # Standard 'blog' crop: Remove bottom 8% and right 2% to kill most watermarks
            new_width = int(width * 0.98)
            new_height = int(height * 0.92)
            return img.crop((0, 0, new_width, new_height))
            
        return img

    def add_padding(self, img, padding_px=40, color=(255, 255, 255)):
        """
        Adds a white margin around the cropped image for a premium look.
        """
        width, height = img.size
        new_width = width + (padding_px * 2)
        new_height = height + (padding_px * 2)
        
        new_img = Image.new("RGB", (new_width, new_height), color)
        new_img.paste(img, (padding_px, padding_px))
        return new_img

    def process_file(self, input_path, output_path, mode='blog', padding=40):
        try:
            with Image.open(input_path) as img:
                # 1. Convert to RGB to avoid issues with specialized formats
                if img.mode in ("RGBA", "P"):
                    img = img.convert("RGB")
                
                # 2. Crop Watermarks
                cleaned = self.clean_watermark(img, mode=mode)
                
                # 3. Add Padding
                final = self.add_padding(cleaned, padding_px=padding)
                
                # 4. Save
                os.makedirs(os.path.dirname(output_path), exist_ok=True)
                final.save(output_path, "JPEG", quality=self.quality, subsampling=0)
                print(f"✅ Success: {os.path.basename(output_path)} processed.")
                return True
        except Exception as e:
            print(f"❌ Error: {str(e)}")
            return False

def main():
    parser = argparse.ArgumentParser(description="Vision Engine Pro: Advanced Image Cleaner")
    parser.add_argument("input", help="Input file or directory")
    parser.add_argument("output", help="Output file or directory")
    parser.add_argument("--mode", default="blog", help="Cleaning mode: blog, gemini, notebooklm")
    parser.add_argument("--padding", type=int, default=40, help="Pixels of white padding to add")
    
    args = parser.parse_args()
    
    engine = VisionEnginePro()
    
    if os.path.isfile(args.input):
        engine.process_file(args.input, args.output, mode=args.mode, padding=args.padding)
    elif os.path.isdir(args.input):
        for f in os.listdir(args.input):
            if f.lower().endswith(('.png', '.jpg', '.jpeg', '.webp')):
                inp = os.path.join(args.input, f)
                # Save as jpg in the output dir
                out = os.path.join(args.output, os.path.splitext(f)[0] + ".jpg")
                engine.process_file(inp, out, mode=args.mode, padding=args.padding)

if __name__ == "__main__":
    main()
