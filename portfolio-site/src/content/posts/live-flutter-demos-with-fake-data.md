---
title: "Three ways to put a live Flutter app demo on a portfolio"
description: "FinWise, Nirai and NallHub run in the browser on my portfolio with made-up data. Each needed a different trick, depending on where its real data lives."
date: 2026-11-23
tags: [Flutter, Flutter web, Firebase, Testing]
---

> **Short answer:** build the real app for the web with one compile-time flag, `DEMO_MODE`, and replace only the part that touches real data. Where that data lives decides the trick: seed a local database, swap in an in-memory one, or answer the backend's requests from memory.

Screenshots show what an app looks like. A demo shows that it works. So three of my case studies have a phone you can tap to launch the **real app**, built for the web and filled with invented data. Nothing is saved to a server, and nobody needs an account.

The rule I set: the demo must be the same code as the real app. No separate "demo app" that can drift away from the real one.

## One flag, set at build time

Each app has a single constant:

```dart
const bool kDemoMode = bool.fromEnvironment('DEMO_MODE');
```

and the demo is built with:

```bash
flutter build web --release --dart-define=DEMO_MODE=true --output=build/web_demo
```

Because the value is fixed when the app is compiled, a normal build can never switch into demo mode by accident, and the demo build can never reach the real backend by accident. Everything else, every screen, every rule, is the real app.

What the flag changes depends on where each app keeps its data.

## FinWise: the data already lives on the device

FinWise is offline-first. It writes everything to a local database first and only syncs when you set up an account. So the demo needed very little:

- The demo build is made **without** the file that holds the Supabase settings. Without them, the app never creates a Supabase client: no sign-in, no sync and no network calls to a real backend.
- On first launch a seeder fills the local database with made-up accounts, spending, budgets and a Goa trip split between four friends.
- Your changes stay in your own browser. A "Reset demo data" item in the More screen puts the sample data back.

When an app already works without a server, the demo is mostly free.

## Nirai: an in-memory database

Nirai also keeps data on the device, but its demo should start fresh on every visit. So on the web, the demo build opens an **in-memory** Drift database instead of a stored one.

Two details mattered:

- **The sample tasks go in through the app's own repositories**, not straight into tables. If the seed used a shortcut, the demo could show data the real app would never create. Going through the same code keeps it honest.
- Drift on the web runs SQLite compiled to WebAssembly, so the build ships `sqlite3.wasm` (about 730 KB). The demo also skips crash reporting, so made-up sessions never show up next to real errors.

A reload starts from the same clean set of tasks.

## NallHub: a fake backend, in memory

NallHub is different. It is a school management app, and almost everything happens on the server: Supabase sign-in, Postgres tables kept apart per school with row-level security, database functions and Edge Functions. There is no local copy to seed. Skipping the backend would leave an empty app.

So I kept the Supabase client exactly as it is and replaced the network underneath it. The demo gives the client a custom HTTP client that answers each request from memory:

| Request | Answered by |
|---|---|
| `/auth/v1/*` | fake sign-in, refresh, current user and sign-out |
| `/rest/v1/<table>` | a small PostgREST-style query engine over in-memory tables |
| `/rest/v1/rpc/*` | the database functions the app calls |
| `/functions/v1/*` | Edge Functions such as invites and email: always "sent" |
| `/storage/v1/*` | harmless stubs |

The data is a made-up school, and the sign-in screen has buttons to enter as the admin, a teacher or a parent.

Two small things made it feel real:

- **A 60 ms delay on every answer.** Without it, loading states never appear and the app feels oddly instant.
- **Tests that run the real repositories against the fake backend.** The fake is about 1,900 lines, and it is only useful if it answers the way Supabase does. The tests catch the day it stops.

This was by far the most work of the three, and the most useful: the same fake backend can drive screen tests later.

## Hosting: its own site, at the root

Each demo lives in **its app's own repository and Firebase project**, as a second hosting site (for example `nallhub-demo`) with its own config file. Deploying the demo can never touch the app's real site.

- **It must be served at the root of its own address.** Drift's web database would not start from a sub-path such as `/demos/finwise/`, so the demos cannot live inside the portfolio's own hosting.
- **`X-Robots-Tag: noindex`.** The demo is not a page anyone should land on from search. The case study is.
- **`Content-Security-Policy: frame-ancestors`** lists only the portfolio, so other sites cannot embed the demo in their pages.

On the portfolio, the phone shows a still picture until you tap **Launch the demo**. A Flutter web build is several megabytes, and most visitors only want to read, so the demo loads only for those who ask for it.

## What I'd tell a client

If you want people to try your app before it is on the stores, a web demo with invented data is a cheap way to do it, as long as it is built from the real code. The first question is where your data lives:

- **On the device:** seed it. This is the small job.
- **On a server you own:** fake the server at the network layer and test the fake. It is more work, but you get a test tool out of it as well.

Either way, keep the demo on its own site, keep it out of search, and load it only when someone taps.
