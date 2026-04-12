import os
import re
import json
import time
import urllib.request
import urllib.error
from datetime import datetime

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BACKLOG_PATH = os.path.join(BASE_DIR, "research", "topic-backlog.md")
INDEX_PATH = os.path.join(BASE_DIR, "generated", "index.json")
POSTS_DIR = os.path.join(BASE_DIR, "generated", "posts")

os.makedirs(POSTS_DIR, exist_ok=True)

# URL and Payload settings
OLLAMA_URL = "http://localhost:11434/v1/chat/completions"
MODEL_NAME = "gemma4:e4b"

def load_backlog():
    with open(BACKLOG_PATH, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract topics
    lines = content.split('\n')
    topics = []
    for line in lines:
        if line.strip().startswith("- [ ] "):
            topic = line.replace("- [ ] ", "").strip()
            topics.append(topic)
    return lines, topics

def update_backlog(lines, topic, date_str):
    new_lines = []
    for line in lines:
        if line.strip().startswith(f"- [ ] {topic}"):
            new_lines.append(line.replace("[ ]", "[x]") + f" — {date_str} 생성")
        else:
            new_lines.append(line)
    
    with open(BACKLOG_PATH, 'w', encoding='utf-8') as f:
        f.write('\n'.join(new_lines))
    return new_lines

def load_index():
    if os.path.exists(INDEX_PATH):
        with open(INDEX_PATH, 'r', encoding='utf-8') as f:
            return json.load(f)
    return {"stats": {"total_generated": 0}, "posts": []}

def save_index(data):
    with open(INDEX_PATH, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

def generate_slug(topic):
    # Keep alphanumeric and korean, replace spaces with hyphens
    slug = re.sub(r'[^가-힣A-Za-z0-9\s-]', '', topic).strip().replace(' ', '-').lower()
    return slug[:30]

def call_ollama(topic):
    system_prompt = """
    너는 네이버 블로그 "AI 데일리" (blog.naver.com/0xhenry)의 콘텐츠 편집장이야.
    필명 '0xHenry'로서 비전공자도 이해할 수 있는 쉽고 친절한 AI 정보 글을 작성해야 해.
    
    주어진 주제에 대해 1500~2000자 분량의 네이버 블로그 포스트를 마크다운 형식으로 작성해.
    
    [블로그 작성 규칙]
    - H2(##), H3(###) 소제목을 활용하여 가독성을 높일 것
    - 문장 끝을 섞을 것 (~어요, ~습니다, ~거든요, ~네요)
    - "솔직히 이건 좀 놀랐어요", "써보니까 괜찮더라고요" 같은 개인 반응 1~2문장 포함
    - '결론적으로', '종합하면', '요약하자면', '다양한', '주목할 만한' 등 전형적인 AI 문구 절대 사용 금지
    - 마무리에는 독자의 참여를 유도하는 구체적인 질문 추가
    
    [이미지 및 Gemini 프롬프트 규칙]
    - 본문 작성 중 이미지가 들어가면 좋을 위치에 안내 표기 작성.
    - 글의 가장 마지막에 "## 🎨 이미지 생성 가이드 (Gemini용 프롬프트)" 세션을 추가할 것.
    - 블로그에 첨부할 만한 핵심 이미지 2-3장을 위한 구체적이고 디테일한 이미지 생성 프롬프트(영문 및 국문)를 제안할 것.
    """
    
    user_prompt = f"다음 주제로 네이버 블로그 글을 작성해 줘: {topic}"
    
    payload = {
        "model": MODEL_NAME,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ],
        "temperature": 0.7,
        "max_tokens": 4096
    }
    
    req = urllib.request.Request(OLLAMA_URL, data=json.dumps(payload).encode('utf-8'),
                                 headers={'Content-Type': 'application/json'})
    
    try:
        with urllib.request.urlopen(req, timeout=300) as response:
            result = json.loads(response.read().decode('utf-8'))
            return result['choices'][0]['message']['content']
    except Exception as e:
        print(f"Error calling Ollama API: {e}")
        return None

def main():
    print("🚀 네이버 블로그 자동 생성기 (Folder Structure Ver.) 시작...")
    
    lines, topics = load_backlog()
    print(f"발견된 미완료 주제: {len(topics)}개. 생성 시작.")
    
    topics_to_generate = topics[:50]
    index_data = load_index()
    
    for idx, topic in enumerate(topics_to_generate, 1):
        print(f"[{idx}/{len(topics_to_generate)}] ✍️ 주제 생성 중: {topic}")
        
        content = call_ollama(topic)
        if not content:
            print(f"❌ '{topic}' 생성 실패. 10초 후 재시도.")
            time.sleep(10)
            continue
            
        date_str = datetime.now().strftime("%Y-%m-%d")
        iso_time = datetime.now().strftime("%Y-%m-%dT%H:%M:%S+09:00")
        slug = f"{date_str}-{generate_slug(topic)}"
        
        # New folder structure
        folder_path = os.path.join(POSTS_DIR, slug)
        os.makedirs(folder_path, exist_ok=True)
        filepath = os.path.join(folder_path, "post.md")
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
            
        lines = update_backlog(lines, topic, date_str)
        
        index_data['posts'].append({
            "id": slug,
            "title": topic,
            "category": "AI/Tech",
            "status": "draft",
            "generated_at": iso_time,
            "published_at": None,
            "naver_url": None,
            "tags": ["AI", "인공지능", "트렌드", "꿀팁"],
            "folder": f"generated/posts/{slug}"
        })
        index_data['stats']['total_generated'] = len(index_data['posts'])
        save_index(index_data)
        
        print(f"✅ '{topic}' 저장 완료 ({folder_path}/post.md)")
        time.sleep(5)

    print("🎉 생성 프로세스 완료!")

if __name__ == "__main__":
    main()
