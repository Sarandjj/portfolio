---
title: "Offline-first sync to Google Drive with no backend"
description: "How Nirai keeps a to-do list identical across devices using one JSON file in the user's own Google Drive, a last-write-wins merge, and tombstones for deletes."
date: 2026-10-27
project: nirai
tags: [Flutter, Drift, Sync]
---

## The problem

I wanted Nirai to be a to-do app that is free to run for ever. A sync server is a bill and an account system, and it means other people's tasks sit on my machine. So the question was: can two phones stay in sync with **no backend of mine at all**?

Google Drive can be the relay. Each person already has a Drive, and the app can be given a private data folder in it. The app never talks to a server of mine, and the data never leaves the person's own Google account.

## The shape of it

Every change is written to the local SQLite database first (through Drift), so the app is instant and works on a plane. Sync is a separate step that runs on resume, on a timer, or when the user taps it:

1. Take a snapshot of all local tables in memory.
2. Download the single sync file from Drive.
3. Merge the two with a pure Dart function, `mergePayloads`.
4. Write the merged result into SQLite inside one transaction.
5. Upload the merged file back to Drive.

The file is one JSON document with all nine synced tables, a version number and a SHA-256 checksum. The local sync bookkeeping table is never uploaded.

The merge being a **pure function** (two payloads in, one payload out, no I/O) is the decision that made everything else testable. I can run it on two in-memory databases and check that they end up identical, without touching Drive.

## Merging: last write wins, per row

Every row has an `updatedAt` and the `deviceId` that wrote it. For ordinary rows the later `updatedAt` wins. Here is the rule as a simplified sketch (the real code has more fields, but this is the idea):

```dart
Row pick(Row a, Row b) {
  if (a.updatedAt != b.updatedAt) {
    return a.updatedAt > b.updatedAt ? a : b;
  }
  // Same millisecond on two devices:
  if (a.deleted != b.deleted) {
    return a.deleted ? b : a; // keep the user's data over a delete
  }
  return a.deviceId.compareTo(b.deviceId) > 0 ? a : b; // deterministic
}
```

The last line matters. If both devices break a tie the same way, then `merge(A, B)` and `merge(B, A)` give the same row, and both phones converge. There is a test that checks exactly that.

Two tables need something smarter than "one row wins":

- **Task labels** are a junction table. Each (task, label) pair is its own row with its own last-write-wins, so if one phone adds label X and another adds label Y at the same time, both survive.
- **Completions of recurring tasks** are merged as a set keyed by the task and the occurrence time. Two phones completing different occurrences, or the same one, never drop or duplicate anything.

## Deleting without bringing things back

A delete that simply removes the row can't sync: the other phone still has the row and will upload it again. So deletes are **tombstones**: the row stays, marked as deleted, with a fresh `updatedAt`.

That gives clear rules, and each one has a test:

| Situation | Result |
|---|---|
| Delete, then an older edit arrives | The delete wins, nothing comes back |
| Delete, then a newer edit arrives | The edit wins, the row is restored |
| Delete, then restore from trash | The later action wins |
| Project deleted on A, new task added to it on B | The task is accepted, no foreign-key error |
| A deletes, then B, then C syncs | The tombstone reaches every device |

The project-and-new-task case is why the merge is applied with `PRAGMA defer_foreign_keys = ON`: foreign keys are checked when the transaction commits, not row by row, so rows can arrive in any order.

## Not corrupting anything

- **One transaction.** The merged result is applied in a single database transaction. If any row is invalid, the whole thing rolls back to the state before the sync. There is a test for this.
- **Idempotent.** Applying the same payload once or ten times gives identical row counts, and a stale payload arriving late never overwrites a newer local edit.
- **Defensive decoding.** Unknown fields are ignored (so a newer app version doesn't break an older one), missing tables become empty, junk entries are dropped, a payload from a future schema version is refused, and a bad checksum is rejected.
- **Retries.** Drive errors are mapped to a few typed exceptions, and quota errors (HTTP 403 and 429) back off exponentially.

## What I'd say honestly about the limits

Last write wins uses each phone's own clock, and there is no server to correct it. If one phone's clock is 15 minutes ahead, its edits win any conflict inside that window. I tested and documented this instead of hiding it. For a personal to-do list synced between a person's own devices, I think that is the right trade. It would not be right for a shared document with many editors.

## What I'd do differently

<span class="note-draft">draft: I wrote this section as a suggestion. Keep it only if it is what you would really say.</span>

I would write the conflict tests before the sync engine, not after. Describing each conflict as a small test (title versus title, due date set versus cleared, delete versus edit) made the rules obvious. The three test files I ended up with (11 conflict tests, 8 deletion tests and 10 payload-compatibility tests) are the real specification of how Nirai syncs.

You can see Nirai on its [project page](/projects/nirai), including a demo with made-up data.
