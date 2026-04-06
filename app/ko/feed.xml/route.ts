import { getAllPosts } from '@/lib/posts';

const BASE_URL = 'https://techblips.com';

export async function GET() {
  const posts = getAllPosts('ko');

  const items = posts
    .map(
      (post) => `    <item>
      <title><![CDATA[${post.title}]]></title>
      <link>${BASE_URL}/ko/study/${post.slug}</link>
      <description><![CDATA[${post.description ?? ''}]]></description>
      <pubDate>${new Date(post.date).toUTCString()}</pubDate>
      <guid>${BASE_URL}/ko/study/${post.slug}</guid>
    </item>`
    )
    .join('\n');

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>TechBlips - 엔지니어 스터디</title>
    <link>${BASE_URL}/ko</link>
    <description>직접 공부하며 기록합니다. STM32, RTOS, PCB, 임베디드 — 유튜브 영상 + 정리글로 함께 배워요.</description>
    <language>ko</language>
    <atom:link href="${BASE_URL}/ko/feed.xml" rel="self" type="application/rss+xml"/>
${items}
  </channel>
</rss>`;

  return new Response(xml, {
    headers: { 'Content-Type': 'application/xml' },
  });
}
