---
title: "I built my own document scanner, then went back to ML Kit"
description: "I replaced Google's ML Kit document scanner with my own edge detector, tested both on a real phone the same day, and went back. Here is what I kept."
date: 2026-10-27
project: clean-scanner
tags: [Flutter, ML Kit, Vision]
---

## The problem

Clean Scanner is an offline document scanner. Its rules include no ads, no login, and no network for the core features. For capture I started with a Flutter package that wraps **Google's ML Kit document scanner**. It worked well, but two things bothered me:

- Its on-screen outline jumps around, and I could not configure it.
- It needs a module from Google Play services, downloaded the first time you use it. For someone who installs the app while offline, that quietly breaks the "works offline" promise.

So I decided to build my own live viewfinder.

## What I built

- **A quad detector.** My first still-image detector returned an axis-aligned rectangle, which cannot describe a page photographed at an angle. The new one finds four corners.
- **Perspective correction.** A homography solve and a warp, so a trapezoid actually comes out square.
- **A frame pipeline.** The detector runs in one long-lived isolate, not a new isolate per frame. If a frame is still being processed, new ones are **dropped, not queued**: a queue makes the outline track where the phone was, not where it is. Image data moves across with `TransferableTypedData` instead of being copied.
- **A verify screen.** After every capture you see the photo with its outline, four draggable corners and a loupe, before anything is straightened.
- **39 unit tests** on synthetic frames with known corners: a page found within 3% of the truth, a tilted page coming out as a trapezoid, an empty desk returning nothing, jitter damped, and a stray false detection never reaching the screen.

I shipped it to a phone.

## The test that decided it

I compared my detector and ML Kit side by side on real documents, on a real phone. **Mine found the edges worse.**

That is the whole story. My notes from that day say it plainly: a calm outline that misses the page is worth less than a restless one that finds it. All the reasoning about frame rates and jitter did not outweigh what the camera showed. I switched the capture entry point back to ML Kit the same day.

One thing made that cheap: every feature (document scan, ID card sides, image-to-PDF, one-shot OCR) reaches the camera through a single function. Swapping the scanner was one change in one place, not a hunt through the app.

## What survived

Going back did not mean the work was wasted. The vision code is still used where ML Kit never ran at all:

- **Gallery imports.** A photo picked from the gallery has never been cropped by anything. My detector earns its place there.
- **The crop verify screen**, and the on-demand **Crop** in page review, both built on the four-corner editor.

The live viewfinder code, which was no longer used, I flagged for deletion instead of leaving it to rot.

## A smaller lesson in the same day

When scanning felt worse after one session, I first blamed my own changes, and I was partly wrong. I checked and ruled out the obvious suspects one by one before deciding what was actually responsible. Keeping "what the user saw" and "what I changed" as separate questions is what stopped me fixing the wrong thing.

## What I'd do differently

I would have run the side-by-side test on a real phone **before** building the frame pipeline, not after. A quick comparison would have told me the detector was not good enough. I'd still have built the detector, because of the gallery case, but not the live viewfinder around it.

I'd also keep tracking size. Every dependency was measured against a 60 MB budget, and the last build I measured was about 42.5 MB.

Clean Scanner is on its [project page](/projects/clean-scanner).
