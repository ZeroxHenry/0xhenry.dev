'use client';

export default function Error({
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center px-4 text-center">
      <div
        className="text-6xl font-extrabold"
        style={{ color: 'var(--accent)' }}
      >
        !
      </div>
      <h2 className="mt-4 text-2xl font-bold text-gray-900 dark:text-gray-100">
        Something went wrong
      </h2>
      <p className="mt-2 text-gray-500 dark:text-gray-400">
        An unexpected error occurred. Please try again.
      </p>
      <button
        onClick={reset}
        className="mt-8 inline-block cursor-pointer rounded-lg px-6 py-3 font-medium text-white transition-opacity hover:opacity-90"
        style={{ backgroundColor: 'var(--accent)' }}
      >
        Try again
      </button>
    </div>
  );
}
