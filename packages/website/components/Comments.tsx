'use client';

import { useState, useEffect, useCallback } from 'react';
import { useSession } from 'next-auth/react';

interface CommentUser {
  name: string | null;
  image: string | null;
}

interface Comment {
  id: string;
  content: string;
  createdAt: string;
  user: CommentUser;
  replies?: Comment[];
}

function timeAgo(dateStr: string): string {
  const now = Date.now();
  const then = new Date(dateStr).getTime();
  const seconds = Math.floor((now - then) / 1000);

  if (seconds < 60) return 'just now';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes} minute${minutes !== 1 ? 's' : ''} ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours} hour${hours !== 1 ? 's' : ''} ago`;
  const days = Math.floor(hours / 24);
  if (days < 30) return `${days} day${days !== 1 ? 's' : ''} ago`;
  const months = Math.floor(days / 30);
  if (months < 12) return `${months} month${months !== 1 ? 's' : ''} ago`;
  const years = Math.floor(months / 12);
  return `${years} year${years !== 1 ? 's' : ''} ago`;
}

function Avatar({ user }: { user: CommentUser }) {
  const fallback = (user.name || '?')[0].toUpperCase();

  if (user.image) {
    return (
      <img
        src={user.image}
        alt={user.name || 'User'}
        className="w-8 h-8 rounded-full object-cover"
      />
    );
  }

  return (
    <div
      className="w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium text-white"
      style={{ backgroundColor: 'var(--accent, #0d9488)' }}
    >
      {fallback}
    </div>
  );
}

function CommentItem({
  comment,
  lang,
  onReplySubmit,
  isReply = false,
}: {
  comment: Comment;
  lang: string;
  onReplySubmit: (parentId: string, content: string) => Promise<void>;
  isReply?: boolean;
}) {
  const { data: session } = useSession();
  const [showReplyForm, setShowReplyForm] = useState(false);
  const [replyContent, setReplyContent] = useState('');
  const [submitting, setSubmitting] = useState(false);

  const handleReply = async () => {
    if (!replyContent.trim()) return;
    setSubmitting(true);
    try {
      await onReplySubmit(comment.id, replyContent);
      setReplyContent('');
      setShowReplyForm(false);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className={isReply ? 'ml-10 mt-3' : ''}>
      <div
        className="rounded-lg p-4"
        style={{
          borderLeft: '3px solid var(--accent, #0d9488)',
          backgroundColor: isReply ? 'rgba(13, 148, 136, 0.03)' : 'rgba(13, 148, 136, 0.05)',
        }}
      >
        <div className="flex items-center gap-3 mb-2">
          <Avatar user={comment.user} />
          <div>
            <span className="font-medium text-sm">
              {comment.user.name || 'Anonymous'}
            </span>
            <span className="text-xs text-gray-500 ml-2">
              {timeAgo(comment.createdAt)}
            </span>
          </div>
        </div>
        <p className="text-sm leading-relaxed whitespace-pre-wrap">
          {comment.content}
        </p>
        {!isReply && session && (
          <button
            onClick={() => setShowReplyForm(!showReplyForm)}
            className="text-xs mt-2 hover:underline"
            style={{ color: 'var(--accent, #0d9488)' }}
          >
            {showReplyForm ? 'Cancel' : 'Reply'}
          </button>
        )}
      </div>

      {showReplyForm && (
        <div className="ml-10 mt-2">
          <textarea
            value={replyContent}
            onChange={(e) => setReplyContent(e.target.value)}
            placeholder="Write a reply..."
            rows={2}
            className="w-full rounded-md border border-gray-300 p-2 text-sm focus:outline-none"
            style={{ borderColor: 'var(--accent, #0d9488)' }}
          />
          <button
            onClick={handleReply}
            disabled={submitting || !replyContent.trim()}
            className="mt-1 px-3 py-1 rounded text-white text-sm disabled:opacity-50"
            style={{ backgroundColor: 'var(--accent, #0d9488)' }}
          >
            {submitting ? 'Posting...' : 'Post Reply'}
          </button>
        </div>
      )}

      {comment.replies?.map((reply) => (
        <CommentItem
          key={reply.id}
          comment={reply}
          lang={lang}
          onReplySubmit={onReplySubmit}
          isReply
        />
      ))}
    </div>
  );
}

export default function Comments({ slug, lang }: { slug: string; lang: string }) {
  const { data: session } = useSession();
  const [comments, setComments] = useState<Comment[]>([]);
  const [content, setContent] = useState('');
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);

  const fetchComments = useCallback(async () => {
    try {
      const res = await fetch(
        `/api/comments?slug=${encodeURIComponent(slug)}&lang=${encodeURIComponent(lang)}`
      );
      if (res.ok) {
        const data = await res.json();
        setComments(data);
      }
    } finally {
      setLoading(false);
    }
  }, [slug, lang]);

  useEffect(() => {
    fetchComments();
  }, [fetchComments]);

  const handleSubmit = async () => {
    if (!content.trim()) return;
    setSubmitting(true);
    try {
      const res = await fetch('/api/comments', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ slug, lang, content }),
      });
      if (res.ok) {
        setContent('');
        await fetchComments();
      }
    } finally {
      setSubmitting(false);
    }
  };

  const handleReplySubmit = async (parentId: string, replyContent: string) => {
    const res = await fetch('/api/comments', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ slug, lang, content: replyContent, parentId }),
    });
    if (res.ok) {
      await fetchComments();
    }
  };

  return (
    <section className="mt-12">
      <h2
        className="text-xl font-bold mb-6 pb-2 border-b-2"
        style={{ borderColor: 'var(--accent, #0d9488)' }}
      >
        Comments
      </h2>

      {session ? (
        <div className="mb-8">
          <textarea
            value={content}
            onChange={(e) => setContent(e.target.value)}
            placeholder="Share your thoughts..."
            rows={3}
            className="w-full rounded-lg border p-3 text-sm focus:outline-none focus:ring-2"
            style={{
              borderColor: 'var(--accent, #0d9488)',
            }}
          />
          <button
            onClick={handleSubmit}
            disabled={submitting || !content.trim()}
            className="mt-2 px-4 py-2 rounded-lg text-white text-sm font-medium disabled:opacity-50 transition-opacity"
            style={{ backgroundColor: 'var(--accent, #0d9488)' }}
          >
            {submitting ? 'Posting...' : 'Post Comment'}
          </button>
        </div>
      ) : (
        <div
          className="mb-8 rounded-lg p-4 text-center text-sm"
          style={{
            border: '1px dashed var(--accent, #0d9488)',
            backgroundColor: 'rgba(13, 148, 136, 0.05)',
          }}
        >
          <a
            href={`/${lang}/login`}
            className="font-medium hover:underline"
            style={{ color: 'var(--accent, #0d9488)' }}
          >
            Sign in to comment
          </a>
        </div>
      )}

      {loading ? (
        <p className="text-sm text-gray-500">Loading comments...</p>
      ) : comments.length === 0 ? (
        <p className="text-sm text-gray-500">
          No comments yet. Be the first to share your thoughts!
        </p>
      ) : (
        <div className="space-y-4">
          {comments.map((comment) => (
            <CommentItem
              key={comment.id}
              comment={comment}
              lang={lang}
              onReplySubmit={handleReplySubmit}
            />
          ))}
        </div>
      )}
    </section>
  );
}
