'use client';

import { useState, useEffect } from 'react';
import Link from 'next/link';
import type { Locale } from '@/lib/i18n';

interface Bookmark {
  id: string;
  postSlug: string;
  postTitle: string;
  createdAt: string;
}

interface DashboardClientProps {
  lang: Locale;
  user: {
    name?: string | null;
    email?: string | null;
    image?: string | null;
  };
}

export default function DashboardClient({ lang, user }: DashboardClientProps) {
  const [bookmarks, setBookmarks] = useState<Bookmark[]>([]);
  const [loadingBookmarks, setLoadingBookmarks] = useState(true);

  useEffect(() => {
    fetch('/api/bookmarks')
      .then((r) => (r.ok ? r.json() : []))
      .then((data) => setBookmarks(Array.isArray(data) ? data : []))
      .catch(() => setBookmarks([]))
      .finally(() => setLoadingBookmarks(false));
  }, []);

  const isKo = lang === 'ko';

  return (
    <div className="max-w-3xl mx-auto px-5 py-12">
      <h1 className="text-2xl font-bold mb-8">
        {isKo ? '대시보드' : 'Dashboard'}
      </h1>

      {/* Profile Card */}
      <section className="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 p-6 mb-8">
        <div className="flex items-center gap-4">
          {user.image ? (
            <img
              src={user.image}
              alt=""
              className="w-16 h-16 rounded-full ring-2 ring-[var(--accent)]/30"
            />
          ) : (
            <div className="w-16 h-16 rounded-full bg-[var(--accent)] flex items-center justify-center text-white text-xl font-bold">
              {user.name?.charAt(0)?.toUpperCase() ?? '?'}
            </div>
          )}
          <div>
            <h2 className="text-lg font-semibold">{user.name ?? 'User'}</h2>
            <p className="text-sm text-gray-500">{user.email}</p>
          </div>
        </div>
      </section>

      {/* Bookmarks */}
      <section className="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 p-6 mb-8">
        <h2 className="text-lg font-semibold mb-4">
          {isKo ? '북마크' : 'Bookmarks'}
        </h2>
        {loadingBookmarks ? (
          <p className="text-sm text-gray-500">
            {isKo ? '로딩 중...' : 'Loading...'}
          </p>
        ) : bookmarks.length === 0 ? (
          <p className="text-sm text-gray-500">
            {isKo
              ? '저장한 북마크가 없습니다.'
              : 'No bookmarks yet. Save posts you want to revisit!'}
          </p>
        ) : (
          <ul className="space-y-3">
            {bookmarks.map((b) => (
              <li key={b.id}>
                <Link
                  href={`/${lang}/study/${b.postSlug}`}
                  className="flex items-center justify-between group"
                >
                  <span className="text-sm font-medium group-hover:text-[var(--accent)] transition-colors">
                    {b.postTitle}
                  </span>
                  <span className="text-xs text-gray-400">
                    {new Date(b.createdAt).toLocaleDateString()}
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        )}
      </section>

      {/* Recent Comments (placeholder) */}
      <section className="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 p-6 mb-8">
        <h2 className="text-lg font-semibold mb-4">
          {isKo ? '최근 댓글' : 'Recent Comments'}
        </h2>
        <p className="text-sm text-gray-500">
          {isKo
            ? '아직 작성한 댓글이 없습니다.'
            : 'No comments yet. Join the conversation on study posts!'}
        </p>
      </section>

      {/* Your Activity */}
      <section className="rounded-xl border border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 p-6">
        <h2 className="text-lg font-semibold mb-4">
          {isKo ? '활동 내역' : 'Your Activity'}
        </h2>
        <div className="grid grid-cols-3 gap-4 text-center">
          <div className="py-4 rounded-lg bg-gray-50 dark:bg-gray-800/50">
            <div className="text-2xl font-bold text-[var(--accent)]">
              {bookmarks.length}
            </div>
            <div className="text-xs text-gray-500 mt-1">
              {isKo ? '북마크' : 'Bookmarks'}
            </div>
          </div>
          <div className="py-4 rounded-lg bg-gray-50 dark:bg-gray-800/50">
            <div className="text-2xl font-bold text-[var(--accent)]">0</div>
            <div className="text-xs text-gray-500 mt-1">
              {isKo ? '댓글' : 'Comments'}
            </div>
          </div>
          <div className="py-4 rounded-lg bg-gray-50 dark:bg-gray-800/50">
            <div className="text-2xl font-bold text-[var(--accent)]">0</div>
            <div className="text-xs text-gray-500 mt-1">
              {isKo ? '좋아요' : 'Likes'}
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}
