---
name: Sports Booking App
kind: court booking and matches
description: A sports app for booking courts, joining matches and managing player profiles, live on Google Play and the App Store. Built in Flutter with Firebase.
summary: A sports app for booking courts, joining matches and managing player profiles, live on Google Play and the App Store. I built the Flutter app and its Firebase, push-notification and payment integrations.
role: Mobile application developer, responsible for the Flutter app across its development lifecycle
status: live
platforms: Android + iOS
stack: [Flutter, Riverpod, Firebase, Razorpay]
works:
  - Court booking and joining matches
  - Player profile management
  - Razorpay payments
  - Push notifications through Firebase Cloud Messaging
  - Released on both Google Play and the Apple App Store
emoji: "🏟️"
c1: "#0891b2"
c2: "#2563eb"
order: 1
proof: { value: "2 stores", label: "live on Play and App Store" }
tags: [mobile, backend]
links:
  - { label: "Google Play", url: "https://play.google.com/store/apps/details?id=com.raq.sportz" }
  - { label: "App Store", url: "https://apps.apple.com/us/app/rak-sports/id6670380960" }
todo:
  - "Real screenshots (4 or 5): home, a booking or match screen, a feature you built, profile, a notification. Remove personal data first"
  - Permission to show screenshots from the client's app
  - Confirm which modules exist in the shipped app (court booking, matches, profiles are on your CV; coach, learning, video and social came from earlier notes)
  - Confirm you built the Cloud Functions that send notifications
  - Confirm the wording of your ownership
---

## What it is

This is a sports app on Google Play and the Apple App Store, built for a client. Players use it to book courts, join matches and manage their player profile.


## My role

I developed the Flutter application and its core user-facing features, and I was responsible for it across its development lifecycle: how the app is structured, building the features, connecting it to backend services, fixing bugs, and releasing it to both stores.


## What I built

- The Flutter app, with Riverpod for state management and Firebase for its backend services.
- Payments with the Razorpay gateway.
- Push notifications with Firebase Cloud Messaging, including handling the device tokens that notifications are sent to.
- Firebase Cloud Functions that deliver notifications to users, device tokens and topics.
- Releases to Google Play and the Apple App Store, and fixes after release.

## The problem, in plain terms

People who play sports often keep track of their activity in scattered places, or not at all, and without a structured way to get updates or look back at what they did, motivation drops and a routine is hard to build.

## How I approached it

The aim was a simple, habit-friendly mobile experience, not a long list of features. That meant:

- Fewer steps for the things people do every day.
- Key actions that are quick and obvious.
- Only the relevant information, at the right time, instead of crowded dashboards.

Mistakes I tried to avoid on mobile: too many features at once, complicated navigation, and no clear feedback or sense of progress. The goal was clarity and consistency, not complexity.


## Why it is here

This is a shipped product, not a demo: it is on both public stores, and the work covers the app, its payments, notifications and backend connections, not only screens.
