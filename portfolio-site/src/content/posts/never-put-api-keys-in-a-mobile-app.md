---
title: "Why you should never put an API key inside a mobile app"
description: "Anything shipped in an app can be pulled out of it. The fix I used in Coin18: a small server in the middle that holds the key and caches the data."
date: 2026-10-27
project: coin18
tags: [Flutter, Security, Node.js]
---

> **Short answer:** a key stored in your app can be extracted by anyone who downloads it, even if you obfuscate the code. Keep the key on a small server of your own, let the app talk only to that server, and add a cache so you also protect your usage limits.

## The mistake

It is easy to do. A crypto-data service, a maps service or an AI service gives you an API key. You paste it into your Flutter app, build, and everything works. But an app is just a file that people install on their own phones. Anyone can unpack that file and read the text inside it. Passing the key in at build time does not hide it. Obfuscating the code renames functions, but it does not make the text of your strings secret.

What can happen next: someone copies the key and uses your quota, you hit the provider's limit, the bill grows, or the provider shuts the key off and every installed copy of your app stops working until you ship an update.

## The fix: a small server in the middle

In Coin18, a crypto research app, the Flutter app never talks to the data provider. It talks to one small Node.js and Express service of mine, and only that service holds the provider's key.

```
Flutter app  →  Coin18 API (Node.js)  →  Market data provider
                (holds the key)
```

The app only knows the base address of my API. The key never leaves the server, so there is nothing in the app to steal.

## What the server also gives you

Once you have a server in the middle, three more problems get easier:

1. **A cache that protects your limits.** Responses are kept in memory for 60 to 300 seconds, depending on the endpoint. Ten thousand users asking for the same coin list cost one request to the provider, not ten thousand.
2. **A fallback.** If the provider fails, the API returns the last good answer instead of an error screen.
3. **Smaller responses.** The server trims each response from about 300 KB to about 2 KB before it reaches the phone, which is much kinder to slow connections and data plans.

## Keep the provider replaceable

The provider-specific code sits behind an adapter, and the API is versioned from the first endpoint (`/v1`). If you change provider, or the provider changes its rules, you update the server. Nobody has to update the app.

## Be honest in the data

Every response carries the time it was refreshed. The app shows it, so users know the prices are delayed and informational. It is a research tool, not a trading app, and it never presents prices as financial advice.

## When you do not need a server

Some keys are made to be public, such as a Firebase web configuration or a Google Maps key that you have restricted to your app. Those are protected by rules on the provider's side. The test is simple: if someone copying this key could spend your money or read private data, it belongs on a server.

## A checklist

- [ ] Search your app for any secret key or token
- [ ] Move it to a server and call the server instead
- [ ] Restrict any key that must stay in the app to your app's ID and to the services it needs
- [ ] Cache responses and set a sensible time to live
- [ ] Return the last good answer if the provider fails
- [ ] Version your API from the start

The full case study is on the [Coin18 page](/projects/coin18).
