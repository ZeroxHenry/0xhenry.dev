export async function GET() {
  const checks = {
    AUTH_SECRET: !!process.env.AUTH_SECRET,
    NEXTAUTH_SECRET: !!process.env.NEXTAUTH_SECRET,
    GOOGLE_CLIENT_ID: !!process.env.GOOGLE_CLIENT_ID,
    GOOGLE_CLIENT_SECRET: !!process.env.GOOGLE_CLIENT_SECRET,
    GITHUB_ID: !!process.env.GITHUB_ID,
    GITHUB_SECRET: !!process.env.GITHUB_SECRET,
    NEXTAUTH_URL: process.env.NEXTAUTH_URL || '(not set)',
    AUTH_URL: process.env.AUTH_URL || '(not set)',
    NODE_ENV: process.env.NODE_ENV || '(not set)',
    AUTH_TRUST_HOST: process.env.AUTH_TRUST_HOST || '(not set)',
  };

  return Response.json(checks);
}
