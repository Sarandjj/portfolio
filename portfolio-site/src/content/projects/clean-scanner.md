---
name: Clean Scanner
kind: offline document scanner
summary: An offline document and ID scanner. Clean PDFs, no ads, no login, and nothing leaves the phone.
status: progress
platforms: Android
stack: [Flutter, Riverpod, ML Kit, SQLite, pdf]
works:
  - Scan, crop, rotate and filter pages
  - OCR to a searchable PDF (English and Hindi)
  - Unlock and password-protect PDFs
  - QR and barcode scanner
emoji: "📄"
c1: "#0ea58f"
c2: "#22d3b6"
order: 7
proof: { value: "42.5 / 60 MB", label: "size budget" }
tags: [mobile]
numbers:
  - { value: "42.5 MB", label: "app size at last check, 60 MB budget" }
  - { value: "0", label: "network calls for core features" }
  - { value: "3", label: "interface languages" }
architecture:
  title: Nothing leaves the phone
  steps:
    - { label: "Camera", note: "Google's ML Kit document scanner" }
    - { label: "On-device processing", note: "crop, filter, compress, OCR" }
    - { label: "Local storage", note: "SQLite for metadata, files on disk" }
    - { label: "Share or export", note: "a PDF only when the user asks" }
todo:
  - Confirm the status and any Play Store or testing link
  - 3 to 6 screenshots or a short screen recording
  - Whether the one-time Pro unlock is live
---

## The idea

A document and ID scanner that keeps everything on your phone. No ads, no login, no watermark, and no internet needed for its main features.

## Why I built it

Most scanner apps are full of ads, ask you to sign in, put a watermark on your PDFs or upload your documents. Clean Scanner is built around a short list of promises it should never break.

## How the data is used

- **Your documents never leave the phone.** Scanning, cropping, filters and text recognition (OCR) all run on the device. Page details are saved in a local database and the files sit on the phone's storage.
- **No network for the core features.** The internet permission is removed from the release build, so the app itself cannot make network calls. One known exception: Google's scanner models are downloaded by Play Services the first time, so a fresh install has to go online once before it can scan.
- **Nothing is collected.** There is no analytics tool and no crash reporter that sends data out, so the Play Store can say "no data collected" truthfully.
- **You decide what is shared.** A PDF is only exported or shared when you ask.

## Key decisions

- **Promises first.** No ads, no login, no watermark, no subscription and no cloud upload. Any change that touches one needs a deliberate decision.
- **A size budget.** The app stays under 60 MB. The QR scanner reuses Google Play Services' barcode model instead of adding a second copy.
- **I built my own scanner, then went back to Google's.** My live edge detector lost to ML Kit on real documents on a real phone, so I switched back and kept my code where it still helps. [The full story](/blog/clean-scanner-ml-kit).
- **Made for cheaper phones.** It targets Android phones in the ₹8,000 to ₹12,000 range, and has English, Tamil and Hindi interfaces.

## Where it stands

In progress, on Android. Scanning, OCR to a searchable PDF, unlock and protect for PDFs, a QR and barcode scanner and an optional app lock work today.

## Go deeper

<details>
<summary>The promises, and how each one is enforced</summary>

A promise written only in a README gets broken quietly later. So each one has an enforcement point.

| Promise | How it is enforced |
|---|---|
| No network call for any core feature | The internet permission is removed in release builds, so a dependency that tries to add it loses. |
| No cloud upload of documents | OCR, barcode scanning and PDF work all run on the device, and there is no backend. |
| No ads, no watermark, no login | There is no ad SDK, no overlay step in export and no account system. |
| No subscription | One one-time Pro purchase, and nothing else. |
| "No data collected" on the Play Store | No analytics SDK and no crash reporter that sends data out. |
| Under 60 MB | Measured after every dependency added. |
| Core features stay free | ID Card Mode, single-document OCR and exact-KB export are written down as never moving behind Pro. |

Anything that would break one of these is treated as a product decision to raise, not a change to quietly make.

**The one exception, documented:** the live scanner is Google's, and its models download on first use, so a phone that has never been online cannot scan until it has been once. It is recorded as an accepted trade-off, because a documented exception can be revisited and a hidden one becomes a surprise bug.

</details>

<details>
<summary>How a photo becomes a PDF with no server</summary>

Camera or gallery, then a crop check with draggable corners, a perspective fix, page review, and finally export. Filters, OCR and the PDF are all made on the phone.

- Files live on disk and only details such as paths and page order live in the local database, never image blobs, so a 50-page document cannot run a cheap phone out of memory.
- Filters are non-destructive: the original is kept and the processed image can be rebuilt.
- Heavy work runs off the screen's thread, with real progress ("Page 3 of 12").
- Errors the user must understand (storage full, permission denied, a corrupt PDF) return a clear result instead of crashing.

</details>

<details>
<summary>I built my own scanner, then went back to Google's</summary>

The live outline hunted constantly and was wrong on tilted pages. There were two causes: the viewfinder was Google's and could not be tuned, and my own still-image detector really was bad (it could only draw an upright rectangle, so it could not correct perspective).

I built a new detector in about 1,400 lines of plain Dart, with 39 tests. It lost to Google's scanner on real documents on a real phone, so capture went back to ML Kit the same day. The detector now does a different job: it crops gallery imports, powers the crop check screen and the optional crop in page review.

The lesson: 39 passing tests on made-up images said nothing about real paper. [The full story is a blog post](/blog/clean-scanner-ml-kit).

</details>

<details>
<summary>Decisions where the obvious choice was wrong</summary>

| Decision | Chosen | Rejected, and why |
|---|---|---|
| PDF password | A hand-written implementation of the standard PDF security handler | A library whose free tier still needs a vendor account and license key. |
| Removing a PDF password | A real, open-source PDF library | Writing my own PDF parser. I first ruled the feature out, then saw the parser did not have to be mine. |
| OCR | ML Kit, English and Hindi | Tamil OCR, because ML Kit does not support Tamil. I checked before promising it. |
| Barcode and QR | Share Google Play Services' model (+0.9 MB) | Bundling a second copy (an estimated 3 to 10 MB). |
| Fonts | The phone's own font | A package that downloads fonts at runtime and breaks the offline promise. |
| Storage | Files on disk, details in the database | Images inside the database. |

Each rejection was driven by something that would only have shown up later: a license condition, a runtime download, or a language the model does not support.

</details>

<details>
<summary>Exact-size export</summary>

Upload forms often ask for a file under a fixed size, such as 100 KB. The app offers presets of 20, 50, 100, 200 and 500 KB. JPEG quality does not map neatly to file size, so it does a binary search over quality, and if even the lowest quality is too big it shrinks the image and searches again. If the target is too small to stay readable, it says so instead of returning a bad result. An honest "I can't" beats a confident wrong answer.

</details>

<details>
<summary>The size budget, measured honestly</summary>

Measured on the per-device download slice, not the universal APK, which looks about three times bigger than what Play delivers.

| Milestone | Added | Size |
|---|---|---|
| Phase 2 | local database, PDF, image filters | 20.6 MB |
| Phase 4 | ML Kit OCR models | 34.0 MB |
| Phase 6 | app lock, in-app purchase | 34.6 MB |
| QR scanner | barcode scanning (shared model) | 35.5 MB |
| PDF unlock | a real PDF library, file picker | 41.4 MB |
| Latest check | ML Kit scanner restored | 42.5 MB |

OCR was the single biggest cost (+13.4 MB). One Gradle setting made barcode scanning cost +0.9 MB instead of several.

</details>

<details>
<summary>A regression that was not where I looked</summary>

Scanning felt worse after one session. I suspected packages and Android settings, and ruled each out with evidence. The cause was in my own change: every ID scan was passing through a new edit screen with a default crop that cut 5% off all four edges, and re-saved the image. The rule that came out of it: never put an unconditional crop after a stage that has already cropped, because cropping is destructive and it compounds. The fix made cropping an optional button.

</details>

<details>
<summary>What is built, what is not verified, what I left out on purpose</summary>

Built: scanning, page review, PDF export, filters, folders, search, OCR, ID card mode, exact-size export, merge, split, compress, protect, unlock, sign, PDF to image and a QR scanner.

Not verified yet: unlocking a real protected file, opening a protected PDF in Adobe Reader or Drive on a phone, the live scanner on a cheaper phone, and the "WhatsApp installed" share path. The Play Store purchase is not created yet, and the app is built but not published.

Left out on purpose, with reasons: PDF to Word or Excel (table detection is a real algorithm problem), smart auto-naming, and Tamil OCR (no supported engine yet).

</details>
