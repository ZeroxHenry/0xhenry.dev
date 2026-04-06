import { auth } from '@/auth';
import { NextResponse } from 'next/server';

export default auth((req) => {
  if (!req.auth) {
    const lang = req.nextUrl.pathname.split('/')[1] || 'en';
    const loginUrl = new URL(`/${lang}/login`, req.nextUrl.origin);
    return NextResponse.redirect(loginUrl);
  }
  return NextResponse.next();
});

export const config = {
  matcher: ['/:lang(en|ko)/dashboard/:path*'],
};
