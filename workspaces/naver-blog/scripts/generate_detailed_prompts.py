import os
import json
import time
import urllib.request
import re

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
POSTS_DIR = os.path.join(BASE_DIR, "generated", "posts")

OLLAMA_URL = "http://localhost:11434/v1/chat/completions"
MODEL_NAME = "gemma4:e4b"

def call_ollama_for_prompts(title, content):
    system_prompt = """
    You are an expert AI Image Prompt Engineer specializing in Midjourney, DALL-E, and Gemini Imagen.
    Your task is to read the title and content of a Korean blog post and generate exactly 3 exceptionally detailed, hyper-realistic image generation prompts in ENGLISH.
    
    Each prompt must vividly describe:
    1. Subject and Focus
    2. Setting and Environment
    3. Lighting, Mood, and Atmosphere (e.g., cinematic lighting, golden hour, volumetric light)
    4. Rendering context (e.g., photorealistic, 8k resolution, highly detailed)
    
    Output format:
    Simply provide the 3 English prompts, separated by double newlines. DO NOT include numbers, bullet points, or any markdown formatting. Do not include any Korean explanation or pleasantries.
    """
    
    truncated_content = content[:2000]
    user_prompt = f"Title: {title}\nContent Snippet: {truncated_content}\n\nGenerate the 3 prompts:"
    
    payload = {
        "model": MODEL_NAME,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ],
        "temperature": 0.8,
        "max_tokens": 1500
    }
    
    req = urllib.request.Request(OLLAMA_URL, data=json.dumps(payload).encode('utf-8'),
                                 headers={'Content-Type': 'application/json'})
    
    try:
        with urllib.request.urlopen(req, timeout=120) as response:
            result = json.loads(response.read().decode('utf-8'))
            return result['choices'][0]['message']['content'].strip()
    except Exception as e:
        print(f"Error calling Ollama API: {e}")
        return None

def main():
    if not os.path.exists(POSTS_DIR):
        print("Posts directory not found!")
        return

    folders = [f for f in os.listdir(POSTS_DIR) if os.path.isdir(os.path.join(POSTS_DIR, f))]
    print(f"총 {len(folders)}개 폴더에 대한 프롬프트 설계 연산을 시작합니다...")

    for idx, folder_name in enumerate(folders, 1):
        folder_path = os.path.join(POSTS_DIR, folder_name)
        post_path = os.path.join(folder_path, "post.md")
        prompts_path = os.path.join(folder_path, "prompts.md")
        
        # Skip if prompts already generated
        if os.path.exists(prompts_path):
            continue
            
        if not os.path.exists(post_path):
            continue

        with open(post_path, 'r', encoding='utf-8') as f:
            content = f.read()

        title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
        title = title_match.group(1) if title_match else folder_name

        print(f"[{idx}/{len(folders)}] 💡 프롬프트 설계 중: {title}")
        
        prompts = call_ollama_for_prompts(title, content)
        
        if prompts:
            with open(prompts_path, 'w', encoding='utf-8') as f:
                f.write(f"## 🎨 이미지 생성 프롬프트\n\n")
                prompt_lines = [p.strip() for p in prompts.split('\n') if len(p.strip()) > 10]
                for p_idx, prompt in enumerate(prompt_lines[:3], 1):
                    f.write(f"### 이미지 {p_idx}\n```text\n{prompt}\n```\n\n")
        else:
            print(f"❌ {title} 처리 실패.")
            
        time.sleep(2)

    print("✅ 프롬프트 생성 작업 완료!")

if __name__ == "__main__":
    main()
