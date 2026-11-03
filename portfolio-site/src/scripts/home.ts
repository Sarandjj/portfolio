import { istNow, phaseOf, type Phase } from './time';
import { setSleep, isAsleep } from './kili';

const $ = <T extends Element = HTMLElement>(s: string) => document.querySelector<T>(s)!;
const $$ = <T extends Element = HTMLElement>(s: string) => [...document.querySelectorAll<T>(s)];
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;

/* ---------- sky on the phone follows Tamil Nadu time ---------- */
const SKY: Record<Phase, { top: string; bot: string; hill: string; sun: number; moon: boolean; stars: number; label: string; note: string }> = {
  morning: { top: '#8ec5ff', bot: '#ffe1b0', hill: '#5cc27e', sun: 450, moon: false, stars: 0, label: 'Morning', note: 'Coffee and code' },
  day: { top: '#3d8bff', bot: '#a9d8ff', hill: '#2bb673', sun: 425, moon: false, stars: 0, label: 'Day', note: 'Probably building something' },
  evening: { top: '#5a3f9e', bot: '#ff9a6b', hill: '#3a6b52', sun: 472, moon: false, stars: 0.35, label: 'Evening', note: 'Wrapping up the day' },
  night: { top: '#0b1230', bot: '#2b2f63', hill: '#1d2b3a', sun: 700, moon: true, stars: 1, label: 'Night', note: 'Asleep. Kili too. Leave a message' },
};
let forced: Phase | null = null;

function paintSky() {
  const t = istNow();
  const ph = forced ?? phaseOf(t.h);
  const s = SKY[ph];
  const screen = $('#screen').style;
  screen.setProperty('--sky-top', s.top);
  screen.setProperty('--sky-bot', s.bot);
  screen.setProperty('--hill', s.hill);
  $('#sun').style.transform = `translateY(${s.sun}px)`;
  $('#sun').style.opacity = s.moon ? '0' : '1';
  $('#moon').style.transform = `translateY(${s.moon ? 428 : 700}px)`;
  $('#moon').style.opacity = s.moon ? '1' : '0';
  $('#stars').style.opacity = String(s.stars);
  $('#pTime').textContent = t.hhmm;
  $('#wTime').textContent = t.hhmm;
  $('#clock').textContent = t.hhmm;
  $('#istSmall').textContent = 'IST ' + t.hhmm;
  $('#wLabel').textContent = 'Tamil Nadu · ' + s.label;
  $('#wNote').textContent = s.note;
  $('#clockNote').textContent = ph === 'night' ? 'Asleep now, back in the morning' : 'Awake right now';
  setSleep(ph === 'night');
}
// first paint: jump straight to the right sky, no 1.2s colour transition
const screenEl = $('#screen');
screenEl.style.transition = 'none';
paintSky();
requestAnimationFrame(() => requestAnimationFrame(() => (screenEl.style.transition = '')));
setInterval(paintSky, 20000);

$('#skypick').addEventListener('click', (e) => {
  const b = (e.target as HTMLElement).closest('button');
  if (!b) return;
  $$('#skypick button').forEach((x) => x.setAttribute('aria-pressed', String(x === b)));
  forced = b.dataset.t === 'live' ? null : (b.dataset.t as Phase);
  paintSky();
});

/* ---------- Kili speech bubble ---------- */
const LINES = [
  "Hi! I'm Kili, Tamil for parrot 🦜",
  'Tap an app on the phone!',
  'The sky follows Tamil Nadu time ☀️',
  'Press ⌘K to jump anywhere',
  'Click the email to copy it',
];
let li = 0;
let sayTimer: ReturnType<typeof setTimeout>;
function say(text: string, ms = 3200) {
  const b = $('#say');
  b.textContent = text;
  b.classList.remove('hide');
  clearTimeout(sayTimer);
  sayTimer = setTimeout(() => b.classList.add('hide'), ms);
}
$('#kiliBtn').addEventListener('click', () => (isAsleep() ? say("zzz… (it's night in Tamil Nadu)") : say(LINES[li++ % LINES.length])));
setTimeout(() => (isAsleep() ? say('zzz…', 2600) : say(LINES[0])), 1400);

/* ---------- phone: open and close apps ---------- */
const win = $('#win');
const pages = $$('.win-page');
let openedFrom: HTMLElement | null = null;

function closeApp() {
  if (!win.classList.contains('open')) return;
  win.classList.remove('open');
  win.setAttribute('aria-hidden', 'true');
  win.setAttribute('inert', '');
  openedFrom?.focus();
}
function openApp(btn: HTMLElement) {
  const id = btn.dataset.app!;
  pages.forEach((p) => p.classList.toggle('on', p.id === `app-${id}`));
  const screenBox = $('#screen').getBoundingClientRect();
  const icon = btn.querySelector('i')!.getBoundingClientRect();
  win.style.transformOrigin = `${icon.left + icon.width / 2 - screenBox.left}px ${icon.top + icon.height / 2 - screenBox.top}px`;
  openedFrom = btn;
  win.removeAttribute('inert');
  win.setAttribute('aria-hidden', 'false');
  win.classList.add('open');
  win.querySelector<HTMLElement>('.win-page.on .go, .win-page.on h3')?.focus?.();
}
win.setAttribute('inert', '');
$('#home').addEventListener('click', (e) => {
  const b = (e.target as HTMLElement).closest<HTMLElement>('.app[data-app]');
  if (b) openApp(b);
});
$('#closeApp').addEventListener('click', closeApp);
win.addEventListener('click', (e) => {
  if ((e.target as HTMLElement).closest('a.go[href^="#"]')) closeApp();
});
addEventListener('keydown', (e) => e.key === 'Escape' && closeApp());

/* ---------- terminal tile ---------- */
const LINES_T = [
  '$ flutter build web --release',
  '<span class="ok">✓</span> Built build/web',
  '$ firebase deploy --only hosting',
  '<span class="ok">✓</span> Deploy complete',
];
const term = $('#term');
const wait = (ms: number) => new Promise((r) => setTimeout(r, ms));
async function runTerm() {
  if (reduce) {
    term.innerHTML = LINES_T.map((l) => `<div>${l}</div>`).join('');
    return;
  }
  for (;;) {
    term.innerHTML = '';
    for (const line of LINES_T) {
      const div = document.createElement('div');
      term.append(div);
      if (line.startsWith('$')) {
        for (let i = 1; i <= line.length; i++) {
          div.textContent = line.slice(0, i);
          const cur = document.createElement('span');
          cur.className = 'cur';
          div.append(cur);
          await wait(28);
        }
        div.textContent = line;
      } else {
        await wait(500);
        div.innerHTML = line;
      }
      await wait(350);
    }
    await wait(3500);
  }
}
runTerm();

/* ---------- glass cards: light follows the pointer, with a small 3D tilt ---------- */
if (matchMedia('(hover: hover)').matches && !reduce) {
  $$('.pcard, .door, .tile, .chapters li').forEach((c) => {
    const tilt = !c.classList.contains('feat');
    c.addEventListener('pointermove', (e) => {
      const r = c.getBoundingClientRect();
      const x = e.clientX - r.left, y = e.clientY - r.top;
      c.style.setProperty('--mx', `${x}px`);
      c.style.setProperty('--my', `${y}px`);
      if (tilt) c.style.setProperty('--rx', `${((y / r.height) - 0.5) * -5}deg`), c.style.setProperty('--ry', `${((x / r.width) - 0.5) * 5}deg`);
    });
    c.addEventListener('pointerleave', () => { c.style.setProperty('--rx', '0deg'); c.style.setProperty('--ry', '0deg'); });
  });
}

/* ---------- proof numbers count up once when seen ---------- */
const counters = $$('[data-count]');
if (!reduce && 'IntersectionObserver' in window) {
  const io = new IntersectionObserver((entries) => entries.forEach((e) => {
    if (!e.isIntersecting) return;
    io.unobserve(e.target);
    const el = e.target as HTMLElement, end = Number(el.dataset.count), t0 = performance.now();
    if (end === 0) return;
    const step = (t: number) => {
      const k = Math.min(1, (t - t0) / 1200);
      el.textContent = String(Math.round(end * (1 - Math.pow(1 - k, 3))));
      if (k < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
  }), { threshold: 0.6 });
  counters.forEach((c) => io.observe(c));
}

/* ---------- short / long bio ---------- */
$$('.biotog button').forEach((b) =>
  b.addEventListener('click', () => {
    $$('.biotog button').forEach((x) => x.setAttribute('aria-pressed', String(x === b)));
    $$('[data-bio]').forEach((el) => (el.hidden = el.dataset.bio !== b.dataset.len));
  }),
);

/* ---------- project filters ---------- */
$$('.filters button').forEach((b) =>
  b.addEventListener('click', () => {
    const f = b.dataset.f!;
    $$('.filters button').forEach((x) => x.setAttribute('aria-pressed', String(x === b)));
    $$('[data-cards]').forEach((grid) => {
      let shown = 0;
      grid.querySelectorAll<HTMLElement>('[data-tags]').forEach((c) => {
        const on = f === 'all' || c.dataset.tags!.split(' ').includes(f);
        c.hidden = !on;
        if (on) shown++;
      });
      grid.hidden = shown === 0;
      const head = grid.previousElementSibling as HTMLElement | null;
      if (head?.hasAttribute('data-group')) head.hidden = shown === 0;
    });
  }),
);

/* ---------- case studies already read (stored in this browser only) ---------- */
let seen: string[] = [];
try { seen = JSON.parse(localStorage.getItem('seen-projects') ?? '[]'); } catch {}
const cards = $$('[data-slug]');
cards.forEach((c) => {
  if (seen.includes(c.dataset.slug!)) c.querySelector<HTMLElement>('.seen')!.hidden = false;
});
const read = cards.filter((c) => seen.includes(c.dataset.slug!)).length;
if (read > 0) {
  const sc = $('#seenCount');
  sc.textContent = `You've read ${read} of ${cards.length}`;
  sc.hidden = false;
}
