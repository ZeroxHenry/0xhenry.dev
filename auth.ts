import NextAuth from 'next-auth';
import Google from 'next-auth/providers/google';
import GitHub from 'next-auth/providers/github';

// Support both Vercel Neon integration prefixes: "DATABASE" and "STORAGE"
if (!process.env.DATABASE_URL && process.env.STORAGE_URL) {
  process.env.DATABASE_URL = process.env.STORAGE_URL;
}

const hasDatabase = !!process.env.DATABASE_URL;

async function getAdapter() {
  if (!hasDatabase) return undefined;
  const { PrismaAdapter } = await import('@auth/prisma-adapter');
  const { prisma } = await import('@/lib/prisma');
  return PrismaAdapter(prisma);
}

export const { handlers, auth, signIn, signOut } = NextAuth({
  trustHost: true,
  adapter: hasDatabase ? await getAdapter() : undefined,
  session: {
    strategy: hasDatabase ? 'database' : 'jwt',
  },
  providers: [
    Google({
      clientId: process.env.AUTH_GOOGLE_ID,
      clientSecret: process.env.AUTH_GOOGLE_SECRET,
    }),
    GitHub({
      clientId: process.env.AUTH_GITHUB_ID,
      clientSecret: process.env.AUTH_GITHUB_SECRET,
    }),
  ],
  pages: {
    signIn: '/en/login',
  },
  callbacks: {
    redirect({ url, baseUrl }) {
      // Allow relative URLs
      if (url.startsWith('/')) return `${baseUrl}${url}`;
      // Allow URLs on the same origin
      if (new URL(url).origin === baseUrl) return url;
      // Default: redirect to base with default locale
      return baseUrl;
    },
  },
});
