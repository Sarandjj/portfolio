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
        const dy = e.clientY - (r.top + r.height * 0.28);
        const d = Math.hypot(dx, dy) || 1;
        const m = Math.min(1.1, d / 120);
        const ox = (dx / d) * m;
        const oy = (dy / d) * m;
        k.querySelectorAll<SVGCircleElement>('.pupil').forEach((p) => {
          p.setAttribute('cx', String(Number(p.dataset.cx) + ox));
          p.setAttribute('cy', String(Number(p.dataset.cy) + oy));
        });
      }
    },
    { passive: true },
  );
}

export const isAsleep = () => mayils.some((k) => k.classList.contains('sleep'));
