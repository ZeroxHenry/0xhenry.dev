#!/usr/bin/env python3
"""
vault_lint.py — Weekly Obsidian Vault Linter
Runs every Friday at 21:00 via cron.

Checks:
1. Orphan notes (no incoming links)
2. Broken wiki-links ([[note that doesn't exist]])
3. Tag inconsistencies (missing frontmatter tags)
4. Stale notes (not updated in 90+ days)
5. Folder density (>12 files → suggest sub-folder)
6. Missing YAML frontmatter
7. P-Reinforce loop execution (collect + analyze)

Output: vault/20_Meta/Log.md 자동 기록
"""

import os
import re
import json
from datetime import datetime, timedelta
from pathlib import Path

# ─── Paths ─────────────────────────────────────────────────────────────────
VAULT_ROOT  = Path.home() / "0xhenry.dev" / "vault"
LOG_FILE    = VAULT_ROOT / "20_Meta" / "Log.md"
ANALYZER    = Path.home() / "0xhenry.dev" / "workspaces" / "naver-blog" / "scripts" / "p_reinforce_analyzer.py"
STALE_DAYS  = 90
DENSITY_MAX = 12
# ───────────────────────────────────────────────────────────────────────────

def collect_all_notes() -> list[Path]:
    """Collect all .md files under vault."""
    return list(VAULT_ROOT.rglob("*.md"))

def extract_frontmatter(content: str) -> dict:
    """Parse YAML frontmatter from markdown."""
    if not content.startswith("---"):
        return {}
    end = content.find("---", 3)
    if end == -1:
        return {}
    fm_text = content[3:end]
    result = {}
    for line in fm_text.split("\n"):
        if ":" in line and not line.startswith(" "):
            k, _, v = line.partition(":")
            result[k.strip()] = v.strip().strip('"')
    return result

def extract_wiki_links(content: str) -> list[str]:
    """Extract all [[wiki-link]] references."""
    return re.findall(r'\[\[(.*?)(?:\|.*?)?\]\]', content)

def run_lint() -> dict:
    notes = collect_all_notes()
    note_names = {p.stem for p in notes}
    
    results = {
        "orphans":   [],
        "broken":    [],
        "no_tags":   [],
        "stale":     [],
        "dense":     [],
        "total":     len(notes),
        "timestamp": datetime.now().isoformat(),
    }
    
    # Build incoming link map
    incoming: dict[str, list[str]] = {n.stem: [] for n in notes}
    all_links: dict[str, list[str]] = {}
    
    for note in notes:
        content = note.read_text(encoding="utf-8", errors="ignore")
        links = extract_wiki_links(content)
        all_links[note.stem] = links
        for link in links:
            target = link.split("|")[0].strip()
            target_stem = Path(target).stem
            if target_stem in incoming:
                incoming[target_stem].append(note.stem)
            else:
                # Broken link — target doesn't exist
                results["broken"].append({"note": str(note.relative_to(VAULT_ROOT)), "link": link})

    # Check each note
    for note in notes:
        # Skip meta templates and system files
        if "_templates" in str(note) or note.name.startswith("."):
            continue
        
        content = note.read_text(encoding="utf-8", errors="ignore")
        fm = extract_frontmatter(content)
        
        # 1. Orphan check (no incoming links AND not an index/MOC)
        is_moc = "moc" in note.stem.lower() or "index" in note.stem.lower() or "log" in note.stem.lower()
        if not incoming.get(note.stem) and not is_moc:
            results["orphans"].append(str(note.relative_to(VAULT_ROOT)))
        
        # 2. Missing tags
        if not fm.get("tags") and not is_moc:
            results["no_tags"].append(str(note.relative_to(VAULT_ROOT)))
        
        # 3. Stale check
        mtime = datetime.fromtimestamp(note.stat().st_mtime)
        if datetime.now() - mtime > timedelta(days=STALE_DAYS):
            results["stale"].append({
                "note": str(note.relative_to(VAULT_ROOT)),
                "last_updated": mtime.strftime("%Y-%m-%d")
            })

    # 4. Folder density
    for folder in VAULT_ROOT.rglob("*"):
        if folder.is_dir() and "_templates" not in str(folder):
            md_files = list(folder.glob("*.md"))
            if len(md_files) > DENSITY_MAX:
                results["dense"].append({
                    "folder": str(folder.relative_to(VAULT_ROOT)),
                    "count": len(md_files)
                })
    
    return results

def write_log(results: dict):
    """Append weekly report to Log.md."""
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    
    orphan_count   = len(results["orphans"])
    broken_count   = len(results["broken"])
    no_tags_count  = len(results["no_tags"])
    stale_count    = len(results["stale"])
    dense_count    = len(results["dense"])
    
    quality_score = 100
    quality_score -= orphan_count * 3
    quality_score -= broken_count * 5
    quality_score -= no_tags_count * 2
    quality_score -= stale_count * 1
    quality_score = max(0, quality_score)
    
    health_emoji = "🟢" if quality_score >= 80 else "🟡" if quality_score >= 60 else "🔴"

    log_entry = f"""
## [{now}] 📊 Vault Weekly Lint Report {health_emoji}

**Vault 품질 점수: {quality_score}/100**

| 항목 | 발견 수 | 상태 |
|------|---------|------|
| 총 노트 수 | {results['total']} | - |
| 🔴 고아 노트 | {orphan_count} | {'✅ 없음' if orphan_count == 0 else '⚠️ 정리 필요'} |
| 🔴 깨진 링크 | {broken_count} | {'✅ 없음' if broken_count == 0 else '⚠️ 수정 필요'} |
| 🟡 태그 없는 노트 | {no_tags_count} | {'✅ 없음' if no_tags_count == 0 else '점검 권장'} |
| 🟡 장기 미업데이트 ({STALE_DAYS}일+) | {stale_count} | {'✅ 없음' if stale_count == 0 else '점검 권장'} |
| 🟡 밀도 초과 폴더 | {dense_count} | {'✅ 없음' if dense_count == 0 else '세분화 고려'} |

"""
    if orphan_count:
        log_entry += "### 🔴 고아 노트 목록\n"
        for o in results["orphans"][:10]:
            log_entry += f"- `{o}`\n"
        if orphan_count > 10:
            log_entry += f"- ... 외 {orphan_count - 10}개\n"
        log_entry += "\n"
    
    if broken_count:
        log_entry += "### 🔴 깨진 링크 목록\n"
        for b in results["broken"][:10]:
            log_entry += f"- `{b['note']}` → `[[{b['link']}]]`\n"
        log_entry += "\n"

    if dense_count:
        log_entry += "### 🟡 밀도 초과 폴더 (세분화 권장)\n"
        for d in results["dense"]:
            log_entry += f"- `{d['folder']}` ({d['count']}개 파일)\n"
        log_entry += "\n"

    log_entry += "---\n"
    
    # Append to Log.md
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(log_entry)
    
    print(f"\n✅ Log.md에 기록 완료")
    return quality_score

def run_p_reinforce():
    """Run the P-Reinforce analysis cycle."""
    import subprocess
    print("\n🔁 Running P-Reinforce analysis...")
    result = subprocess.run(
        ["python3", str(ANALYZER)],
        capture_output=True, text=True
    )
    print(result.stdout)
    if result.returncode != 0:
        print(f"⚠️ Analyzer error: {result.stderr}")

def main():
    print(f"🧹 Vault Lint starting — {datetime.now().strftime('%Y-%m-%d %H:%M')}\n")
    print(f"📁 Vault: {VAULT_ROOT}\n")
    
    results = run_lint()
    
    print(f"📊 Results:")
    print(f"  Total notes:    {results['total']}")
    print(f"  Orphans:        {len(results['orphans'])}")
    print(f"  Broken links:   {len(results['broken'])}")
    print(f"  No tags:        {len(results['no_tags'])}")
    print(f"  Stale (90d+):   {len(results['stale'])}")
    print(f"  Dense folders:  {len(results['dense'])}")
    
    score = write_log(results)
    print(f"\n🏆 Vault Quality Score: {score}/100")
    
    run_p_reinforce()
    
    print("\n✨ Weekly vault lint complete.")

if __name__ == "__main__":
    main()
