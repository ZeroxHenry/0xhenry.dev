# 세션 프롬프트 모음

다른 Claude Code 세션에서 아래 프롬프트를 복사해서 사용하세요.

---

## 글 1편 생성 + 발행

```
workspaces/naver-blog/WORKFLOW.md 읽고,
오늘의 AI 뉴스를 검색해서 블로그 글 1편 작성해.
generated/ 폴더에 저장하고, chrome으로 네이버 블로그에 발행해줘.
```

## AI 용어 사전 1편 작성 + 발행

```
workspaces/naver-blog/WORKFLOW.md 읽고,
AI 용어 사전 카테고리로 'RAG란?' 주제의 블로그 글을 작성해서
네이버 블로그에 발행해줘.
```

## 일괄 생성 (용어 사전 5편, 발행 안 함)

```
workspaces/naver-blog/WORKFLOW.md 읽고,
templates/ai-glossary.md 의 용어 목록에서 아직 안 쓴 5개를
순서대로 모두 작성해서 generated/에 저장해줘. 발행은 안 해도 됨.
```

## ready 포스트 일괄 발행

```
workspaces/naver-blog/WORKFLOW.md 읽고,
generated/index.json에서 status가 ready인 포스트를
순서대로 네이버 블로그에 발행해줘.
```

## 주간 AI 브리핑

```
workspaces/naver-blog/WORKFLOW.md 읽고,
이번 주 AI 뉴스를 종합해서 주간 AI 브리핑 글을 작성하고 발행해줘.
```

## AI 도구 리뷰 1편

```
workspaces/naver-blog/WORKFLOW.md 읽고,
[도구명]에 대한 AI 도구 리뷰 글을 작성해서 발행해줘.
```

## AI 활용법 1편

```
workspaces/naver-blog/WORKFLOW.md 읽고,
'[주제]' AI 활용법 가이드를 작성해서 발행해줘.
```

## 배치 생성 (뉴스 3편)

```
workspaces/naver-blog/WORKFLOW.md 읽고,
오늘 AI 뉴스 3건을 검색해서 각각 블로그 글로 작성해줘.
generated/에 저장만 하고 발행은 나중에.
```

## 트래킹 확인

```
workspaces/naver-blog/generated/index.json 읽고,
현재 진행 상황 알려줘. 몇 편 발행됐고, 50편까지 얼마나 남았는지.
```

## Chrome 셀렉터 탐색 (최초 1회)

```
네이버 블로그 글쓰기 페이지(blog.naver.com/0xhenry/postwrite)를
chrome으로 열고, DOM 구조를 분석해서
scripts/PUBLISH-GUIDE.md의 셀렉터 메모를 업데이트해줘.
```
