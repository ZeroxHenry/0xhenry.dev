import os
import zipfile
import datetime
import json
import re

# Configuration
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
VAULT_DIR = os.path.join(BASE_DIR, 'vault')
BACKUP_DIR = os.path.join(BASE_DIR, 'backups/vault')

# Exclusion list for backup (relative to VAULT_DIR)
EXCLUDE_LIST = [
    '.trash',
    '.obsidian/workspace.json',
    '.obsidian/workspace-mobile.json',
    '.DS_Store'
]

def create_backup():
    if not os.path.exists(BACKUP_DIR):
        os.makedirs(BACKUP_DIR)

    timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M')
    backup_filename = f"vault_backup_{timestamp}.zip"
    backup_path = os.path.join(BACKUP_DIR, backup_filename)

    print(f"📦 Creating backup: {backup_filename}...")
    
    with zipfile.ZipFile(backup_path, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(VAULT_DIR):
            for file in files:
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, VAULT_DIR)
                
                # Check exclusion
                if any(rel_path.startswith(exc) for exc in EXCLUDE_LIST):
                    continue
                
                zipf.write(file_path, rel_path)

    print(f"✅ Backup complete: {backup_path}")
    return backup_path

def run_diagnostics():
    print("🔍 Running Vault Diagnostics...")
    broken_links = []
    
    # Simple regex for [[WikiLinks]]
    link_pattern = re.compile(r'\[\[([^\]|]+)(?:\|[^\]]+)?\]\]')

    # Map of all files in vault (to check link existence)
    vault_files = set()
    for root, dirs, files in os.walk(VAULT_DIR):
        for file in files:
            if file.endswith('.md'):
                vault_files.add(os.path.splitext(file)[0])

    # Scan for broken links
    for root, dirs, files in os.walk(VAULT_DIR):
        for file in files:
            if file.endswith('.md'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    links = link_pattern.findall(content)
                    for link in links:
                        # Simple check: assumes link target exists as a .md file
                        if link not in vault_files and not link.endswith('.png') and not link.endswith('.jpg'):
                            broken_links.append((file, link))

    if broken_links:
        print(f"⚠️ Found {len(broken_links)} potentially broken links:")
        for source, target in broken_links[:10]:
            print(f"  - {source} -> [[{target}]]")
        if len(broken_links) > 10: print("  ... and more.")
    else:
        print("✨ No broken wiki-links found!")

if __name__ == "__main__":
    import sys
    
    if len(sys.argv) > 1:
        if sys.argv[1] == '--diag':
            run_diagnostics()
        elif sys.argv[1] == '--backup':
            create_backup()
    else:
        # Default: backup and diag
        create_backup()
        run_diagnostics()
