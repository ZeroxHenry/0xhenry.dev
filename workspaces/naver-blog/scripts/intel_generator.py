#!/usr/bin/env python3
import os
import json
import datetime
import argparse
import re

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PROJECT_ROOT = os.path.dirname(BASE_DIR)
POLICY_FILE = os.path.join(PROJECT_ROOT, "vault/20_Meta/Policy.md")
DRAFTS_DIR = os.path.join(BASE_DIR, "generated", "posts")

# Guidelines from Policy.md
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

def clean_text(text):
    """Removes typical AI markdown symbols like ###, **, -, and list bullets."""
    # Remove Bold (**)
    text = text.replace("**", "")
    # Remove Markdown Headers (#, ##, ###, ####)
    text = re.sub(r'^#+\s*', '', text, flags=re.M)
    # Remove List Bullets (-, *, 1.)
    text = re.sub(r'^[ \t]*[-*]\s*', '• ', text, flags=re.M)
    text = re.sub(r'^[ \t]*\d+\.\s*', '', text, flags=re.M)
    # Remove generic separators
    text = re.sub(r'---+', '', text)
    return text.strip()

def generate_blog_content(topic_data):
    """
    Simulates content generation with human-like flow.
    """
    title = topic_data.get("title", "Untitled Post")
    source = topic_data.get("source", "Unknown")
    link = topic_data.get("link", "")
    
    # Human-centric narrative style
    body = f"""
{topic_data.get('description', '최근 공개된 AI 기술 소식입니다.')}

오늘 전해드릴 이야기는 {source}에서 발표한 소식인데요. 
단순히 기술이 좋아졌다는 수준을 넘어, 우리 실무 환경을 어떻게 바꿀 수 있을지 고민해볼 만한 내용입니다.

{title}에 관한 이번 소식은 특히 에이전틱 AI를 연구하는 제 입장에서도 상당히 흥미롭습니다.

(뉴스 상세 링크: {link})

![인포그래픽 컨셉](concept_placeholder.png)

0xHenry의 인사이트

이번 소식을 접하며 느낀 점은... (인사이트 생략) 
결국 기술은 도구일 뿐, 이를 어떻게 우리 워크플로우에 녹여내느냐가 관건이겠죠.
"""
    # Force clean-up
    body = clean_text(body)

    content = f"""---
title: {title}
category: AI 뉴스
tags: [AI, {source}, 테크]
---

{body}
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
    
    save_draft(candidate['title'], content)

if __name__ == "__main__":
    main()
