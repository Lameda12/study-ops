# Mode: tracker — Study Progress Overview

**Triggered by:** `/study-ops tracker`

---

## Steps

1. **Read progress data**
   - Read `data/progress.md` — parse all rows in the session log table
   - Read `config/profile.yml` — get all courses, exam dates, weak areas

2. **Calculate per-course stats**

   For each course in profile:
   - **Days Left** = exam_date minus today
   - **Sessions Done** = count rows in progress.md for this course
   - **Last Mode** = most recent mode used for this course
   - **Last Session** = most recent date for this course
   - **Weak Areas** = from profile.yml `weak_areas` field

3. **Output the tracker table**

   ```
   # Study Progress Tracker
   Updated: {today}

   | Course | Exam Date | Days Left | Sessions Done | Last Mode | Last Session | Weak Areas |
   |--------|-----------|-----------|---------------|-----------|--------------|------------|
   | {name} | {date}    | {X} days  | {N}           | {mode}    | {date}       | {areas}    |
   ...

   ## Alerts
   {list any courses where exam < 7 days AND sessions < 3}
   ⚠ {Course}: exam in {X} days but only {N} sessions logged — start studying now.
   ```

4. **Suggest next action per course**

   After the table, output:
   ```
   ## Recommended Next Actions

   {Course A}: {X} days out, last used {mode} — next: /study-ops {suggested-mode} {course}
   {Course B}: Exam in {X} days, weak on {topic} — next: /study-ops quiz {course} {topic}
   ```

   Logic for suggestions:
   - 0 sessions → suggest `/study-ops review {course}` first
   - Last mode was plan → suggest starting with first topic in plan
   - Last mode was quiz → suggest flashcards on weak areas
   - Last mode was mock → suggest reviewing flagged weak areas
   - < 7 days → suggest mock exam regardless

5. **No file saved for tracker** — it's a dashboard view, not a report.
   Log in `data/progress.md` with mode = "tracker".
