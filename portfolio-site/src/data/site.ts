export const SITE = {
  name: 'Sarankumar G',
  url: 'https://sarankumar.dev',
  title: 'Sarankumar G | Flutter, React & Mobile App Developer in India',
  description:
    'Sarankumar G builds fast, offline-first mobile and web apps with Flutter, React, Firebase, Supabase, Node.js and FastAPI. Full stack developer based in Tamil Nadu, India, open to freelance projects.',
  email: 'sarankumarg.in@gmail.com',
  github: 'https://github.com/Sarandjj',
  linkedin: 'https://www.linkedin.com/in/sarankuamr-g',
  locale: 'en_IN',
  timeZone: 'Asia/Kolkata',
} as const;

export const NAV = [
  { label: 'Work', href: '/projects' },
  { label: 'Services', href: '/services' },
  { label: 'Blog', href: '/blog' },
  { label: 'About', href: '/about' },
  { label: 'Contact', href: '/contact' },
] as const;

/** Contact form endpoint (Formspree). Same endpoint the old site used. */
export const FORM_ENDPOINT = 'https://formspree.io/f/xgvzozra';

export type Status = 'live' | 'beta' | 'progress';

export const STATUS_LABEL: Record<Status, string> = {
  live: 'Live',
  beta: 'Beta',
  progress: 'In progress',
};
