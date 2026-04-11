---
title: "로컬 AI(Gemma 4.0) 구축 가이드: Windows, Mac, Linux 플랫폼별 완벽 대응"
date: "2026-04-11"
description: "로컬 AI 구동, OS가 달라서 헤매셨나요? 윈도우부터 리눅스까지 모든 환경을 위한 Ollama 및 Gemma 4.0 설치 상세 매뉴얼을 공개합니다."
category: "hw"
tags: ["AI", "Gemma-4.0", "Ollama", "Cross-Platform", "Tutorial"]
---

# 로컬 AI(Gemma 4.0) 플랫폼별 완벽 구축 매뉴얼

로컬 환경에서 AI를 구동할 때 가장 큰 장벽은 각자의 운영체제(OS) 환경이 다르다는 점입니다. "왜 윈도우에서는 안 되지?", "리눅스는 어떻게 깔지?" 고민하셨던 분들을 위해 **Windows, Mac, Linux 각각의 환경에 최적화된 Gemma 4.0 상세 가이드**를 준비했습니다.

---

## 1. 운영체제별 설치 및 구동 가이드

### 🪟 Windows (가장 쉬운 설정 방법)

1. **설치**: [Ollama 공식 홈페이지](https://ollama.com)에서 Windows 용 설치 파일(.exe)을 받아 설치합니다.
2. **실행**: 설치 후 작업 표시줄 우측 하단의 트레이 아이콘에 **라마 모양(Ollama)**이 있는지 확인하세요. 이게 켜져 있어야 AI가 작동합니다!
3. **설정 파일 폴더 바로 열기**: 
   - 키보드의 `Windows 키 + R`을 동시에 누릅니다.
   - 나타나는 입력창에 아래 주소를 복사해서 붙여넣고 엔터를 누르세요.
     > `%APPDATA%\Antigravity\User\`
   - 그러면 즉시 설정 폴더가 열립니다. 여기서 `settings.json` 파일을 메모장이나 에디터로 여세요.
4. **설정값 추가 (중요)**:
   - 파일의 기존 내용을 모두 지우지 말고, 아래 내용을 **기존 설정들 사이에 추가**하세요.
   - **주의**: `baseUrl` 끝에 `/v1`이 반드시 붙어야 하며, 모델명은 `gemma4:e4b`를 사용합니다.

    ```json
    {
      "antigravity.activeProvider": "local",
      "antigravity.customConfigPath": "C:\\Users\\사용자이름\\Documents\\0xhenry.dev\\antigravity.config.json",
      "models": {
        "local": {
          "provider": "openai-compatible",
          "baseUrl": "http://127.0.0.1:11434/v1",
          "model": "gemma4:e4b",
          "apiKey": "ollama"
        }
      }
    }
    ```
   - **주의**: `사용자이름` 부분은 본인의 PC 사용자 폴더 이름으로 꼭 바꿔주세요!

5. **최종 확인**: `PowerShell` 또는 `CMD`(명령 프롬프트)에서 모델을 설치합니다.
    ```powershell
    ollama pull gemma4:e4b
    ```

### 🍎 Mac (개발자들의 선호 환경)

1. **설치**: `.zip` 파일을 내려받아 `Applications` 폴더로 드래그하여 설치하거나, `Homebrew`를 사용해 설치할 수 있습니다.
    - `brew install ollama` (Homebrew 사용 시)
2. **실행 확인**: 상단 메뉴바에 Ollama 아이콘이 나타납니다.
3. **명령어**: `Terminal`을 열고 아래를 입력하여 모델을 준비하세요.
    ```zsh
    ollama pull gemma4:e4b
    ```

### 🐧 Linux (서버 및 고성능 환경)

1. **설치**: 터미널에서 다음의 원라인 명령어를 호출합니다.
    ```bash
    curl -fsSL https://ollama.com/install.sh | sh
    ```
2. **서비스 관리**: 리눅스는 백그라운드 서비스(systemd)로 관리됩니다.
    - `sudo systemctl start ollama` (시작)
    - `sudo systemctl enable ollama` (부팅 시 자동 실행)
3. **명령어**:
    ```bash
    ollama pull gemma4:e4b
    ```

---

## 2. 공통 핵심: 기본(Default) 모델 설정 (`antigravity.config.json`)

매번 `@local` 태그를 쓰기 번거롭다면, 프로젝트 루트에 있는 **`antigravity.config.json`** 파일을 앱 사양에 맞춰 정확히 수정해야 합니다. (오타 하나라도 있으면 작동하지 않습니다.)

### ✅ 검증된 설정 형식 (Copy & Paste)
```json
{
  "models": {
    "local": {
      "provider": "openai-compatible",
      "baseUrl": "http://localhost:11434/v1",
      "model": "gemma4:e4b",
      "apiKey": "ollama",
      "temperature": 0.1,
      "contextWindow": 128000
    }
  },
  "defaultModel": "local",
  "fallback": {
    "enabled": false,
    "model": "local",
    "trigger": "never"
  }
}
```

---

## 3. 플랫폼별 트러블슈팅 (Q&A)

> **Q. 연결 에러 (Connection Error)가 발생해요!**
> - **A**: `baseUrl`에 `http://`가 포함되어 있는지, 그리고 끝에 `/v1`이 붙어 있는지 확인하세요. 또한 Ollama 웹사이트에서 최신 버전으로 업데이트했는지 확인이 필요합니다.

> **Q. Windows에서 AI가 너무 느려요!**
> - **A**: 그래픽카드(NVIDIA) 드라이브를 최신으로 업데이트하세요. 속도가 비약적으로 향상됩니다. 만약 내장 그래픽을 사용 중이라면 `gemma4:e4b` 같이 최적화된 모델을 권장합니다.

---

## 마무리하며

이제 수정된 가이드를 통해 실제 작동하는 **Gemma 4.0** 환경을 구축하실 수 있을 것입니다. 플랫폼별 미묘한 설정 차이를 완벽히 반영했으니, 지금 바로 자신의 PC에서 프라이빗한 개발 환경을 만끽해 보세요!

**Henry — Robot Education Founder**
