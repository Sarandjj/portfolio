# sarankumar.dev (new site)

Astro + self-hosted fonts, deployed as static files to Firebase Hosting at https://sarankumar.dev.
It replaced the old Flutter web portfolio, which has been removed from this repo (it is still in git history).
The plan it was built from is in `../prototype/PLAN.md`.

Build with **Node 22 or newer** (Astro refuses older versions).

## Commands

```bash
npm install
npm run dev        # http://localhost:4321
npm run build      # static site into dist/
npm run preview    # serve dist/ locally (what Firebase will serve)
node scripts/make-og.mjs   # re-render every share image (public/og/) with headless Chrome
node scripts/make-og.mjs pages               # only about, contact, projects, services, recruiter
node scripts/make-og.mjs posts <slug> <slug> # only these blog posts (do this for every new post)
npm run deploy     # build, deploy to Firebase, then tell IndexNow (Bing and others) which pages changed
npm run indexnow -- --dry-run   # list the pages IndexNow would be told about, send nothing
```

Deploy (not done yet, needs Saran's go-ahead):

```bash
npm run build
firebase hosting:channel:deploy phase1 --expires 7d   # private preview URL first
firebase deploy --only hosting                         # production, only after approval
```

## Where things live

| Path | What |
|---|---|
| `src/data/services.ts` | The three service pages at /services/<slug>: copy, steps, related work, FAQ |
| `src/pages/llms-full.txt.ts` | /llms-full.txt, the full text of the site for AI assistants, built from the same content |
| `src/data/site.ts` | Name, email, links, nav, form endpoint, status labels, planned posts |
| `src/content/projects/*.md` | The 5 case studies. Frontmatter = status, stack, "works today", numbers, architecture steps, `todo` list. Body = the story |
| `src/pages/index.astro` | Home page sections |
| `src/pages/404.astro` | Kili 404 page (real 404 status) |
| `src/layouts/Base.astro` | `<head>`: title, description, canonical, Open Graph, Twitter, JSON-LD slot, theme script |
| `src/components/` | Nav, Footer, CommandMenu, Kili (mascot), Phone (apps, sky, windows) |
| `src/scripts/` | `ui.ts` (theme, reveal, copy, ⌘K), `home.ts` (sky, Kili talk, phone, terminal, hover preview), `kili.ts`, `time.ts` |
| `src/styles/` | `global.css` (tokens, nav, buttons), `home.css` (home sections) |
| `public/` | Icons, `og/default.png`, `robots.txt`, `site.webmanifest`, `.well-known/security.txt` |
| `firebase.json` | Hosting: clean URLs, no slash, headers, cache. No catch-all rewrite, so a missing page is a real 404 |

## Content that is still a placeholder or needs Saran's OK

- Project **statuses** (all set to "In progress") and the "works today" lists: written from each repo, confirm them.
- "How I work" section copy is draft and marked with a visible tag. Remove the tag when confirmed.
- "Available for freelance" in the hero.
- Blog titles are planned posts, not written yet.
- No photo, WhatsApp or Calendly yet. No analytics yet (decision pending: GA4 or a privacy-friendly tool).
- Each case study has orange `placeholder` tags where Saran's own words are needed, and its frontmatter `todo:` lists what is missing (screenshots, status, links).
- `/about`: photo and story are placeholders; work history, education and the CV download are real (CV source in `cv/`; the public PDF in `public/` has no phone number, `cv/Sarankumar-G-CV-with-phone.pdf` is for sending to people directly); "How I like to build" is draft.
- `/services`: engagement types and FAQ answers are draft.
- `/contact`: posts to the Formspree endpoint in `src/data/site.ts`. Validation, the `?topic=` prefill and the success state were tested with a mocked request. **No real message has been sent yet**, so send one test message after deploy.

## Flutter demos (Phase 3)

A demo is a real Flutter web build with fake data (no real backend, accounts or data), shown in the phone on a case study page
(`DemoPhone.astro`, click to launch). Each demo lives in **its own app's repo and its own Firebase project**, as a second
hosting site named `<project>-demo`, so the app's real site is never touched. It must be served at the root of its own origin:
Drift's web database does not start from a sub-path such as `/demos/finwise/`.

| App | Demo site | Firebase project | Config (in the app's repo) |
|---|---|---|---|
| FinWise | https://finwise-managermoney-demo.web.app | `finwise-managermoney` | `finwise/firebase.demo.json`, branch `portfolio-demo` |
| NallHub | https://nallhub-demo.web.app | `nallhub` | `nallhub/firebase.demo.json`, branch `portfolio-demo` (in-memory fake backend in `lib/core/demo/`, tests in `test/demo/`) |
| Nirai | https://nirai-managetask-demo.web.app | `nirai-managetask` | `Nirai_todo/firebase.demo.json`, branch `portfolio-demo` (in-memory database, sqlite3.wasm in `web/`) |

FinWise rebuild and deploy:

```bash
cd ~/personal/finwise
flutter build web --release --pwa-strategy=none --dart-define=DEMO_MODE=true --output=build/web_demo
firebase deploy --only hosting --config firebase.demo.json
```

Then the case study frontmatter (`src/content/projects/finwise.md`) has:

```yaml
demo:
  url: https://finwise-managermoney-demo.web.app/
  note: ...
```

The demo sites send `frame-ancestors 'self' https://sarankumar.dev https://*.web.app` and `X-Robots-Tag: noindex`.
Visitors' data lives in their own browser; "More > Reset demo data" inside the FinWise demo restores the sample data.

## Notes

- Tailwind is installed for theme + preflight only. Its utility classes are off because hand-written class names
  (`ring`, `border`, `filter`) collided with them. Turn on `tailwindcss/utilities.css` in `global.css` if you
  start writing Tailwind classes.
- `security.txt` expiry was renewed to 2027-10-26 (the old one expired 2026-07-20).
- URL form is `/about` (no slash, no `.html`): `astro.config.mjs` (`trailingSlash: 'never'`, `build.format: 'file'`) and
  `firebase.json` (`cleanUrls`, `trailingSlash: false`) must stay in agreement.
