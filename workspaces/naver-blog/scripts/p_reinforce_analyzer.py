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
from datetime import datetime
from collections import defaultdict

MEMORY_FILE  = os.path.expanduser("~/0xhenry.dev/vault/20_Meta/Performance_Memory.json")
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

def analyze(memory: dict) -> dict:
    """Core root cause analysis engine."""
    posts = memory.get("posts", {})
    if not posts:
        print("No post data available. Skipping analysis.")
        return {}

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

    # ─── Pattern extraction ────────────────────────────────────────────────────

    # 1. Category performance
    cat_views = defaultdict(list)
    for post_id, data in posts.items():
        cat_views[data.get("category", "Unknown")].append(data.get("views", 0))
    cat_avg = {cat: sum(v)/len(v) for cat, v in cat_views.items()}

    # 2. Image count correlation
    high_img_views = [d.get("views", 0) for d in posts.values() if d.get("image_count", 0) >= 3]
    low_img_views  = [d.get("views", 0) for d in posts.values() if d.get("image_count", 0) < 3]
    avg_high = sum(high_img_views) / max(1, len(high_img_views))
    avg_low  = sum(low_img_views)  / max(1, len(low_img_views))
    image_impact = avg_high - avg_low

    # 3. Tag density correlation
    high_tag_views = [d.get("views", 0) for d in posts.values() if len(d.get("tags", [])) >= 5]
    low_tag_views  = [d.get("views", 0) for d in posts.values() if len(d.get("tags", [])) < 5]
    avg_htag = sum(high_tag_views) / max(1, len(high_tag_views))
    avg_ltag = sum(low_tag_views)  / max(1, len(low_tag_views))

    # 4. Character count correlation
    short_views = [d.get("views", 0) for d in posts.values() if d.get("char_count", 0) < 2000]
    long_views  = [d.get("views", 0) for d in posts.values() if d.get("char_count", 0) >= 2000]
    avg_short = sum(short_views) / max(1, len(short_views))
    avg_long  = sum(long_views)  / max(1, len(long_views))

    return {
        "summary": {
            "total_posts":    len(posts),
            "reward_count":   len(rewards),
            "punish_count":   len(punishes),
            "avg_views":      sum(d.get("views", 0) for d in posts.values()) / max(1, len(posts))
        },
        "patterns": {
            "category_avg":   cat_avg,
            "image_impact":   image_impact,
            "high_img_avg":   avg_high,
            "low_img_avg":    avg_low,
            "high_tag_avg":   avg_htag,
            "low_tag_avg":    avg_ltag,
            "long_post_avg":  avg_long,
            "short_post_avg": avg_short
        },
        "rewards":   rewards[:5],
        "punishes":  punishes[:5]
    }

def derive_rules(analysis: dict) -> list[dict]:
    """Convert analysis patterns into concrete behavioral rules."""
    rules = []
    p = analysis.get("patterns", {})

    # Rule: Image count
    if p.get("image_impact", 0) > 10:
        rules.append({
            "signal": "REWARD",
            "rule": "이미지 3장 이상 포함 시 평균 조회수 높음 → 모든 포스트에 이미지 3장 이상 필수",
            "evidence": f"이미지 3장+ 평균 {p['high_img_avg']:.0f}회 vs 미포함 {p['low_img_avg']:.0f}회"
        })
    elif p.get("image_impact", 0) < -10:
        rules.append({
            "signal": "PUNISH",
            "rule": "이미지 과다 포함이 오히려 이탈률 상승 유발 → 이미지는 핵심 2~3장으로 제한",
            "evidence": f"이미지 3장+ 평균 {p['high_img_avg']:.0f}회 vs 미포함 {p['low_img_avg']:.0f}회"
        })

    # Rule: Content length
    if p.get("long_post_avg", 0) > p.get("short_post_avg", 0):
        rules.append({
            "signal": "REWARD",
            "rule": "2000자 이상 글이 더 높은 조회수를 기록 → 깊이 있는 콘텐츠 우선 작성",
            "evidence": f"장문 {p['long_post_avg']:.0f}회 vs 단문 {p['short_post_avg']:.0f}회"
        })
    else:
        rules.append({
            "signal": "PUNISH",
            "rule": "과도하게 긴 글이 이탈 유발 → 핵심만 담은 1500~2500자 최적 분량 준수",
            "evidence": f"장문 {p['long_post_avg']:.0f}회 vs 단문 {p['short_post_avg']:.0f}회"
        })

    # Rule: Tag density
    if p.get("high_tag_avg", 0) > p.get("low_tag_avg", 0) * 1.2:
        rules.append({
            "signal": "REWARD",
            "rule": "태그 5개 이상 사용이 유입 증가에 기여 → 모든 글에 5~8개 태그 필수",
            "evidence": f"태그 5+ 평균 {p['high_tag_avg']:.0f}회 vs 태그 5미만 {p['low_tag_avg']:.0f}회"
        })

    # Rule: Best performing category
    cat_avg = p.get("category_avg", {})
    if cat_avg:
        best_cat = max(cat_avg, key=cat_avg.get)
        rules.append({
            "signal": "REWARD",
            "rule": f"'{best_cat}' 카테고리 포스트가 최고 평균 조회수 기록 → 해당 주제 우선 배치",
            "evidence": f"평균 {cat_avg[best_cat]:.0f}회"
        })

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
        "## ✅ Reward Rules (반드시 따를 것)",
        ""
    ]

    reward_rules = [r for r in rules if r["signal"] == "REWARD"]
    if reward_rules:
        for i, r in enumerate(reward_rules, 1):
            lines.append(f"### R{i}. {r['rule']}")
            lines.append(f"> 근거: {r['evidence']}")
            lines.append("")
    else:
        lines.append("*(아직 데이터 없음 — 더 많은 포스트가 발행되면 자동 업데이트)*")
        lines.append("")

    lines += [
        "---",
        "",
        "## ❌ Punish Rules (절대 하지 말 것)",
        ""
    ]

    punish_rules = [r for r in rules if r["signal"] == "PUNISH"]
    if punish_rules:
        for i, r in enumerate(punish_rules, 1):
            lines.append(f"### P{i}. {r['rule']}")
            lines.append(f"> 근거: {r['evidence']}")
            lines.append("")
    else:
        lines.append("*(아직 데이터 없음)*")
        lines.append("")

    lines += [
        "---",
        "",
        "## 🏆 Top Performing Posts",
        ""
    ]
    for post in top_rewards:
        lines.append(f"- **{post.get('title', '')}** — {post.get('views', 0)}회")
    if not top_rewards:
        lines.append("*(아직 발행된 포스트 없음)*")

    lines += [
        "",
        "## ⚠️ Underperforming Posts",
        ""
    ]
    for post in top_punishes:
        lines.append(f"- **{post.get('title', '')}** — {post.get('views', 0)}회")
    if not top_punishes:
        lines.append("*(아직 발행된 포스트 없음)*")

    lines += ["", f"---", f"*마지막 자동 분석: {timestamp}*", ""]
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
    if not memory or not memory.get("posts"):
        print("No data to analyze. Run p_reinforce_collector.py first.")
        return

    analysis = analyze(memory)
    rules    = derive_rules(analysis)
    ts       = datetime.now().isoformat()

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
        print(f"  {icon} {r['rule']}")

    update_policy(rules, args.dry_run)
    print("\n✨ P-Reinforce analysis complete.")

if __name__ == "__main__":
    main()
