// Renders share images (1200x630) with headless Chrome:
//   public/og/default.png          from scripts/og/default.html
//   public/og/projects/<slug>.png  from scripts/og/project.html + each project's frontmatter
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
