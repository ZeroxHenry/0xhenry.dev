# Vision Cleaner

Vision Cleaner는 인공지능을 활용하여 이미지의 워터마크, 불필요한 UI 요소(예: NotebookLM의 UI), 그리고 기타 텍스트 노이즈를 식별하고 제거하는 자동화 도구입니다.

## 🚀 주요 기능

1.  **Watermark Detection**: 고도로 훈련된 Vision 모델을 사용하여 이미지 내의 워터마크 영역을 정밀하게 식별합니다.
2.  **Generative Filling**: 식별된 영역을 주변 배경과 조화롭게 채워 넣어 흔적 없이 제거합니다.
3.  **UI Element Stripper**: NotebookLM과 같은 도구에서 캡처된 스크린샷의 특정 UI 레이아웃을 인식하고 해당 부분만 가리거나 삭제합니다.
4.  **Batch Processing**: 다량의 이미지를 한 번에 처리하여 블로그 운영 효율을 극대화합니다.

## 🛠️ 기술 스택

-   **Frontend**: Next.js (App Router), Tailwind CSS, Framer Motion
-   **AI Engine**: Google Gemini Pro Vision (via MCP)
-   **Backend**: Serverless Functions (Vercel)

## 📂 프로젝트 구조

```text
vision-cleaner/
├── app/                # Next.js App Router
├── components/         # UI 컴포넌트
├── lib/                # 이미지 처리 로직 및 AI 연동
├── public/             # 정적 에셋
└── README.md
```

## 📝 향후 계획

-   [ ] MVP 디자인 프로토타입 제작
-   [ ] Gemini Vision API 연동 테스트
-   [ ] 드래그 앤 드롭 업로드 기능 구현
-   [ ] 결과 이미지 실시간 다운로드 기능

---
*Created as part of the Exosuit Strategy Expansion.*
