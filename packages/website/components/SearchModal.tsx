'use client';

import { useState, useEffect, useRef, useCallback } from 'react';
import Link from 'next/link';

interface SearchResult {
  slug: string;
  title: string;
  date: string;
  description: string;
  tags: string[];
}

interface SearchModalProps {
  lang: string;
  isOpen: boolean;
  onClose: () => void;
}

export default function SearchModal({ lang, isOpen, onClose }: SearchModalProps) {
  const [query, setQuery] = useState('');
  const [posts, setPosts] = useState<SearchResult[]>([]);
  const [loading, setLoading] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);

  // Fetch all posts when modal opens
  useEffect(() => {
    if (!isOpen) return;
    setLoading(true);
    fetch(`/api/search?lang=${lang}`)
      .then((r) => r.json())
      .then((data) => setPosts(data))
      .catch(() => setPosts([]))
      .finally(() => setLoading(false));
  }, [isOpen, lang]);

  // Reset query when modal opens, autofocus
  useEffect(() => {
    if (isOpen) {
      setQuery('');
      setTimeout(() => inputRef.current?.focus(), 50);
    }
  }, [isOpen]);

  // Close on Escape
  useEffect(() => {
    if (!isOpen) return;
    const handler = (e: KeyboardEvent) => {
      if (e.key === 'Escape') onClose();
    };
    document.addEventListener('keydown', handler);
    return () => document.removeEventListener('keydown', handler);
  }, [isOpen, onClose]);

  const filtered = query.trim()
    ? posts.filter(
        (p) =>
          p.title.toLowerCase().includes(query.toLowerCase()) ||
          p.description.toLowerCase().includes(query.toLowerCase())
      )
    : posts;

  if (!isOpen) return null;

  return (
    <div
      className="fixed inset-0 z-[100] flex items-start justify-center pt-[15vh] bg-black/50 backdrop-blur-sm animate-fade-in"
      onClick={(e) => {
        if (e.target === e.currentTarget) onClose();
      }}
    >
      <div className="w-full max-w-lg mx-4 bg-white dark:bg-gray-900 rounded-xl shadow-2xl border border-gray-200 dark:border-gray-700 overflow-hidden animate-slide-up">
        {/* Search input */}
        <div className="flex items-center gap-3 px-4 border-b border-gray-200 dark:border-gray-700">
          <svg className="w-5 h-5 text-gray-400 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth={2}>
            <circle cx="11" cy="11" r="8" />
            <path d="m21 21-4.35-4.35" />
          </svg>
          <input
            ref={inputRef}
            type="text"
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder={lang === 'ko' ? '검색...' : 'Search posts...'}
            className="w-full py-4 bg-transparent text-base outline-none placeholder:text-gray-400"
          />
          <kbd className="hidden sm:inline-flex items-center px-2 py-0.5 text-xs text-gray-400 bg-gray-100 dark:bg-gray-800 rounded font-mono">
            ESC
          </kbd>
        </div>

        {/* Results */}
        <div className="max-h-80 overflow-y-auto">
          {loading ? (
            <div className="px-4 py-8 text-center text-sm text-gray-500">
              {lang === 'ko' ? '로딩 중...' : 'Loading...'}
            </div>
          ) : filtered.length === 0 ? (
            <div className="px-4 py-8 text-center text-sm text-gray-500">
              {query.trim()
                ? lang === 'ko'
                  ? '검색 결과가 없습니다'
                  : 'No results found'
                : lang === 'ko'
                  ? '게시글이 없습니다'
                  : 'No posts yet'}
            </div>
          ) : (
            <ul>
              {filtered.map((post) => (
                <li key={post.slug}>
                  <Link
                    href={`/${lang}/study/${post.slug}`}
                    onClick={onClose}
                    className="block px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
                  >
                    <div className="font-medium text-sm">{post.title}</div>
                    {post.description && (
                      <div className="text-xs text-gray-500 mt-0.5 line-clamp-1">
                        {post.description}
                      </div>
                    )}
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-xs text-gray-400">{post.date}</span>
                      {post.tags.slice(0, 3).map((tag) => (
                        <span
                          key={tag}
                          className="text-[10px] px-1.5 py-0.5 rounded bg-[var(--accent)]/10 text-[var(--accent)]"
                        >
                          {tag}
                        </span>
                      ))}
                    </div>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </div>

        {/* Footer hint */}
        <div className="px-4 py-2 border-t border-gray-200 dark:border-gray-700 text-[11px] text-gray-400 flex items-center gap-3">
          <span>{lang === 'ko' ? '이동하려면 클릭' : 'Click to navigate'}</span>
        </div>
      </div>

      <style jsx global>{`
        @keyframes fade-in {
          from { opacity: 0; }
          to { opacity: 1; }
        }
        @keyframes slide-up {
          from { opacity: 0; transform: translateY(10px) scale(0.98); }
          to { opacity: 1; transform: translateY(0) scale(1); }
        }
        .animate-fade-in { animation: fade-in 0.15s ease-out; }
        .animate-slide-up { animation: slide-up 0.15s ease-out; }
      `}</style>
    </div>
  );
}
