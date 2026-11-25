/**
 * One page per service at /services/<slug>, so each can be found for what a client actually searches
 * ("Flutter app development", "fix my Flutter app") instead of one page trying to rank for everything.
 * Facts here come from the case studies, the posts and the services page. There is no public price list,
 * so no prices: the cost question always says how a quote is made.
 */
export type Service = {
  slug: string;
  /** short name, used in cards and breadcrumbs */
  name: string;
  /** <title>, kept to about 60 characters */
  metaTitle: string;
  /** meta description, under 160 characters */
  description: string;
  /** schema.org serviceType */
  serviceType: string;
  ic: string;
  c1: string;
  c2: string;
  /** the /contact?need= value that starts the right message */
  need: string;
  h1: string;
  /** the part of the heading shown in the accent colour */
  h1em: string;
  lede: string;
  forWho: string[];
  youGet: string[];
  steps: { title: string; text: string }[];
  /** case study slugs that show this work */
  projects: string[];
  /** blog post slugs on the same subject */
  posts: string[];
  faqs: [string, string][];
  /** the same page in Tamil, shown when the visitor picks தமிழ் (same order as the English lists) */
  ta: {
    name: string;
    h1: string;
    h1em: string;
    lede: string;
    forWho: string[];
    youGet: string[];
    steps: { title: string; text: string }[];
    faqs: [string, string][];
  };
};

const QUOTE: [string, string] = [
  'How much does it cost?',
  'There is no public price list, because it depends on the screens, the backend and what the app connects to. After a short call you get the scope and a quote in writing, either a fixed price or an hourly rate.',
];

const QUOTE_TA: [string, string] = [
  'செலவு எவ்வளவு?',
  'பொதுவான விலைப்பட்டியல் இல்லை; திரைகள், backend, செயலி இணையும் சேவைகள் ஆகியவற்றைப் பொறுத்தது. ஒரு சிறிய அழைப்புக்குப் பிறகு, வேலையின் அளவையும் விலையையும் (நிலையான விலை அல்லது மணிநேரக் கட்டணம்) எழுத்துப்பூர்வமாகப் பெறுவீர்கள்.',
];

export const SERVICES: Service[] = [
  {
    slug: 'flutter-app-development',
    name: 'Flutter app development',
    metaTitle: 'Flutter app development in Tamil Nadu, India | Sarankumar G',
    description:
      'Android, iOS and web apps from one Flutter codebase, built offline-first and released to Google Play and the App Store. Freelance, from Tamil Nadu, India.',
    serviceType: 'Mobile app development',
    ic: 'app',
    c1: '#027dfd',
    c2: '#13b9fd',
    need: 'app',
    h1: 'Flutter apps for Android, iOS',
    h1em: 'and the web.',
    lede: 'One codebase, three platforms, released to the stores. Built in Tamil Nadu, India, so it still works with no signal and the next feature is easy to add.',
    forWho: [
      'A business or startup that needs its first app, on both Android and iOS.',
      'A school, club or company that needs an app for its own people: admins, staff, members or parents.',
      'A team with a web product that now needs a mobile app next to it.',
    ],
    youGet: [
      'Android and iOS apps from one Flutter codebase, plus a web build when it helps',
      'Offline-first storage: changes are saved on the phone first and synced later',
      'Camera, OCR, biometrics and push notifications where the app needs them',
      'Test builds you can install and try while the app is being built',
      'Store listing and release on Google Play and the App Store',
      'The source code, which is yours once the work is paid for',
    ],
    steps: [
      { title: 'Discover', text: 'A short call about the goal, the users and the budget. You get the scope in writing.' },
      { title: 'Design', text: 'The key screens and flows are agreed before any code is written.' },
      { title: 'Build', text: 'Regular builds you can install and try, so feedback comes early.' },
      { title: 'Ship and support', text: 'Store release, analytics, and fixes after launch.' },
    ],
    projects: ['sports-booking-app', 'finwise', 'nallhub', 'nirai'],
    posts: ['before-you-hire-an-app-developer', 'live-flutter-demos-with-fake-data', 'nirai-drive-sync-no-backend'],
    faqs: [
      [
        'Why Flutter instead of separate Android and iOS apps?',
        'One codebase runs on Android, iOS and the web. Features ship on both phones at the same time, and there is one app to maintain instead of two.',
      ],
      [
        'Can the app work without internet?',
        'Yes. Most of my apps are offline-first: every change is saved on the phone first and synced when there is a connection. FinWise and Nirai work this way.',
      ],
      [
        'Will you publish it to the Play Store and App Store?',
        'Yes. Store release is part of the work. The store accounts should be in your name, and I can walk you through creating them.',
      ],
      ['Who owns the code?', 'You do, once the work is paid for.'],
      QUOTE,
      ['Do you work with clients outside India?', 'Yes. I work remotely from Tamil Nadu, India, with clients anywhere.'],
    ],
    ta: {
      name: 'Flutter செயலி உருவாக்கம்',
      h1: 'Android, iOS மற்றும் இணையத்துக்கான',
      h1em: 'Flutter செயலிகள்.',
      lede: 'ஒரே codebase, மூன்று தளங்கள், ஸ்டோர்களில் வெளியீடு. தமிழ்நாட்டில் உருவாக்கப்படுகிறது; இணைய இணைப்பு இல்லாதபோதும் இயங்கும்படியும், அடுத்த அம்சத்தை எளிதாகச் சேர்க்கும்படியும்.',
      forWho: [
        'Android, iOS இரண்டிலும் முதல் செயலி தேவைப்படும் நிறுவனம் அல்லது ஸ்டார்ட்அப்.',
        'தன் சொந்த நபர்களுக்காக (நிர்வாகிகள், பணியாளர்கள், உறுப்பினர்கள், பெற்றோர்) ஒரு செயலி தேவைப்படும் பள்ளி, கிளப் அல்லது நிறுவனம்.',
        'ஏற்கனவே ஒரு இணையத் தயாரிப்பு உள்ள, இப்போது அதனுடன் ஒரு மொபைல் செயலியும் தேவைப்படும் குழு.',
      ],
      youGet: [
        'ஒரே Flutter codebase-இலிருந்து Android, iOS செயலிகள்; தேவைப்பட்டால் இணையப் பதிப்பும்',
        'Offline-first சேமிப்பு: ஒவ்வொரு மாற்றமும் முதலில் கைப்பேசியில் சேமிக்கப்பட்டு, பின்னர் ஒத்திசைக்கப்படும்',
        'செயலிக்குத் தேவையான இடங்களில் கேமரா, OCR, பயோமெட்ரிக்ஸ், அறிவிப்புகள் (push notifications)',
        'உருவாக்கும்போதே நிறுவிப் பயன்படுத்திப் பார்க்கக்கூடிய சோதனைப் பதிப்புகள்',
        'Google Play, App Store-இல் பட்டியலிடலும் வெளியீடும்',
        'மூலக் குறியீடு (source code): பணம் செலுத்தியதும் அது உங்களுடையது',
      ],
      steps: [
        { title: 'புரிந்துகொள்ளல்', text: 'இலக்கு, பயனர்கள், பட்ஜெட் பற்றி ஒரு சிறிய அழைப்பு. வேலையின் அளவை எழுத்துப்பூர்வமாகப் பெறுவீர்கள்.' },
        { title: 'வடிவமைப்பு', text: 'எந்தக் குறியீடும் எழுதுவதற்கு முன்பே முக்கியத் திரைகளும் பயன்பாட்டு ஓட்டங்களும் ஒப்புக்கொள்ளப்படும்.' },
        { title: 'உருவாக்கம்', text: 'நிறுவிப் பார்க்கக்கூடிய பதிப்புகள் தொடர்ந்து வரும்; அதனால் உங்கள் கருத்து முன்கூட்டியே கிடைக்கும்.' },
        { title: 'வெளியீடும் ஆதரவும்', text: 'ஸ்டோர் வெளியீடு, பகுப்பாய்வு (analytics), வெளியீட்டுக்குப் பிறகான திருத்தங்கள்.' },
      ],
      faqs: [
        ['தனித்தனி Android, iOS செயலிகளுக்குப் பதிலாக ஏன் Flutter?', 'ஒரே codebase Android, iOS, இணையம் மூன்றிலும் இயங்கும். அம்சங்கள் இரண்டு கைப்பேசிகளிலும் ஒரே நேரத்தில் வெளியாகும்; பராமரிக்க இரண்டு செயலிகள் அல்ல, ஒன்றுதான்.'],
        ['இணைய இணைப்பு இல்லாமலும் செயலி இயங்குமா?', 'ஆம். என் பெரும்பாலான செயலிகள் offline-first: ஒவ்வொரு மாற்றமும் முதலில் கைப்பேசியில் சேமிக்கப்பட்டு, இணைப்பு கிடைக்கும்போது ஒத்திசைக்கப்படும். FinWise, Nirai இப்படித்தான் இயங்குகின்றன.'],
        ['Play Store, App Store-இல் நீங்களே வெளியிடுவீர்களா?', 'ஆம். ஸ்டோர் வெளியீடும் வேலையின் ஒரு பகுதி. ஸ்டோர் கணக்குகள் உங்கள் பெயரில் இருக்க வேண்டும்; அவற்றை உருவாக்க நான் வழிகாட்டுவேன்.'],
        ['குறியீடு யாருக்குச் சொந்தம்?', 'பணம் செலுத்தியதும் உங்களுக்குத்தான்.'],
        QUOTE_TA,
        ['இந்தியாவுக்கு வெளியே உள்ள வாடிக்கையாளர்களுடனும் வேலை செய்வீர்களா?', 'ஆம். தமிழ்நாட்டிலிருந்து தொலைதூரமாக (remote), எங்கிருக்கும் வாடிக்கையாளர்களுடனும் வேலை செய்கிறேன்.'],
      ],
    },
  },
  {
    slug: 'web-development',
    name: 'Web development',
    metaTitle: 'Web developer: React, Next.js and Astro sites | Sarankumar G',
    description:
      'Fast websites and web apps in React, Next.js, Astro and Flutter web, with the backend behind them. Web developer in Tamil Nadu, India, for clients anywhere.',
    serviceType: 'Web development',
    ic: 'web',
    c1: '#a855f7',
    c2: '#ec4899',
    need: 'web',
    h1: 'Websites and web apps',
    h1em: 'that load fast.',
    lede: 'Websites that search engines can read, and web apps with sign-in and real data behind them. Built with React, Next.js, Astro or Flutter web, depending on the job.',
    forWho: [
      'A business that needs a fast website that shows up in search.',
      'A product that needs a web app or admin dashboard next to its mobile app.',
      'A Flutter app that should also run in the browser.',
    ],
    youGet: [
      'Websites built as real HTML pages with Astro or Next.js, so search engines can read every word',
      'Web apps and dashboards in React, Next.js or Flutter web',
      'A title, description and structured data on every page, plus a sitemap',
      'Sign-in, database and APIs with Supabase, Firebase, Node.js or FastAPI',
      'Layouts checked on phones, tablets and wide screens',
      'Hosting on Firebase Hosting with your own domain',
    ],
    steps: [
      { title: 'Discover', text: 'A short call about the goal, the visitors and the budget. You get the scope in writing.' },
      { title: 'Design', text: 'The key pages and flows are agreed before any code is written.' },
      { title: 'Build', text: 'Preview links you can open and share while the site is being built.' },
      { title: 'Launch', text: 'Your domain, hosting, sitemap and Search Console set up, then fixes after launch.' },
    ],
    projects: ['nallhub', 'finwise'],
    posts: ['flutter-web-seo', 'live-flutter-demos-with-fake-data'],
    faqs: [
      [
        'React, Next.js, Astro or Flutter web?',
        'For pages that need to be found in search, real HTML pages: Astro or Next.js. For a web app behind a sign-in, React or Flutter web. Flutter web makes most sense when you already have a Flutter mobile app and want the same app in the browser.',
      ],
      [
        'Will the site show up on Google?',
        'It is built so search engines can read every page: real HTML, a title and description per page, structured data and a sitemap. Where it ranks also depends on your content and on other sites linking to you, so nobody can honestly promise a position.',
      ],
      [
        'Do you have an example?',
        'This website: Astro, real HTML pages, a sitemap and structured data, with a home page of about 20 KB. NallHub and FinWise also run as web apps, and you can try their demos.',
      ],
      ['Who owns the site and the domain?', 'You do. The domain and hosting accounts should be in your name; I set them up with you.'],
      QUOTE,
    ],
    ta: {
      name: 'இணைய உருவாக்கம்',
      h1: 'வேகமாகத் திறக்கும்',
      h1em: 'இணையதளங்களும் இணையச் செயலிகளும்.',
      lede: 'தேடுபொறிகள் படிக்கக்கூடிய இணையதளங்கள், உள்நுழைவும் உண்மையான தரவும் கொண்ட இணையச் செயலிகள். வேலையைப் பொறுத்து React, Next.js, Astro அல்லது Flutter web கொண்டு உருவாக்கப்படுகின்றன.',
      forWho: [
        'தேடலில் தெரியும் வேகமான இணையதளம் தேவைப்படும் நிறுவனம்.',
        'மொபைல் செயலியுடன் ஒரு இணையச் செயலி அல்லது நிர்வாக dashboard தேவைப்படும் தயாரிப்பு.',
        'உலாவியிலும் இயங்க வேண்டிய ஒரு Flutter செயலி.',
      ],
      youGet: [
        'Astro அல்லது Next.js கொண்டு உண்மையான HTML பக்கங்களாக உருவாக்கப்படும் இணையதளங்கள்; தேடுபொறிகள் ஒவ்வொரு சொல்லையும் படிக்கும்',
        'React, Next.js அல்லது Flutter web-இல் இணையச் செயலிகளும் dashboard-களும்',
        'ஒவ்வொரு பக்கத்துக்கும் தலைப்பு, விளக்கம், structured data; கூடவே sitemap',
        'Supabase, Firebase, Node.js அல்லது FastAPI கொண்டு உள்நுழைவு, தரவுத்தளம், API-கள்',
        'கைப்பேசி, டேப்லெட், அகலத் திரைகள் அனைத்திலும் சரிபார்க்கப்பட்ட வடிவமைப்பு',
        'உங்கள் சொந்த domain-உடன் Firebase Hosting',
      ],
      steps: [
        { title: 'புரிந்துகொள்ளல்', text: 'இலக்கு, பார்வையாளர்கள், பட்ஜெட் பற்றி ஒரு சிறிய அழைப்பு. வேலையின் அளவை எழுத்துப்பூர்வமாகப் பெறுவீர்கள்.' },
        { title: 'வடிவமைப்பு', text: 'எந்தக் குறியீடும் எழுதுவதற்கு முன்பே முக்கியப் பக்கங்களும் பயன்பாட்டு ஓட்டங்களும் ஒப்புக்கொள்ளப்படும்.' },
        { title: 'உருவாக்கம்', text: 'உருவாக்கும்போதே திறந்து பார்க்கவும் பகிரவும் முன்னோட்ட இணைப்புகள்.' },
        { title: 'வெளியீடு', text: 'உங்கள் domain, hosting, sitemap, Search Console அமைப்பு; பின்னர் வெளியீட்டுக்குப் பிறகான திருத்தங்கள்.' },
      ],
      faqs: [
        ['React, Next.js, Astro அல்லது Flutter web: எது?', 'தேடலில் கண்டுபிடிக்கப்பட வேண்டிய பக்கங்களுக்கு உண்மையான HTML பக்கங்கள்: Astro அல்லது Next.js. உள்நுழைவுக்குப் பின்னால் உள்ள இணையச் செயலிக்கு React அல்லது Flutter web. ஏற்கனவே ஒரு Flutter மொபைல் செயலி இருந்து, அதையே உலாவியிலும் வேண்டுமென்றால் Flutter web மிகப் பொருத்தம்.'],
        ['தளம் Google-இல் தெரியுமா?', 'ஒவ்வொரு பக்கத்தையும் தேடுபொறிகள் படிக்கும்படி உருவாக்கப்படுகிறது: உண்மையான HTML, ஒவ்வொரு பக்கத்துக்கும் தலைப்பும் விளக்கமும், structured data, sitemap. தேடலில் எந்த இடம் என்பது உங்கள் உள்ளடக்கத்தையும், பிற தளங்கள் உங்களை இணைப்பதையும் பொறுத்தது; எனவே குறிப்பிட்ட இடத்தை யாரும் நேர்மையாக உறுதியளிக்க முடியாது.'],
        ['ஏதாவது உதாரணம் உண்டா?', 'இந்த இணையதளமே: Astro, உண்மையான HTML பக்கங்கள், sitemap, structured data; முகப்புப் பக்கம் சுமார் 20 KB. NallHub, FinWise இரண்டும் இணையச் செயலிகளாகவும் இயங்குகின்றன; அவற்றின் demo-க்களை முயன்று பார்க்கலாம்.'],
        ['தளமும் domain-உம் யாருக்குச் சொந்தம்?', 'உங்களுக்குத்தான். Domain, hosting கணக்குகள் உங்கள் பெயரில் இருக்க வேண்டும்; அவற்றை உங்களுடன் சேர்ந்து அமைக்கிறேன்.'],
        QUOTE_TA,
      ],
    },
  },
  {
    slug: 'backend-development',
    name: 'Backend development',
    metaTitle: 'Backend for apps: Supabase, Firebase, Node.js | Sarankumar G',
    description:
      'Sign-in, a database with proper security rules, and APIs your app can rely on. Supabase, Firebase, Node.js and FastAPI, built by someone who builds apps too.',
    serviceType: 'Backend development',
    ic: 'db',
    c1: '#0f9d58',
    c2: '#2bb673',
    need: 'backend',
    h1: 'The backend your app',
    h1em: 'can rely on.',
    lede: 'Sign-in, a database where each user only sees their own data, and APIs that keep secret keys off the phone. Built by someone who also builds the app that calls it.',
    forWho: [
      'An app that needs accounts, shared data or sync between devices.',
      'An app that calls a paid API and should not carry the key inside it.',
      'A product used by several organisations, where each one must only see its own data.',
    ],
    youGet: [
      'Supabase: Postgres, Auth, row-level security and Edge Functions',
      'Firebase, including sign-in and push notifications',
      'Node.js and Express, or FastAPI (Python), APIs',
      'Security rules in the database itself, not only in the app',
      'Caching and rate limits in front of slow or paid services',
      'Sync between the phone and the server, including deletes',
    ],
    steps: [
      { title: 'Map the data', text: 'Who can see and change what. This decides the tables and the security rules.' },
      { title: 'Pick the platform', text: 'Supabase, Firebase or a small API of your own, depending on the data and the app.' },
      { title: 'Build and test', text: 'The rules and APIs come with tests, so a later change cannot quietly open up data.' },
      { title: 'Connect the app', text: 'Wire it into the app, with offline storage and sync where the app needs it.' },
    ],
    projects: ['nallhub', 'coin18', 'finwise'],
    posts: ['never-put-api-keys-in-a-mobile-app', 'finwise-soft-delete-drift', 'nirai-drive-sync-no-backend'],
    faqs: [
      [
        'Supabase or Firebase?',
        'Both work well. Supabase fits data that is relational and needs per-user or per-organisation rules in the database, like NallHub, where each school only sees its own rows. Firebase fits apps that lean on its other Google services, like push notifications. We choose after looking at your data.',
      ],
      [
        'Why not call the API straight from the app?',
        'Anything shipped inside an app can be pulled out of it, including API keys. A small server in the middle holds the key and can cache the answers. Coin18 works this way.',
      ],
      [
        'Can you build only the backend?',
        'Yes. If you already have an app, or a team building it, I can build the server side and the API it calls.',
      ],
      QUOTE,
    ],
    ta: {
      name: 'Backend உருவாக்கம்',
      h1: 'உங்கள் செயலி',
      h1em: 'நம்பியிருக்கக்கூடிய backend.',
      lede: 'உள்நுழைவு, ஒவ்வொரு பயனரும் தன் தரவை மட்டுமே காணும் தரவுத்தளம், ரகசியச் சாவிகளைக் கைப்பேசியிலிருந்து விலக்கி வைக்கும் API-கள். அவற்றை அழைக்கும் செயலியையும் உருவாக்கும் ஒருவரால் கட்டப்படுகிறது.',
      forWho: [
        'கணக்குகள், பகிரப்பட்ட தரவு அல்லது சாதனங்களுக்கு இடையே ஒத்திசைவு தேவைப்படும் செயலி.',
        'கட்டணம் செலுத்தும் API-ஐ அழைக்கும், அதன் சாவியைத் தனக்குள் வைத்திருக்கக் கூடாத செயலி.',
        'பல நிறுவனங்கள் பயன்படுத்தும், ஒவ்வொன்றும் தன் தரவை மட்டுமே காண வேண்டிய தயாரிப்பு.',
      ],
      youGet: [
        'Supabase: Postgres, Auth, row-level security, Edge Functions',
        'Firebase: உள்நுழைவும் அறிவிப்புகளும் (push notifications) உட்பட',
        'Node.js, Express அல்லது FastAPI (Python) API-கள்',
        'பாதுகாப்பு விதிகள் செயலியில் மட்டுமல்ல, தரவுத்தளத்திலேயே',
        'மெதுவான அல்லது கட்டணச் சேவைகளுக்கு முன்னால் caching, rate limits',
        'கைப்பேசிக்கும் சர்வருக்கும் இடையே ஒத்திசைவு, நீக்கல்கள் உட்பட',
      ],
      steps: [
        { title: 'தரவை வரையறுத்தல்', text: 'யார் எதைப் பார்க்கலாம், மாற்றலாம். இதுவே அட்டவணைகளையும் பாதுகாப்பு விதிகளையும் தீர்மானிக்கிறது.' },
        { title: 'தளத்தைத் தேர்வு செய்தல்', text: 'தரவையும் செயலியையும் பொறுத்து Supabase, Firebase, அல்லது உங்களுக்கான ஒரு சிறிய API.' },
        { title: 'உருவாக்கமும் சோதனையும்', text: 'விதிகளும் API-களும் சோதனைகளுடன் வரும்; அதனால் பிற்காலத்தில் வரும் ஒரு மாற்றம் தரவை அமைதியாகத் திறந்துவிட முடியாது.' },
        { title: 'செயலியுடன் இணைத்தல்', text: 'தேவையான இடங்களில் offline சேமிப்பும் ஒத்திசைவும் சேர்த்து, செயலியுடன் இணைக்கப்படும்.' },
      ],
      faqs: [
        ['Supabase-ஆ, Firebase-ஆ?', 'இரண்டுமே நன்றாக வேலை செய்யும். தரவு ஒன்றோடொன்று தொடர்புடையதாக (relational) இருந்து, ஒவ்வொரு பயனருக்கும் அல்லது நிறுவனத்துக்கும் தரவுத்தளத்திலேயே விதிகள் தேவைப்படும்போது Supabase பொருந்தும்; NallHub-இல் ஒவ்வொரு பள்ளியும் தன் தரவை மட்டுமே காண்கிறது. Push notifications போன்ற பிற Google சேவைகளை அதிகம் சார்ந்த செயலிகளுக்கு Firebase பொருந்தும். உங்கள் தரவைப் பார்த்த பிறகு தேர்வு செய்வோம்.'],
        ['API-ஐ ஏன் செயலியிலிருந்தே நேரடியாக அழைக்கக் கூடாது?', 'செயலிக்குள் அனுப்பப்படும் எதையும், API சாவிகள் உட்பட, வெளியே எடுத்துவிட முடியும். நடுவில் உள்ள ஒரு சிறிய சர்வர் சாவியை வைத்திருக்கும்; பதில்களை cache செய்யவும் முடியும். Coin18 இப்படித்தான் இயங்குகிறது.'],
        ['Backend மட்டும் உருவாக்கித் தருவீர்களா?', 'ஆம். உங்களிடம் ஏற்கனவே செயலி இருந்தால், அல்லது அதை ஒரு குழு உருவாக்கினால், சர்வர் பக்கத்தையும் அது அழைக்கும் API-யையும் நான் உருவாக்குவேன்.'],
        QUOTE_TA,
      ],
    },
  },
  {
    slug: 'flutter-app-rescue',
    name: 'Flutter app rescue',
    metaTitle: 'Flutter app rescue: fix a slow or buggy app | Sarankumar G',
    description:
      'Have a Flutter app that is slow, crashes or is hard to change? I audit it, fix the worst problems first, and add tests so they stay fixed.',
    serviceType: 'Software maintenance',
    ic: 'bolt',
    c1: '#ff6a3d',
    c2: '#ffb020',
    need: 'rescue',
    h1: 'Fix the Flutter app',
    h1em: 'you already have.',
    lede: 'Slow screens, crashes, layouts that break on some phones, code nobody wants to touch. I find the worst problems first and fix them, without a rewrite unless it is really needed.',
    forWho: [
      'An app that is live but slow, crashes, or gets bad reviews.',
      'An app built by someone who is no longer around, that now needs changes.',
      'A team that wants a second opinion before a big release.',
    ],
    youGet: [
      'A written audit: what is wrong, how bad it is, and what to fix first',
      'Performance and layout fixes, including on small screens',
      'Bug and crash fixes, worst first',
      'Code cleanup where it blocks the next feature',
      'Tests around what was fixed, so it stays fixed',
      'Plain technical advice on what to do next',
    ],
    steps: [
      { title: 'Access', text: 'The code, a build that runs, and the list of what users complain about.' },
      { title: 'Audit', text: 'I read the code and run the app, then send a written list ordered by impact.' },
      { title: 'Fix', text: 'The worst problems first, on an hourly basis, with a short note on each fix.' },
      { title: 'Keep it fixed', text: 'Tests around the fixes, so the same problem does not come back.' },
    ],
    projects: ['nirai', 'nallhub', 'clean-scanner'],
    posts: ['clean-scanner-ml-kit', 'finwise-soft-delete-drift'],
    faqs: [
      ['Can you work on an app someone else wrote?', 'Yes, that is what this is for. The first step is always reading the code and writing down what I find.'],
      [
        'Do we need to rewrite it?',
        'Usually not. Most problems can be fixed in place, worst first. A rewrite is only worth it when the audit shows that fixing would cost more than starting again.',
      ],
      ['How is it billed?', 'Usually hourly, because it is hard to know the full size of the problem until the code is open. You see the audit before any fixing starts.'],
      ['What do you need from me?', 'Access to the code, a build that runs, and the problems users report. Store and crash-report access helps too.'],
    ],
    ta: {
      name: 'Flutter செயலி மீட்பு',
      h1: 'உங்களிடம் ஏற்கனவே உள்ள',
      h1em: 'Flutter செயலியைச் சரிசெய்வோம்.',
      lede: 'மெதுவான திரைகள், crash-கள், சில கைப்பேசிகளில் உடையும் வடிவமைப்புகள், யாரும் தொட விரும்பாத குறியீடு. மிக மோசமான பிரச்சினைகளை முதலில் கண்டுபிடித்துச் சரிசெய்கிறேன்; உண்மையிலேயே தேவைப்பட்டால் மட்டுமே முழுதாக மீண்டும் எழுதுவது.',
      forWho: [
        'வெளியாகியிருக்கும், ஆனால் மெதுவாக இயங்கும், crash ஆகும், அல்லது மோசமான மதிப்புரைகள் பெறும் செயலி.',
        'இப்போது உடன் இல்லாத ஒருவர் உருவாக்கிய, இப்போது மாற்றங்கள் தேவைப்படும் செயலி.',
        'பெரிய வெளியீட்டுக்கு முன் இரண்டாவது கருத்தை விரும்பும் குழு.',
      ],
      youGet: [
        'எழுத்துப்பூர்வத் தணிக்கை: என்ன தவறு, எவ்வளவு மோசம், எதை முதலில் சரிசெய்ய வேண்டும்',
        'வேகம், வடிவமைப்புத் திருத்தங்கள், சிறிய திரைகளிலும்',
        'பிழைகள், crash-கள் திருத்தம், மோசமானவை முதலில்',
        'அடுத்த அம்சத்தைத் தடுக்கும் இடங்களில் குறியீட்டைச் சீரமைத்தல்',
        'சரிசெய்தவை அப்படியே இருக்க, அவற்றைச் சுற்றிச் சோதனைகள்',
        'அடுத்து என்ன செய்வது என்பதற்கு எளிய தொழில்நுட்ப ஆலோசனை',
      ],
      steps: [
        { title: 'அணுகல்', text: 'குறியீடு, இயங்கும் ஒரு build, பயனர்கள் சொல்லும் புகார்களின் பட்டியல்.' },
        { title: 'தணிக்கை', text: 'குறியீட்டைப் படித்து, செயலியை இயக்கிப் பார்த்து, பாதிப்பின் அடிப்படையில் வரிசைப்படுத்திய பட்டியலை எழுத்தில் அனுப்புவேன்.' },
        { title: 'திருத்தம்', text: 'மோசமான பிரச்சினைகள் முதலில், மணிநேர அடிப்படையில்; ஒவ்வொரு திருத்தத்துக்கும் ஒரு சிறு குறிப்புடன்.' },
        { title: 'நிலைத்திருக்க', text: 'அதே பிரச்சினை மீண்டும் வராமல் இருக்க, திருத்தங்களைச் சுற்றிச் சோதனைகள்.' },
      ],
      faqs: [
        ['வேறொருவர் எழுதிய செயலியில் வேலை செய்வீர்களா?', 'ஆம், இந்தச் சேவையே அதற்குத்தான். முதல் படி எப்போதும் குறியீட்டைப் படித்து, கண்டதை எழுதுவதுதான்.'],
        ['முழுவதையும் மீண்டும் எழுத வேண்டுமா?', 'பெரும்பாலும் தேவையில்லை. பெரும்பாலான பிரச்சினைகளை இருக்கும் இடத்திலேயே, மோசமானவை முதலில் என்று சரிசெய்யலாம். சரிசெய்வதைவிடப் புதிதாகத் தொடங்குவது குறைந்த செலவு என்று தணிக்கை காட்டும்போது மட்டுமே மீண்டும் எழுதுவது பயனுள்ளது.'],
        ['கட்டணம் எப்படி?', 'பொதுவாக மணிநேர அடிப்படையில்; குறியீட்டைத் திறக்கும் வரை பிரச்சினையின் முழு அளவும் தெரியாது. எந்தத் திருத்தமும் தொடங்கும் முன் தணிக்கையைப் பார்ப்பீர்கள்.'],
        ['என்னிடமிருந்து என்ன தேவை?', 'குறியீட்டுக்கான அணுகல், இயங்கும் ஒரு build, பயனர்கள் தெரிவிக்கும் பிரச்சினைகள். ஸ்டோர், crash-report அணுகலும் உதவும்.'],
      ],
    },
  },
];

export const serviceBySlug = (slug: string) => SERVICES.find((s) => s.slug === slug);
