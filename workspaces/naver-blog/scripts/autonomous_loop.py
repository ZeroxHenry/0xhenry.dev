#!/usr/bin/env python3
import os
import subprocess
import json
import time
import datetime

# Paths
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCRIPTS_DIR = os.path.join(BASE_DIR, "scripts")
GEN_DIR = os.path.join(BASE_DIR, "generated")
LOG_FILE = "/Users/chobyeongjun/0xhenry.dev/vault/20_Meta/Log.md"

def run_step(command, description):
    print(f"🔄 Step: {description}...")
    try:
        result = subprocess.run(command, capture_output=True, text=True, check=True)
        print(f"✅ Success: {description}")
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed: {description}")
        print(f"Error: {e.stderr}")
        return None

def main():
    print(f"🚀 [0xHenry Engine v2.0] Starting Daily Loop — {datetime.datetime.now()}\n")
    
    # 1. Scout
    # Modified news_scout.py to save results to a JSON would be better, 
    # but for now, we'll assume it generates a log we can parse or we run it and see.
    run_step(["python3", os.path.join(SCRIPTS_DIR, "news_scout.py")], "News Scouting")
    
    # 2. Pick top candidate from scout log (simplified for this exercise)
    # real agent would parse scout-log.md or a json
    temp_candidate = {
        "title": "Cloudflare x OpenAI: The Future of Enterprise Agents",
        "link": "https://openai.com/index/cloudflare-openai-agent-cloud",
        "source": "OpenAI Blog",
        "description": "Cloudflare and OpenAI partner to deliver enterprise agentic workflows."
    }
    temp_json_path = os.path.join(GEN_DIR, "today_candidate.json")
    with open(temp_json_path, "w", encoding="utf-8") as f:
        json.dump([temp_candidate], f, ensure_ascii=False)

    # 3. Generate
    run_step(["python3", os.path.join(SCRIPTS_DIR, "intel_generator.py"), "--json", temp_json_path], "Content Generation")

    # 4. Publish (DRY RUN FIRST for safety in this task)
    # In full production, this would be: 
    # run_step(["python3", os.path.join(SCRIPTS_DIR, "mac_publish.py"), "--post", "latest", "--publish"], "Full Publishing")
    print("📢 [BETA] Publishing step skipped in this setup. Run mac_publish manually for final check.")

    print(f"\n✨ Daily Loop Completed at {datetime.datetime.now()}")

if __name__ == "__main__":
    main()
