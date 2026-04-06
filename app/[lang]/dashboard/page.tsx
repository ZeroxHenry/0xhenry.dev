import { auth } from '@/auth';
import { redirect } from 'next/navigation';
import type { Locale } from '@/lib/i18n';
import DashboardClient from './DashboardClient';

export default async function DashboardPage({
  params,
}: {
  params: Promise<{ lang: string }>;
}) {
  const { lang } = await params;
  const locale = (lang === 'ko' ? 'ko' : 'en') as Locale;
  const session = await auth();

  if (!session?.user) {
    redirect(`/${locale}/login`);
  }

  return <DashboardClient lang={locale} user={session.user} />;
}
