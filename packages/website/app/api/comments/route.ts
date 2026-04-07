import { NextRequest, NextResponse } from 'next/server';
import { auth } from '@/auth';

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const slug = searchParams.get('slug');
  const lang = searchParams.get('lang') || 'en';

  if (!process.env.DATABASE_URL) {
    return NextResponse.json([]);
  }

  if (!slug) {
    return NextResponse.json({ error: 'slug is required' }, { status: 400 });
  }

  const { prisma } = await import('@/lib/prisma');

  const comments = await prisma.comment.findMany({
    where: { slug, lang, parentId: null },
    include: {
      user: { select: { name: true, image: true } },
      replies: {
        include: {
          user: { select: { name: true, image: true } },
        },
        orderBy: { createdAt: 'asc' },
      },
    },
    orderBy: { createdAt: 'desc' },
  });

  return NextResponse.json(comments);
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

  const { slug, lang, content, parentId } = await request.json();

  if (!slug || !content) {
    return NextResponse.json(
      { error: 'slug and content are required' },
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

  const comment = await prisma.comment.create({
    data: {
      content,
      slug,
      lang: lang || 'en',
      userId: user.id,
      parentId: parentId || null,
    },
    include: {
      user: { select: { name: true, image: true } },
      replies: {
        include: {
          user: { select: { name: true, image: true } },
        },
      },
    },
  });

  return NextResponse.json(comment, { status: 201 });
}
