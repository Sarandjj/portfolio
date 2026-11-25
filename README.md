# sarankumar.dev

Source for [sarankumar.dev](https://sarankumar.dev), the portfolio and blog of Sarankumar G.

| Folder | What |
|---|---|
| [`portfolio-site/`](portfolio-site/) | The live site: Astro, static HTML, deployed to Firebase Hosting. Start with its README. |
| [`prototype/`](prototype/) | The HTML design prototype and the plan the site was built from. |

```bash
cd portfolio-site
npm install
npm run dev                         # http://localhost:4321
npm run build                       # static site in dist/ (Node 22+)
firebase deploy --only hosting      # run from portfolio-site/, never from the repo root
```

Writing a new blog post: add `portfolio-site/src/content/posts/<slug>.md`, give it colours in
`src/data/post-look.ts`, render its share image with `node scripts/make-og.mjs posts <slug>`,
and add a line for it in `public/llms.txt`.

The live demos of FinWise, NallHub and Nirai live in those apps' own repositories (branch `portfolio-demo`).
The old Flutter web version of this portfolio was removed; it is in the git history before this change.
