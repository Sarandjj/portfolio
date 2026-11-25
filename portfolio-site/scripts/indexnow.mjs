// Tells IndexNow search engines (Bing, Yandex, Seznam, Naver; Bing passes it on to Copilot and the
// tools built on its index) which pages changed, so they are crawled within hours instead of weeks.
// Run it after a deploy:
//   node scripts/indexnow.mjs            pages whose sitemap date is in the last 3 days
//   node scripts/indexnow.mjs --days 14  a longer window
//   node scripts/indexnow.mjs --all      every page (only after a big change; do not repeat it daily)
//   node scripts/indexnow.mjs --dry-run  list what would be sent, send nothing
// The key is public on purpose: it is served at /<key>.txt so the engines can check this site sent it.
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const KEY = '7113fd36d678f630e4b99d7db575853a';
const HOST = 'sarankumar.dev';
const root = resolve(import.meta.dirname, '..');
const args = process.argv.slice(2);
const all = args.includes('--all');
const dry = args.includes('--dry-run');
const days = Number(args[args.indexOf('--days') + 1]) || 3;

let xml;
try {
  xml = readFileSync(resolve(root, 'dist/sitemap-0.xml'), 'utf8');
} catch {
  console.error('No dist/sitemap-0.xml. Run npm run build first.');
  process.exit(1);
}
const since = Date.now() - days * 86_400_000;
const urls = [...xml.matchAll(/<url><loc>([^<]+)<\/loc>(?:<lastmod>([^<]+)<\/lastmod>)?/g)]
  .filter(([, , lastmod]) => all || (lastmod && Date.parse(lastmod) >= since))
  .map(([, loc]) => loc);

if (urls.length === 0) {
  console.log(`Nothing changed in the last ${days} days. Use --days or --all to send more.`);
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
