import type { MetadataRoute } from 'next';
import { getAllPosts } from '@/lib/posts';
import { locales } from '@/lib/i18n';

const BASE_URL = 'https://0xhenry.dev';

export default function sitemap(): MetadataRoute.Sitemap {
  const entries: MetadataRoute.Sitemap = [];

  for (const lang of locales) {
    // Homepage
    entries.push({
      url: `${BASE_URL}/${lang}`,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 1.0,
    });

    // Study index
    entries.push({
      url: `${BASE_URL}/${lang}/study`,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 0.8,
    });

    // About
    entries.push({
      url: `${BASE_URL}/${lang}/about`,
      lastModified: new Date(),
      changeFrequency: 'monthly',
      priority: 0.5,
    });

    // Study posts
    const posts = getAllPosts(lang);
    for (const post of posts) {
      entries.push({
        url: `${BASE_URL}/${lang}/study/${post.slug}`,
        lastModified: new Date(post.date),
        changeFrequency: 'monthly',
        priority: 0.7,
      });
    }
  }

  return entries;
}
