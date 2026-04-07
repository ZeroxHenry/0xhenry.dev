import { NextRequest, NextResponse } from 'next/server';
import { getAllPosts } from '@/lib/posts';
import type { Locale } from '@/lib/i18n';

export async function GET(request: NextRequest) {
  const { searchParams } = request.nextUrl;
  const lang = (searchParams.get('lang') === 'ko' ? 'ko' : 'en') as Locale;
  const q = searchParams.get('q')?.toLowerCase().trim();

  let posts = getAllPosts(lang).map(({ slug, title, date, description, tags }) => ({
    slug,
    title,
    date,
    description: description ?? '',
    tags: tags ?? [],
  }));

  if (q) {
    posts = posts.filter(
      (p) =>
        p.title.toLowerCase().includes(q) ||
        p.description.toLowerCase().includes(q)
    );
  }

  return NextResponse.json(posts);
}
