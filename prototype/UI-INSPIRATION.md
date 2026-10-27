# UI/UX study: 18 sites, and what we take from them

Date: 2026-10-27. Every site below was opened and scrolled in a browser. Notes are what is actually on the page.

---

## 1. Developer portfolios (the 5 that matter most)

| Site | The one big idea | Details worth taking |
|---|---|---|
| **anzalabidi.dev** | A moonlit museum. A classical night-sea painting is the hero, the type is an elegant serif, and the colours are warm dark brown and candle orange. | Life told as **five chapters** with Roman numerals (I Copying, II Proving, III Shipping, IV Leading, V Building), each with dates, roles and **one lesson line** in italics. Projects are **"FIG 1, FIG 2" technical drawings** in an engraved style, each with **one measured proof** ("0 differences in 800,000 fuzzed comparisons"). "Open to new work" dot, **"Book a call · Tomorrow 9:00 AM"** (shows the next free slot), Resume, icon links. A tiny character sits in the corner. |
| **shanesation.tech** | A journey from **morning to night**. The sky turns from day to night across the hero, and a character rides a bicycle along a road with stops from "classroom" to "home". | Opens with a short animated intro. Offers **two ways through: "Take the ride"** (scenic, about 3 minutes, with music) **or "Recruiter view"** (express lane, everything on one page, "about 1 minute"). Each card states the time it takes. |
| **v2.kidus-yohannes.engineer** | An **explorable pixel-art home**. A cosy living room you can click around, with rooms (Living room, Study, Den, Workshop, Porch). | "Click anything that sparkles", a **"Found 0 / 31" counter** that turns the site into a little game, and a **"Plain site" link** top right for people who just want the facts. |
| **fireflybuilds.netlify.app** | Dark, quiet and personal. | Serif italic name, an illustrated avatar, a **hanging ID badge you can "pull"** (string physics), a **"chat" item in the nav**, and very large real product screenshots for each project with the stack underneath. |
| **harshitr.me** | An **engineer's notebook**: graph-paper background, thin technical frames with crop marks, mono labels. | A **playable pixel football game** in the banner ("Play me"), a **view counter**, ⌘K, a "Developer snapshot" box, project cards styled as a **camera viewfinder ("REC · ISO 400 · LIVE")**, project filters, and a project that is itself a RAG assistant answering questions about the developer. |

**What all five share:** one clear concept that runs through the whole site, a real personality, and at least one thing you can play with. Two of them also give a fast "plain" path for recruiters.

## 2. UI kit and component sites (for techniques, not for copying)

| Site | What stands out |
|---|---|
| **originkit.dev** | A library of animated backgrounds: particle tornado, accretion disc, glimmering field, cloud sky, ribbon glow, coverflow gallery. A modal pops up on first visit, which is annoying. |
| **atelier-ui.com** | "Premium handcrafted" headline with a mixed serif italic word and a hammer emoji, dashed frames with **small square corner markers**, a component preview inside a fake browser window, a scrolling logo strip of the stack. |
| **pixel-perfect.space** | Black, technical grid with coordinates printed in the corners ("x: 0, y: 0"), a big 3D logo shape, components shown in a tight grid of tiles. |
| **ui.soralabs.studio** | "Copy the source. Ship the polish." Clean catalogue of **scroll effects**: Scroll Chapters, Sticky Scroll Cards, Text Reveal Box, Cursor Trail Reveal, Infinite Scrolling Images. An "Ask AI" button bottom right. |
| **cuedesign.space** | Light, airy catalogue with filter chips and tags, a small doodle character next to the call to action. Also opens with a modal. |

## 3. App icon galleries (for your apps' icons)

iconsclub.xyz, icon.museum, iosicongallery.com, macosicongallery.com, asoinspo.com/logos, logosystem.co/app-icons, recent.design/app-icons, bestdesignsonx.com/app-icons.

What the best icons do:
- **One bold idea per icon**: a single symbol, letter or character, recognisable at 40 px.
- **A strong background colour** that becomes the app's brand colour.
- **Depth and material**: soft lighting, gentle highlights, glass or paper textures, objects that look touchable.
- **Characters with faces** stand out (ghosts, blobs, animals).
- **Presentation matters**: icon.museum sits icons on little shelves with a shadow, recent.design adds a soft reflection. Icons look precious when they are displayed like objects.

---

## 4. Honest comparison with our site

**What we already do well:** fast (Lighthouse 99 to 100), honest case studies with real numbers, live demos inside a phone, structured data, accessibility, a clear site map.

**Where we fall short:**
1. **No single concept.** A parrot, a phone, a bento grid and a cream-and-orange palette do not tell one story. The look (Geist with an Instrument Serif italic word, bento cards) is now very common.
2. **No fast path for recruiters.** Everything assumes the visitor will scroll and read.
3. **Projects look like placeholders.** Emoji tiles and grey phone frames, while the best sites show real screenshots, technical drawings or one measured proof per project.
4. **All five of our own apps use the default Flutter icon** (checked in each repo's `android/app/src/main/res/mipmap-xxxhdpi`). This is the biggest gap: it matters for the site and for the store release.
5. **The story is flat.** The About timeline lists jobs; Anzal tells chapters with a lesson in each.
6. **Nothing to play with** apart from the parrot's eyes.
7. **No call booking or "next free slot".**

---

## 5. Proposal: one concept, "Pearl City"

Make the whole site one world built from where you are from. Thoothukudi is known as the Pearl City, and "turning ideas into pearls" is a fitting line for someone who finishes products.

1. **Hero: a living harbour scene**, drawn in code (SVG and CSS, the same technique as the NallHub living sky): sea, a lighthouse, a boat, a moon or sun. It follows the visitor's local time (morning, day, evening, night), like Shane's site, without the heavy 3D.
2. **Mascot: Muthu the pearl**, small and quiet, living in a shell on the shore. Click the shell and it opens.
3. **Two ways in**, side by side under your name:
   - **"Take the tour"**: the full site.
   - **"Recruiter view · 1 minute"**: one page with role, stack, the two store apps, CV download and contact.
   Plus a "Plain site" link for people who turn animations off.
4. **The journey in chapters** on About, Anzal-style: I Learning (B.Sc), II Shipping (Digisailor, apps on both stores), III Building full stack (Neural Schema IT), IV My own products (FinWise, Nirai, NallHub). Each with one lesson line in your words.
5. **Projects as "pearls" on a shelf**: the real app icon (once designed) on a little shelf like icon.museum, then a card with **one measured proof** we already have (447 tests, 0 servers, 42.5 MB of a 60 MB budget, 4.2 ms frames), and real screenshots.
6. **Technical detailing** borrowed from the notebook sites: thin frames with corner markers and "FIG 1" labels around architecture diagrams.
7. **One small game**: "Find the 7 pearls", one hidden on each project page, with a counter in the corner (Kidus's idea, light version).
8. **"Ask" in the nav**: the guided Q&A box from the plan, later an AI version.
9. **"Open to work" and a booking link** showing the next free slot (needs a Cal.com or Calendly account from you).
10. **New type**: a calm serif for headings (instead of the common Instrument Serif italic) and a clean sans for text, with mono for labels.

**Palette:** pearl white, deep ocean ink, teal, and a coral accent, with a dark "night harbour" mode.

**What we do not copy:** first-visit pop-ups (originkit, cue), multi-minute 3D tours, heavy WebGL backgrounds on every page, and pixel-art scenes that need an illustrator. Everything stays fast and works without animations.

## 6. App icons (for the site and the stores)

Design a real icon for each app, following the galleries: one bold symbol, one brand colour, soft depth.

| App | Icon idea | Colour |
|---|---|---|
| FinWise | A leaf folded into a rupee-like curve, or a coin with a leaf | Green |
| Nirai | A single check mark inside a full circle ("nirai" means fullness) | Teal |
| NallHub | A small owl (Nalli, already the app's mascot) | Warm orange |
| Coin18 | A coin with "18" or a rising line | Gold |
| Clean Scanner | A page with a sparkle, or scan corners around a page | Mint |

Then generate the launcher icons for Android and iOS from one 1024 px source per app.

## 7. Order of work

1. App icons for the five apps (needed for the stores anyway).
2. New palette, type and hero scene with the two ways in.
3. Recruiter view page.
4. Projects as a shelf, with one proof each.
5. Journey in chapters on About.
6. Muthu and "Find the 7 pearls".
7. "Ask" box, booking link.
