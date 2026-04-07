import Link from 'next/link';

export default function NotFound() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center px-4 text-center">
      <h1
        className="text-9xl font-extrabold tracking-tight"
        style={{ color: 'var(--accent)' }}
      >
        404
      </h1>
      <p className="mt-4 text-xl text-gray-600 dark:text-gray-400">
        Page not found
      </p>
      <p className="mt-2 text-gray-500 dark:text-gray-500">
        The page you are looking for does not exist or has been moved.
      </p>
      <Link
        href="/en"
        className="mt-8 inline-block rounded-lg px-6 py-3 font-medium text-white transition-opacity hover:opacity-90"
        style={{ backgroundColor: 'var(--accent)' }}
      >
        Go Home
      </Link>
    </div>
  );
}
