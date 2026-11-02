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
role: Solo founder, product designer and full-stack developer
emoji: "🏫"
c1: "#ff6a3d"
c2: "#ff3d77"
order: 5
proof: { value: "447", label: "tests passing" }
tags: [mobile, web, backend]
numbers:
  - { value: "447", label: "automated tests passing" }
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

## The idea

One app for a private school: admins run the school, teachers mark attendance and set homework, and parents see only their own children. It works in English and Tamil.

## Why I built it

Small private schools often run on paper registers and scattered spreadsheets. NallHub puts students, classes, attendance, homework, exams and announcements in one place, for schools of roughly 100 to 500 students in Tamil Nadu.

## How the data is used

- **One database, one school at a time.** Everything lives in Supabase (Postgres), and every table has row-level security, so a school can only ever see its own data.
- **Each role sees only what it needs.** An admin sees their whole school. A teacher sees only the classes they are assigned to. A parent sees only their own children and those children's classes.
- **The server decides, not the app.** Sensitive actions such as saving attendance, entering exam marks or recording a fee payment run as database functions that check who is calling, and never trust IDs sent by the phone.
- **Accounts are by invitation.** An admin enters a teacher or parent, an Edge Function creates the account, and the person sets their own password from a link.
- **Files stay private.** Timetable files go in a private storage bucket and open through links that expire after an hour.
- **A student keeps one identity.** The permanent student record is separate from the yearly class, so promoting a student adds a row and keeps the history.

## Key decisions

- **Set the curriculum once.** Subjects belong to a grade-group, and every section inherits them.
- **One login, several roles.** A person can be an admin, a teacher and a parent, and the app asks which one to use.
- **Security first.** Every database change has a SQL test that checks nobody can read another school's data.

## Where it stands

In progress, on Android and web. Admin tools, teacher invites, attendance, homework, the parent dashboard and Tamil and English work today. It has been tested on a real phone, with large text, small screens and dark mode.

## Go deeper

<details>
<summary>Who has the problem, and why the options did not fit</summary>

| Person | The pain today |
|---|---|
| **Parent** | "Was my child absent today? What is the homework?" The answer comes late, through a noisy WhatsApp group or a call to the teacher. |
| **Teacher** | Marks attendance on paper, copies it again for the office, and posts homework in several groups. |
| **School admin** | Setting up a new year means re-typing classes, subjects and teachers, and building reports by hand. |
| **School owner** | Cannot afford a large ERP and does not trust "free" apps with children's data. |

Big school systems are built for big schools. WhatsApp has no structure, no history and no privacy between classes. Spreadsheets give parents no access and no notifications. The gap was something cheap, simple and safe enough for a 300-student school.

</details>

<details>
<summary>Four design bets</summary>

1. **Built for the small school.** The whole setup must be doable by one non-technical admin in one sitting. Schools do not sign themselves up: a platform admin creates the school and its first admin, which stops fake tenants.
2. **Grade-groups, so nobody types the same thing twice.** Subjects are defined once for a grade (Grade 1, or Grade 11 Biology) and every section inherits them. This also covers Tamil Nadu's higher-secondary streams, and year rollover copies the structure forward.
3. **Students are permanent, class membership is yearly.** Identity is stored once, and each year's class is a separate row, so promotion keeps history and a child is never duplicated.
4. **Real roles, including two hats.** One login can be admin, teacher and parent, and the person switches role instead of keeping several accounts.

</details>

<details>
<summary>How a school's data stays private</summary>

It is children's data, so security was designed first, not added later.

1. Row-level security is on every table, and anonymous users can read nothing.
2. Small helper functions (such as "is this person an admin of this school") keep the policies simple and fast.
3. The server is the source of truth. Functions such as `submit_attendance` work out the school, the person marking and their role on the server, and never trust the app to say who it is.
4. Writes go through checked functions. Marks must be between zero and the maximum, the student must be in that class, and the caller must teach it.
5. A suspended school is locked out by a rule on every table that has a school.
6. Automated isolation tests run as admin, teacher, parent and outsider, and always roll back. The latest run passed 15 role-isolation checks on live data.

A real bug taught me the rule behind step 2: a policy on one table that looked up a second table, whose own policy looked back at the first, caused an "infinite recursion" and would have broken login. The rule is now written down ("never loop policies; use a helper function") and the tests catch it.

</details>

<details>
<summary>Hard problems and how I solved them</summary>

| Problem | What happened | Fix |
|---|---|---|
| Policies that loop | Two policies referenced each other and login queries failed. | Moved the lookups into helper functions, wrote a rule, and added isolation tests after every policy change. |
| Edge function could not read tables | Hand-made tables had no privileges for the service role. | A migration to grant them. |
| Invite email returned 401 | The guard used an admin call that fails with the new secret-key format. | Compare the key directly in a timing-safe way. |
| Activation link failed | The page sent `token`, the API expects `token_hash`. | Fixed the page and documented the flow. |
| Deleting a staff login deleted their work | Audit columns cascaded from the auth users table. | A migration to keep history. |
| Overflow on small phones, big fonts and Tamil | Tamil words are long and layouts broke. | Layout tests at 320 px, double text size, Tamil and dark mode found and fixed real overflows. |
| Router crashed on refresh or with the wrong role | The router was rebuilt and its guards were weak. | Created the router once, added a role guard and a not-found page. |
| Visitors cannot sign in to a demo | A real backend needs accounts and email. | An in-memory fake backend that runs the real app code. |

</details>

<details>
<summary>The demo runs the real app on a fake backend</summary>

A recruiter will not create an account or wait for an invite email. So a demo build swaps the network layer for an in-memory one with its own query engine, fake sign-in and a seeded school. The real repositories and screens run unchanged, so nothing in the interface is faked. Tests run the real repositories against it, and normal builds never touch the demo code. The demo is hosted on its own site, blocked from search, and separate from the real activation page.

</details>

<details>
<summary>How I know it works, and the honest limits</summary>

- `flutter analyze` is clean, and 447 tests pass (another 34 visual tests need screenshots to run).
- A rules script counts banned patterns and can only go down. Hard-coded colours in pages went from 65 to 0, and literal font sizes from 208 to 0.
- Performance is aimed at 120 Hz phones, with a frame budget of 8.33 ms, and a script collects frame stats from a real phone.

What is not done: timing and memory on a real device and full phone walkthroughs are not yet verified, email delivery depends on an SMTP setup that was not confirmed end to end, there are no push or SMS notifications yet, and separate test and live Supabase projects should have existed from day one. Online fee payments are parked on purpose, because money handling needs legal and gateway work.

</details>

<details>
<summary>What I learned</summary>

1. Design the security model first. Adding tenant isolation later is far harder.
2. A rule that is not measured is a wish.
3. Test real languages. Tamil text exposed bugs English never would.
4. Say no to scope. Parking payments protected quality.
5. Make the demo effortless, so a project that needed setup becomes one link.

</details>
