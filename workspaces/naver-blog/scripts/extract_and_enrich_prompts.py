import os
import re

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
GENERATED_DIR = os.path.join(BASE_DIR, "generated", "2026-04")
OUTPUT_FILE = os.path.join(BASE_DIR, "generated", "gemini_prompts_master.md")

def enrich_prompt(text):
    # Base enhancement words for Gemini / Imagen / Midjourney
    enhancements = ", ultra-detailed, photorealistic, 8k resolution, cinematic lighting, masterpiece, hyperrealistic, vibrant colors, trending on ArtStation"
    text = text.strip()
    if not text.endswith('.'):
        text += '.'
    return text + enhancements

def main():
    if not os.path.exists(GENERATED_DIR):
        print(f"Directory not found: {GENERATED_DIR}")
        return

    files = [f for f in os.listdir(GENERATED_DIR) if f.endswith(".md")]
    files.sort()

    master_content = []
    master_content.append("# 🎨 블로그 50편 통합 이미지 프롬프트 마스터본\n")
    master_content.append("> 이 파일은 50편의 네이버 블로그에 삽입될 이미지들의 프롬프트만을 모아둔 마스터 파일입니다.")
    master_content.append("> 각 프롬프트는 제미나이(Gemini) 또는 Midjourney가 최고 품질의 이미지를 생성할 수 있도록 **초고화질 파라미터 및 극사실주의 프롬프트**가 추가되어 강화되었습니다.\n")
    master_content.append("---\n")

    for filename in files:
        filepath = os.path.join(GENERATED_DIR, filename)
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Extract title
        title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
        title = title_match.group(1) if title_match else filename

        # Extract the English prompts
        # Usually prefixed by "*   **English:**" or "- **English:**"
        eng_prompts = re.findall(r'\*\s+\*\*English:\*\*\s+(.+)', content)
        
        # If the generated file used a different format
        if not eng_prompts:
            eng_prompts = re.findall(r'-\s+\*\*English:\*\*\s+(.+)', content)

        if eng_prompts:
            master_content.append(f"## 📝 {title}")
            for idx, prompt in enumerate(eng_prompts, 1):
                enriched = enrich_prompt(prompt)
                master_content.append(f"### 이미지 {idx}")
                master_content.append(f"```text\n{enriched}\n```\n")
            master_content.append("---\n")

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        f.write('\n'.join(master_content))
    
    print(f"✅ 총 {len(files)}개 파일의 프롬프트 추출 및 강화 완료!")
    print(f"✅ 저장 경로: {OUTPUT_FILE}")

if __name__ == "__main__":
    main()
