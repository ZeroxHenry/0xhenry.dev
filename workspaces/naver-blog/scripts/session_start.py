#!/usr/bin/env python3
"""
session_start.py — Context Router for Antigravity Sessions
Detects topic from user's first message and prints relevant Obsidian notes to load.

Usage:
  python3 scripts/session_start.py --topic "ROS2 impedance control"
  python3 scripts/session_start.py --topic "naver blog automation"
  python3 scripts/session_start.py --topic "p-reinforce vault lint"
"""

import os
import re
import sys
import argparse
from pathlib import Path

VAULT_ROOT = Path.home() / "0xhenry.dev" / "vault"
META_DIR   = VAULT_ROOT / "20_Meta"

# ─── Topic → Vault File Routing Map ─────────────────────────────────────────
# Each entry: (keywords, [vault paths to load])
TOPIC_ROUTES = {
    # Research: H-Walker / Exosuit
    "exosuit": [
        "Research/10_Wiki/h-walker.md",
        "Research/10_Wiki/exosuit-hardware-overview.md",
        "Research/10_Wiki/exosuit-safety.md",
        "Research/10_Wiki/cable-driven-mechanism.md",
    ],
    "h-walker": [
        "Research/10_Wiki/h-walker.md",
        "Research/10_Wiki/ak60-motor.md",
        "Research/10_Wiki/can-communication.md",
    ],
    "ros2": [
        "Research/10_Wiki/h-walker.md",
        "Research/10_Wiki/jetson-orin-nx.md",
        "Research/10_Wiki/zed-x-mini.md",
    ],
    "impedance": [
        "Research/10_Wiki/admittance-control.md",
        "Research/10_Wiki/h-walker.md",
        "Research/10_Wiki/ak60-motor.md",
    ],
    "stm32": [
        "Research/10_Wiki/h-walker.md",
        "Research/10_Wiki/can-communication.md",
    ],
    "motor": [
        "Research/10_Wiki/ak60-motor.md",
        "Research/10_Wiki/motor-benchmark.md",
        "Research/10_Wiki/elmo-driver-comparison.md",
    ],
    "jetson": [
        "Research/10_Wiki/jetson-orin-nx.md",
        "Research/10_Wiki/zed-x-mini.md",
    ],
    "gait": [
        "Research/10_Wiki/gait-analysis.md",
        "Research/10_Wiki/h-walker.md",
        "Research/10_Wiki/admittance-control.md",
    ],

    # Life: Blog / Content
    "naver": [
        "20_Meta/naver-blog-dashboard.md",
        "20_Meta/Reinforcement_Insights.md",
        "Life/10_Wiki/naver-blog-published-index.md",
    ],
    "blog": [
        "20_Meta/naver-blog-dashboard.md",
        "20_Meta/Reinforcement_Insights.md",
        "Life/10_Wiki/youtube-strategy.md",
    ],
    "youtube": [
        "Life/10_Wiki/youtube-strategy.md",
        "20_Meta/Reinforcement_Insights.md",
    ],
    "vision": [
        "20_Meta/naver-blog-dashboard.md",
        "Life/10_Wiki/tech-blog-plan.md",
    ],
    "content": [
        "20_Meta/content-dashboard.md",
        "20_Meta/Reinforcement_Insights.md",
    ],

    # Meta: P-Reinforce / Vault
    "p-reinforce": [
        "20_Meta/Reinforcement_Insights.md",
        "20_Meta/Reinforcement_Log.md",
        "20_Meta/Policy.md",
    ],
    "reinforce": [
        "20_Meta/Reinforcement_Insights.md",
        "20_Meta/Reinforcement_Log.md",
    ],
    "vault": [
        "20_Meta/Log.md",
        "20_Meta/Policy.md",
        "20_Meta/Index.md",
    ],
    "obsidian": [
        "Research/10_Wiki/obsidian.md",
        "20_Meta/Reinforcement_Insights.md",
        "20_Meta/Log.md",
    ],

    # Research: LLM / AI Engineering
    "llm": [
        "Research/10_Wiki/llm-wiki.md",
        "Research/10_Wiki/gemma-4.md",
    ],
    "gemma": [
        "Research/10_Wiki/gemma-4.md",
        "Research/10_Wiki/antigravity.md",
    ],
    "antigravity": [
        "Research/10_Wiki/antigravity.md",
        "20_Meta/Reinforcement_Insights.md",
    ],
}

# Always load — global memory that applies to every session
ALWAYS_LOAD = [
    "20_Meta/Reinforcement_Insights.md",  # P-Reinforce rules
    "20_Meta/Log.md",                     # Recent activity log (last 20 lines)
]

def detect_topics(text: str) -> list[str]:
    """Return matched topic keys from the input text."""
    text_lower = text.lower()
    matched = []
    for key in TOPIC_ROUTES:
        # Match whole word or partial keyword
        if re.search(r'\b' + re.escape(key) + r'\b', text_lower) or key in text_lower:
            matched.append(key)
    return matched

def load_file_snippet(rel_path: str, max_lines: int = 30) -> str:
    """Load first N lines of a vault file."""
    full_path = VAULT_ROOT / rel_path
    if not full_path.exists():
        return f"[FILE NOT FOUND: {rel_path}]"
    lines = full_path.read_text(encoding="utf-8", errors="ignore").splitlines()
    snippet = "\n".join(lines[:max_lines])
    if len(lines) > max_lines:
        snippet += f"\n... ({len(lines) - max_lines} more lines)"
    return snippet

def build_context(topic_text: str) -> str:
    matched_topics = detect_topics(topic_text)
    
    # Collect unique files to load
    files_to_load = dict.fromkeys(ALWAYS_LOAD)  # preserve order, deduplicate
    for topic in matched_topics:
        for f in TOPIC_ROUTES[topic]:
            files_to_load[f] = None

    output = []
    output.append("=" * 60)
    output.append("📚 SESSION CONTEXT LOADER — Antigravity")
    output.append(f"🔍 Detected topics: {matched_topics or ['(none — loading defaults)']}")
    output.append("=" * 60)

    for rel_path in files_to_load:
        output.append(f"\n### 📄 {rel_path}")
        output.append("-" * 40)
        output.append(load_file_snippet(rel_path))

    output.append("\n" + "=" * 60)
    output.append("✅ Context loaded. You may begin your session.")
    output.append("=" * 60)
    
    return "\n".join(output)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--topic", required=True, help="User's first message or topic keywords")
    args = parser.parse_args()

    context = build_context(args.topic)
    print(context)

if __name__ == "__main__":
    main()
