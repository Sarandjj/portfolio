// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwindcss from '@tailwindcss/vite';

// https://astro.build/config
export default defineConfig({
  site: 'https://sarankumar.dev',
  // /about (no slash, no .html) is the canonical URL form; firebase.json matches it
  trailingSlash: 'never',
  build: { format: 'file' },
  integrations: [
    sitemap({
      // the 404 page must not be in the sitemap
      filter: (page) => !page.includes('/404'),
      // tells crawlers the sitemap is fresh each deploy
      lastmod: new Date(),
    }),
  ],
  vite: { plugins: [tailwindcss()] },
});
