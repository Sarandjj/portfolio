import { SITE } from '../data/site';

export type Phase = 'morning' | 'day' | 'evening' | 'night';

/** Current hour and minute in Tamil Nadu (IST). */
export function istNow() {
  const parts = new Intl.DateTimeFormat('en-GB', {
    timeZone: SITE.timeZone,
    hour: '2-digit',
    minute: '2-digit',
    hour12: false,
  }).formatToParts(new Date());
  const get = (type: string) => parts.find((p) => p.type === type)?.value ?? '00';
  const h = Number(get('hour')) % 24;
  const m = get('minute');
  return { h, m, hhmm: `${String(h).padStart(2, '0')}:${m}` };
}

export function phaseOf(h: number): Phase {
  if (h >= 5 && h < 10) return 'morning';
  if (h >= 10 && h < 17) return 'day';
  if (h >= 17 && h < 20) return 'evening';
  return 'night';
}
