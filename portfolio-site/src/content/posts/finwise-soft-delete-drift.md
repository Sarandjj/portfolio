---
title: "Soft deletes in Drift: SQLite's onDelete does not fire on UPDATE"
description: "Why turning deletes into tombstones for sync silently switches off every foreign-key cascade, and how FinWise rebuilt them by hand across 8 tables."
date: 2026-10-27
project: finwise
tags: [Flutter, Drift, SQLite, Sync]
---

## The problem

FinWise started life as a local-only app, with real `DELETE` statements. Then I added sync, and a real delete stopped working: if phone A removes a row, phone B has no way to learn it was removed. It just sees a row it still has, and uploads it again.

The standard fix is a **soft delete** (a tombstone). Instead of deleting the row, set `isDeleted = true` and refresh `updatedAt`, so the change travels with the next sync like any other edit.

Here is the catch I want to write down.

## SQLite only fires foreign-key actions on a real DELETE

In Drift you can declare foreign keys with `onDelete: KeyAction.cascade` or `KeyAction.setNull`. While deletes were hard deletes, those were free. Delete an account and its transactions went with it. Delete a category and its subcategories followed, and transactions pointing at it were set to "no category".

SQLite runs those actions when a row is **deleted**. An `UPDATE ... SET isDeleted = 1` is not a delete, so **none of them run**. The moment deletes became tombstones, every cascade in the schema silently switched off. Nothing crashes. The data just becomes inconsistent: a deleted category's transactions still point at it, a deleted space still has members.

## Finding every one

Before touching code, I listed every relationship that depended on a cascade or set-null. In FinWise that was ten of them:

| Deleting a… | Used to cascade to |
|---|---|
| Account | its transactions and recurring rules |
| Category | its subcategories and budgets; set-null on transactions and recurring rules |
| Space (a trip or group) | its members; set-null on transactions |
| Space member | set-null on the "paid by" of transactions |
| Budget | its per-period amounts |

I also picked out the riskiest spot: the category delete was one line with no guards, quietly relying on three cascades at once. The account delete already refused to run if the account had transactions, so its cascade was unreachable and lower risk.

## Rebuilding the cascades

Two decisions:

1. **Put the cascade logic in one place, not in each DAO.** A category DAO, a space DAO and a budget DAO all need to tombstone related rows in other tables. I made the cross-table logic live at the database level, where every DAO is reachable, so each relationship is written exactly once.
2. **Every tombstone must also bump the sync fields.** A soft delete that doesn't refresh `updatedAt` and `syncVersion` is invisible to the sync engine. As a simplified sketch:

```dart
Future<void> softDeleteCategory(String id) => transaction(() async {
  final now = DateTime.now();
  // 1. the category itself
  await (update(categories)..where((c) => c.id.equals(id))).write(
    CategoriesCompanion(isDeleted: const Value(true), updatedAt: Value(now)),
  );
  // 2. what the database used to do for free
  //    (subcategories, budgets, set-null on transactions...)
  await cascade.afterCategoryDeleted(id, now);
});
```

Doing it inside one transaction means a half-finished cascade can never be left behind.

## Undo needed a change too

FinWise lets you undo deleting a transaction. The old undo re-inserted the row. Once a delete means "the row is still there, marked deleted", re-inserting the same primary key collides with the tombstone. Undo had to become "flip `isDeleted` back to false".

## How I tested it

For each relationship in the table, a test that uses a **real in-memory database**, not mocks: create the parent and children, delete the parent, assert the children and the set-null columns end up exactly as the old hard-delete would have left them. I wrote 15 dedicated cascade tests, and the project has 300+ automated tests in total.

## What I'd do differently

I would have made every table soft-delete-ready from the first version. Retrofitting meant auditing every foreign key by hand. If you are building a local-first app now and think you will sync later, add `isDeleted`, `updatedAt` and a version column on day one, and route every delete through one place.

FinWise is on its [project page](/projects/finwise), with a demo you can use in the browser.
