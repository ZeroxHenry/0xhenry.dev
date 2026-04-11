import fs from 'fs';
import path from 'path';
import matter from 'gray-matter';
import { remark } from 'remark';
import remarkGfm from 'remark-gfm';
import html from 'remark-html';
import type { Locale } from './i18n';

export interface Post {
  slug: string;
  title: string;
  date: string;
  description?: string;
  tags?: string[];
  youtube?: string;
  series?: string;
  content: string;
  readingTime: number;
}

function calcReadingTime(text: string, lang: Locale): number {
  if (lang === 'ko') {
    const chars = text.replace(/\s+/g, '').length;
    return Math.max(1, Math.ceil(chars / 500));
  }
  const words = text.trim().split(/\s+/).length;
  return Math.max(1, Math.ceil(words / 200));
}

const contentDir = (lang: Locale) =>
  path.join(process.cwd(), 'content', lang, 'study');

export function getAllPosts(lang: Locale): Post[] {
  const dir = contentDir(lang);
  if (!fs.existsSync(dir)) return [];

  return fs
    .readdirSync(dir)
    .filter((f) => f.endsWith('.md'))
    .map((filename) => {
      const slug = filename.replace(/\.md$/, '');
      const file = fs.readFileSync(path.join(dir, filename), 'utf-8');
      const { data, content } = matter(file);
      return {
        slug,
        title: data.title || slug,
        date: data.date ? new Date(data.date).toISOString().split('T')[0] : '',
        description: data.description,
        tags: data.tags,
        youtube: data.youtube,
        series: data.series,
        content: '',
        readingTime: calcReadingTime(content, lang),
      };
    })
    .filter((p) => p.date && p.date <= new Date().toISOString().split('T')[0])
    .sort((a, b) => b.date.localeCompare(a.date));
}

export async function getPost(lang: Locale, slug: string): Promise<Post | null> {
  const filePath = path.join(contentDir(lang), `${slug}.md`);
  if (!fs.existsSync(filePath)) return null;

  const file = fs.readFileSync(filePath, 'utf-8');
  const { data, content } = matter(file);
  const result = await remark().use(remarkGfm).use(html, { sanitize: false }).process(content);

  const postDate = data.date ? new Date(data.date).toISOString().split('T')[0] : '';
  const today = new Date().toISOString().split('T')[0];
  
  if (postDate > today) return null;

  return {
    slug,
    title: data.title || slug,
    date: postDate,
    description: data.description,
    tags: data.tags,
    youtube: data.youtube,
    series: data.series,
    content: result.toString(),
    readingTime: calcReadingTime(content, lang),
  };
}

export function getAllSlugs(lang: Locale): string[] {
  const dir = contentDir(lang);
  if (!fs.existsSync(dir)) return [];
  return fs
    .readdirSync(dir)
    .filter((f) => f.endsWith('.md'))
    .map((f) => f.replace(/\.md$/, ''));
}
