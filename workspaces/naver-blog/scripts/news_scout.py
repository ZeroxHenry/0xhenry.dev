#!/usr/bin/env python3
"""
news_scout.py — AI 뉴스 차별화 스카우팅 시스템

매일 실행해서 한국 블로그에 없는 주제를 찾아냅니다.
사용법: python scripts/news_scout.py
"""

import os
import json
import datetime
from urllib.request import urlopen, Request
from urllib.error import URLError
import xml.etree.ElementTree as ET

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INDEX_FILE = os.path.join(BASE_DIR, "generated", "index.json")
SCOUT_LOG = os.path.join(BASE_DIR, "research", "scout-log.md")

# ─────────────────────────────────────────
# Tier S: 한국 블로그가 거의 안 보는 소스
# 이 소스들에서 나온 뉴스 = 차별화 가능
# ─────────────────────────────────────────
PRIORITY_SOURCES = {
    "Platformer": {
        "rss": "https://www.platformer.news/rss/",
        "why": "Casey Newton의 인사이더 취재. 대기업 내부 스토리. 한국 매체가 절대 못 잡는 단독."
    },
    "Import AI (Jack Clark)": {
        "rss": "https://importai.substack.com/feed",
        "why": "AI 연구 + 지정학 분석. 너무 딥하지만 한국어 요약하면 독점 콘텐츠."
    },
    "The Batch (DeepLearning.AI)": {
        "rss": "https://read.deeplearning.ai/the-batch/rss/",
        "why": "Andrew Ng 팀. 연구 논문 → 일반인 언어로. 한국 블로그 아무도 참고 안 함."
    },
    "Anthropic Blog": {
        "rss": "https://www.anthropic.com/rss.xml",
        "why": "공식 발표 → 한국 블로그는 2-3일 후 번역. 우리는 당일."
    },
    "OpenAI Blog": {
        "rss": "https://openai.com/blog/rss.xml",
        "why": "공식. 당일 한국어 해석이 없음."
    },
    "MIT Technology Review AI": {
        "rss": "https://www.technologyreview.com/feed/",
        "why": "학문적 관점. 단순 뉴스를 넘어 '왜'를 설명."
    },
    "Ars Technica AI": {
        "rss": "https://feeds.arstechnica.com/arstechnica/technology-lab",
        "why": "기술 심층. 다른 매체보다 빠르고 정확."
    },
    "The Information": {
        "rss": None,  # 유료, RSS 미제공
        "url": "https://www.theinformation.com/",
        "why": "최고의 단독 기사. 유료지만 트위터/X에 헤드라인은 공개됨."
    },
}

# ─────────────────────────────────────────
# Tier A: 보조 확인 소스 (한국 블로그도 봄)
# → 이 소스 단독으로 쓰면 차별화 안 됨
# ─────────────────────────────────────────
SECONDARY_SOURCES = {
    "TechCrunch AI": "https://techcrunch.com/category/artificial-intelligence/feed/",
    "The Verge AI": "https://www.theverge.com/ai-artificial-intelligence/rss/index.xml",
    "9to5Google AI": "https://9to5google.com/feed/",
}

# ─────────────────────────────────────────
# 한국 블로그가 이미 포화된 주제 필터
# 이 키워드가 제목에 있으면 패스
# ─────────────────────────────────────────
OVERUSED_TOPICS = [
    "ChatGPT 사용법",
    "ChatGPT 활용법",
    "무료 AI 도구",
    "AI 도구 추천",
    "AI 란",
    "AI 뜻",
    "미드저니 사용법",
    "Midjourney 사용법",
    "AI로 이미지",
    "프롬프트 엔지니어링이란",
    "GPT vs Claude",
    "AI 비교",
    "AI 초보",
    "AI 입문",
]

# ─────────────────────────────────────────
# 차별화 가능성이 높은 시그널 키워드
# 제목/내용에 이게 있으면 유력 후보
# ─────────────────────────────────────────
HIGH_VALUE_SIGNALS = [
    "lawsuit", "sued", "settlement",       # 법률 이슈
    "shutdown", "discontinue", "end",       # 서비스 종료
    "leaked", "leak", "internal",          # 내부 유출
    "regulation", "ban", "restrict",       # 규제
    "layoff", "fired", "job",              # 고용 영향
    "security", "hack", "vulnerability",   # 보안
    "IMF", "government", "congress",       # 정책/기관
    "study", "research", "report",         # 연구 결과
    "first time", "unprecedented",         # 역대 최초
    "secret", "confidential",              # 비밀/기밀
]


def fetch_rss(url: str, timeout: int = 8) -> list[dict]:
    """RSS 피드에서 최신 기사 목록 가져오기"""
    items = []
    try:
        req = Request(url, headers={"User-Agent": "NaverBlogScout/1.0"})
        with urlopen(req, timeout=timeout) as resp:
            content = resp.read()
        root = ET.fromstring(content)
        # Handle both RSS and Atom
        ns = {"atom": "http://www.w3.org/2005/Atom"}
        # RSS 2.0
        for item in root.findall(".//item"):
            title_el = item.find("title")
            link_el = item.find("link")
            pub_el = item.find("pubDate")
            desc_el = item.find("description")
            if title_el is not None:
                items.append({
                    "title": title_el.text or "",
                    "link": link_el.text if link_el is not None else "",
                    "published": pub_el.text if pub_el is not None else "",
                    "description": desc_el.text[:200] if desc_el is not None and desc_el.text else "",
                })
        # Atom
        if not items:
            for entry in root.findall("{http://www.w3.org/2005/Atom}entry"):
                title_el = entry.find("{http://www.w3.org/2005/Atom}title")
                link_el = entry.find("{http://www.w3.org/2005/Atom}link")
                pub_el = entry.find("{http://www.w3.org/2005/Atom}published")
                items.append({
                    "title": title_el.text if title_el is not None else "",
                    "link": link_el.get("href", "") if link_el is not None else "",
                    "published": pub_el.text if pub_el is not None else "",
                    "description": "",
                })
    except (URLError, ET.ParseError, Exception) as e:
        print(f"  ⚠️  RSS 오류: {e}")
    return items[:10]  # 최신 10개만


def score_article(title: str, desc: str) -> tuple[int, list[str]]:
    """차별화 점수 계산 (0-100)"""
    score = 0
    reasons = []
    text = (title + " " + desc).lower()

    # 고가치 시그널 체크
    for signal in HIGH_VALUE_SIGNALS:
        if signal.lower() in text:
            score += 15
            reasons.append(f"고가치 키워드: {signal}")

    # 포화 주제 페널티
    for topic in OVERUSED_TOPICS:
        if topic.lower() in (title + desc).lower():
            score -= 30
            reasons.append(f"⛔ 포화 주제: {topic}")

    # 한국 미보도 가능성 (영문 소스 기본 보너스)
    score += 10
    reasons.append("영문 소스 → 한국어 해석 공백 존재")

    return max(0, min(100, score)), reasons


def load_existing_topics() -> set[str]:
    """이미 작성한 주제들 로드 (중복 방지)"""
    if not os.path.exists(INDEX_FILE):
        return set()
    with open(INDEX_FILE, encoding="utf-8") as f:
        data = json.load(f)
    return {p.get("title", "").lower() for p in data.get("posts", [])}


def run_scout():
    today = datetime.date.today().isoformat()
    existing = load_existing_topics()

    results = []
    print(f"\n🔍 AI 뉴스 스카우팅 시작 — {today}\n")
    print("=" * 60)

    for source_name, info in PRIORITY_SOURCES.items():
        rss_url = info.get("rss")
        if not rss_url:
            print(f"\n📌 [{source_name}] → 수동 확인 필요: {info.get('url')}")
            print(f"   이유: {info['why']}")
            continue

        print(f"\n📡 [{source_name}] 스캔 중...")
        articles = fetch_rss(rss_url)

        if not articles:
            print("   결과 없음 (접속 실패)")
            continue

        for article in articles:
            title = article["title"]
            # 중복 체크
            if any(t in title.lower() for t in existing):
                continue

            score, reasons = score_article(title, article["description"])
            if score >= 20:
                results.append({
                    "source": source_name,
                    "score": score,
                    "title": title,
                    "link": article["link"],
                    "published": article["published"],
                    "why_source": info["why"],
                    "signals": reasons,
                })

    # 점수순 정렬
    results.sort(key=lambda x: x["score"], reverse=True)

    # 로그 파일 작성
    log_lines = [
        f"# 뉴스 스카우트 결과 — {today}\n",
        f"총 {len(results)}개 후보 발견\n",
        "---\n",
    ]

    print(f"\n{'=' * 60}")
    print(f"🎯 오늘의 블로그 후보 TOP {min(5, len(results))}\n")

    for i, r in enumerate(results[:10], 1):
        tier = "🔴 강력 추천" if r["score"] >= 50 else "🟡 검토 필요" if r["score"] >= 25 else "⚪ 참고"
        print(f"{i}. [{tier}] 점수: {r['score']}")
        print(f"   제목: {r['title']}")
        print(f"   출처: {r['source']}")
        print(f"   링크: {r['link']}")
        print()

        log_lines.append(f"## {i}. {r['title']}\n")
        log_lines.append(f"- 점수: {r['score']} | {tier}\n")
        log_lines.append(f"- 출처: {r['source']}\n")
        log_lines.append(f"- 왜 이 소스인가: {r['why_source']}\n")
        log_lines.append(f"- 링크: {r['link']}\n")
        log_lines.append(f"- 차별화 신호: {', '.join(r['signals'][:3])}\n")
        log_lines.append("\n---\n")

    if not results:
        print("오늘은 강력 추천 주제가 없습니다. 내일 다시 시도하세요.")
        log_lines.append("후보 없음\n")

    with open(SCOUT_LOG, "w", encoding="utf-8") as f:
        f.writelines(log_lines)

    print(f"✅ 결과 저장: {SCOUT_LOG}")
    return results


if __name__ == "__main__":
    run_scout()
