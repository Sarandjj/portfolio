---
title: "Flutter web and SEO: why my portfolio is plain HTML now"
description: "My portfolio used to be a Flutter web app that search engines could barely read. Why I rebuilt it as plain HTML with Astro, and what each page has now."
date: 2026-11-23
tags: [Flutter web, SEO, Astro]
---

> **Short answer:** Flutter web is great for apps and a poor fit for pages that need to be found in search. Build the app in Flutter, and build the website around it (home page, case studies, blog) as plain HTML. I use Astro for that.

I build apps in Flutter, so my first portfolio was a Flutter web app too. It had parallax scrolling and floating particles, and it looked good. Search engines could barely read it.

## What was wrong with the old site

**The text was not in the page.** Flutter web draws its interface itself, onto a canvas. A browser shows you the words, but the HTML that a crawler downloads has almost none of them. When I checked, the page body had nearly no text. Flutter's own documentation says the same thing in its own way: Flutter web is aimed at apps, not at text-heavy pages such as blogs.

**Every address was the same page.** The hosting sent every path to `index.html`, as single-page apps usually do. So `/about`, `/projects` and `/anything-you-type` all answered "200 OK" with the same page. To a search engine that looks like one page with many names, plus an endless supply of pages that should have been "not found".

**All the SEO lived in one file.** A title, a description and some structured data in `index.html`, copied into the build with `robots.txt` and a sitemap. Fine for one page, but there was only ever one page.

## What I moved to

The site is now built with **Astro**. At build time it turns each page into a finished HTML file, so a crawler gets the full text without running any code. JavaScript only adds extras on top, like the theme switch and the animations; the words are there without it.

Each page now has:

- **Its own address and its own title and description**, written for that page and kept short enough that Google does not cut them off.
- **A canonical link**, so copies of the site at other addresses point back to the real one.
- **Structured data** describing what the page is: a person on the About page, an article on each blog post, an app on each case study, plus breadcrumbs.
- **A share image** made for the page, so a link pasted into WhatsApp or LinkedIn shows what it is about.
- **A real 404.** A page that does not exist now says so, with the right status code.

Across the site:

- **A sitemap with honest dates.** Each page's "last changed" date comes from its file's history in git, not from the build time. When every date is "today", search engines learn to ignore them.
- **`robots.txt` and `llms.txt`.** Search and AI crawlers are welcome, and `llms.txt` is a plain-text summary that AI assistants can read in one go.
- **An RSS feed** for this blog.

It is also fast: the home page is about 20 KB once compressed, and the server answers in under 100 ms.

## Where Flutter still fits

Flutter did not leave the site. Three case studies have a phone you can tap to launch the real app, built with Flutter for the web (I wrote about [how those demos work](/blog/live-flutter-demos-with-fake-data)). That is the right job for it: an app inside a page, not the page itself.

## What I'd tell a client

If you are building an app and also need a website:

- **Build the app in Flutter.** One codebase for Android, iOS and the web is still the best reason to use it.
- **Build the marketing site, landing pages and blog in plain HTML.** Astro, a static Next.js site or WordPress all work. What matters is that each page is real HTML with its own address.
- **Flutter web is a good choice behind a sign-in** (dashboards, admin panels, internal tools), where search does not matter and the app does.

Pick the tool for the page, not the page for the tool.
