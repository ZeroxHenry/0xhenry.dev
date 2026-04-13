# 🗺️ Obsidian Vault 이식 가이드 (Portability Guide)

0xHenry의 옵시디언 시스템을 다른 컴퓨터로 옮기거나, 포맷 후 복원할 때 이 가이드를 따르세요.

## 📦 새 기기에서 복구하기

### 방법 1: 백업 압축 파일(ZIP) 사용 (권장)
1. **백업 파일 가져오기**: `backups/vault/vault_backup_YYYYMMDD.zip` 파일을 새 기기로 복사합니다.
2. **압축 풀기**: 원하는 폴더에 압축을 풉니다.
3. **옵시디언에서 열기**: Obsidian 실행 -> `Open folder as vault` -> 압축을 푼 폴더 선택.
4. **플러그인 확인**: 모든 설정과 플러그인이 그대로 유지되어 있을 것입니다. 만약 플러그인이 비활성화되어 있다면 `Settings > Community Plugins`에서 활성화해 주세요.

### 방법 2: Git Repository 사용
1. **Repo Clone**: 새 기기에서 `git clone [REPO_URL]`을 수행합니다.
2. **설정 복원**: 
   - 기본 문서는 Git에 포함되어 있지만, `.obsidian/plugins` 등 대용량 폴더는 Git에서 제외되어 있을 수 있습니다. 
   - 이 경우, 기존 기기에서 생성한 `vault_backup.zip`을 이용해 `.obsidian` 폴더만 덮어쓰기 하는 것이 가장 빠릅니다.

## 🛠 정기 백업 및 관리 (CLI)

터미널에서 아래 명령어를 실행하여 수동으로 백업과 볼트 상태 점검을 수행할 수 있습니다.

```bash
# 백업 생성 및 무결성 점검 동시 실행
python3 scripts/vault_manager.py

# 무결성 점검(깨진 링크 찾기)만 실행
python3 scripts/vault_manager.py --diag

# 백업 파일만 생성
python3 scripts/vault_manager.py --backup
```

## ⚠️ 주의사항
- **workspace.json**: 이 파일은 기기마다 화면 배치 정보를 담고 있어 백업에서 제외됩니다. 새 기기에서 열면 화면 레이아웃만 초기화될 수 있으나, 데이터와 기능은 온전합니다.
- **이미지 경로**: 게시물에 삽입된 이미지가 절대 경로로 되어 있는 경우 링크가 깨질 수 있습니다. 가급적 `[[파일명]]` 형식을 사용하세요.

---
**💡 0xHenry의 팁**: 주기적으로 생성되는 백업 파일을 Google Drive나 iCloud 등 본인이 사용하는 클라우드 서비스의 동기화 폴더로 복사해 두면 완벽한 2중 백업이 가능합니다.
