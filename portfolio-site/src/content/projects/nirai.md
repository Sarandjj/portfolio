---
name: Nirai
kind: offline-first to-do app
summary: A free to-do app that keeps your data on your phone and syncs it to your own Google Drive. No server, no account.
status: progress
platforms: Android + macOS
stack: [Flutter, Riverpod, Drift, Google Drive API, ML Kit]
works:
  - "Natural-language quick add (\"tomorrow 3pm #work p1\")"
  - Inbox, Today, Upcoming, board and calendar views
  - Pomodoro focus timer and habit streaks with reminders
  - Background sync to your own Google Drive
role: Solo product designer and engineer, from research to build and testing
emoji: "✅"
c1: "#4f7bff"
c2: "#7a4dff"
order: 4
proof: { value: "0", label: "servers to run" }
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

## The idea

A to-do app that keeps your tasks on your phone and syncs them to your own Google Drive. There is no server and no account to run.

## Why I built it

To-do apps are usually paid, full of upsells, or keep your tasks on someone else's server. Nirai is for people who want a fast, free app where the data stays theirs, with the speed of tools like Todoist.

## How the data is used

- **On your phone.** Every task, project, label and habit is saved in a local SQLite database first, so the app is instant and works offline.
- **Sync through your Drive.** If you sign in with Google, the app keeps one private file in its own data folder in your Google Drive. Each device downloads it, merges it with its own data and uploads the result. Nothing goes to a server of mine.
- **No account needed.** Without signing in, you still get every feature, stored on the device.
- **Safe to merge.** If two devices edit different parts of the same task, both edits are kept. If they change the same field, the newer one wins. Deletes are marked so they spread to other devices, and the whole merge is applied in one transaction that rolls back if anything fails.
- **Crash reports** have your text, emails and file paths stripped out before they are sent.

## Key decisions

- **Google Drive as the relay.** No backend means nothing to pay for and nothing of yours on my machine.
- **A merge with the same answer on every device.** Ties are broken in a fixed order, so it does not matter which phone syncs first.
- **Local first, always.** Writes never wait for the network. [How the sync works, step by step](/blog/nirai-drive-sync-no-backend).

## Where it stands

In progress, on Android and macOS. Quick add in plain language, Inbox, Today and Upcoming, list, board and calendar views, a focus timer, habits with reminders and Drive sync work today.

## Go deeper

<details>
<summary>The problem: the vendor owns the server</summary>

Before writing code I read reviews and competitor pricing. The same complaints kept coming back: paywalls on the free plan, worry about task history sitting on a startup's server, unreliable sync and reminders, and apps that shut down and took people's data with them.

The insight was that these are not five separate problems. They share one root cause, which is that the vendor owns the server. Remove the server and several of them disappear at once. I was careful about the claim: small apps already sync to Drive, so the gap is the combination (free with no project cap, offline-first, your own storage, Android and Mac both polished) done well, not any single feature.

</details>

<details>
<summary>How sync works without a server</summary>

Syncing through a plain file is harder than it sounds. Drive has rate limits, there is no push channel, two devices can edit the same task offline, and a bad merge can silently destroy data.

| Concern | Approach |
|---|---|
| Cheap when idle | Check only the file's version on Drive and a local change fingerprint. If neither changed, nothing is transferred. |
| Battery and quota | Push a few seconds after edits settle, never per keystroke. Poll every 15 seconds in the foreground, less often when hidden, and back off on quota errors. |
| Two devices edit the same task | Merge field by field using a saved copy both sides last agreed on, so a note edited on one device and a completion on another both survive. |
| Fields that belong together | Treated as one unit, for example a due date and its repeat rule. |
| Deletes | A flag on every synced table, so a delete spreads instead of coming back. |
| Photos and documents | Travel as separate files, found by name. |
| Fear of the first sync | A safety copy of your data is written before a device first merges with an account. |

To prove it, I wrote a randomised test where three simulated devices make random edits offline, sync in random order, and must all end with identical data. [The step-by-step sync story is a blog post](/blog/nirai-drive-sync-no-backend).

</details>

<details>
<summary>Design: Todoist's logic, Nirai's own identity</summary>

I copied Todoist's behaviour, which is proven and familiar, but not its look.

- **Flat, calm surfaces.** No shadows except on drag, and hairline-divided rows instead of boxed cards.
- **Amber for overdue, not red.** Red makes people feel guilty and a to-do app should not punish you. Red is kept for priority 1 and destructive actions, so it means something.
- **Progressive disclosure.** In a task, only the fields that are set are shown. The rest appear as small "+ Field" chips, so a new task is not a wall of empty form fields.
- **Today as "My Day".** A progress ring, today's habits as one-tap chips, an "Up next" card with a jump into Focus, and one "Move all to today" button for overdue tasks.
- **Behaviour-based features.** A "Wrap up the day" ritual that asks you to decide each open task, a day-load bar with a "Spread out" suggestion on overloaded days, and a hint to make a habit when a quick-add repeats daily.

</details>

<details>
<summary>Features, and why each one exists</summary>

| Feature | Why |
|---|---|
| Natural-language quick add | Capture has to be faster than forgetting. A hand-written parser shows live chips so you see how it understood you. |
| Filter queries such as `today & p1` | Power users get saved filters, compiled to typed database queries. |
| Camera OCR | Turn a printed or handwritten list into tasks. It runs on the phone, so no image leaves it. |
| Voice dictation | Speech feeds the same parser. |
| Biometric lock | Privacy as a feature, with an auto-lock timeout and a screen-switcher privacy cover. |
| Focus timer | Tied to a task, and each session is logged as a comment. |
| Habits | Streaks are aware of scheduled days, and "today still pending" does not break a streak. |
| Recurring tasks as events | Each completion is stored, not a due date reset, so history and streaks are kept. |
| Todoist import | Making it cheap to leave builds trust in joining. |

</details>

<details>
<summary>Engineering: how I know it holds up</summary>

- **Performance measured on a real phone** (Xiaomi 14, 120 Hz, so an 8.33 ms frame budget). One keyboard-opening frame cost 14.8 ms because a card was being repainted on every step of the keyboard rising. Adding a repaint boundary and removing a delayed layout jump brought it to 4.2 ms.
- **A randomised monkey test** performs random interactions across many seeds and found real crashes that normal tests did not.
- **A responsive sweep** runs 14 widths, two text sizes and light and dark, and fails on any overflow with the exact file and line.
- **Screens rendered headlessly** to images so layouts can be checked without a device.
- **Pure-Dart logic.** The parser, recurrence, filters, habit stats and day balance have no Flutter dependency, so they are easy to unit test.
- **Android 14 exact-alarm limits** were identified early, so reminders got proper permission handling instead of being discovered through bad reviews.

</details>

<details>
<summary>Trade-offs and honest limits</summary>

- **No real-time sharing.** File-based sync cannot do live shared lists well, and I chose not to compromise the core promise to get it.
- **Google-only storage.** Without a Google account there is no sync. Other storage options are on the roadmap.
- **Polling, not push.** Drive has no push for this scope, so there is a few-second delay between devices.
- **Clocks matter.** With no server, each phone's own clock decides which same-field edit is newer.
- **Parity is not a product.** Chasing feature parity can become a trap. My own point of view started when I built My Day, Wrap up and day balance, and I would start that earlier.
- **Honest outlook.** Indie productivity apps rarely earn much. I treat Nirai as a craft and learning project with optional upside.

</details>
