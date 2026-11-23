export const SITE = {
  name: 'Sarankumar G',
  url: 'https://sarankumar.dev',
  title: 'Sarankumar G | Flutter, React & Mobile App Developer in India',
  // keep meta descriptions under ~160 characters, or Google cuts them off
  description:
    'Sarankumar G builds fast, offline-first mobile and web apps with Flutter, React, Firebase and Node.js. Freelance full-stack developer in Tamil Nadu, India.',
  email: 'sarankumarg.in@gmail.com',
  github: 'https://github.com/Sarandjj',
  linkedin: 'https://www.linkedin.com/in/sarankuamr-g',
  locale: 'en_IN',
  timeZone: 'Asia/Kolkata',
} as const;

/**
 * Who the site is about, as schema.org data. Google reads structured data one page at a time, so a bare
 * { '@id' } pointing at the home page is not enough: use PERSON where a page is about Saran
 * (home, about, recruiter) and PERSON_REF for author, publisher and provider fields.
 */
export const PERSON_REF = {
  '@type': 'Person',
  '@id': `${SITE.url}/#person`,
  name: SITE.name,
  url: SITE.url,
} as const;

export const PERSON = {
  ...PERSON_REF,
  jobTitle: 'Mobile and full-stack developer',
  description:
    'Mobile and full-stack developer from Tamil Nadu, India, building offline-first apps with Flutter, React, Firebase, Supabase, Node.js and FastAPI.',
  email: SITE.email,
  address: { '@type': 'PostalAddress', addressLocality: 'Kovilpatti', addressRegion: 'Tamil Nadu', addressCountry: 'IN' },
  alumniOf: { '@type': 'CollegeOrUniversity', name: 'Sri S. Ramasamy Naidu Memorial College, Sattur' },
  sameAs: [SITE.github, SITE.linkedin],
  knowsAbout: ['Flutter', 'Dart', 'React', 'Firebase', 'Supabase', 'Node.js', 'FastAPI', 'Python', 'Offline-first apps', 'Mobile app development'],
} as const;

/** Google Analytics 4 / Firebase web app measurement ID (portfolio web app). Loaded only after a visitor accepts. */
export const GA_ID = 'G-8YMR3RP8RJ';

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
