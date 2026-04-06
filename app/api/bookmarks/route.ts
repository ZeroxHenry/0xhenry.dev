import { NextRequest, NextResponse } from 'next/server';
import { auth } from '@/auth';

export async function GET(request: NextRequest) {
  if (!process.env.DATABASE_URL) {
    return NextResponse.json({ bookmarked: false });
  }

  const session = await auth();
  if (!session?.user?.email) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { prisma } = await import('@/lib/prisma');

  const user = await prisma.user.findUnique({
    where: { email: session.user.email },
  });

  if (!user) {
    return NextResponse.json({ error: 'User not found' }, { status: 404 });
  }

  const { searchParams } = new URL(request.url);
  const slug = searchParams.get('slug');
  const lang = searchParams.get('lang') || 'en';

  // If no slug, return all bookmarks for the user
  if (!slug) {
    const bookmarks = await prisma.bookmark.findMany({
      where: { userId: user.id },
      orderBy: { createdAt: 'desc' },
    });
    return NextResponse.json(bookmarks);
  }

  // Check if a specific post is bookmarked
  const bookmark = await prisma.bookmark.findUnique({
    where: {
      userId_slug_lang: { userId: user.id, slug, lang },
    },
  });

  return NextResponse.json({ bookmarked: !!bookmark });
}

export async function POST(request: NextRequest) {
  if (!process.env.DATABASE_URL) {
    return NextResponse.json(
      { error: 'Database not configured' },
      { status: 503 }
    );
  }

  const session = await auth();
  if (!session?.user?.email) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  const { slug, lang } = await request.json();

  if (!slug) {
    return NextResponse.json(
      { error: 'slug is required' },
      { status: 400 }
    );
  }

  const { prisma } = await import('@/lib/prisma');

  const user = await prisma.user.findUnique({
    where: { email: session.user.email },
  });

  if (!user) {
    return NextResponse.json({ error: 'User not found' }, { status: 404 });
  }

  const effectiveLang = lang || 'en';

  // Toggle: remove if exists, create if not
  const existing = await prisma.bookmark.findUnique({
    where: {
      userId_slug_lang: { userId: user.id, slug, lang: effectiveLang },
    },
  });

  if (existing) {
    await prisma.bookmark.delete({ where: { id: existing.id } });
    return NextResponse.json({ bookmarked: false });
  }

  await prisma.bookmark.create({
    data: {
      slug,
      lang: effectiveLang,
      userId: user.id,
    },
  });

  return NextResponse.json({ bookmarked: true }, { status: 201 });
}
