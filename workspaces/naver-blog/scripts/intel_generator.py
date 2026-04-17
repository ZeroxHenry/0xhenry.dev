#!/usr/bin/env python3
import os
import json
import datetime
import argparse

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROJECT_ROOT = os.path.dirname(BASE_DIR)
POLICY_FILE = os.path.join(PROJECT_ROOT, "vault/20_Meta/Policy.md")
DRAFTS_DIR = os.path.join(BASE_DIR, "generated", "posts")

# Guidelines from Policy.md (Simplified for script)
FORBIDDEN_PHRASES = [
    "결론적으로 말씀드리자면",
    "더 궁금하신 점이 있다면",
    "살펴보았습니다",
    "알아보았습니다"
]

def check_quality(content):
    """Checks if the content violates any rules."""
    violations = []
    for phrase in FORBIDDEN_PHRASES:
        if phrase in content:
            violations.append(f"Forbidden phrase found: {phrase}")
    return violations

def generate_blog_content(topic_data):
    """
    Simulates content generation based on topic data.
    In real usage, this would call an LLM with NotebookLM context.
    """
    title = topic_data.get("title", "Untitled Post")
    source = topic_data.get("source", "Unknown")
    link = topic_data.get("link", "")
    
    # Placeholder for LLM generation logic
    content = f"""---
title: {title}
category: AI 뉴스
tags: [AI, {source}, 테크]
---

# {title}

{topic_data.get('description', '최근 공개된 AI 기술 소식입니다.')}

## 🚀 주요 내용 분석
- 출처: {source}
- 상세 링크: {link}

이 뉴스가 중요한 이유는 단순히 기술적 진보를 넘어, 우리 업무 워크플로우를 근본적으로 바꿀 수 있기 때문입니다. 특히 에이전틱 AI 관점에서 볼 때... (후략)

![인포그래픽 컨셉](concept_placeholder.png)

## 0xHenry의 인사이더 뷰
이번 소식은 작년에 공개된... (인사이트 생략)
"""
    return content

def save_draft(title, content):
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d")
    safe_title = "".join(x for x in title if x.isalnum() or x in " -_").strip()
    folder_name = f"{timestamp}-{safe_title.replace(' ', '-').lower()}"
    target_dir = os.path.join(DRAFTS_DIR, folder_name)
    os.makedirs(target_dir, exist_ok=True)
    
    with open(os.path.join(target_dir, "post.md"), "w", encoding="utf-8") as f:
        f.write(content)
    
    print(f"✅ Draft saved to: {target_dir}")
    return os.path.join(target_dir, "post.md")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--json", required=True, help="Path to news scout JSON candidate")
    args = parser.parse_args()
    
    if not os.path.exists(args.json):
        print(f"❌ File not found: {args.json}")
        return

    with open(args.json, "r", encoding="utf-8") as f:
        news_data = json.load(f)
    
    # Pick the top candidate
    if isinstance(news_data, list) and len(news_data) > 0:
        candidate = news_data[0]
    else:
        print("❌ No valid candidates found in JSON.")
        return

    print(f"🧠 Generating content for: {candidate['title']}...")
    content = generate_blog_content(candidate)
    
    violations = check_quality(content)
    if violations:
        print("⚠️  Quality check failed:")
        for v in violations:
            print(f"  - {v}")
        # In a real agent, we would re-generate here.
    
    save_draft(candidate['title'], content)

if __name__ == "__main__":
    main()
