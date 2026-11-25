import { getImage } from 'astro:assets';
import type { ImageMetadata } from 'astro';

/**
 * App screenshots live in src/assets/shots/ so Astro can turn them into small WebP files with
 * content-hashed names under /_astro/ (cached for a year). Content files keep plain paths such as
 * "/shots/finwise/home.jpg"; this maps a path to its optimised versions.
 */
const files = import.meta.glob<{ default: ImageMetadata }>('../assets/shots/**/*.{jpg,jpeg,png,webp}', { eager: true });

export type Shot = { src: string; srcset?: string; width: number; height: number };

/** The screenshot at `path`, as WebP in a few widths (shown at 120 to 210 CSS px, so up to 540 for sharp screens). */
export async function shot(path: string, widths = [240, 420, 540]): Promise<Shot> {
  const mod = files[`../assets${path}`];
  if (!mod) return { src: path, width: 540, height: 979 }; // not in assets: serve it as it is
  const img = await getImage({ src: mod.default, widths, format: 'webp' });
  return {
    src: img.src,
    srcset: img.srcSet.attribute,
    width: mod.default.width,
    height: mod.default.height,
  };
}

/** Every screenshot of a project, optimised, keeping its alt text. */
export const shots = (list: { src: string; alt: string }[]) =>
  Promise.all(list.map(async (s) => ({ ...(await shot(s.src)), alt: s.alt })));
