#!/usr/bin/env python3
"""
handoff_create.py — Create a temporary handoff document for the next session.
Run this when the conversation context is almost full.

Usage:
  python3 scripts/handoff_create.py --summary "블로그 발행 엔진 mac_publish.py 작업 중, 네이버 로그인 이슈 해결 필요"
  python3 scripts/handoff_create.py  # Interactive mode
"""

import os
import sys
import argparse
from datetime import datetime
from pathlib import Path

VAULT_META  = Path.home() / "0xhenry.dev" / "vault" / "20_Meta"
HANDOFF_FILE = VAULT_META / "HANDOFF_TMP.md"

def create_handoff(summary: str, next_steps: list[str], context_files: list[str]):
    now = datetime.now().strftime("%Y-%m-%d %H:%M")

    content = f"""---
title: "SESSION HANDOFF (TEMP)"
created: "{now}"
status: "tmp — delete after reading"
---

# 🔄 Session Handoff Document

> ⚠️ **임시 파일** — 다음 세션 시작 시 자동으로 읽고 즉시 삭제됩니다.

## 📋 이어받을 작업 요약

{summary}

## 🧭 다음 단계 (Next Steps)

"""
    for i, step in enumerate(next_steps, 1):
        content += f"{i}. {step}\n"

    content += """
## 📂 관련 파일

"""
    for f in context_files:
        content += f"- `{f}`\n"

    content += f"""
## 🧠 P-Reinforce 상태

- 파일: `vault/20_Meta/Reinforcement_Insights.md` 참조
- 최근 로그: `vault/20_Meta/Log.md` 참조

---

*생성 시각: {now} — session_start.py가 이 파일을 자동 삭제합니다.*
"""

    HANDOFF_FILE.write_text(content, encoding="utf-8")
    print(f"✅ Handoff document created: {HANDOFF_FILE}")
    print("   → 다음 대화에서 session_start.py 실행 시 자동으로 로드 후 삭제됩니다.")

def interactive_mode():
    print("=== Handoff Document Creator ===")
    summary = input("현재 작업 상황 요약: ").strip()

    steps = []
    print("다음 단계 입력 (빈 줄로 종료):")
    while True:
        step = input(f"  Step {len(steps)+1}: ").strip()
        if not step:
            break
        steps.append(step)

    files = []
    print("관련 파일 경로 입력 (빈 줄로 종료):")
    while True:
        f = input("  File: ").strip()
        if not f:
            break
        files.append(f)

    create_handoff(summary, steps, files)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--summary", default="", help="Brief summary of in-progress work")
    parser.add_argument("--steps",   nargs="*", default=[], help="Next steps as a list")
    parser.add_argument("--files",   nargs="*", default=[], help="Relevant file paths")
    args = parser.parse_args()

    if not args.summary:
        interactive_mode()
    else:
        create_handoff(args.summary, args.steps or [], args.files or [])

if __name__ == "__main__":
    main()
