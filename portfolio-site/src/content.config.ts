import { defineCollection } from 'astro:content';
import { glob } from 'astro/loaders';
import { z } from 'astro/zod';

const projects = defineCollection({
  loader: glob({ pattern: '*.md', base: './src/content/projects' }),
  schema: z.object({
    name: z.string(),
    kind: z.string(),
    summary: z.string(),
    /** what Saran did on it, shown under the title. Used for client work. */
    role: z.string().optional(),
    status: z.enum(['live', 'beta', 'progress']),
    platforms: z.string(),
    stack: z.array(z.string()),
    /** only things that exist in the repo today */
    works: z.array(z.string()),
    emoji: z.string(),
    c1: z.string(),
    c2: z.string(),
    order: z.number(),
    /** drives the filter chips on /projects */
    tags: z.array(z.enum(['mobile', 'web', 'backend'])),
    /** only numbers that can be checked in the repo or its docs */
    numbers: z.array(z.object({ value: z.string(), label: z.string() })).default([]),
    architecture: z
      .object({
        title: z.string(),
        steps: z.array(z.object({ label: z.string(), note: z.string() })),
      })
      .optional(),
    /** store or product links; when present they replace the "get notified" button */
    links: z.array(z.object({ label: z.string(), url: z.string() })).default([]),
    /** A live Flutter web build with fake data, shown inside a phone on the case study page */
    demo: z
      .object({
        url: z.string(),
        /** shown under the phone */
        note: z.string(),
      })
      .optional(),
    /** what Saran still needs to provide (not shown on the page, listed in README) */
    todo: z.array(z.string()).default([]),
  }),
});

const posts = defineCollection({
  loader: glob({ pattern: '*.md', base: './src/content/posts' }),
  schema: z.object({
    title: z.string(),
    /** one or two sentences, also used as the meta description */
    description: z.string(),
    date: z.coerce.date(),
    /** the project this post comes from (a slug in src/content/projects) */
    project: z.string(),
    tags: z.array(z.string()).default([]),
    /** false until Saran has read it and changed anything that is not how he would say it */
    reviewed: z.boolean().default(false),
  }),
});

export const collections = { projects, posts };
