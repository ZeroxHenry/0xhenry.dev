import { getAllPosts } from '@/lib/posts';

const BASE_URL = 'https://0xhenry.dev';

export async function GET() {
  const posts = getAllPosts('en');

  const items = posts
    .map(
      (post) => `    <item>
      <title><![CDATA[${post.title}]]></title>
      <link>${BASE_URL}/en/study/${post.slug}</link>
      <description><![CDATA[${post.description ?? ''}]]></description>
      <pubDate>${new Date(post.date).toUTCString()}</pubDate>
      <guid>${BASE_URL}/en/study/${post.slug}</guid>
    </item>`
    )
    .join('\n');

  const xml = `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>0xHenry - Engineer Study</title>
    <link>${BASE_URL}/en</link>
    <description>Learning by doing. STM32, RTOS, PCB, embedded systems — studied from scratch, recorded on YouTube, documented here.</description>
    <language>en</language>
    <atom:link href="${BASE_URL}/feed.xml" rel="self" type="application/rss+xml"/>
${items}
  </channel>
</rss>`;

  return new Response(xml, {
    headers: { 'Content-Type': 'application/xml' },
  });
}
