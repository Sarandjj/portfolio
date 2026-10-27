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
order: 5
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

## The problem

Most scanner apps are full of ads, ask you to sign in, put a watermark on your PDFs or upload your documents. Clean Scanner is built around a short list of promises it should never break.

<span class="note-draft">placeholder: add in your own words what pushed you to build it</span>

## What I built

- A scanner with live capture, cropping, rotation and filters, saved as clean PDFs.
- OCR that produces a searchable PDF, plus a QR and barcode scanner.
- Tools for unlocking a PDF and protecting one with a password.
- An optional app lock using biometrics, and a one-time purchase instead of a subscription.

## Hard parts and decisions

**Promises that shape the code.** No ads, no login, no watermark, no network call for any core feature, no subscription. The internet permission is stripped from release builds, so the app works fully in airplane mode and can say "no data collected" truthfully.

**A size budget.** The app must stay under 60 MB. The OCR models were the biggest single jump, and the QR scanner added under 1 MB because it reuses Google Play Services' barcode model instead of bundling a second copy. The size is measured on the per-device download, not the universal APK, which would look three times bigger.

**Built it myself, then went back.** I wrote my own auto-capture viewfinder, then tested it on real phones and found it detected document edges worse than Google's ML Kit scanner, so I restored ML Kit.

**Built for cheaper phones.** The target device is an Android phone in the ₹8,000 to ₹12,000 range, not a flagship, and the interface is available in English, Tamil and Hindi.

## What's next

<span class="note-draft">placeholder: add the next milestone, for example a Play Store release</span>
