#!/usr/bin/env python3
"""
p_reinforce_analyzer.py — Autonomous Root Cause & Policy Evolver
Reads Performance_Memory.json, finds Reward/Punish signals,
performs root cause analysis, and evolves Policy.md automatically.

Usage:
  python3 scripts/p_reinforce_analyzer.py             # Full analysis + policy update
  python3 scripts/p_reinforce_analyzer.py --dry-run   # Analysis only, no file changes
"""

import json
import os
import argparse
import re
from datetime import datetime
from collections import defaultdict

MEMORY_FILE  = os.path.expanduser("~/0xhenry.dev/vault/20_Meta/Performance_Memory.json")
MANUAL_LOG_FILE = os.path.expanduser("~/0xhenry.dev/vault/20_Meta/Reinforcement_Log.md")
INSIGHTS_FILE = os.path.expanduser("~/0xhenry.dev/vault/20_Meta/Reinforcement_Insights.md")
POLICY_FILE  = os.path.expanduser("~/0xhenry.dev/vault/20_Meta/Policy.md")

# ─── Thresholds ───────────────────────────────────────────────────────────────
REWARD_THRESHOLD   = 100   # views → Reward signal
PUNISH_THRESHOLD   = 20    # views → Punish signal
# ──────────────────────────────────────────────────────────────────────────────

def load_memory() -> dict:
    if not os.path.exists(MEMORY_FILE):
        print("⚠️  No Performance_Memory.json found. Run p_reinforce_collector.py first.")
        return {}
    with open(MEMORY_FILE, encoding="utf-8") as f:
        return json.load(f)

def classify_signal(views: int) -> str:
    if views >= REWARD_THRESHOLD:
        return "REWARD"
    elif views <= PUNISH_THRESHOLD:
        return "PUNISH"
    return "NEUTRAL"

def parse_manual_feedback() -> list[dict]:
    """Parse Reinforcement_Log.md for manual text feedbacks."""
    feedbacks = []
    if not os.path.exists(MANUAL_LOG_FILE):
        return feedbacks
    with open(MANUAL_LOG_FILE, encoding="utf-8") as f:
        content = f.read()
    
    # Match: - [Domain] Signal: Feedback text
    pattern = r"-\s*\[(.*?)\]\s*(Reward|Punish):\s*(.*)"
    matches = re.findall(pattern, content, re.IGNORECASE)
    
    for domain, signal, text in matches:
        feedbacks.append({
            "domain": domain.strip().title(),  # Research or Life
            "signal": signal.strip().upper(),  # REWARD or PUNISH
            "rule": text.strip(),
            "evidence": "수동 피드백 (Reinforcement_Log.md)"
        })
    return feedbacks

def analyze(memory: dict) -> dict:
    """Core root cause analysis engine."""
    posts = memory.get("posts", {})
    
    analysis = {
        "summary": {"total_posts": len(posts), "reward_count": 0, "punish_count": 0, "avg_views": 0},
        "patterns": {},
        "rewards": [],
        "punishes": []
    }
    
    if not posts:
        return analysis

    rewards = []
    punishes = []
    for post_id, data in posts.items():
        views  = data.get("views", 0)
        signal = classify_signal(views)
        data["signal"] = signal
        if signal == "REWARD":
            rewards.append(data)
        elif signal == "PUNISH":
            punishes.append(data)

    analysis["summary"]["reward_count"] = len(rewards)
    analysis["summary"]["punish_count"] = len(punishes)
    analysis["summary"]["avg_views"] = sum(d.get("views", 0) for d in posts.values()) / max(1, len(posts))

    # 1. Category performance
    cat_views = defaultdict(list)
    for post_id, data in posts.items():
        cat_views[data.get("category", "Unknown")].append(data.get("views", 0))
    analysis["patterns"]["category_avg"] = {cat: sum(v)/len(v) for cat, v in cat_views.items()}

    # 2. Image count correlation
    high_img_views = [d.get("views", 0) for d in posts.values() if d.get("image_count", 0) >= 3]
    low_img_views  = [d.get("views", 0) for d in posts.values() if d.get("image_count", 0) < 3]
    analysis["patterns"]["high_img_avg"] = sum(high_img_views) / max(1, len(high_img_views))
    analysis["patterns"]["low_img_avg"]  = sum(low_img_views)  / max(1, len(low_img_views))
    analysis["patterns"]["image_impact"] = analysis["patterns"]["high_img_avg"] - analysis["patterns"]["low_img_avg"]
    
    # 3. Content Length
    short_views = [d.get("views", 0) for d in posts.values() if d.get("char_count", 0) < 2000]
    long_views  = [d.get("views", 0) for d in posts.values() if d.get("char_count", 0) >= 2000]
    analysis["patterns"]["short_post_avg"] = sum(short_views) / max(1, len(short_views))
    analysis["patterns"]["long_post_avg"]  = sum(long_views)  / max(1, len(long_views))

    analysis["rewards"] = rewards[:5]
    analysis["punishes"] = punishes[:5]
    
    return analysis

def derive_rules(analysis: dict) -> list[dict]:
    """Convert analysis patterns into concrete behavioral rules and inject manual feedback."""
    rules = []
    p = analysis.get("patterns", {})

    if p:
        # Automated Rules for 'Life' (Blog Posts)
        if p.get("image_impact", 0) > 10:
            rules.append({"domain": "Life", "signal": "REWARD", "rule": "이미지 3장 이상 포함 시 평균 조회수 상승 → 모든 포스트에 이미지 3장 이상 필수", "evidence": f"평균 {p['high_img_avg']:.0f}회 vs {p['low_img_avg']:.0f}회"})
        elif p.get("image_impact", 0) < -10:
            rules.append({"domain": "Life", "signal": "PUNISH", "rule": "이미지 과다 포함이 오히려 이탈 유발 → 심플한 포맷 유지", "evidence": f"평균 {p['high_img_avg']:.0f}회 vs {p['low_img_avg']:.0f}회"})
            
        if p.get("long_post_avg", 0) > p.get("short_post_avg", 0):
            rules.append({"domain": "Life", "signal": "REWARD", "rule": "2000자 이상 장문 포스트가 더 높은 조회수 기록 → 깊이 있는 콘텐츠 유지", "evidence": f"장문 {p['long_post_avg']:.0f}회 vs 단문 {p['short_post_avg']:.0f}회"})
            
        cat_avg = p.get("category_avg", {})
        if cat_avg:
            best_cat = max(cat_avg, key=cat_avg.get)
            rules.append({"domain": "Life", "signal": "REWARD", "rule": f"'{best_cat}' 카테고리 반응 최고 → 해당 주제 우선 편성", "evidence": f"평균 {cat_avg[best_cat]:.0f}회"})

    # Parse and Inject Manual Rules from Log
    manual_rules = parse_manual_feedback()
    rules.extend(manual_rules)
    
    return rules

def generate_insights_md(analysis: dict, rules: list[dict], timestamp: str) -> str:
    """Generate the Reinforcement_Insights.md content."""
    s = analysis.get("summary", {})
    top_rewards  = analysis.get("rewards",  [])
    top_punishes = analysis.get("punishes", [])

    lines = [
        "---",
        "title: Reinforcement Insights",
        f"updated: {timestamp[:10]}",
        "tags: [p-reinforce, autonomous, reward, punish]",
        "---",
        "",
        "# 🧠 P-Reinforce: Behavioral Insights",
        "",
        "> AI 에이전트가 이 파일을 모든 작업 전에 읽고, 밑의 규칙을 반드시 준수해야 합니다.",
        "",
        "## 📊 현재 성과 요약",
        "",
        f"| 지표 | 값 |",
        f"|------|-----|",
        f"| 분석 포스트 수 | {s.get('total_posts', 0)}개 |",
        f"| 보상 기준 초과 | {s.get('reward_count', 0)}개 (>= {REWARD_THRESHOLD}회) |",
        f"| 처벌 기준 미달 | {s.get('punish_count', 0)}개 (<= {PUNISH_THRESHOLD}회) |",
        f"| 전체 평균 조회수 | {s.get('avg_views', 0):.0f}회 |",
        "",
        "---",
        "",
        "# 🔬 Research Rules (연구, 코딩, 논문 분석)",
        "",
        "> 사용자가 직접 입력한 '연구/코딩' 도메인의 피드백 룰셋입니다.",
        ""
    ]
    
    research_rewards = [r for r in rules if r["domain"] == "Research" and r["signal"] == "REWARD"]
    research_punishes = [r for r in rules if r["domain"] == "Research" and r["signal"] == "PUNISH"]

    lines.append("## ✅ Reward (강화할 행동)")
    if research_rewards:
        for i, r in enumerate(research_rewards, 1):
            lines.append(f"### R-RES{i}. {r['rule']}")
            lines.append(f"> 근거: {r['evidence']}\n")
    else:
        lines.append("*(아직 기록된 피드백 없음)*\n")

    lines.append("## ❌ Punish (배제할 행동)")
    if research_punishes:
        for i, r in enumerate(research_punishes, 1):
            lines.append(f"### P-RES{i}. {r['rule']}")
            lines.append(f"> 근거: {r['evidence']}\n")
    else:
        lines.append("*(아직 기록된 피드백 없음)*\n")

    lines += [
        "---",
        "",
        "# 📝 Life Rules (블로그, 자동화 콘텐츠)",
        "",
        "> 통계 데이터 기반으로 자율 추출되었거나 사용자가 입력한 콘텐츠 도메인 룰셋입니다.",
        ""
    ]

    life_rewards = [r for r in rules if r["domain"] == "Life" and r["signal"] == "REWARD"]
    life_punishes = [r for r in rules if r["domain"] == "Life" and r["signal"] == "PUNISH"]

    lines.append("## ✅ Reward (강화할 행동)")
    if life_rewards:
        for i, r in enumerate(life_rewards, 1):
            lines.append(f"### R-LIF{i}. {r['rule']}")
            lines.append(f"> 근거: {r['evidence']}\n")
    else:
        lines.append("*(아직 기록된 피드백 없음)*\n")

    lines.append("## ❌ Punish (배제할 행동)")
    if life_punishes:
        for i, r in enumerate(life_punishes, 1):
            lines.append(f"### P-LIF{i}. {r['rule']}")
            lines.append(f"> 근거: {r['evidence']}\n")
    else:
        lines.append("*(아직 기록된 피드백 없음)*\n")

    lines += [
        "---",
        "",
        "## 🏆 Top Performing Posts (Life)"
    ]
    for post in top_rewards:
        lines.append(f"- **{post.get('title', '')}** — {post.get('views', 0)}회")
    if not top_rewards:
        lines.append("\n*(아직 발행된 포스트 없음)*")

    lines += [
        "",
        "## ⚠️ Underperforming Posts (Life)"
    ]
    for post in top_punishes:
        lines.append(f"- **{post.get('title', '')}** — {post.get('views', 0)}회")
    if not top_punishes:
        lines.append("\n*(아직 발행된 포스트 없음)*")

    lines += ["\n---", f"*마지막 자동 분석: {timestamp}*"]
    return "\n".join(lines)

def update_policy(rules: list[dict], dry_run: bool):
    """Append newly derived rules to Policy.md."""
    if not rules or dry_run:
        return

    new_rules_block = "\n\n## P-Reinforce 자동 업데이트 규칙\n\n"
    new_rules_block += f"> 마지막 갱신: {datetime.now().strftime('%Y-%m-%d %H:%M')}\n\n"
    for r in rules:
        icon = "✅" if r["signal"] == "REWARD" else "❌"
        new_rules_block += f"- {icon} {r['rule']}\n"

    with open(POLICY_FILE, "a", encoding="utf-8") as f:
        f.write(new_rules_block)
    print("✅ Policy.md updated with new reinforcement rules.")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true", help="Analysis only, no file changes")
    args = parser.parse_args()

    print("🔍 P-Reinforce Analyzer starting...\n")
    memory   = load_memory()
    analysis = analyze(memory)
    rules    = derive_rules(analysis)
    ts       = datetime.now().isoformat()

    if not rules:
        print("⚠️  No rules derived. Add entries to Reinforcement_Log.md or publish posts first.")
        return

    # Write insights
    insights_md = generate_insights_md(analysis, rules, ts)
    if not args.dry_run:
        with open(INSIGHTS_FILE, "w", encoding="utf-8") as f:
            f.write(insights_md)
        print(f"✅ Insights written to {INSIGHTS_FILE}")
    else:
        print("\n--- DRY RUN OUTPUT ---")
        print(insights_md)

    # Print derived rules
    print(f"\n📋 Derived {len(rules)} behavioral rules:")
    for r in rules:
        icon = "✅" if r["signal"] == "REWARD" else "❌"
        domain = r.get("domain", "?")
        print(f"  {icon} [{domain}] {r['rule']}")

    update_policy(rules, args.dry_run)
    print("\n✨ P-Reinforce analysis complete.")

if __name__ == "__main__":
    main()
