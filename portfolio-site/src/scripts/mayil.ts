import { istNow, phaseOf } from './time';

const mayils = [...document.querySelectorAll<SVGElement>('svg.mayil')];

/** Mayil sleeps at night in Tamil Nadu. */
export function setSleep(asleep: boolean) {
  mayils.forEach((k) => k.classList.toggle('sleep', asleep));
}
setSleep(phaseOf(istNow().h) === 'night');

// eyes follow the cursor
if (mayils.length && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
  addEventListener(
    'mousemove',
    (e) => {
      for (const k of mayils) {
        const r = k.getBoundingClientRect();
        const dx = e.clientX - (r.left + r.width / 2);
        const dy = e.clientY - (r.top + r.height * 0.34);
        const d = Math.hypot(dx, dy) || 1;
        const m = Math.min(4.5, d / 40);
        const ox = (dx / d) * m;
        const oy = (dy / d) * m;
        k.querySelector('[data-eye="l"]')?.setAttribute('cx', String(49 + ox));
        k.querySelector('[data-eye="l"]')?.setAttribute('cy', String(48 + oy));
        k.querySelector('[data-eye="r"]')?.setAttribute('cx', String(71 + ox));
        k.querySelector('[data-eye="r"]')?.setAttribute('cy', String(48 + oy));
      }
    },
    { passive: true },
  );
}

export const isAsleep = () => mayils.some((k) => k.classList.contains('sleep'));
