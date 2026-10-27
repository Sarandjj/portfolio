---
name: NallHub
kind: school management app
summary: A white-label school management app for private schools in Tamil Nadu, with separate tools for admins, teachers and parents, in English and Tamil.
status: progress
platforms: Android + web
stack: [Flutter, Riverpod, Supabase, Firebase, GoRouter]
works:
  - Admin tools for students, teachers, classes, subjects, academic years and a timetable grid editor
  - Teacher invitations by email, with a self-service set-password link
  - Parent dashboard with report cards (PDF), leave requests and messaging
  - English and Tamil, checked on a real phone
emoji: "🏫"
c1: "#ff6a3d"
c2: "#ff3d77"
order: 5
tags: [mobile, web, backend]
numbers:
  - { value: "860+", label: "automated tests" }
  - { value: "4", label: "user roles" }
  - { value: "2", label: "languages" }
architecture:
  title: How the pieces fit
  steps:
    - { label: "Flutter app", note: "Android and web, one codebase" }
    - { label: "Supabase Auth", note: "invitation-only, one login can hold several roles" }
    - { label: "Postgres + RLS", note: "each school is a tenant, kept apart by row-level security" }
    - { label: "Edge Functions", note: "teacher invites, password reset links, email" }
demo:
  url: https://nallhub-demo.web.app/
  note: This is the real NallHub app with a made-up school (Sunrise Matriculation School). Use the buttons on the first screen to try it as the school admin, a teacher or a parent. The data is invented, and it is not saved or sent anywhere.
todo:
  - Confirm the status and whether any school is using or piloting it
  - 3 to 6 screenshots (fake data only, never real students)
  - Decide what to say about the business side (pricing is deliberately kept off the page)
  - Whether to give NallHub its own landing page
  - A public web demo needs a separate demo database, not the live one
---

## The problem

Small private schools often run on paper registers and scattered spreadsheets. NallHub is one system for school admins, teachers and parents, built for schools with roughly 100 to 500 students in Tamil Nadu.

<span class="note-draft">placeholder: add in your own words what you saw that made you build it, and whether a school is piloting it</span>

## What I built

- **Admin:** students, teachers, subjects, academic years, classes and sections, a timetable grid editor, leave management, an activity log, attendance and exam results, and report cards you can preview as a PDF.
- **Teachers:** invited by email. The admin enters their profile, an Edge Function creates the account, and the teacher sets their own password from a link, with a self-service resend if the link expires.
- **Parents:** a dashboard, the child's report card, leave requests and messages to the school.
- **Platform admin:** one owner role that creates and manages the schools.
- Everything works in **English and Tamil**.

## Hard parts and decisions

**Define the curriculum once.** Subjects are set per grade-group (for example Grade 11 Biology) and every section inherits them, so adding a section does not mean re-entering subjects. Groups can be copied from one academic year to the next, and old years stay unchanged.

**Students keep one identity for life.** A student's permanent record is separate from their yearly class assignment, so promoting a student adds a new row instead of overwriting history.

**Real-world teaching.** Teacher-to-subject assignment has no uniqueness rule, so two teachers can share a subject in one class (theory and practical, or a substitute).

**One person, several roles.** A single account can be an admin, a teacher and a parent at once, and the app asks which role to use after login.

**Tenant isolation, kept fast.** Every table has row-level security. A performance pass fixed how those policies are evaluated and added indexes on foreign keys, and each database change has a rolled-back SQL test.

**Tested on a real phone.** Layout tests cover a 320 px screen, doubled text size, Tamil and dark mode, and a scroll test on a real 120 Hz phone passed.

## What's next

<span class="note-draft">placeholder: add the next milestone. The fee module is currently parked.</span>
