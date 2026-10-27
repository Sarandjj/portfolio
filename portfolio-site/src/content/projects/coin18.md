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
order: 4
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

## The problem

Crypto data is easy to find and hard to browse calmly. Coin18 is a research and tracking tool, deliberately not an exchange, wallet or trading platform, with clear loading, empty and error states on every screen.

<span class="note-draft">placeholder: add in your own words why you built Coin18</span>

## What I built

- A Flutter app with a ranked market list, debounced search, sorting and filter chips.
- A coin detail screen with an interactive chart and range switching.
- A market stats screen and a watchlist that persists on the device and refreshes prices in a batch.
- A Node.js and Express backend that the app talks to instead of calling the data provider directly.

## Hard parts and decisions

**Keep provider keys off the phone.** A key shipped inside an app can be extracted. All external calls go through the Coin18 API, so the app only knows its own base URL.

**A backend that protects the provider's rate limits.** Responses are cached in memory for 60 to 300 seconds depending on the endpoint, and if the provider fails the API returns the last cached result instead of an error.

**Replaceable data source.** The provider code sits behind an adapter and the API is versioned from the first endpoint (`/v1`), so changing provider does not require a new app release.

**Honest data.** Every response carries a refresh time and source status, and the app never presents prices as financial advice.

## What's next

<span class="note-draft">placeholder: add the next milestone</span>
