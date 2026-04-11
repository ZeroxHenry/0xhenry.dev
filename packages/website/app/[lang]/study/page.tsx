import Link from 'next/link';
import { t, locales } from '@/lib/i18n';
import type { Locale } from '@/lib/i18n';
import { getAllPosts, Post } from '@/lib/posts';

export function generateStaticParams() {
  return locales.map((lang) => ({ lang }));
}

export default async function StudyPage({ params }: { params: Promise<{ lang: string }> }) {
  const { lang } = await params;
  const locale = (lang === 'ko' ? 'ko' : 'en') as Locale;
  const labels = t[locale];
  const posts = getAllPosts(locale);

  const hwPosts = posts.filter((p) => p.category === 'hw');
  const otherPosts = posts.filter((p) => p.category !== 'hw');

  const renderPost = (post: Post) => (
    <Link 
      key={post.slug} 
      href={`/${locale}/study/${post.slug}`} 
      className="group flex items-start gap-5 p-5 rounded-2xl border border-gray-200 dark:border-gray-800 dark:card-gradient card-hover hover:border-[var(--accent)] transition-all"
    >
      <div className="flex-1">
        <div className="flex items-center gap-2 mb-1">
          {post.category === 'hw' && (
            <span className="text-[10px] font-bold px-1.5 py-0.5 rounded bg-indigo-500/10 text-indigo-500 uppercase tracking-tight">HW</span>
          )}
          <h2 className="text-lg font-bold group-hover:text-[var(--accent)] transition-colors line-clamp-1">{post.title}</h2>
        </div>
        {post.description && (
          <p className="text-sm text-gray-600 dark:text-gray-400 mt-1 line-clamp-2">{post.description}</p>
        )}
        <div className="flex items-center gap-3 mt-3 text-xs text-gray-500">
          <time>{post.date}</time>
          <span>{locale === 'ko' ? `${post.readingTime}분 읽기` : `${post.readingTime} min read`}</span>
          {post.series && <span className="text-[var(--accent)] font-medium">{post.series}</span>}
          {post.youtube && <span className="text-red-500 font-medium">YouTube</span>}
        </div>
      </div>
    </Link>
  );

  return (
    <section className="max-w-5xl mx-auto px-5 py-16">
      <div className="mb-12">
        <h1 className="text-4xl font-black mb-3">{labels.studyLog}</h1>
        <p className="text-gray-600 dark:text-gray-400">{labels.studyLogDesc}</p>
      </div>

      {posts.length > 0 ? (
        <div className="space-y-12">
          {/* Hardware Section */}
          {hwPosts.length > 0 && (
            <div>
              <div className="flex items-center gap-3 mb-6">
                <div className="h-6 w-1 bg-indigo-500 rounded-full" />
                <h2 className="text-xl font-black tracking-tight">{labels.categoryHw}</h2>
                <span className="text-xs font-bold text-gray-400">{hwPosts.length} posts</span>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {hwPosts.map(renderPost)}
              </div>
            </div>
          )}

          {/* Others Section */}
          {otherPosts.length > 0 && (
            <div>
              <div className="flex items-center gap-3 mb-6">
                <div className="h-6 w-1 bg-gray-300 dark:bg-gray-700 rounded-full" />
                <h2 className="text-xl font-black tracking-tight text-gray-600 dark:text-gray-400">{labels.categoryOther}</h2>
                <span className="text-xs font-bold text-gray-400">{otherPosts.length} posts</span>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {otherPosts.map(renderPost)}
              </div>
            </div>
          )}
        </div>
      ) : (
        <div className="py-20 text-center">
          <p className="text-gray-500 text-lg">{labels.comingSoon}</p>
        </div>
      )}
    </section>
  );
}
