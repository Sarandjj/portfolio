---
name: FinWise
kind: personal finance tracker
summary: A personal finance tracker that works offline, syncs across your own devices, and splits trip and group expenses.
status: progress
platforms: Mobile + web
stack: [Flutter, Riverpod, Drift, Supabase, Google Drive API]
works:
  - Accounts, categories, budgets and recurring rules
  - Trips and groups, with uneven splits and a settle-up screen
  - Import from a backup file
  - Sync across your own devices, with Supabase or Google Drive as the backend
emoji: "💸"
c1: "#2bb673"
c2: "#0e8a7a"
order: 1
tags: [mobile, web]
numbers:
  - { value: "300+", label: "automated tests" }
  - { value: "8", label: "synced tables" }
  - { value: "2", label: "sync backends" }
architecture:
  title: How data moves
  steps:
    - { label: "App", note: "Flutter + Riverpod" }
    - { label: "Local database", note: "Drift (SQLite), always written first" }
    - { label: "Sync engine", note: "pulls changes by updated_at" }
    - { label: "Cloud", note: "Supabase Postgres with row-level security, or Google Drive" }
demo:
  url: https://finwise-managermoney-demo.web.app/
  note: This is the real FinWise app, built for the web and filled with made-up accounts, spending, budgets and a Goa trip split between four friends. Add an expense, open the trip, check the budgets. Your changes stay in your browser; "More, Reset demo data" puts the sample data back.
todo:
  - Confirm the status (In progress, Beta or Live) and a public link if there is one
  - 3 to 6 screenshots or a 20 to 30 second screen recording
  - One sentence on who it is for and why you built it
  - Whether to say "solo build" and how long it has taken
---

## The problem

Most expense apps either need an account before they do anything useful, or lose your data when you change phones. FinWise starts from the opposite end: the database lives on the device, so the app is fast and works offline, and sync is added on top for people who want it.

<span class="note-draft">placeholder: add in your own words who FinWise is for and what made you start it</span>

## What I built

- An offline-first money tracker with accounts, categories, budgets and recurring rules.
- Trips and groups: shared expenses with even or uneven splits, and a settle-up screen that shows who owes whom.
- Importing from a backup file, including on web, where there is no file system to read from.
- Sync across a person's own devices, with Supabase as one backend and Google Drive as an alternative.

## Hard parts and decisions

**Deleting without breaking sync.** Every table now uses soft deletes: a delete marks the row as deleted instead of removing it, so other devices learn about the deletion when they sync. The catch is that SQLite only runs its `ON DELETE CASCADE` rules on a real `DELETE`, not on an `UPDATE`. I re-implemented every cascade by hand across all 8 tables and covered them with 15 dedicated tests.

**Security in the database, not just the app.** The Postgres schema mirrors the local one, with row-level security on every table so a signed-in user can only reach their own rows. Policies wrap `auth.uid()` in a sub-select so Postgres evaluates it once per query instead of once per row, which is what Supabase's own performance checker recommends.

**Being honest about what is shared.** Until real multi-user accounts exist, a Space syncs across one person's own phones but is not shared with a second person. I kept that boundary explicit in the plan so "multi-device" is never confused with "multi-user".

## What's next

Real shared Spaces between different people, which is already scoped as its own piece of work.

<span class="note-draft">placeholder: confirm the next milestone and whether there is a release date</span>
