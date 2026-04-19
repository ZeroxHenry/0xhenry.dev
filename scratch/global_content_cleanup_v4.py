import os
import re
from pathlib import Path

CONTENT_DIR = Path("/Users/chobyeongjun/0xhenry.dev/packages/website/content")

# Patterns to remove
PATTERNS = [
    # English Series Branding & Navigation
    r"(?i)This is Part [0-9]+ of the \*\*?[^*]+\*\*? Series\.?",
    r"(?i)This is Part [0-9]+ of the [^.]+ Series\.?",
    r"(?m)^\*\*?Next:\*\*?.*$",
    r"(?m)^\*\*?Previous:\*\*?.*$",
    r"(?m)^Next:.*$",
    r"(?m)^Previous:.*$",
    
    # Korean Series Branding & Navigation
    r"이 글은 \*\*?[^*]+\*\*? [0-9]+편입니다\.?",
    r"이 글은 [^.]+ [0-9]+편입니다\.?",
    r"시리즈 완결\. 항해를 시작하시겠습니까\?",
    r"(?m)^\*\*?(?:이전 글|다음 글|이전 주제|다음 주제|시리즈 처음으로):\*\*?.*$",
    r"(?m)^(?:이전 글|다음 글|이전 주제|다음 주제|시리즈 처음으로):.*$",
    
    # Universal Navigation Patterns (Arrows, specific series list formats)
    r"(?m)^→\s*(?:[0-9]+편|Part\s*[0-9]+):?.*$",
    r"(?m)^\*\*?(?:Technical Blog Archive|0xhenry.dev Technical Blog Pipeline).*$",
    r"(?m)^\(8 Chapters, 78 High-Quality Posts Finished - C/A/S/O/R/E/P/M\)$",
]

def clean_file(file_path):
    content = file_path.read_text()
    original_content = content
    
    for pattern in PATTERNS:
        content = re.sub(pattern, "", content)
    
    # Clean up redundant spaces and multiple newlines
    content = re.sub(r"\n\n\n+", "\n\n", content)
    # Remove lines containing only bold periods or dashes that were left over
    content = re.sub(r"(?m)^\*\*.\*\*\s*$", "", content)
    content = re.sub(r"(?m)^---\s*\n\s*---\s*$", "---", content) # Avoid double dividers
    
    content = content.strip() + "\n"
    
    if content != original_content:
        file_path.write_text(content)
        return True
    return False

modified_count = 0
for root, dirs, files in os.walk(CONTENT_DIR):
    for file in files:
        if file.endswith(".md"):
            if clean_file(Path(root) / file):
                modified_count += 1

print(f"Cleaned {modified_count} files.")
