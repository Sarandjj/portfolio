---
name: Coin18
kind: crypto research app
summary: A market-research app for browsing coins, charts and a personal watchlist, backed by its own Node.js API that hides provider keys and caches data.
status: progress
platforms: Mobile
stack: [Flutter, GetX, Node.js, Express, fl_chart]
works:
  - Ranked coin list with search, sort and filters
  - Coin detail page with an interactive price chart
  - Global market stats and a personal watchlist
  - Node.js API with caching, deployed on Render
emoji: "🪙"
c1: "#ffb020"
c2: "#ff7a1a"
order: 6
tags: [mobile, backend]
numbers:
  - { value: "60-300 s", label: "cache lifetimes" }
  - { value: "4", label: "focused controllers" }
  - { value: "0", label: "provider keys in the app" }
architecture:
  title: Why there is a backend at all
  steps:
    - { label: "Flutter app", note: "talks only to the Coin18 API" }
    - { label: "Coin18 API", note: "Node.js + Express: validation, rate limits, cache" }
    - { label: "Provider adapter", note: "swappable, so a provider change needs no app update" }
    - { label: "Market data provider", note: "the key lives only on the server" }
todo:
  - Confirm the status. The Render backend sleeps when idle, so a public demo needs a wake-up state
  - 3 to 6 screenshots or a short screen recording
  - Whether you plan to publish it, and where
---

## The idea

A calm place to research crypto markets: browse coins, see a price chart and keep a watchlist. It is a research tool, not an exchange, wallet or trading app.

## Why I built it

Crypto data is easy to find and hard to browse calmly. Coin18 shows a ranked list, search and filters, and a clear chart, with a loading, empty or error state on every screen instead of a blank page.

## How the data is used

- **Market data comes through my own server.** The app never calls a data provider directly. It talks only to the Coin18 API, a small Node.js and Express service.
- **The server protects the key and the limits.** The provider key lives only on the server. Responses are cached for 60 to 300 seconds, and if the provider fails the API returns the last cached answer instead of an error.
- **Smaller responses.** The server trims each response from about 300 KB to about 2 KB before it reaches the phone.
- **Your watchlist stays on your phone.** There are no accounts. The watchlist is saved on the device and refreshed in one batch.
- **Honest about freshness.** Every response says when it was refreshed, and the app never presents prices as financial advice.

## Key decisions

- **A backend at all.** A key inside an app can be extracted, so it is kept on a server.
- **A replaceable provider.** The provider code sits behind an adapter and the API is versioned from the first endpoint (`/v1`), so changing provider needs no app update.
- **Small and focused.** No trading, payments, accounts or social features until the basics are solid.

## Where it stands

In progress. The market list, search, coin detail with chart, market stats and watchlist work. The backend runs on Render, and the free plan makes it sleep when idle.
