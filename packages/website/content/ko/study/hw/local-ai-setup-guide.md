---
title: "로컬 AI(Gemma) 구축 가이드: Windows, Mac, Linux 플랫폼별 완벽 대응"
date: "2026-04-11"
description: "로컬 AI 구동, OS가 달라서 헤매셨나요? 윈도우부터 리눅스까지 모든 환경을 위한 Ollama 및 Gemma 설치 상세 매뉴얼을 공개합니다."
category: "hw"
tags: ["AI", "Gemma", "Ollama", "Cross-Platform", "Tutorial"]
---

# 로컬 AI(Gemma) 플랫폼별 완벽 구축 매뉴얼

로컬 환경에서 AI를 구동할 때 가장 큰 장벽은 각자의 운영체제(OS) 환경이 다르다는 점입니다. "왜 윈도우에서는 안 되지?", "리눅스는 어떻게 깔지?" 고민하셨던 분들을 위해 **Windows, Mac, Linux 각각의 환경에 최적화된 상세 가이드**를 준비했습니다.

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
4. **내용 통째로 바꾸기 (복사 & 붙여넣기)**:
   - 파일 안에 있는 내용을 모두 지우고, 아래 내용을 그대로 **복사해서 전체 붙여넣기** 하세요. (이미 설정이 있다면 `antigravity.activeProvider` 부분만 찾아 바꾸셔도 됩니다.)

    ```json
    {
      "antigravity.activeProvider": "local",
      "antigravity.customConfigPath": "C:\\Users\\사용자이름\\Documents\\0xhenry.dev\\antigravity.config.json"
    }
    ```
   - **주의**: `사용자이름` 부분은 본인의 PC 사용자 폴더 이름으로 꼭 바꿔주세요! (잘 모르겠다면 내 PC의 '사용자' 폴더를 열어보시면 됩니다.)

5. **최종 확인**: `PowerShell` 또는 `CMD`(명령 프롬프트)를 열고 아래를 입력하여 모델을 내려받습니다.

    ```powershell
    ollama run gemma2
    ```

### 🍎 Mac (개발자들의 선호 환경)

1. **설치**: `.zip` 파일을 내려받아 `Applications` 폴더로 드래그하여 설치하거나, `Homebrew`를 사용해 설치할 수 있습니다.
    - `brew install ollama` (Homebrew 사용 시)
2. **실행 확인**: 상단 메뉴바에 Ollama 아이콘이 나타납니다.
3. **명령어**: `Terminal`을 열고 아래를 입력하세요.

    ```zsh
    ollama run gemma2
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
    ollama run gemma2
    ```

---

## 2. 공통 핵심: 기본(Default) 모델 설정

매번 `@local` 태그를 쓰기 번거롭다면, 다음 설정 파일을 수정하여 로컬 AI를 기본 답변자로 지정하세요.

### Antigravity 설정 (`antigravity.config.json`)

```json
{
  "active_provider": "local",
  "providers": {
    "local": {
      "type": "ollama",
      "endpoint": "http://localhost:11434",
      "model": "gemma2"
    }
  }
}
```

---

## 3. 플랫폼별 트러블슈팅 (Q&A)

> **Q. Windows에서 AI가 너무 느려요!**
>
> - **A**: 그래픽카드(NVIDIA) 드라이버를 최신으로 업데이트하세요. Ollama는 CUDA를 통해 연산 속도를 획기적으로 높입니다.

> **Q. Mac에서 '확인된 개발자가 아니어서 열 수 없습니다'라고 떠요.**
>
> - **A**: `설정 > 개인정보 보호 및 보안`에서 '확인 없이 열기'를 클릭해 주세요.

> **Q. Linux에서 포트 충돌이 발생합니다.**
>
> - **A**: `OLLAMA_HOST` 환경 변수를 사용하여 포트를 변경할 수 있습니다. (기본값 11434)

---

## 마무리하며

이제 어떤 OS를 사용하시든 프라이빗한 로컬 AI 환경을 구축하실 수 있습니다. 로컬 AI는 단순히 편리함을 넘어 보안과 자유를 제공합니다. 오늘 바로 여러분의 터미널에서 최신 모델을 깨워보세요!

**Henry — Robot Education Founder**
