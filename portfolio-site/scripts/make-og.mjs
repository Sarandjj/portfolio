// Renders share images (1200x630) with headless Chrome:
//   public/og/default.png          from scripts/og/default.html
//   public/og/projects/<slug>.png  from scripts/og/project.html + each project's frontmatter
//   public/og/blog/<slug>.png      from scripts/og/post.html + each post's frontmatter (blog.png for the index)
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

mkdirSync(join(root, 'public/og/projects'), { recursive: true });
shot('default.html', null, join(root, 'public/og/default.png'));

const dir = join(root, 'src/content/projects');
for (const file of readdirSync(dir).filter((f) => f.endsWith('.md'))) {
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
for (const file of readdirSync(postDir).filter((f) => f.endsWith('.md'))) {
  const fm = front(join(postDir, file));
  const pr = projects[fm.project];
  shot('post.html', { title: fm.title, project: pr.name, emoji: pr.emoji, c1: pr.c1, c2: pr.c2 },
    join(root, 'public/og/blog', file.replace(/\.md$/, '.png')));
}
shot('post.html', { title: 'Notes from building apps', project: 'Blog', emoji: '✍️', c1: '#ff6a3d', c2: '#7a4dff' }, join(root, 'public/og/blog.png'));
