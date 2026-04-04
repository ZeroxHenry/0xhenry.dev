# Antigravity 세션 프롬프트 모음

## 매번 세션 시작 시 (필수)
```
이 레포는 techblips.com — Hugo + PaperMod 기반 테크 레이더 플랫폼이야.
GEMINI.md 파일을 먼저 읽고 모든 규칙을 따라.
main 브랜치에서 작업하고, 작업 완료되면 바로 commit + push 해줘.
Cloudflare Pages가 main push를 감지해서 자동 배포해.
```

---

## 작업 우선순위

### P0: 레이더 blip 렌더링 버그 수정
```
techblips.com/radar/current/ 페이지에서 레이더 시각화의 blip 점(dot)이 안 보이는 버그를 수정해줘.

현재 상태:
- static/js/radar.js 에서 D3.js로 레이더 그림
- 링(원)과 쿼드런트 라벨은 보이지만 blip 점들이 안 보임
- 데이터: static/data/radar/2026-q2.json (30개 blip, 구조 정상)
- layouts/radar/single.html 에서 data-source="/data/radar/2026-q2.json" 로 로딩

디버깅 순서:
1. 브라우저에서 /radar/current/ 열고 콘솔 에러 확인
2. fetch('/data/radar/2026-q2.json')이 정상 응답하는지 확인
3. radar.js의 drawBlips() 함수가 실행되는지 확인
4. SVG에 .blip 요소가 DOM에 존재하는지 확인
5. 원인 찾아서 수정, commit + push

가능한 원인:
- Hugo minifyOutput이 JS를 깨뜨림 (hugo.toml의 minifyOutput = true)
- D3.js CDN 로딩 실패
- CORS 이슈로 JSON fetch 실패
- SVG viewBox 계산 오류로 blip이 보이는 영역 밖에 렌더링
```

### P1: author-card.html 연동
```
layouts/partials/author-card.html 이 만들어져 있는데 아무 데서도 include 안 되고 있어. 블로그 포스트 하단에 추가해줘.

방법:
PaperMod 테마의 single.html을 오버라이드해야 함.
1. themes/PaperMod/layouts/_default/single.html 을 복사해서 layouts/_default/single.html 로 만들어
2. {{ .Content }} 다음에 {{ partial "author-card.html" . }} 추가
3. commit + push
```

### P2: 주간 디자인 폴리시 (반복)
```
GEMINI.md의 규칙을 읽고, 이번 주 디자인 개선을 해줘.

체크리스트:
1. assets/css/extended/custom.css — 포스트 카드 호버 인터랙션
2. static/css/radar.css — 블립 호버 효과, 필터 버튼 스타일
3. 다크모드 레이더 가시성
4. 모바일 반응형 860px 이하 레이아웃
5. 뉴스레터 구독 폼
6. commit + push
```

### P3: 블로그 포스트 퀄리티 리뷰 (반복)
```
content/posts/ 폴더의 블로그 포스트를 검토하고 퀄리티를 높여줘.

규칙:
- AI가 쓴 티 나는 문장 수정
- 도입부가 너무 길면 줄여
- 코드 예제 정확성 확인
- description 150자 이내
- 한 세션에 3-5개만
- 새 포스트 생성 금지, 파일명 변경 금지
```

### P4: Q3 레이더 준비 (분기별)
```
data/radar/2026-q2.json을 기반으로 Q3 2026 레이더를 준비해줘.

1. data/radar/2026-q3.json 생성
2. blip 이동 제안 (Assess→Trial 등)
3. 새 기술 3-5개 추가 제안
4. 각 변경에 한 줄 근거
5. static/data/radar/2026-q3.json 복사
6. content/radar/current.md는 아직 변경 금지
```
