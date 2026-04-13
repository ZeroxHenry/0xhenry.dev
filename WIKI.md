# 0xHenry Dev Pipeline Wiki 🏠

이 문서는 0xHenry의 모든 개발 에셋 및 콘텐츠 파이프라인 정착과 일관된 AI 에이전트 협업을 위한 **공식 지침서**입니다. 모든 AI 에이전트(Antigravity, Claude Code 등)는 이 규칙을 최우선으로 준수해야 합니다.

---

## 📂 파일 및 에셋 관리 규칙

### 1. Obsidian 파일명 (Visibility)
- **규칙**: 영문 ID(Slug) 대신 **'한국어 블로그 제목'**을 파일명으로 사용합니다.
- **예시**: `🚀 커서 AI 에디터 사용기.md` (O) / `2026-04-11-cursor-ai.md` (X)
- **이유**: 사용자가 파일 탐색기에서 직관적으로 내용을 파악하기 위함입니다. 문서 내부 YAML의 `id` 필드를 통해 시스템 동기화를 유지합니다.

### 2. 지능형 이미지 네이밍 (Intelligent Naming)
- **규칙**: `image1.png`와 같은 무의미한 이름 대신 **'[Safe_Title]_[Index/Role].png'** 형식을 사용합니다.
- **예시**: `커서_AI_리뷰_1.png`, `커서_AI_리뷰_메인.png`
- **이유**: AI와 사용자 모두 파일명만으로 이미지의 맥락을 이해할 수 있어야 합니다.

---

## 🤖 AI 프롬프트 가이드 (JSON-AI)

제미나이 및 클로드와의 복잡한 작업 시 아래와 같은 **JSON 구조화 프롬프트 스타일**을 채택합니다.

### JSON-AI 프롬프트 스타일 예시
```json
{
  "task": "블로그용 이미지 생성 프롬프트 정교화",
  "context": {
    "topic": "Cursor AI 코드 에디터",
    "style": "Minimalist 3D Claymation",
    "constraints": ["wide margins", "subject centered", "no text in image"]
  },
  "prompt_structure": {
    "subject": "A cute character coder using a futuristic laptop",
    "background": "Soft pastel studio background",
    "lighting": "Volumetric studio lighting",
    "enrichment": "trending on behance, octanerender, high resolution"
  }
}
```
- **장점**: 에이전트가 프롬프트를 해석하고 수정하기에 훨씬 명확하며, 파라미터별로 정밀한 조정이 가능합니다.

---

## 🎨 이미지 품질 및 워터마크 관리
- **워터마크 제거**: 생성된 모든 이미지는 `scripts/process_image.py`를 통해 우측 하단 워터마크(4개 별)가 제거된 상태여야 합니다.
- **여백 확보**: 프롬프트 시 반드시 `wide margins`, `subject centered`를 포함하여 크롭 시 주요 피사체가 잘리지 않게 합니다.

---

> [!IMPORTANT]
> 이 규칙은 프로젝트의 무결성을 위해 절대적입니다. 새로운 기능 추가 시 이 가이드라인과 충돌하지 않는지 항상 확인하십시오.
