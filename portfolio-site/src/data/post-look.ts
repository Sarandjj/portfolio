/** Each blog post wears the icon and colours of the app it is about (used on the blog list and the home page). */
const APP: Record<string, { g: string; c1: string; c2: string }> = {
  'before-you-hire-an-app-developer': { g: 'hire', c1: '#ff6a3d', c2: '#ffb020' },
  'clean-scanner-ml-kit': { g: 'clean-scanner', c1: '#0ea58f', c2: '#22d3b6' },
  'finwise-soft-delete-drift': { g: 'finwise', c1: '#2bb673', c2: '#0e8a7a' },
  'never-put-api-keys-in-a-mobile-app': { g: 'coin18', c1: '#ffb020', c2: '#ff7a1a' },
  'nirai-drive-sync-no-backend': { g: 'nirai', c1: '#4f7bff', c2: '#7a4dff' },
};
export const postLook = (id: string) => APP[id] ?? { g: 'writing', c1: '#c08a2b', c2: '#d4501e' };
