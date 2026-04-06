import NextAuth from 'next-auth';
import Google from 'next-auth/providers/google';
import GitHub from 'next-auth/providers/github';

const hasDatabase = !!process.env.DATABASE_URL;

async function getAdapter() {
  if (!hasDatabase) return undefined;
  const { PrismaAdapter } = await import('@auth/prisma-adapter');
  const { prisma } = await import('@/lib/prisma');
  return PrismaAdapter(prisma);
}

export const { handlers, auth, signIn, signOut } = NextAuth({
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
});
