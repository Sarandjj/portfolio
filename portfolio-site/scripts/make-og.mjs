// Renders share images (1200x630) with headless Chrome:
//   public/og/default.png          from scripts/og/default.html
//   public/og/projects/<slug>.png  from scripts/og/project.html + each project's frontmatter
//   public/og/blog/<slug>.png      from scripts/og/post.html + each post's frontmatter (blog.png for the index)
//   public/og/<page>.png           from scripts/og/post.html, for about, contact, projects, services, recruiter
// `node scripts/make-og.mjs pages` renders only the page images; `... posts <slug> <slug>` only those posts.
import { execFileSync } from 'node:child_process';
import { readFileSync, readdirSync, mkdirSync } from 'node:fs';
import { resolve, join } from 'node:path';
import { pathToFileURL } from 'node:url';
import YAML from 'yaml';

const root = resolve(import.meta.dirname, '..');
const chrome = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const STATUS = { live: 'Live', beta: 'Beta', progress: 'In progress' };

function shot(htmlFile, query, out) {
  const url = pathToFileURL(join(root, 'scripts/og', htmlFile));
  if (query) url.search = new URLSearchParams(query).toString();
  execFileSync(
    chrome,
    ['--headless=new', '--disable-gpu', '--hide-scrollbars', '--force-device-scale-factor=1', '--window-size=1200,630',
      '--virtual-time-budget=3000', `--screenshot=${out}`, url.href],
    { stdio: 'ignore' },
  );
  console.log('wrote', out.replace(root + '/', ''));
}

// Main pages, so a shared link shows what the page is instead of the same default card everywhere.
const PAGES = [
  ['about', 'About', 'Mobile and full-stack developer', 'Tamil Nadu, India', '👋', '#ff6a3d', '#ffb03d'],
  ['projects', 'Work', 'Apps I have built and am building', 'Case studies', '📱', '#7a4dff', '#3da5ff'],
  ['services', 'Services', 'Apps, and the systems behind them', 'Flutter · React · Backend', '🛠️', '#1f9d6b', '#3dd6a5'],
  ['contact', 'Contact', "Got an idea? Let's talk.", 'Start a project', '✉️', '#ff3d7a', '#ff6a3d'],
  ['recruiter', 'Recruiter view', 'Sarankumar G on one page', 'Flutter and full-stack developer', '📄', '#3d6aff', '#7a4dff'],
];
function pageShots() {
  for (const [slug, tag, title, project, emoji, c1, c2] of PAGES) {
    shot('post.html', { tag: `${tag} · Sarankumar G`, title, project, emoji, c1, c2 }, join(root, 'public/og', `${slug}.png`));
  }
}
if (process.argv[2] === 'pages') {
  pageShots();
  process.exit(0);
}

const postsOnly = process.argv[2] === 'posts';
mkdirSync(join(root, 'public/og/projects'), { recursive: true });
if (!postsOnly) shot('default.html', null, join(root, 'public/og/default.png'));

const dir = join(root, 'src/content/projects');
for (const file of postsOnly ? [] : readdirSync(dir).filter((f) => f.endsWith('.md'))) {
  const fm = YAML.parse(readFileSync(join(dir, file), 'utf8').split('---')[1]);
  shot('project.html', {
    name: fm.name, kind: fm.kind, emoji: fm.emoji, c1: fm.c1, c2: fm.c2,
    status: STATUS[fm.status], stack: fm.stack.slice(0, 4).join(' · '),
  }, join(root, 'public/og/projects', file.replace(/\.md$/, '.png')));
}

// Blog posts: the colours and emoji come from the project the post is about.
mkdirSync(join(root, 'public/og/blog'), { recursive: true });
const front = (path) => YAML.parse(readFileSync(path, 'utf8').split('---')[1]);
const projects = Object.fromEntries(
  readdirSync(dir).filter((f) => f.endsWith('.md')).map((f) => [f.replace(/\.md$/, ''), front(join(dir, f))]),
);
const postDir = join(root, 'src/content/posts');
// colours for posts without an app, read from the same table the site uses
const LOOK = Object.fromEntries(
  [...readFileSync(join(root, 'src/data/post-look.ts'), 'utf8').matchAll(/'([\w-]+)': \{ g: '[\w-]+', c1: '(#\w+)', c2: '(#\w+)' \}/g)].map(([, id, c1, c2]) => [id, { c1, c2 }]),
);
const only = process.argv[2] === 'posts' ? process.argv.slice(3) : null;
for (const file of readdirSync(postDir).filter((f) => f.endsWith('.md') && (!only || only.includes(f.replace(/\.md$/, ''))))) {
  const fm = front(join(postDir, file));
  // general posts have no app: they use their colours from src/data/post-look.ts and a writing emoji
  const pr = projects[fm.project] ?? { name: fm.tags?.[0] ?? 'Blog', emoji: '✍️', ...(LOOK[file.replace(/\.md$/, '')] ?? { c1: '#c08a2b', c2: '#d4501e' }) };
  shot('post.html', { title: fm.title, project: pr.name, emoji: pr.emoji, c1: pr.c1, c2: pr.c2 },
    join(root, 'public/og/blog', file.replace(/\.md$/, '.png')));
}
if (!postsOnly) shot('post.html', { title: 'Notes from building apps', project: 'Blog', emoji: '✍️', c1: '#ff6a3d', c2: '#7a4dff' }, join(root, 'public/og/blog.png'));
if (!postsOnly) pageShots();
