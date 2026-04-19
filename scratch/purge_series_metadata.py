import os
import re
from pathlib import Path

CONTENT_DIR = Path("/Users/chobyeongjun/0xhenry.dev/packages/website/content")

def purge_frontmatter(file_path):
    content = file_path.read_text()
    original_content = content
    
    # Remove series and series_order from frontmatter
    # Matches series: ["..."] and series_order: X
    content = re.sub(r"(?m)^series:\s*\[.*\]\s*\n?", "", content)
    content = re.sub(r"(?m)^series_order:\s*[0-9]+\s*\n?", "", content)
    
    # Also clean up the bold dot left over in some files
    content = re.sub(r"(?m)^\*\*.\*\*\s*\n?", "", content)
    
    if content != original_content:
        file_path.write_text(content)
        return True
    return False

modified_count = 0
for root, dirs, files in os.walk(CONTENT_DIR):
    for file in files:
        if file.endswith(".md"):
            if purge_frontmatter(Path(root) / file):
                modified_count += 1

print(f"Purged frontmatter and dots in {modified_count} files.")
