import { SITE } from '../data/site';

const $ = <T extends Element = HTMLElement>(s: string) => document.querySelector<T>(s);
const $$ = <T extends Element = HTMLElement>(s: string) => [...document.querySelectorAll<T>(s)];
const root = document.documentElement;
root.dataset.ui = '1';

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
const bar = $('#progress');
const onScroll = () => {
  nav?.classList.toggle('scrolled', scrollY > 10);
  const max = document.documentElement.scrollHeight - innerHeight;
  if (bar) bar.style.transform = `scaleX(${max > 0 ? Math.min(1, scrollY / max) : 0})`;
};
addEventListener('scroll', onScroll, { passive: true });
onScroll();

/* ---------- reveal on scroll ----------
   Items that arrive together under the same parent come in one after another (a short stagger),
   then the delay is cleared so hover effects stay instant. */
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
const items = $$('.reveal');
if ('IntersectionObserver' in window) {
  const io = new IntersectionObserver(
    (entries) => {
      const seen = new Map<Element | null, number>();
      entries.forEach((e) => {
        if (!e.isIntersecting) return;
        const el = e.target as HTMLElement;
        const n = seen.get(el.parentElement) ?? 0;
        seen.set(el.parentElement, n + 1);
        if (n && !reduce) {
          el.style.setProperty('--rd', `${Math.min(n, 6) * 90}ms`);
          setTimeout(() => el.style.removeProperty('--rd'), 1400);
        }
        el.classList.add('in');
        el.querySelectorAll('.arc').forEach((a) => ((a as SVGElement).style.strokeDashoffset = '0'));
        io.unobserve(el);
      });
    },
    { threshold: 0.15 },
  );
  items.forEach((el) => io.observe(el));
} else {
  items.forEach((el) => el.classList.add('in'));
}

/* ---------- journey and process lines fill as they scroll through the screen ---------- */
const fills = $$('.chapters, .steps');
if (fills.length && !reduce) {
  let ticking = false;
  const update = () => {
    ticking = false;
    for (const el of fills) {
      const r = el.getBoundingClientRect();
      // 0 when the block's top reaches 85% of the screen height, 1 when it reaches 35%
      const p = Math.min(1, Math.max(0, (innerHeight * 0.85 - r.top) / (innerHeight * 0.5)));
      el.style.setProperty('--fill', p.toFixed(3));
      // process steps light up one by one as the line reaches them
      if (el.classList.contains('steps')) {
        const steps = el.children;
        for (let i = 0; i < steps.length; i++) steps[i].classList.toggle('lit', p >= (i / steps.length) + 0.02);
      }
    }
  };
  addEventListener('scroll', () => { if (!ticking) { ticking = true; requestAnimationFrame(update); } }, { passive: true });
  update();
} else {
  // no scroll effect: show every step lit
  for (const el of $$('.steps')) el.classList.add('no-fill');
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

/* ---------- English / Tamil switch ----------
   Elements carry their Tamil text in data-ta; the English stays in the HTML for search engines. */
type Lang = 'en' | 'ta';
function setLang(l: Lang) {
  $$('[data-ta]').forEach((el) => {
    if (el.dataset.en === undefined) el.dataset.en = el.innerHTML;
    el.innerHTML = l === 'ta' ? el.dataset.ta! : el.dataset.en;
    if (l === 'ta') el.setAttribute('lang', 'ta');
    else el.removeAttribute('lang');
  });
  root.dataset.lang = l;
  $('#langSw')?.setAttribute('aria-pressed', String(l === 'ta'));
  try {
    localStorage.setItem('lang', l);
  } catch {}
  dispatchEvent(new CustomEvent('site:lang', { detail: l }));
}
$('#langSw')?.addEventListener('click', () => setLang(root.dataset.lang === 'ta' ? 'en' : 'ta'));
try {
  if (localStorage.getItem('lang') === 'ta') setLang('ta');
} catch {}
