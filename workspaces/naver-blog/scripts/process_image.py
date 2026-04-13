import os
from PIL import Image

def remove_watermark(image_path, output_path=None):
    """우측 하단 워터마크(별 모양)를 정밀 크롭하여 제거"""
    if not os.path.exists(image_path):
        print(f"Error: Image not found {image_path}")
        return False

    try:
        img = Image.open(image_path)
        width, height = img.size

        # 하단 2.5%, 우측 2.5% 정도를 잘라냄 (가장 깔끔한 방식)
        # 워터마크가 보통 구석에 아주 작게 박히므로 이 정도면 충분
        crop_bottom = int(height * 0.025)
        crop_right = int(width * 0.025)

        new_width = width - crop_right
        new_height = height - crop_bottom

        # 좌측 상단 (0,0) 부터 (new_width, new_height) 까지 크롭
        cropped_img = img.crop((0, 0, new_width, new_height))
        
        if not output_path:
            output_path = image_path # Overwrite
            
        cropped_img.save(output_path, quality=95)
        print(f"✅ Watermark removed (cropped): {os.path.basename(image_path)}")
        return True
    except Exception as e:
        print(f"❌ Error processing {image_path}: {e}")
        return False

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        remove_watermark(sys.argv[1])
    else:
        print("Usage: python3 scripts/process_image.py <image_path>")
