# Next plan: blog reset, keywords, new mascot, chatbot

Date: 2026-10-27. Written after the site reached about 85% (build and case studies done, preview only).

---

## 1. Blog reset: more interesting, more useful

**Why the first three posts feel flat.** They are written from inside the project ("how Nirai syncs", "FinWise cascades"). They are accurate, but a stranger searching Google or asking an AI never types those titles. Good posts start from the reader's problem, give an answer fast, and prove it with something real from your work.

**Two lanes, two readers**

| Lane | Reader | What they want |
|---|---|---|
| A. For people who need an app | School owners, small business owners, startup founders | Plain answers: what to build first, how long, what can go wrong, how to choose a developer |
| B. For developers | Flutter and backend developers, recruiters | Working solutions with real code and honest trade-offs |

Lane A is what turns visitors into messages. Lane B is what earns links and shows depth. Aim for about 1 post in A for every 1 in B.

**Post ideas (titles written the way people search)**

Lane A, for clients:
1. How long does it take to build a mobile app? (what changes the answer)
2. Flutter or native: which should a small business choose?
3. The 7 things to have ready before you hire an app developer
4. How to put your app on the Google Play Store and App Store: a plain checklist
5. Does your school need its own app? What to look for in school management software
6. Why your app should work offline (and what it costs to do it right)

Lane B, for developers:
7. Flutter and Supabase: keeping every customer's data separate with row-level security (NallHub)
8. Why you should never put an API key inside a mobile app (Coin18's server in the middle)
9. Offline-first in Flutter: the pattern, the traps, and a checklist (from Nirai and FinWise)
10. Testing a Flutter app in Tamil, with big text and on small screens
11. Making a Flutter app feel smooth on a 120 Hz phone: three real fixes with before and after numbers (Nirai)
12. Flutter vs React for a web app: how I choose (honest, with the cases for each)

The three existing posts stay, but I would retitle and rework them to follow the new format (problem first, short answer at the top, then the proof).

**Format rules for every post**
- A one-paragraph answer at the top (this is what search and AI tools quote).
- One real example, number or screenshot from your own work. Nothing invented.
- A short checklist or "do this" box.
- A source link and a date for any outside fact.
- "Updated on" date, and update the post when facts change.
- You read and approve before it goes live.

**Rhythm.** Two posts first, then one every two to three weeks. News notes are optional and short. Quality over volume.

---

## 2. Keywords (to aim at, not guaranteed)

I have no search-volume data yet, so these are targets based on how people phrase it. After launch, Search Console shows what really brings people in, and we adjust.

| Group | Example phrases | Where they go |
|---|---|---|
| Hiring | Flutter developer in India, hire Flutter developer, freelance Flutter developer, full stack developer Tamil Nadu, React developer India, FastAPI developer | Home, Services, About |
| Local | app developer Thoothukudi, mobile app developer Tamil Nadu | Services, About, Contact |
| Client problems | how long to build a mobile app, Flutter vs native for business, school management app Tamil Nadu, offline mobile app | Lane A posts, Services FAQ |
| Developer problems | Flutter offline first sync, Supabase row level security multi tenant, Flutter API key security, Flutter Tamil localization, Flutter jank 120 Hz | Lane B posts, case studies |
| Questions people ask AI | who builds offline-first Flutter apps, Flutter developer who has apps on both stores | `llms.txt`, About, Services FAQ |
| Brand | Sarankumar G, sarankumar.dev | Home, About |

Rules: one main phrase per page, in the title, the first heading and the first paragraph. No keyword stuffing. Do not claim "best" or "top". Check each phrase in Google's autocomplete and "People also ask" before writing a post for it.

---

## 3. A new mascot

**Honest view.** Kili the parrot works technically (eyes follow the cursor, it sleeps at night) but the character itself does not say anything about you. A mascot is also optional. Many strong portfolios use a simple mark instead. If none of the options below feels right, we skip the mascot and keep a clean logotype.

**Options**

| Option | Idea | Why it could work | Risk |
|---|---|---|---|
| **A. Muthu the pearl** (recommended) | A small pearl peeking out of a shell. "Muthu" means pearl in Tamil. Thoothukudi is known as the Pearl City. | True to where you are from, memorable, easy to draw in a few shapes, and it fits your story: turning ideas into finished products | Needs to look charming, not like a sticker |
| B. A simpler Kili | Same parrot (kili is Tamil for parrot) redrawn flatter and calmer | Keeps what exists | Still a generic bird |
| C. "Pocket", a tiny phone with a face | A phone-shaped character whose screen shows its mood | Obvious tie to mobile apps | Common idea, many developers use it |
| D. No mascot | A bold name mark with small motion | Cleanest, most grown-up | Less personality |

**Where Muthu would live (small and quiet, never blocking content)**
- The shell opens when a page loads, or as the loading state.
- The 404 page: "This page isn't in the shell."
- The contact form success: the pearl shines.
- About page next to your photo.
- Reduced-motion: a still image.

**How I would do it.** I draw 3 quick SVG mockups of Muthu (and one of D) for you to choose from. Then I build the one you pick in plain SVG and CSS, with a still version for people who turn animations off, and remove Kili.

---

## 4. A chatbot

**Is it worth it?** Only if it helps a visitor decide to contact you. A bad bot (wrong answers, made-up prices) hurts more than no bot. So I would build it in two levels.

| Level | What it is | Cost and risk |
|---|---|---|
| 0. Already there | The ⌘K command menu | None |
| **1. Guided "Ask" box** (recommended first) | A small chat-style box with ready-made questions: "What do you build?", "Are you available?", "How do we start?", "Show me an offline app". Answers are written by us, with links, and it ends at the contact form. | No AI, no cost, no wrong answers. About a day of work. |
| 2. AI assistant | Free-text questions answered by an AI model that only knows your site content (`llms.txt`, case studies, services). | Needs your Anthropic API account and billing, a small server function, and safeguards (below). Per-message cost is small but not zero. |

**If we build Level 2, the rules**
- The API key lives only on the server (a Firebase Cloud Function in your own project), never in the browser.
- It answers only from your published content, and says "I don't know, please message Saran" otherwise.
- It never states prices, dates or promises. It never discloses client names or private details.
- Limits per visitor and a hard daily and monthly spending cap, with a billing alert.
- A visible notice that it is an AI assistant, and no chat logs stored unless you decide to.
- A "Talk to Saran" button that fills the contact form. The visitor reviews it before sending.
- Test it against tricky inputs (asking for prices, trying to make it ignore its rules) before it goes live.

**My recommendation.** Build Level 1 after launch. Once analytics shows what visitors ask, build Level 2 only if people actually want to ask free-form questions. If you want the AI version right away because it impresses recruiters, it is a fair choice. Say so and we do it with the rules above.

---

## 5. Order of work

1. Analytics (GA4, consent banner, events). About an hour. Needs nothing from you.
2. Mascot mockups. You pick, I build.
3. Blog reset: rework the 3 posts and write 2 new ones (one per lane). I draft, you approve.
4. Apply the keywords: titles and descriptions on Home, Services, About and the posts.
5. Guided "Ask" box.
6. Screenshots for Nirai, NallHub, Coin18 and Clean Scanner.
7. Launch (needs your explicit OK): domain, Search Console, Bing, profile links.

Still needed from you: Coin18 notes (if you have a case study file), which first two posts you want, and your pick of mascot.
