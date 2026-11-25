// Tells IndexNow search engines (Bing, Yandex, Seznam, Naver; Bing passes it on to Copilot and the
// tools built on its index) which pages changed, so they are crawled within hours instead of weeks.
// Run it after a deploy:
//   node scripts/indexnow.mjs            only pages whose sitemap date changed since the last send
//   node scripts/indexnow.mjs --days 14  every page dated in the last 14 days, sent or not
//   node scripts/indexnow.mjs --all      every page (only after a big change; do not repeat it daily)
//   node scripts/indexnow.mjs --dry-run  list what would be sent, send nothing, remember nothing
//   node scripts/indexnow.mjs --mark-sent  remember the current dates as sent, send nothing
// What was sent is kept in .indexnow-sent.json (gitignored), so a redeploy with no changes sends
// nothing. Engines ask sites to report only real changes and can ignore sites that repeat themselves.
// With no record yet, it falls back to pages dated in the last 3 days.
// The key is public on purpose: it is served at /<key>.txt so the engines can check this site sent it.
import { readFileSync, writeFileSync } from 'node:fs';
import { resolve } from 'node:path';

const KEY = '7113fd36d678f630e4b99d7db575853a';
const HOST = 'sarankumar.dev';
const root = resolve(import.meta.dirname, '..');
const STATE = resolve(root, '.indexnow-sent.json');
const args = process.argv.slice(2);
const all = args.includes('--all');
const dry = args.includes('--dry-run');
const mark = args.includes('--mark-sent');
const daysArg = args.includes('--days') ? Number(args[args.indexOf('--days') + 1]) : NaN;

let xml;
try {
  xml = readFileSync(resolve(root, 'dist/sitemap-0.xml'), 'utf8');
} catch {
  console.error('No dist/sitemap-0.xml. Run npm run build first.');
  process.exit(1);
}
const pages = [...xml.matchAll(/<url><loc>([^<]+)<\/loc>(?:<lastmod>([^<]+)<\/lastmod>)?/g)].map(([, loc, lastmod]) => ({
  loc,
  lastmod: lastmod ?? '',
}));

let sent = null;
try {
  sent = JSON.parse(readFileSync(STATE, 'utf8'));
} catch {}

/** Remember every page's current date, so the next run sends only what changes after this. */
function remember() {
  const next = { ...(sent ?? {}) };
  for (const p of pages) next[p.loc] = p.lastmod;
  writeFileSync(STATE, JSON.stringify(next, null, 2) + '\n');
}

if (mark) {
  remember();
  console.log(`Marked ${pages.length} page(s) as sent. Nothing was sent.`);
  process.exit(0);
}

const windowDays = Number.isFinite(daysArg) && daysArg > 0 ? daysArg : sent ? null : 3;
const since = windowDays ? Date.now() - windowDays * 86_400_000 : 0;
const urls = pages
  .filter((p) => {
    if (all) return true;
    if (windowDays) return p.lastmod && Date.parse(p.lastmod) >= since;
    return sent[p.loc] !== p.lastmod; // new page, or its date moved since the last send
  })
  .map((p) => p.loc);

if (urls.length === 0) {
  console.log(
    windowDays
      ? `Nothing changed in the last ${windowDays} days. Use --days or --all to send more.`
      : 'Nothing changed since the last send. Use --days or --all to send anyway.',
  );
  if (!dry && !sent) remember();
  process.exit(0);
}
console.log(`${dry ? 'Would send' : 'Sending'} ${urls.length} URL(s):\n  ${urls.join('\n  ')}`);
if (dry) process.exit(0);

const res = await fetch('https://api.indexnow.org/indexnow', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json; charset=utf-8' },
  body: JSON.stringify({ host: HOST, key: KEY, keyLocation: `https://${HOST}/${KEY}.txt`, urlList: urls }),
});
// 200 and 202 both mean accepted; 403 means the key file is not live yet (deploy first)
console.log(`IndexNow answered ${res.status} ${res.statusText}`);
if (!res.ok) process.exit(1);
remember();
