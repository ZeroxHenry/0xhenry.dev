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
  category?: string;
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

/**
 * Recursively find all markdown files in a directory.
 * Returns absolute paths.
 */
function getMarkdownFiles(dir: string): string[] {
  if (!fs.existsSync(dir)) return [];
  let files: string[] = [];
  const items = fs.readdirSync(dir, { withFileTypes: true });

  for (const item of items) {
    const fullPath = path.join(dir, item.name);
    if (item.isDirectory()) {
      files = [...files, ...getMarkdownFiles(fullPath)];
    } else if (item.name.endsWith('.md')) {
      files.push(fullPath);
    }
  }
  return files;
}

export function getAllPosts(lang: Locale): Post[] {
  const dir = contentDir(lang);
  const files = getMarkdownFiles(dir);

  return files
    .map((filePath) => {
      const filename = path.basename(filePath);
      const slug = filename.replace(/\.md$/, '');
      const relativeDirPath = path.dirname(path.relative(dir, filePath));
      const category = relativeDirPath === '.' ? undefined : relativeDirPath;

      const fileContent = fs.readFileSync(filePath, 'utf-8');
      const { data, content } = matter(fileContent);

      return {
        slug,
        title: data.title || slug,
        category: data.category || category,
        date: data.date ? new Date(data.date).toISOString().split('T')[0] : '',
        description: data.description,
        tags: data.tags,
        youtube: data.youtube,
        series: data.series,
        content: '',
        readingTime: calcReadingTime(content, lang),
      };
    })
    .filter((p) => p.date)
    .sort((a, b) => b.date.localeCompare(a.date));
}

export async function getPost(lang: Locale, slug: string): Promise<Post | null> {
  const dir = contentDir(lang);
  const files = getMarkdownFiles(dir);
  const filePath = files.find((f) => path.basename(f) === `${slug}.md`);

  if (!filePath) return null;

  const fileContent = fs.readFileSync(filePath, 'utf-8');
  const { data, content } = matter(fileContent);
  const result = await remark().use(remarkGfm).use(html, { sanitize: false }).process(content);

  const relativeDirPath = path.dirname(path.relative(dir, filePath));
  const category = relativeDirPath === '.' ? undefined : relativeDirPath;

  return {
    slug,
    title: data.title || slug,
    category: data.category || category,
    date: data.date ? new Date(data.date).toISOString().split('T')[0] : '',
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
  const files = getMarkdownFiles(dir);
  return files.map((f) => path.basename(f).replace(/\.md$/, ''));
}
