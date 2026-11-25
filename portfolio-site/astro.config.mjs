// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';
import { execFileSync } from 'node:child_process';
import { existsSync, readdirSync } from 'node:fs';

/**
 * When a file last changed, from git (uncommitted edits count as today).
 * The sitemap used to stamp every URL with the build time, and Google ignores lastmod
 * once it sees the dates are always "now". Real dates keep it worth reading.
 */
function lastChanged(files) {
  const existing = files.filter((f) => existsSync(f));
  if (existing.length === 0) return undefined;
  try {
    const dirty = execFileSync('git', ['status', '--porcelain', '--', ...existing], { encoding: 'utf8' }).trim();
    if (dirty) return new Date().toISOString();
    const iso = execFileSync('git', ['log', '-1', '--format=%cI', '--', ...existing], { encoding: 'utf8' }).trim();
    return iso ? new Date(iso).toISOString() : undefined;
  } catch {
    return undefined; // no git (e.g. a CI checkout without history): leave lastmod out rather than guess
  }
}

const md = (dir) => readdirSync(dir).filter((f) => f.endsWith('.md')).map((f) => `${dir}/${f}`);

/** The source files behind each public path. */
function sourcesFor(path) {
  const page = (name) => [`src/pages/${name}.astro`];
  if (path === '/') return [...page('index'), ...md('src/content/projects'), ...md('src/content/posts')];
  if (path === '/blog') return [...page('blog/index'), ...md('src/content/posts')];
  if (path === '/projects') return [...page('projects/index'), ...md('src/content/projects')];
  if (path === '/recruiter') return [...page('recruiter'), ...md('src/content/projects')];
  // posts and case studies date from their own text only, so a design change to the shared
  // template does not mark every one of them as changed
  const post = path.match(/^\/blog\/(.+)$/);
  if (post) return [`src/content/posts/${post[1]}.md`];
  const project = path.match(/^\/projects\/(.+)$/);
  if (project) return [`src/content/projects/${project[1]}.md`];
  // the service pages share one data file
  if (path.startsWith('/services/')) return ['src/data/services.ts'];
  return page(path.slice(1));
}

// https://astro.build/config
export default defineConfig({
  site: 'https://sarankumar.dev',
  // /about (no slash, no .html) is the canonical URL form; firebase.json matches it
  trailingSlash: 'never',
  build: { format: 'file' },
  integrations: [
    sitemap({
      // the 404 page must not be in the sitemap
      filter: (page) => !page.includes('/404'),
      serialize(item) {
        const lastmod = lastChanged(sourcesFor(new URL(item.url).pathname));
        return lastmod ? { ...item, lastmod } : item;
      },
    }),
  ],
  vite: { plugins: [tailwindcss()] },
});
