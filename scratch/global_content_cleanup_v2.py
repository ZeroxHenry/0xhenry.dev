import os
import re
from pathlib import Path

CONTENT_DIR = Path("/Users/chobyeongjun/0xhenry.dev/packages/website/content")

# Patterns to remove
PATTERNS = [
    # English Series Branding (with or without bold, with or without period)
    r"(?i)This is Part [0-9]+ of the \*\*?[^*]+\*\*? Series\.?",
    r"(?i)This is Part [0-9]+ of the [^.]+ Series\.?",
    
    # Korean Series Branding
    r"이 글은 \*\*?[^*]+\*\*? [0-9]+편입니다\.?",
    r"이 글은 [^.]+ [0-9]+편입니다\.?",
    
    # Navigation Links (Matches lines starting with bold or specific keywords)
    r"(?m)^\*\*?(?:이전 글|다음 글|Previous Post|Next Post):\*\*?.*$",
    r"(?m)^(?:이전 글|다음 글|Previous Post|Next Post):.*$",
]

def clean_file(file_path):
    content = file_path.read_text()
    original_content = content
    
    for pattern in PATTERNS:
        content = re.sub(pattern, "", content)
    
    # Clean up redundant spaces and multiple newlines
    content = re.sub(r"\n\n\n+", "\n\n", content)
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
