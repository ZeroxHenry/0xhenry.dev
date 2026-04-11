---
title: "로컬 AI(Gemma) 구축 가이드: 누구나 쉽게 만드는 프라이빗 개발 환경"
date: "2026-04-11"
description: "로컬 AI가 실행되지 않아 답답하셨나요? Ollama 설치부터 Gemma 모델 구동, 그리고 기본 모델 설정까지 한 번에 끝내는 완벽 가이드를 공유합니다."
category: "hw"
tags: ["AI", "Gemma", "Ollama", "Local-AI", "Tutorial"]
---

# 로컬 AI(Gemma), 왜 나만 안 될까? 완벽 해결 가이드

로컬 환경에서 AI를 구동하는 것은 프라이버시와 속도, 그리고 비용 면에서 엄청난 장점이 있습니다. 하지만 처음 설정할 때 "왜 실행이 안 되지?" 라며 삽질하는 경우가 많죠. 저 또한 겪었던 그 답답함을 해결해 드리고자, **Ollama와 Gemma를 활용한 로컬 AI 구축의 모든 것**을 정리했습니다.

---

## 1. 시작하기: Ollama 설치 (엔진 장착)

로컬 AI를 돌리기 위한 가장 가볍고 강력한 엔진은 **Ollama**입니다.

1.  **[Ollama 공식 홈페이지](https://ollama.com)**에 접속합니다.
2.  사용 중인 OS(Windows, Mac, Linux)에 맞는 설치 파일을 내려받아 설치합니다.
3.  **핵심 체크**: 설치 후 오른쪽 하단(Windows)이나 상단 메뉴바(Mac)에 **Ollama 아이콘**이 떠 있는지 확인하세요. 이 아이콘이 없으면 AI 엔진이 꺼져 있는 상태입니다.

---

## 2. 모델 설치: 터미널에서 '한 줄'이면 끝

엔진을 달았으니 이제 뇌(Model)를 이식할 차례입니다. 우리는 구글의 강력한 오픈 모델인 **Gemma 2**를 사용합니다.

터미널(CMD 또는 PowerShell)을 열고 다음 명령어를 입력하세요.

```bash
ollama run gemma2
```

> **왜 안 될까요?**
> - 만약 `command not found`가 뜬다면 Ollama 설치가 완료되지 않았거나 경로 설정이 안 된 것입니다.
> - `error connecting to service`가 뜬다면 Ollama 앱이 실행 중인지 다시 확인하세요.

---

## 3. 심화: 매번 @local 입력하기 귀찮다면? (Default 설정)

Antigravity 같은 도구를 쓸 때, 매번 `@local` 태그를 붙이는 건 상당히 번거로운 일입니다. 아예 **로컬 AI를 기본(Default) 모델로 고정**하는 방법입니다.

### Antigravity 설정 파일 수정
`antigravity.config.json` 또는 `settings.json` 파일을 찾아 `active_provider` 항목을 수정합니다.

```json
{
  "active_provider": "local",  // 기본 프로바이더를 'local'로 변경
  "providers": {
    "local": {
      "type": "ollama",
      "endpoint": "http://localhost:11434",
      "model": "gemma2"
    }
  }
}
```

이제 태그 없이 그냥 질문해도 로컬 AI가 즉시 답변합니다!

---

## 4. 환경에 따른 문제 해결 (Troubleshooting)

### Windows 사용자라면?
- **방화벽 허용**: 윈도우 방화벽이 **11434 포트**를 막고 있을 수 있습니다. 'Windows 보안' 설정에서 해당 포트를 허용해 주세요.
- **GPU 가속**: NVIDIA 그래픽카드가 있다면 Ollama가 자동으로 GPU를 사용하지만, 속도가 너무 느리다면 드라이버가 최신인지 꼭 확인하세요.

---

## 마치며

로컬 AI는 더 이상 전문가들만의 전유물이 아닙니다. 한 번의 설정만으로 여러분의 소중한 코드를 외부 유출 걱정 없이, 그리고 무료로 무제한 활용해 보세요. 

더 궁금한 점이 있다면 언제든 댓글이나 커뮤니티를 통해 질문해 주시기 바랍니다. 여러분의 스마트한 개발 라이프를 응원합니다!

**Henry — Robot Education Founder**
