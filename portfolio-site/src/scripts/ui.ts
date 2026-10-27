import { SITE } from '../data/site';

const $ = <T extends Element = HTMLElement>(s: string) => document.querySelector<T>(s);
const $$ = <T extends Element = HTMLElement>(s: string) => [...document.querySelectorAll<T>(s)];
const root = document.documentElement;

/* ---------- theme ---------- */
function toggleTheme() {
  const dark = root.dataset.theme ? root.dataset.theme === 'dark' : matchMedia('(prefers-color-scheme: dark)').matches;
  root.dataset.theme = dark ? 'light' : 'dark';
  try {
    localStorage.setItem('theme', root.dataset.theme);
  } catch {}
}
$('#theme')?.addEventListener('click', toggleTheme);

/* ---------- nav border once scrolled ---------- */
const nav = $('#nav');
const onScroll = () => nav?.classList.toggle('scrolled', scrollY > 10);
addEventListener('scroll', onScroll, { passive: true });
onScroll();

/* ---------- reveal on scroll ---------- */
const items = $$('.reveal');
if ('IntersectionObserver' in window) {
  const io = new IntersectionObserver(
    (entries) =>
      entries.forEach((e) => {
        if (!e.isIntersecting) return;
        e.target.classList.add('in');
        e.target.querySelectorAll('.arc').forEach((a) => ((a as SVGElement).style.strokeDashoffset = '0'));
        io.unobserve(e.target);
      }),
    { threshold: 0.15 },
  );
  items.forEach((el) => io.observe(el));
} else {
  items.forEach((el) => el.classList.add('in'));
}

/* ---------- copy email ---------- */
async function copyEmail() {
  const label = $('[data-copy-label]');
  try {
    await navigator.clipboard.writeText(SITE.email);
    if (label) label.textContent = 'copied ✓';
    setTimeout(() => label && (label.textContent = 'click to copy'), 2000);
  } catch {
    location.href = `mailto:${SITE.email}`;
  }
}
$$('[data-copy-email]').forEach((b) => b.addEventListener('click', copyEmail));

/* ---------- command menu (⌘K / Ctrl+K) ---------- */
type Cmd = [label: string, kind: string, run: () => void];
const go = (href: string) => () => {
  location.href = href;
};
let projectCmds: Cmd[] = [];
try {
  const list = JSON.parse($('#cmd-projects')?.textContent ?? '[]') as { slug: string; name: string }[];
  projectCmds = list.map((p): Cmd => [`Open ${p.name}`, 'project', go(`/projects/${p.slug}`)]);
} catch {}
const CMDS: Cmd[] = [
  ['Go to Projects', 'page', go('/projects')],
  ...projectCmds,
  ['Go to Services', 'page', go('/services')],
  ['Go to About', 'page', go('/about')],
  ['Contact me', 'page', go('/contact')],
  ['Copy email', 'action', copyEmail],
  ['Toggle dark mode', 'action', toggleTheme],
  ['Open GitHub', 'link', () => window.open(SITE.github, '_blank', 'noopener')],
  ['Open LinkedIn', 'link', () => window.open(SITE.linkedin, '_blank', 'noopener')],
];

const K = $('#cmdk')!;
const kq = $<HTMLInputElement>('#kq')!;
const kl = $('#kl')!;
let sel = 0;
let filtered = CMDS;
let opener: HTMLElement | null = null;

function render() {
  filtered = CMDS.filter((c) => c[0].toLowerCase().includes(kq.value.toLowerCase()));
  sel = Math.min(sel, Math.max(filtered.length - 1, 0));
  kl.innerHTML = '';
  filtered.forEach((c, i) => {
    const li = document.createElement('li');
    li.setAttribute('role', 'option');
    li.dataset.i = String(i);
    li.className = i === sel ? 'sel' : '';
    li.textContent = c[0];
    const span = document.createElement('span');
    span.textContent = c[1];
    li.append(span);
    kl.append(li);
  });
}
function openK() {
  opener = document.activeElement as HTMLElement;
  K.classList.add('on');
  kq.value = '';
  sel = 0;
  render();
  kq.focus();
}
function closeK() {
  if (!K.classList.contains('on')) return;
  K.classList.remove('on');
  opener?.focus();
}
function runK(i: number) {
  const c = filtered[i];
  closeK();
  c?.[2]();
}
$('#openK')?.addEventListener('click', openK);
K.addEventListener('click', (e) => {
  const li = (e.target as HTMLElement).closest('li');
  if (li) runK(Number(li.dataset.i));
  else if (e.target === K) closeK();
});
kq.addEventListener('input', () => {
  sel = 0;
  render();
});
addEventListener('keydown', (e) => {
  if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
    e.preventDefault();
    K.classList.contains('on') ? closeK() : openK();
    return;
  }
  if (e.key === 'Escape') closeK();
  if (!K.classList.contains('on') || !filtered.length) return;
  if (e.key === 'ArrowDown') {
    sel = (sel + 1) % filtered.length;
    render();
    e.preventDefault();
  }
  if (e.key === 'ArrowUp') {
    sel = (sel - 1 + filtered.length) % filtered.length;
    render();
    e.preventDefault();
  }
  if (e.key === 'Enter') runK(sel);
});
