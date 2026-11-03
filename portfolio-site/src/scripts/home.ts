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

/* ---------- project cards: soft light follows the pointer ---------- */
if (matchMedia('(hover: hover)').matches && !reduce) {
  $$('.pcard').forEach((c) => {
    c.addEventListener('pointermove', (e) => {
      const r = c.getBoundingClientRect();
      c.style.setProperty('--mx', `${e.clientX - r.left}px`);
      c.style.setProperty('--my', `${e.clientY - r.top}px`);
    });
  });
}
