import { getCollection, type CollectionEntry } from 'astro:content';

export type Post = CollectionEntry<'posts'>;

/** All posts, newest first. */
export async function getPosts(): Promise<Post[]> {
  const all = await getCollection('posts');
  return all.sort((a, b) => b.data.date.getTime() - a.data.date.getTime());
}

/** Rough reading time from the raw markdown, at 200 words a minute. */
export function readingMinutes(body: string | undefined): number {
  const words = (body ?? '').split(/\s+/).filter(Boolean).length;
  return Math.max(1, Math.round(words / 200));
}

/** Topics used for the filter on /blog: every tag that at least two posts share. */
export function blogTopics(posts: Post[]): { tag: string; count: number }[] {
  const counts = new Map<string, number>();
  posts.forEach((p) => p.data.tags.forEach((t) => counts.set(t, (counts.get(t) ?? 0) + 1)));
  return [...counts]
    .filter(([, n]) => n >= 2)
    .sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0]))
    .map(([tag, count]) => ({ tag, count }));
}

export const topicHref = (tag: string) => `/blog?topic=${encodeURIComponent(tag)}`;

/** Up to three other posts, closest first: same app, then shared tags, then the newest. */
export function relatedPosts(post: Post, all: Post[], limit = 3): Post[] {
  const score = (o: Post) =>
    (post.data.project && o.data.project === post.data.project ? 3 : 0) + o.data.tags.filter((t) => post.data.tags.includes(t)).length;
  return all
    .filter((o) => o.id !== post.id)
    .map((o) => ({ o, s: score(o) }))
    .sort((a, b) => b.s - a.s || b.o.data.date.getTime() - a.o.data.date.getTime())
    .slice(0, limit)
    .map(({ o }) => o);
}
