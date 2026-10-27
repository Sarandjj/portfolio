// Consent-first analytics (Google Analytics 4 through the Firebase web app's measurement ID).
// - Nothing loads and nothing is sent until the visitor presses "Allow analytics".
// - A Global Privacy Control signal counts as "no", and the banner is not shown.
// - Events are collected by one click listener, using small rules and data-track attributes.
import { GA_ID } from '../data/site';

const KEY = 'analytics-consent';
type Choice = 'yes' | 'no';

const read = (): Choice | null => {
  try {
    const v = localStorage.getItem(KEY);
    return v === 'yes' || v === 'no' ? v : null;
  } catch {
    return null;
  }
};
const write = (v: Choice) => {
  try {
    localStorage.setItem(KEY, v);
  } catch {
    /* private window: the choice just lasts for this page */
  }
};

type GtagFn = (...args: unknown[]) => void;
declare global {
  interface Window {
    dataLayer?: unknown[];
    gtag?: GtagFn;
  }
}

let loaded = false;
function load() {
  if (loaded || location.hostname === 'localhost' || location.hostname === '127.0.0.1') return;
  loaded = true;
  window.dataLayer = window.dataLayer || [];
  window.gtag = function () {
    // eslint-disable-next-line prefer-rest-params
    window.dataLayer!.push(arguments);
  };
  window.gtag('js', new Date());
  window.gtag('config', GA_ID, { allow_google_signals: false, allow_ad_personalization_signals: false });
  const s = document.createElement('script');
  s.async = true;
  s.src = `https://www.googletagmanager.com/gtag/js?id=${GA_ID}`;
  document.head.appendChild(s);
}

function track(name: string, params: Record<string, string | number> = {}) {
  if (read() !== 'yes' || !window.gtag) return;
  window.gtag('event', name, params);
}

// ---- consent banner ----
const gpc = (navigator as Navigator & { globalPrivacyControl?: boolean }).globalPrivacyControl === true;
const banner = document.getElementById('consent');
const stored = read();

if (gpc && stored === null) write('no');

if (read() === 'yes') {
  load();
} else if (read() === null && banner) {
  banner.hidden = false;
}

banner?.addEventListener('click', (e) => {
  const btn = (e.target as HTMLElement).closest<HTMLButtonElement>('[data-consent]');
  if (!btn) return;
  const choice = btn.dataset.consent as Choice;
  write(choice);
  banner.hidden = true;
  if (choice === 'yes') load();
});

// "Cookie settings" link in the footer reopens the banner
document.querySelectorAll('[data-consent-open]').forEach((el) =>
  el.addEventListener('click', () => {
    if (banner) banner.hidden = false;
  }),
);

// ---- events ----
document.addEventListener('click', (e) => {
  const el = e.target as HTMLElement;

  const tracked = el.closest<HTMLElement>('[data-track]');
  if (tracked) {
    track(tracked.dataset.track!, tracked.dataset.trackItem ? { item: tracked.dataset.trackItem } : {});
  }

  if (el.closest('[data-copy-email]')) track('email_copy');

  const launch = el.closest<HTMLElement>('[data-launch]');
  if (launch) {
    const title = document.querySelector<HTMLElement>('[data-demo-title]')?.dataset.demoTitle ?? 'demo';
    track('demo_launch', { demo: title });
  }

  const a = el.closest<HTMLAnchorElement>('a[href]');
  if (!a || tracked) return;
  const href = a.getAttribute('href') ?? '';
  if (href.startsWith('mailto:')) track('email_click');
  else if (/\.pdf($|\?)/i.test(href)) track('cv_download');
  else if (/^https?:/i.test(href) && new URL(href, location.href).hostname !== location.hostname) {
    track('outbound_click', { link_domain: new URL(href).hostname });
  }
});

// custom events from page scripts, for example the contact form
window.addEventListener('site:track', (e) => {
  const d = (e as CustomEvent<{ name: string; params?: Record<string, string | number> }>).detail;
  track(d.name, d.params);
});
