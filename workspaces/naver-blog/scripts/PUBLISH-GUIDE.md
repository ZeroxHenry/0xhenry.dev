# Chrome 자동화 발행 가이드

## 전제 조건
1. Chrome 브라우저 열림 + Naver 로그인 상태
2. claude-in-chrome MCP 확장 프로그램 활성
3. 발행할 포스트의 status가 `ready`

## 발행 순서

### Step 1: 글쓰기 페이지 열기
```
mcp__claude-in-chrome__navigate
url: https://blog.naver.com/0xhenry/postwrite
```
SmartEditor ONE 로딩 대기.

### Step 2: 로그인 확인
```javascript
// javascript_tool
document.querySelector('.gnb_name_area')?.textContent || 
document.querySelector('.nick')?.textContent
```
null이면 → 사용자에게 로그인 요청 후 중단.

### Step 3: 제목 입력
SmartEditor ONE의 제목은 contenteditable div.
```javascript
// javascript_tool — 제목
const titleEl = document.querySelector('.se-documentTitle .se-text-paragraph') 
  || document.querySelector('[contenteditable][data-placeholder*="제목"]');
if (titleEl) {
  titleEl.focus();
  titleEl.textContent = '';
  document.execCommand('insertText', false, '{{TITLE}}');
  titleEl.dispatchEvent(new Event('input', { bubbles: true }));
}
```

### Step 4: 본문 에디터 포커스
```javascript
// javascript_tool — 본문 포커스
const body = document.querySelector('.se-component.se-text .se-text-paragraph')
  || document.querySelector('.se-content .se-text-paragraph');
if (body) {
  body.focus();
  body.click();
}
```

### Step 5: 본문 입력 (섹션별)
전체를 한번에 넣지 않고, 섹션 단위로 입력.

```javascript
// javascript_tool — 텍스트 삽입
document.execCommand('insertText', false, '{{SECTION_TEXT}}');
document.execCommand('insertParagraph', false);
```

H2 소제목 삽입:
```javascript
// 도구모음의 제목 버튼 사용 또는:
// 텍스트 선택 후 서식 변경
document.execCommand('insertText', false, '{{HEADING_TEXT}}');
// 선택 후 Heading 2 적용
```

> 주의: 각 섹션 사이에 짧은 대기 시간 두기 (봇 감지 방지)

### Step 6: 이미지 삽입
각 섹션 뒤에 관련 이미지 삽입:
```
mcp__claude-in-chrome__upload_image
path: /Users/chobyeongjun/0xhenry.dev/workspaces/naver-blog/generated/images/YYYY-MM/filename.jpg
```

이미지 업로드 후 alt text 설정:
```javascript
// 마지막으로 추가된 이미지의 alt text
const imgs = document.querySelectorAll('.se-image-resource img');
const lastImg = imgs[imgs.length - 1];
if (lastImg) lastImg.alt = '{{ALT_TEXT_KO}}';
```

### Step 7: 카테고리 선택
```javascript
// 카테고리 드롭다운 열기
const catBtn = document.querySelector('.post_set_wrap .category_btn')
  || document.querySelector('[class*="category"]');
catBtn?.click();
// 잠시 대기 후 해당 카테고리 클릭
setTimeout(() => {
  const items = document.querySelectorAll('.category_item, [class*="category"] li');
  items.forEach(el => {
    if (el.textContent.trim().includes('{{CATEGORY}}')) el.click();
  });
}, 500);
```

### Step 8: 태그 입력
```javascript
const tagInput = document.querySelector('.post_tag_input input')
  || document.querySelector('[placeholder*="태그"]');
if (tagInput) {
  const tags = [{{TAGS_ARRAY}}];
  for (const tag of tags) {
    tagInput.focus();
    tagInput.value = tag;
    tagInput.dispatchEvent(new Event('input', { bubbles: true }));
    tagInput.dispatchEvent(new KeyboardEvent('keydown', { key: 'Enter', keyCode: 13, bubbles: true }));
  }
}
```

### Step 9: 발행
```javascript
// 발행 버튼 클릭
const publishBtn = document.querySelector('.btn_publish')
  || Array.from(document.querySelectorAll('button, a')).find(b => b.textContent.includes('발행'));
publishBtn?.click();
```

발행 확인 다이얼로그:
```javascript
// 확인 버튼
setTimeout(() => {
  const confirmBtn = Array.from(document.querySelectorAll('button'))
    .find(b => b.textContent.includes('확인') || b.textContent.includes('발행'));
  confirmBtn?.click();
}, 1000);
```

### Step 10: URL 캡처
발행 후 3초 대기, URL 확인:
```javascript
window.location.href
```

---

## 실패 대응

### JavaScript 셀렉터 실패 시
1. `mcp__claude-in-chrome__read_page` → DOM 구조 재확인
2. `mcp__claude-in-chrome__find` query="제목" → 텍스트로 요소 탐색
3. `mcp__claude-in-chrome__computer` → 스크린샷 기반 좌표 클릭

### 완전 실패 시
- index.json에 status를 `manual-required`로 업데이트
- 포스트 내용을 사용자에게 텍스트로 제공
- 사용자가 수동으로 복붙 후 발행

---

## 셀렉터 메모 (첫 탐색 후 업데이트)

> 아래는 실제 DOM 탐색 후 정확한 셀렉터로 교체할 것

- 제목 입력: `(탐색 필요)`
- 본문 에디터: `(탐색 필요)`
- 이미지 버튼: `(탐색 필요)`
- 카테고리 드롭다운: `(탐색 필요)`
- 태그 입력: `(탐색 필요)`
- 발행 버튼: `(탐색 필요)`
- 발행 확인: `(탐색 필요)`
