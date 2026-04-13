import json
import os
from datetime import datetime, timedelta
import random

# Configuration
REPO_ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
INDEX_FILE = os.path.join(REPO_ROOT, 'workspaces/naver-blog/generated/index.json')

POSTS_PER_DAY = 3  # Recommended: 1~3 for safety
START_DATE = datetime.now() + timedelta(days=1)  # Start from tomorrow

# Human-like times
PUBLISH_TIMES = [
    (8, 30),   # Breakfast
    (13, 15),  # Lunch
    (20, 45)   # Dinner
]

def schedule_posts():
    if not os.path.exists(INDEX_FILE):
        print(f"Error: {INDEX_FILE} not found.")
        return

    with open(INDEX_FILE, 'r', encoding='utf-8') as f:
        data = json.load(f)

    posts = data.get('posts', [])
    # Sort posts by ID (usually YYYY-MM-DD-slug) to keep thematic order
    posts.sort(key=lambda x: x['id'])

    current_date = START_DATE
    scheduled_count = 0

    for i, post in enumerate(posts):
        # Determine slot for the day
        slot_idx = i % POSTS_PER_DAY
        if i > 0 and slot_idx == 0:
            current_date += timedelta(days=1)

        hour, minute = PUBLISH_TIMES[slot_idx % len(PUBLISH_TIMES)]
        
        # Add slight randomization (±15 mins)
        random_minute = minute + random.randint(-15, 15)
        if random_minute < 0: random_minute = 0
        if random_minute > 59: random_minute = 59
        
        scheduled_time = current_date.replace(hour=hour, minute=random_minute, second=0, microsecond=0)
        
        post['scheduled_at'] = scheduled_time.strftime('%Y-%m-%dT%H:%M:%S+09:00')
        scheduled_count += 1

    with open(INDEX_FILE, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

    print(f"✅ Successfully scheduled {scheduled_count} posts.")
    print(f"📅 Start Date: {START_DATE.strftime('%Y-%m-%d')}")
    print(f"🏁 End Date: {(START_DATE + timedelta(days=scheduled_count//POSTS_PER_DAY)).strftime('%Y-%m-%d')}")

if __name__ == "__main__":
    schedule_posts()
