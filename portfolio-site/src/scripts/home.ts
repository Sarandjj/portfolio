import { istNow, phaseOf, type Phase } from './time';
import { setSleep, isAsleep } from './mayil';

const $ = <T extends Element = HTMLElement>(s: string) => document.querySelector<T>(s)!;
const $$ = <T extends Element = HTMLElement>(s: string) => [...document.querySelectorAll<T>(s)];
const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;

/* ---------- sky on the phone follows Tamil Nadu time ---------- */
const SKY: Record<Phase, { top: string; bot: string; hill: string; sun: number; moon: boolean; stars: number; label: string; note: string }> = {
  morning: { top: '#8ec5ff', bot: '#ffe1b0', hill: '#5cc27e', sun: 450, moon: false, stars: 0, label: 'Morning', note: 'Coffee and code' },
  day: { top: '#3d8bff', bot: '#a9d8ff', hill: '#2bb673', sun: 425, moon: false, stars: 0, label: 'Day', note: 'Probably building something' },
  evening: { top: '#5a3f9e', bot: '#ff9a6b', hill: '#3a6b52', sun: 472, moon: false, stars: 0.35, label: 'Evening', note: 'Wrapping up the day' },
  night: { top: '#0b1230', bot: '#2b2f63', hill: '#1d2b3a', sun: 700, moon: true, stars: 1, label: 'Night', note: 'Asleep. Mayil too. Leave a message' },
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

/* ---------- Mayil speech bubble ---------- */
const LINES = {
  en: [
    "Vanakkam! I'm Mayil, Tamil for peacock 🦚",
    'Tap an app on the phone!',
    'The sky follows Tamil Nadu time ☀️',
    'From Kovilpatti, home of kadalai mittai 🥜',
    'Press ⌘K to jump anywhere',
    'Try the த switch at the top for Tamil',
  ],
  ta: [
    'வணக்கம்! நான் மயில் 🦚',
    'போனில் ஒரு செயலியைத் தொட்டுப் பாருங்கள்!',
    'இந்த வானம் தமிழ்நாட்டு நேரத்தைப் பின்பற்றுகிறது ☀️',
    'கோவில்பட்டி கடலை மிட்டாய் சாப்பிட்டிருக்கீங்களா? 🥜',
    'எங்கும் செல்ல ⌘K அழுத்துங்கள்',
  ],
};
const lines = () => LINES[document.documentElement.dataset.lang === 'ta' ? 'ta' : 'en'];
const nightLine = () => (document.documentElement.dataset.lang === 'ta' ? 'zzz… (தமிழ்நாட்டில் இப்போது இரவு)' : "zzz… (it's night in Tamil Nadu)");
let li = 0;
let sayTimer: ReturnType<typeof setTimeout>;
function say(text: string, ms = 3200) {
  const b = $('#say');
  b.textContent = text;
  b.classList.remove('hide');
  clearTimeout(sayTimer);
  sayTimer = setTimeout(() => b.classList.add('hide'), ms);
}
$('#mayilBtn').addEventListener('click', () => {
  if (isAsleep()) return say(nightLine());
  // fan the tail out while it talks
  const m = $('#mayilBtn svg');
  m.classList.add('show');
  setTimeout(() => m.classList.remove('show'), 1600);
  const l = lines();
  say(l[li++ % l.length]);
});
setTimeout(() => (isAsleep() ? say('zzz…', 2600) : say(lines()[0])), 1400);
addEventListener('site:lang', () => say(lines()[0]));

/* ---------- phone: open and close apps ---------- */
const win = $('#win');
const pages = $$('.win-page');
let openedFrom: HTMLElement | null = null;

const phoneScreen = $('#screen');
function closeApp() {
  if (!win.classList.contains('open')) return;
  win.classList.remove('open');
  win.style.removeProperty('transform');
  phoneScreen.classList.remove('app-open');
  win.setAttribute('aria-hidden', 'true');
  win.setAttribute('inert', '');
  openedFrom?.focus({ preventScroll: true });
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
  phoneScreen.classList.add('app-open');
  $('#home').classList.add('used');
  win.querySelector<HTMLElement>('.win-page.on .go, .win-page.on h3')?.focus?.({ preventScroll: true });
}
win.setAttribute('inert', '');

/* drag the home bar up to close the app, like iOS (a plain tap still closes it) */
const hit = $('#closeApp');
let dragY: number | null = null;
let dragged = false;
hit.addEventListener('pointerdown', (e) => {
  dragY = e.clientY;
  dragged = false;
  hit.setPointerCapture(e.pointerId);
  win.classList.add('dragging');
});
hit.addEventListener('pointermove', (e) => {
  if (dragY === null) return;
  const up = Math.max(0, dragY - e.clientY);
  if (up > 4) dragged = true;
  const k = Math.min(1, up / 220);
  win.style.transform = `translateY(${-up * 0.6}px) scale(${1 - k * 0.35})`;
});
const endDrag = (e: PointerEvent) => {
  if (dragY === null) return;
  const up = dragY - e.clientY;
  dragY = null;
  win.classList.remove('dragging');
  if (!dragged || up > 60) closeApp();
  else win.style.removeProperty('transform');
};
hit.addEventListener('pointerup', endDrag);
hit.addEventListener('pointercancel', endDrag);
$('#home').addEventListener('click', (e) => {
  const b = (e.target as HTMLElement).closest<HTMLElement>('.app[data-app]');
  if (b) openApp(b);
});
// keyboard: Enter or Space on the home bar button still closes the app
hit.addEventListener('keydown', (e) => (e.key === 'Enter' || e.key === ' ') && closeApp());
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
  $$('.pcard, .door').forEach((c) => {
    const tilt = !c.classList.contains('feat');
    c.addEventListener('pointermove', (e) => {
      const r = c.getBoundingClientRect();
      const x = e.clientX - r.left, y = e.clientY - r.top;
      c.style.setProperty('--mx', `${x}px`);
      c.style.setProperty('--my', `${y}px`);
      if (tilt) c.style.setProperty('--rx', `${((y / r.height) - 0.5) * -3}deg`), c.style.setProperty('--ry', `${((x / r.width) - 0.5) * 3}deg`);
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

/* ---------- thoranam: leaves near the pointer flick and spring back ---------- */
const thor = document.querySelector<SVGSVGElement>('.thoranam svg');
if (thor && !reduce && matchMedia('(hover: hover)').matches) {
  const pieces = [...thor.querySelectorAll<SVGGElement>('.sway')].map((g) => ({ x: Number(g.dataset.x), push: g.querySelector<SVGGElement>('.push')! }));
  let lastX = 0, raf = 0, ev: PointerEvent | null = null;
  addEventListener('pointermove', (e) => {
    ev = e;
    if (!raf) raf = requestAnimationFrame(() => {
      raf = 0;
      const r = thor.getBoundingClientRect();
      if (!ev || ev.clientY > r.bottom + 30 || ev.clientY < r.top) { if (ev) lastX = ev.clientX; return; }
      const vx = ev.clientX - lastX;
      lastX = ev.clientX;
      // map the pointer into the SVG's own coordinates (the viewBox is 1400 wide, sliced to fill)
      const s = Math.max(r.width / 1400, r.height / 110);
      const sx = (ev.clientX - r.left - (r.width - 1400 * s) / 2) / s;
      for (const p of pieces) {
        const d = Math.abs(p.x - sx);
        if (d > 70) continue;
        const angle = Math.max(-22, Math.min(22, -vx * 0.9 * (1 - d / 70)));
        p.push.style.setProperty('--p', `${angle}deg`);
        clearTimeout((p.push as any)._t);
        (p.push as any)._t = setTimeout(() => p.push.style.setProperty('--p', '0deg'), 140);
      }
    });
  }, { passive: true });
}

/* ---------- doorstep lamps: tap to light or put out ---------- */
document.querySelectorAll<SVGGElement>('[data-lamp]').forEach((l) =>
  l.addEventListener('click', () => {
    l.classList.add('touched');
    l.classList.toggle('on');
  }),
);

/* ---------- hero: kolam dots glow around the pointer ---------- */
const hero = document.querySelector<HTMLElement>('.hero');
const field = document.querySelector<HTMLElement>('.pulli-field');
if (hero && field && !reduce && matchMedia('(hover: hover)').matches) {
  hero.addEventListener('pointermove', (e) => {
    const r = hero.getBoundingClientRect();
    field.style.setProperty('--hx', `${e.clientX - r.left}px`);
    field.style.setProperty('--hy', `${e.clientY - r.top}px`);
  }, { passive: true });
  hero.addEventListener('pointerleave', () => field.style.setProperty('--hx', '-500px'));
}

/* ---------- clock tile: place the sun or moon on the day arc ---------- */
const arc = document.querySelector<SVGSVGElement>('.dayarc');
function placeOrb() {
  if (!arc) return;
  const t = istNow();
  const h = t.h + Number(t.m) / 60;
  const day = h >= 6 && h < 18;
  // 6:00 → left end, 12:00 → top, 18:00 → right end; the night runs the same arc from 18:00 to 6:00
  const p = day ? (h - 6) / 12 : ((h + 6) % 24) / 12;
  const a = Math.PI * (1 - p);
  const orb = arc.querySelector<SVGCircleElement>('.orb')!;
  orb.setAttribute('cx', (60 + 52 * Math.cos(a)).toFixed(1));
  orb.setAttribute('cy', (40 - 36 * Math.sin(a)).toFixed(1));
  arc.style.setProperty('--dp', String(Math.round(p * 100)));
  arc.classList.toggle('night', !day);
}
placeOrb();
setInterval(placeOrb, 60000);
