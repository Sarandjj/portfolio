import { istNow, phaseOf } from './time';

const kilis = [...document.querySelectorAll<SVGElement>('svg.kili')];

/** Kili sleeps at night in Tamil Nadu. */
export function setSleep(asleep: boolean) {
  kilis.forEach((k) => k.classList.toggle('sleep', asleep));
}
setSleep(phaseOf(istNow().h) === 'night');

// eyes follow the cursor
if (kilis.length && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
  addEventListener(
    'mousemove',
    (e) => {
      for (const k of kilis) {
        const r = k.getBoundingClientRect();
        const dx = e.clientX - (r.left + r.width / 2);
        const dy = e.clientY - (r.top + r.height * 0.38);
        const d = Math.hypot(dx, dy) || 1;
        const m = Math.min(4.5, d / 40);
        const ox = (dx / d) * m;
        const oy = (dy / d) * m;
        k.querySelector('[data-eye="l"]')?.setAttribute('cx', String(46 + ox));
        k.querySelector('[data-eye="l"]')?.setAttribute('cy', String(54 + oy));
        k.querySelector('[data-eye="r"]')?.setAttribute('cx', String(74 + ox));
        k.querySelector('[data-eye="r"]')?.setAttribute('cy', String(54 + oy));
      }
    },
    { passive: true },
  );
}

export const isAsleep = () => kilis.some((k) => k.classList.contains('sleep'));
