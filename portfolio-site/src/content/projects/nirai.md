---
name: Nirai
kind: offline-first to-do app
summary: A free to-do app that keeps your data on your phone and syncs it to your own Google Drive. No server, no account.
status: progress
platforms: Android + macOS
stack: [Flutter, Riverpod, Drift, Google Drive API, ML Kit]
works:
  - Natural-language quick add ("tomorrow 3pm #work p1")
  - Inbox, Today, Upcoming, board and calendar views
  - Pomodoro focus timer and habit streaks with reminders
  - Background sync to your own Google Drive
emoji: "✅"
c1: "#4f7bff"
c2: "#7a4dff"
order: 4
tags: [mobile]
numbers:
  - { value: "38", label: "specified features" }
  - { value: "9", label: "synced tables" }
  - { value: "0", label: "servers to run" }
architecture:
  title: How sync works with no backend
  steps:
    - { label: "Your phone", note: "every change is written to local SQLite first" }
    - { label: "Sync engine", note: "downloads the Drive file, merges, applies in one transaction" }
    - { label: "Your Google Drive", note: "one private JSON file in the app's own data folder" }
    - { label: "Your other device", note: "runs the same merge and ends up identical" }
demo:
  url: https://nirai-managetask-demo.web.app/
  note: This is the real Nirai app running in your browser with made-up tasks. Open Today, check a task off, try the Client app board. Nothing is saved or sent anywhere, and a reload starts fresh.
todo:
  - Confirm the status and any Play Store or beta link
  - 3 to 6 screenshots or a short screen recording
  - Why you are making it free
  - Release plan, if any
---

## The problem

To-do apps are either paid, full of accounts and upsells, or keep your tasks on someone else's server. Nirai is meant to be a fast, free alternative where your data stays yours.

<span class="note-draft">placeholder: add in your own words why you built Nirai and who it is for</span>

## What I built

- A task manager with a quick-add box that understands plain language: dates, repeats, priorities, projects and labels.
- Inbox, Today (with an overdue banner), Upcoming (with a 14-day strip), and project views as a list, a board or a calendar.
- A Pomodoro focus timer, habit tracking with streaks and reminders, subtasks and attachments.
- Optional biometric lock and a document scanner using Google's ML Kit.

## Hard parts and decisions

**Sync with no server.** Instead of running a backend, Nirai uses a private file in the user's own Google Drive as the relay between devices. Each sync reads the local data, downloads the remote file, merges the two, applies the result in a single SQLite transaction, and uploads it back. If anything fails, the transaction rolls back and nothing is half-applied.

**A merge that gives the same answer on every device.** Rows are merged with last-write-wins. When two edits have the same timestamp, ties are broken in a fixed order (a live row beats a deleted one, then the device ID, then the canonical JSON). That makes the merge commutative: merging A into B gives the same result as B into A, so it does not matter which device syncs first.

**Local first, always.** Every change is written to the local database immediately, so the app is instant and works with no connection. Sync happens in the background.

## What's next

<span class="note-draft">placeholder: add the next milestone, for example a store release</span>
