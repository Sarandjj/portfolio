import type { APIRoute } from 'astro';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { getPosts } from '../lib/posts';
import { getProjects } from '../lib/projects';
import { SERVICES } from '../data/services';
import { SITE, STATUS_LABEL } from '../data/site';

/**
 * /llms-full.txt: the whole site as one plain-text file for AI assistants and answer engines.
 * /llms.txt (in public/) is the short index; this adds the full text of every service page,
 * case study and blog post, built from the same sources as the pages so it never goes stale.
 * Like llms.txt, it leaves employer names out.
 */
const strip = (md: string | undefined) =>
  (md ?? '')
    .replace(/<[^>]+>/g, '') // the odd inline HTML tag in case studies
    // nest the page's own headings under this file's "### Page" heading
    .replace(/^(#{1,4}) /gm, (_, h: string) => `${'#'.repeat(h.length + 2)} `)
    .replace(/\n{3,}/g, '\n\n')
    .trim();

const date = (d: Date) => d.toISOString().slice(0, 10);

export const GET: APIRoute = async () => {
  const index = readFileSync(join(process.cwd(), 'public/llms.txt'), 'utf8').trim();
  const posts = await getPosts();
  const projects = await getProjects();

  const services = SERVICES.map((s) =>
    [
      `### ${s.name}`,
      `URL: ${SITE.url}/services/${s.slug}`,
      '',
      s.lede,
      '',
      'Who it is for:',
      ...s.forWho.map((w) => `- ${w}`),
      '',
      'What you get:',
      ...s.youGet.map((g) => `- ${g}`),
      '',
      'How it works:',
      ...s.steps.map((st, i) => `${i + 1}. ${st.title}: ${st.text}`),
      '',
      'Questions:',
      ...s.faqs.flatMap(([q, a]) => [`- Q: ${q}`, `  A: ${a}`]),
    ].join('\n'),
  ).join('\n\n');

  const cases = projects
    .map(({ id, data: p, body }) =>
      [
        `### ${p.name}: ${p.kind}`,
        `URL: ${SITE.url}/projects/${id}`,
        `Status: ${STATUS_LABEL[p.status]}. Platforms: ${p.platforms}. Stack: ${p.stack.join(', ')}.`,
        ...(p.role ? [`Role: ${p.role}`] : []),
        ...(p.links.length ? [`Links: ${p.links.map((l) => `${l.label} ${l.url}`).join('; ')}`] : []),
        ...(p.demo ? [`Live demo with made-up data: ${p.demo.url}`] : []),
        '',
        p.summary,
        '',
        'Works today:',
        ...p.works.map((w) => `- ${w}`),
        '',
        strip(body),
      ].join('\n'),
    )
    .join('\n\n');

  const notes = posts
    .map(({ id, data: p, body }) =>
      [
        `### ${p.title}`,
        `URL: ${SITE.url}/blog/${id}`,
        `Published: ${date(p.date)}${p.updated ? `. Updated: ${date(p.updated)}` : ''}. Topics: ${p.tags.join(', ')}.`,
        '',
        p.description,
        '',
        strip(body),
      ].join('\n'),
    )
    .join('\n\n');

  const body = `${index}

---

# Full text

Everything below is the text of the pages on ${SITE.url}, generated from the same sources when the site is built.

## Services

${services}

## Case studies

${cases}

## Blog posts

${notes}
`;
  return new Response(body, { headers: { 'Content-Type': 'text/plain; charset=utf-8' } });
};
