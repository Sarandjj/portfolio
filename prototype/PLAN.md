# Sarankumar G: New Portfolio, Full Plan

Status: draft v1 · written 2026-10-26 · design prototype: `prototype/index.html`

---

## 0. Summary

**Goal.** Replace the current Flutter-web portfolio with a fast, searchable, multi-page site that shows Sarankumar as a **mobile and full-stack developer who ships real products**, not only "a Flutter developer". The site should (a) rank for his name and a few realistic niche searches, (b) make clients and recruiters trust him within 10 seconds, and (c) let visitors *use* his work, not just read about it.

**The one big idea.** A working phone on the home page. Each real app is an icon on it. Tap an icon and the app opens (live demo with fake data, or a short video). A parrot mascot, **Kili**, lives on it, and the wallpaper sky follows Tamil Nadu time.

**Stack in one line.** Astro + Tailwind (static HTML, almost no JavaScript) on Firebase Hosting, Flutter web demos on their own sub-sites, Formspree for the contact form, Search Console + a privacy-friendly analytics tool.

**Rough timeline.** 5–6 weeks part-time. Estimates are approximate and depend mostly on how fast content and demo builds are ready.

**What this plan will not promise.** No guaranteed rankings, traffic or clients. The plan sets up everything search engines and people reward; results depend on content over time.

---

## 1. Where we are today (audit of https://sarankumar.dev)

| # | Finding | Impact |
|---|---|---|
| 1 | The page body is a Flutter canvas, so **search engines see almost no text** (page text is empty). | Biggest ranking problem |
| 2 | Only a hidden `<noscript>` block and meta tags describe the site. The noscript text contains literal `**bold**` markdown stars. | Looks broken if indexed |
| 3 | `/icons/og-image.png`, `/icons/twitter-image.png`, `/icons/Icon-192.png` and the sitemap image return **HTML instead of images** (Firebase rewrite sends everything to index.html). | Broken link previews on LinkedIn, WhatsApp, X |
| 4 | `main.dart.js` is **2.1 MB** (612 KB gzipped) plus a 3-second fake loading screen. | Slow first view |
| 5 | Project buttons only `debugPrint`, they open nothing. Projects are placeholders (`github.com/example/...`). | No proof of work |
| 6 | Experience says "Senior Flutter Developer" with a blank company, while the page says "2+ years". | Credibility gap |
| 7 | Sitemap lists **one URL**. | One page can rank for one thing |
| 8 | Keyword-stuffing meta tags (`keywords`, `revisit-after`, `geo.*`, `ICBM`) and `Crawl-delay` are ignored by Google. robots.txt has a duplicate `Allow: /` and comments that don't match its rules. | Noise, no benefit |
| 9 | The repo carries android/ios/linux/macos/windows folders that never ship. | Clutter |
| 10 | Good already: HTTPS + HSTS, security headers, `security.txt`, GA tag, structured data present. | Keep |

**Real assets found in `~/personal`** (all five GitHub repos are private; none has a public live demo today):

| App | What it is | Stack highlights | Evidence |
|---|---|---|---|
| **FinWise** | Personal finance tracker: trips, groups, settle-up, import | Flutter, Riverpod, Drift, Supabase sync, Google Drive sync | 341 passing tests, web build works, 28 commits |
| **Nirai** | Free, offline-first to-do app (Android + macOS) | Drift SQLite, Google Drive sync with no server, ML Kit OCR, Pomodoro, habits, natural-language quick add | 98 commits, audits, Todoist-parity test plan |
| **NallHub** | School management SaaS for private schools in Tamil Nadu | Flutter web + mobile, Supabase (23 tables), Firebase, PDF/CSV, Riverpod | 189 commits, ~350 Dart files |
| **Coin18** | Crypto research app (CoinGecko-style browsing, watchlist) | Flutter + **Node.js/Express backend on Render**, adapter layer, caching | docs, tests, deployed backend |
| **Clean Scanner** | Offline document & ID scanner, "no ads, no login" | ML Kit scanner, OCR, searchable PDF, PDF unlock, QR, in-app purchase | Android only, earlier stage |

---

## 2. Positioning

### 2.1 The message
Not "Flutter developer". Instead:

> **Mobile & full-stack developer.** I build fast, private, offline-first apps, and the backends behind them. Flutter · Firebase · Supabase · Node.js · Google Cloud.

Why it works: three of five apps share the offline-first / privacy theme (Nirai, Clean Scanner, FinWise), and Coin18 and NallHub prove the backend side. Flutter stays the headline skill, it just stops being the *only* thing.

### 2.2 Audiences (ranked)
1. **Freelance clients** in India and abroad who need an app built (startups, small businesses, schools).
2. **Recruiters / hiring managers** checking depth quickly.
3. **Other developers** who find him through blog posts and open-source work.

### 2.3 Honest framing of unfinished work
Apps are not all finished, and that is fine. Every app carries a **status badge**:

| Badge | Meaning | Rule |
|---|---|---|
| 🟢 Live | Public and usable (store or web) | Only when a real link works |
| 🟡 Beta | Works, testers welcome | Needs a real beta/testing link |
| 🔵 In progress | Being built now | Show "what already works" and "what's next" |

Never show store badges, download counts, ratings or testimonials that are not real. Anything unverified is marked `placeholder`.

### 2.4 Keyword targets (aims, not guarantees)
- **Brand:** "Sarankumar G", "Sarankumar G Flutter developer", "sarankumar.dev"
- **Service:** "freelance Flutter developer Tamil Nadu", "hire Flutter developer India", "Flutter Firebase developer India"
- **Product:** "school management app Tamil Nadu" (NallHub landing page)
- **Blog long-tail:** offline-first Flutter sync, Drift soft delete, Flutter Google Drive sync, Flutter ML Kit document scanner

Brand terms should rank quickly once the site has real text and links. Competitive terms ("Flutter developer") take months of content, so we do not chase them first.

---

## 3. Technology and architecture

### 3.1 Decision: Astro + Tailwind
- Ships HTML, so Google reads everything; near-zero JavaScript by default.
- Markdown/MDX content collections for blog posts and project case studies.
- React/Svelte "islands" only where needed (the phone, ⌘K menu, mascot).
- Static output deploys to the **existing Firebase Hosting**; the domain and DNS stay.
- Fallback option if goals change (web/React jobs, logins, database): Next.js. Moving later is possible; components port over.

### 3.2 Repo layout
Build in a **new folder** (`portfolio-site/`) so the live Flutter site keeps running until cutover. The old Flutter code stays in git history; the useful web parts (security.txt, SEO files) are ported.

```
portfolio-site/
├─ src/
│  ├─ pages/            index, about, services, contact, 404, projects/[slug], blog/[slug], uses, now
│  ├─ content/
│  │  ├─ projects/      finwise.mdx, nirai.mdx, nallhub.mdx, coin18.mdx, clean-scanner.mdx
│  │  └─ blog/          *.mdx
│  ├─ components/       Phone, Kili, SkyScene, Bento, WorkList, CommandMenu, ProjectCard, StatusBadge, ...
│  ├─ layouts/          Base.astro (SEO head), Page.astro, Post.astro
│  └─ styles/           tokens.css (colors, type), global.css
├─ public/              fonts (self-hosted), og/, icons/, robots.txt, humans.txt, .well-known/security.txt
├─ firebase.json        hosting config (headers, redirects, cache)
└─ astro.config.mjs     site: https://sarankumar.dev, sitemap integration
```

### 3.3 Hosting and domains
| Thing | Where | Notes |
|---|---|---|
| Main site | Firebase Hosting site #1 → `sarankumar.dev` | existing project `saran-portfolio-76b1f` |
| Flutter demos | Firebase Hosting extra sites → `demo-finwise.sarankumar.dev` etc. (or `/demos/...`) | separate builds, `noindex`, own cache rules |
| Contact form | Formspree (existing endpoint) | add spam protection (honeypot) and a mailto fallback |
| Analytics | Search Console + Bing Webmaster (required) + one of GA4 or Plausible | decide in §10 |
| Images | `astro:assets` → WebP/AVIF with `srcset` | |
| Fonts | Self-hosted Geist, Geist Mono, Instrument Serif | no Google Fonts request |

Cutover is done with a **Firebase preview channel first**; DNS is not touched until approval. Rollback = redeploy the previous Flutter build.

---

## 4. Site map and page specs

```
/                       Home
/projects               All projects (filters: Mobile · Web · Backend)
/projects/finwise       Case study
/projects/nirai         Case study
/projects/nallhub       Case study (+ optional landing page /school-management-app)
/projects/coin18        Case study
/projects/clean-scanner Case study
/services               What I offer, process, engagement types, FAQ
/blog                   Posts with tags, search
/blog/<slug>            Post
/about                  Story, photo, timeline, skills, CV download
/uses                   Tools and setup
/now                    What I'm building this month
/contact                Form, email, WhatsApp/Calendly, social links
/404                    Kili holding a sign
/sitemap.xml  /robots.txt  /humans.txt  /.well-known/security.txt  /rss.xml
```

### 4.1 Home (prototype already built)
1. **Nav:** name, 4 links, ⌘K, theme toggle, "Hire me".
2. **Hero:** status line (Available · Tamil Nadu · live IST time), headline, 2-sentence intro, two buttons. Right side: the phone + Kili + sky picker.
3. **Bento "Not just Flutter":** Flutter code tile, terminal (real deploy flow), local clock, score rings (real measured numbers after launch), toolbox, CTA tile.
4. **Selected work:** numbered list with hover preview (5 real apps, with status badges).
5. **How I work:** Discover → Design → Build → Ship & support.
6. **Writing:** latest 3 posts.
7. **Contact block:** huge CTA, click-to-copy email, socials.

### 4.2 Project case study template (each project)
1. Header: name, one-line summary, status badge, platforms, year, links (demo / video / store / "request access").
2. Phone/desktop demo (click-to-launch iframe) or screen-recording.
3. **The problem** and who it's for.
4. **What I built** (features that actually work today).
5. **Architecture** diagram (e.g. Nirai: phone → SQLite → Google Drive appData, no server).
6. **Hard parts and decisions** (2–3 specifics, from the project's own docs).
7. **Stack** chips and **by the numbers** (only verifiable: tests, commits, screens, tables).
8. **What's next** (roadmap line) and "Get notified" / "Join beta" button.
9. Related posts and next project.

### 4.3 Services
Three offers (mobile apps · backend & APIs · app rescue and speed), process, engagement types (fixed-price / hourly / retainer), tech list, FAQ (timeline, store publishing, maintenance, ownership of code), CTA to the contact page. **Pricing page only if Saran wants public prices**; otherwise "Get a quote" form (app type, platforms, budget range, timeline).

### 4.4 About
Photo, story (why he builds offline-first apps), real timeline (work, education, projects), skills grouped (mobile, backend, web, shipping), CV download (PDF, one page), "Currently learning".

### 4.5 Contact
Form (name, email, message, optional budget/timeline) → Formspree with honeypot; success state with Kili celebrating; direct email with copy button; WhatsApp and/or Calendly; response-time note ("within a day", shows asleep at night via the live clock).

### 4.6 Utility pages
`/uses` (laptop, editor, fonts, phones, tools), `/now` (monthly update), `/404`.

---

## 5. Design system

### 5.1 Principles (from research: Josh Comeau, Rauno, Bruno Simon, Emil Kowalski, Lee Robinson, Awwwards winners, 2026 trend reports)
1. **One signature idea, calm everywhere else** → the working phone + Kili.
2. Big, expressive type; restrained colour.
3. Motion with purpose; respect `prefers-reduced-motion`.
4. Real content and proof beat decoration.
5. Fast first: type is cheaper than images.

### 5.2 Tokens
| Token | Light | Dark |
|---|---|---|
| Paper | `#f3f0e8` | `#11110f` |
| Card | `#fbfaf6` | `#1b1b18` |
| Ink | `#141412` | `#f1ede3` |
| Muted | `#6b675e` | `#9b968a` |
| Line | `#dcd7c9` | `#2e2d28` |
| Accent | `#ff4f1f` | same (check contrast for small text) |
| Green (status) | `#2bb673` | same |

Fonts: **Geist** (UI/headlines), **Geist Mono** (labels, code), **Instrument Serif Italic** (accent words). Sizes use `clamp()` fluid scale.

### 5.3 Components to build
Nav, Button (solid/ghost), StatusBadge, Phone (with apps, widget, dock, app window), SkyScene, Kili, Bento tiles, WorkList (+ hover peek), ProjectCard, CaseStudyLayout, ArchitectureDiagram, PostCard, TOC, CodeBlock with copy button, CommandMenu (⌘K), ThemeToggle, Footer, ContactForm.

### 5.4 Kili (mascot)
- Code-drawn SVG + CSS, no image files; blinks, bobs, flaps, eyes follow cursor, speaks in a bubble.
- **Sleeps at night (IST)**; the sky and widget follow Tamil Nadu time.
- Cameos: hero (home), 404 sign, contact success, loading of demos ("warming up"), favicon, optional OG image.
- Rules: one character, few places; static pose when reduced-motion; no autoplay sound.
- Optional later: Kili + Nalli (NallHub's owl) together on the NallHub page.

### 5.5 Accessibility (built in, not added later)
- Semantic headings (one `h1` per page), landmarks, skip link.
- Phone icons are real `<button>`s with labels, focus rings, Esc to close, focus trap in the app window.
- Colour contrast AA minimum; no information by colour alone (status badges have text).
- Reduced motion, keyboard-only use, visible focus, alt text on every image, captions/transcripts for videos.
- Test with axe and a real screen reader pass before launch.

---

## 6. Content plan

### 6.1 Project copy (draft headline per app, to be confirmed by Saran)
| App | One-liner | Status (proposed) |
|---|---|---|
| FinWise | "A personal finance tracker that works offline, syncs across devices, and splits trip expenses." | 🔵 In progress (Phase 2 of N) → decide |
| Nirai | "A free, offline-first to-do app that syncs to your own Google Drive. No server, no account." | 🔵 In progress |
| NallHub | "School management for private schools in Tamil Nadu: students, fees, attendance, reports." | 🔵 In progress |
| Coin18 | "A crypto research app on a Node.js backend that hides API keys and caches market data." | 🟡/🔵 decide |
| Clean Scanner | "An offline document and ID scanner. Clean PDFs, no ads, no login." | 🔵 In progress |

Each also gets "works today" and "next" lists taken from its own docs, written and checked with Saran. **No numbers beyond what the repos prove.**

### 6.2 Blog: first 3 posts (material already in the repos' docs)
1. *Offline-first sync to Google Drive with no backend* (Nirai).
2. *Soft-delete in Drift: why SQLite `onDelete` doesn't fire on UPDATE* (FinWise).
3. *I built my own document scanner, then went back to ML Kit* (Clean Scanner).

Backlog ideas (12 months, ~1 post/month):
- Hiding API keys behind a Node adapter for a Flutter app (Coin18)
- Building a multi-role school app on Supabase and Riverpod (NallHub, without business pricing)
- Making Flutter feel fast on cheap Android phones
- Flutter web SEO: what works and what doesn't (and why this site moved off it)
- Firebase Auth mistakes to avoid
- Natural-language date parsing in Dart (companion to the pub.dev package)
- How the Kili mascot is drawn in code (SVG + CSS, and the Flutter CustomPainter version)
- Monthly "What I shipped" devlog

Post template: one-line summary, problem, steps with code, result, "what I'd do differently", related links. Reading time, TOC, copy-code buttons, tags, RSS.

### 6.3 Other content
- Bio (50, 150 and 300 word versions), headshot, one-page CV, social banner.
- Testimonials: only real ones, with permission; none shown until then.
- Press-style "Now" page updated monthly.

---

## 7. Flutter demos ("use the real app")

### 7.1 Per-app feasibility
| App | Plan | Notes / risks |
|---|---|---|
| **FinWise** | Flutter web build with **seeded demo data**, hosted as its own site | Handoff says web build works. Use a demo mode that never talks to the real Supabase. |
| **NallHub** | Web build with a demo "school" (fake students/teachers) | Needs a **separate demo Supabase project or a mock data layer**. Never expose production data or keys. |
| **Nirai** | Try a web build in demo mode; fall back to a **screen recording** | Uses Google sign-in, ML Kit, local notifications, biometric lock: several are not available on web. Demo mode disables them. |
| **Coin18** | Web build against the Render API | Free-tier backend sleeps; show a "waking the server" state or switch to cached sample data. |
| **Clean Scanner** | **Screen recording only** | Android-only (camera, ML Kit). |

### 7.2 How demos run on the site
- Phone shows a poster image; **"Tap to launch"** loads the iframe (so the home page stays light).
- Each demo is a **separate Firebase Hosting site** with its own cache rules and `noindex`; iframe uses `sandbox` and `loading="lazy"`.
- A "Reset demo" button; a banner: "Demo with sample data".
- Fallback if a demo fails to load: video + screenshots.
- Never ship API keys or real user data in demo builds. Review `env`/`firebase_options`/Supabase config before each build.

### 7.3 Demo-mode work in each app (separate small tasks in each repo)
- A compile-time flag (`--dart-define=DEMO=true`) that swaps repositories for in-memory seeded data.
- Turn off sign-in, push, camera and purchase flows in demo.
- Add a "Demo" ribbon.
- Check bundle size; use `--wasm` or tree-shaken fonts/icons where possible.

---

## 8. SEO, AEO and discoverability plan

### 8.1 Technical (done in Phase 1)
- Static HTML for every page; one `h1`; clean URLs; trailing-slash policy chosen once.
- Unique `<title>` (≤ 60 chars) and `<meta name="description">` (≤ 155 chars) per page.
- `<link rel="canonical">`, `lang`, viewport, theme-color.
- **Open Graph and Twitter cards with real 1200×630 images per page** (home, each project, each post). Verify with the LinkedIn Post Inspector and a WhatsApp share test.
- `sitemap.xml` generated for all pages with `lastmod`; submitted to Google and Bing.
- Clean `robots.txt`: allow all, point to the sitemap, **no** `Crawl-delay`, no contradictory rules; demo sites `noindex`.
- Correct 404 page (real 404 status, not a rewrite to home) and 301 redirects for any old URLs.
- Remove ignored tags (`keywords`, `revisit-after`, `geo.*`, `ICBM`).
- `rss.xml`, `humans.txt`, `security.txt` kept.
- Optional, low-evidence: `llms.txt`. Add only if it costs nothing; do not rely on it.

### 8.2 Structured data (JSON-LD, must match visible content)
- Home: `Person` (name, jobTitle, url, sameAs: GitHub, LinkedIn, store pages when real, knowsAbout) and `WebSite`.
- About: `ProfilePage`.
- Projects: `SoftwareApplication` or `CreativeWork` (only with true fields; no fake ratings).
- Blog: `BlogPosting` (author, dates, image).
- Services: `Service`/`ProfessionalService` only if details are real.
- Breadcrumbs on deep pages. Validate with Google's Rich Results Test and Schema validator.

### 8.3 On-page and content
- Each page answers one clear need; direct answer first (good for featured snippets and AI answers), details after.
- Internal links: home → projects → case studies → posts → services → contact; descriptive anchor text.
- Image alt text; descriptive filenames; WebP/AVIF.
- Author box and dates on posts; update posts when facts change.

### 8.4 Off-site
- Add the new URL to GitHub profile, LinkedIn (Featured + About + contact info), pub.dev, X, dev.to / Hashnode (cross-post with canonical pointing to his site).
- Post each case study and blog post on LinkedIn with a proper preview image.
- Optional: Google Business Profile only if operating as a local service business; otherwise skip.
- Listings that genuinely fit: GitHub README, Product Hunt (when an app is live), Indie Hackers, relevant Flutter communities.
- No link schemes or paid links.

### 8.5 Measurement
- Google Search Console and Bing Webmaster Tools: verify domain, submit sitemap, watch indexing/coverage, queries, CTR.
- After launch: check "site:sarankumar.dev", branded query ranking, and indexed page count weekly for 6 weeks, then monthly.

---

## 9. Performance and quality targets

| Metric | Target |
|---|---|
| Lighthouse (mobile) Performance / Accessibility / Best Practices / SEO | 95+ each |
| LCP | < 2.0 s on 4G mid-range phone |
| CLS | < 0.05 |
| INP | < 200 ms |
| JS shipped on a normal page | < 60 KB gzipped (Flutter demos excluded, loaded on demand) |
| Total home page weight | < 700 KB before demos |
| Contrast | WCAG AA |

Methods: self-hosted subset fonts with `font-display: swap`, image optimisation, lazy demos, no layout shift (reserve phone size), minimal third-party scripts, `Cache-Control` immutable for hashed assets, preload only the hero font.

Testing: Lighthouse CI on every deploy, axe-core, manual keyboard and screen-reader pass, real-device check (Android + iPhone), Chrome/Safari/Firefox, light/dark, reduced-motion, 320 px–1920 px widths.

---

## 10. Analytics and conversion

- Decide **GA4 (existing tag `G-8YMR3RP8RJ`) vs Plausible/Umami**. Recommended: a privacy-friendly tool for page views plus Search Console for search data; keep GA4 only if wanted. If GA4 stays, add a cookie notice appropriate for visitors.
- Track events: contact form submit, email copy, "Hire me" click, demo launch per app, CV download, outbound links, blog scroll depth.
- Goals: contact messages per month; demo launches; blog visitors from search.
- Monthly 15-minute review: top pages, top queries, what to write next.

---

## 11. Security and privacy

- Repos are private; case studies explain architecture without exposing code or secrets. Offer "request access" instead of public links.
- Do **not** publish business details from private docs (e.g. NallHub pricing) unless Saran decides to.
- Demo builds contain only demo config; never production Supabase/Firebase keys with write access; review before each build.
- Firebase/Google API keys in client apps are not secrets by themselves but must be restricted (HTTP referrers/package names) and rules/RLS must be correct. Check this for each project.
- Contact form: honeypot + Formspree spam filtering; no personal data in URLs.
- Keep security headers (HSTS, `nosniff`, frame options, referrer policy, permissions policy) and add a sensible CSP once scripts are known.
- Privacy page (short): what is collected (analytics, form), no selling of data.
- `security.txt` kept and renewed (check expiry date).
- Copyright and credits: fonts (Geist, Instrument Serif: open licences), icons, any stock images; credit where required.

---

## 12. Migration and launch

1. Build in `portfolio-site/` (never touches the live Flutter deploy).
2. Deploy to a **Firebase preview channel**; share the link for review.
3. Pre-launch checklist (see §13, Phase 5).
4. Switch production: deploy the new build to the live hosting site. Because Firebase currently rewrites `**` to `index.html`, the new `firebase.json` must **remove that rewrite** and serve a real 404.
5. Keep a copy of the old Flutter web build for rollback (and optionally publish it at `/flutter-portfolio/` as a "built with Flutter" showcase; mark `noindex`).
6. Redirect any known old URLs.
7. Submit sitemap again, request indexing for home and key pages, test share previews, update all profile links.
8. Monitor for 48 hours (errors, 404s, form delivery).

Rollback: redeploy previous release in Firebase Hosting (one click in console or `firebase hosting:rollback`).

---

## 13. Phased work plan with acceptance criteria

> Time is estimated for roughly 10–15 hours/week. "Saran" = inputs needed from him.

### Phase 0: Decisions and inputs (week 0, mostly Saran)
- [ ] Confirm positioning line and keyword aims (§2).
- [ ] Choose which apps to show, their order and status badge (§6.1).
- [ ] Provide photo, bio, real work history and education, CV text.
- [ ] Provide screenshots or short screen recordings for each app.
- [ ] Decide: services/pricing page yes/no; WhatsApp and/or Calendly; analytics tool.
- [ ] Approve demo builds with fake data.
**Done when:** a short content brief exists with every placeholder either filled or consciously left.

### Phase 1: Foundation (week 1)
- [ ] Create `portfolio-site/` Astro + Tailwind project, TypeScript, content collections.
- [ ] Port design tokens, fonts (self-hosted), layouts, theme toggle with no flash.
- [ ] Port home page: hero, Phone, Kili, SkyScene, bento, work list, process, writing, contact, footer, ⌘K.
- [ ] SEO base: `Base.astro` head, canonical, OG/Twitter, JSON-LD (`Person`, `WebSite`), sitemap, robots, humans, security.txt.
- [ ] Proper 404 page (Kili), real `firebase.json` (no catch-all rewrite), headers.
- [ ] Preview-channel deploy.
**Done when:** home page on a preview URL; Lighthouse ≥ 95 on all four; no console errors; share previews work.

### Phase 2: Pages and real content (weeks 2–3)
- [ ] Projects index + 5 case study pages from the template (placeholders marked until Saran's content arrives).
- [ ] About, Services, Contact (form + honeypot + success state), Uses, Now.
- [ ] Architecture diagrams (SVG) for Nirai, FinWise, Coin18, NallHub.
- [ ] Status badges, "Get notified"/"Join beta" buttons wired to the form.
- [ ] Image pipeline and real screenshots/videos.
- [ ] Accessibility pass (keyboard, screen reader, contrast).
**Done when:** every page reachable from navigation, no placeholder text without a visible `placeholder` marker, axe clean.

### Phase 3: Demos (weeks 3–4)
- [ ] FinWise: demo flag, seeded data, web build, hosted demo site, embedded in the phone.
- [ ] NallHub: demo flag or mock data layer, demo school data, web build, hosted.
- [ ] Nirai: demo flag + web feasibility check; else screen recording.
- [ ] Coin18: web build on the Render API with wake-up state; or recorded demo.
- [ ] Clean Scanner: recorded demo + screenshots.
- [ ] Lazy launch, reset button, demo banner, `noindex`, secrets review.
**Done when:** each app has either a working demo or a video on its page, and no real credentials are in any demo build.

### Phase 4: Blog and growth hooks (weeks 4–5)
- [ ] Blog layout, tags, RSS, TOC, code copy, reading time.
- [ ] 3 launch posts written and reviewed.
- [ ] Share images (OG) for posts.
- [ ] Newsletter signup (optional) or RSS-only.
**Done when:** 3 posts live on preview, each with correct meta and structured data.

### Phase 5: Launch (week 5–6)
- [ ] Final copy/proofread, remove or hide any unverified claim.
- [ ] Lighthouse CI, axe, cross-browser, real-device checks.
- [ ] 404/redirect check; sitemap counts; robots check; JSON-LD validation.
- [ ] Switch production hosting; keep rollback copy.
- [ ] Search Console + Bing: verify, submit sitemap, request indexing.
- [ ] Update LinkedIn, GitHub profile, pub.dev, X; post launch announcement with preview image.
- [ ] Set up analytics events and a monthly review reminder.
**Done when:** production site passes all checks and previews render correctly on LinkedIn, WhatsApp and X.

### Phase 6: Ongoing (monthly)
- [ ] One blog post or devlog per month.
- [ ] Update app statuses as they move to beta/live; add real store links and badges only when true.
- [ ] Publish a small **pub.dev package** (e.g. Nirai's natural-language date parser) with a post.
- [ ] **NallHub landing page** targeting school-management searches in Tamil Nadu.
- [ ] Add testimonials when real; Tamil/English versions of key pages (optional).
- [ ] Review Search Console monthly; improve pages with high impressions and low clicks.
- [ ] Refresh `uses`, `now`, CV and screenshots every quarter.

---

## 14. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Content is not ready, site launches with placeholders | Launch with fewer, true items (3 apps) rather than five half-filled; hide anything unverified |
| Demo builds leak real data or keys | Demo flag, separate demo backend/mock data, secrets review checklist |
| Nirai/Coin18 web demos hit plugin or hosting limits | Video fallback decided up front |
| Switch-over breaks the live domain | Preview channel + rollback + no DNS change |
| Over-designed, slow site | Perf budget in §9, Lighthouse CI blocks regressions |
| Unrealistic ranking expectations | Track branded queries first; publish steadily; never promise positions |
| Claims about unfinished apps | Status badges; "works today / next" format |
| Maintenance burden | Content in Markdown, few dependencies, scheduled quarterly review |

---

## 15. Inputs checklist for Saran

- [ ] Photo (clear, recent, square crop + one wide)
- [ ] Bio: where from, why he builds, years of experience (true numbers only)
- [ ] Work history with company names/dates; education
- [ ] For each app: status, 3 "works today" features, 2 "next" items, 3–6 screenshots or a 20–30 s video, any public links
- [ ] Services he wants to sell; price approach (public / "get a quote")
- [ ] WhatsApp number and/or Calendly link he is happy to publish
- [ ] Preferred contact email (currently kumar2004saran@gmail.com)
- [ ] Which analytics he prefers
- [ ] Anything that must stay private (e.g. NallHub pricing/customers)
- [ ] Permission to build fake-data demos

---

## 16. Open decisions

1. Astro (recommended) or Next.js?
2. Public pricing page or "get a quote" only?
3. GA4 or a privacy-friendly analytics tool?
4. Demos on sub-domains (recommended) or paths?
5. Publish the old Flutter site as a "built with Flutter" showcase?
6. Tamil + English versions now or later?
7. Which apps ship on day one (suggest FinWise, Nirai, NallHub; add Coin18 and Clean Scanner as "in progress")?

---

## 17. Success measures (check at 6 and 12 weeks)

- Lighthouse 95+ on all four scores, on every key page.
- 15+ indexed pages (vs 1 today); sitemap fully processed.
- Searching "Sarankumar G" shows the site first.
- Share previews correct on LinkedIn, WhatsApp, X.
- Contact messages received from the site each month.
- At least 3 blog posts live, and 1 new post per month after.
- Demo launches recorded for each live demo.
