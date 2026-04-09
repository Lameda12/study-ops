# Mode: plan — Build a Study Plan

**Triggered by:** `/study-ops plan {course}`

---

## Steps

1. **Load profile data**
   - Read `config/profile.yml` — find the course matching `{course}` (by name or short code)
   - Get the `exam_date` for that course
   - Note `weak_areas` from profile

2. **Read course notes**
   - Read all files in `notes/{course-short}/`
   - Build a list of topics that exist in notes
   - Note topics that look thin (short files, few headings) vs. well-covered

3. **Calculate time**
   - Compute days until exam from today's date
   - Apply difficulty calibration from `_shared.md`
   - Reserve the last 2 days before exam as full-review buffer

4. **Generate the plan**

   Output format:

   ```
   # Study Plan: {Course Name}
   Exam Date: {date} ({X} days away)
   Generated: {today}

   ## Week-by-Week Overview
   [High-level breakdown by week]

   ## Daily Schedule

   ### Day 1 — {date}
   - Topic: {topic from notes}
   - Mode: /study-ops quiz {course} {topic}
   - Goal: {specific thing to accomplish}

   ### Day 2 — {date}
   ...

   ## Final 2 Days — Review Buffer
   - Day {X-1}: Full flashcard review of all weak areas
   - Day {X}: Mock exam → /study-ops mock {course}
   ```

   Rules for building the plan:
   - Spread topics evenly across available days
   - Prioritize `weak_areas` from profile — schedule them earlier and revisit them
   - Assign the right mode per day:
     - New topic → start with `explain`, then `flashcards`
     - Familiar topic → `quiz`
     - All topics covered → `mock`
   - Do not schedule more than 2 new topics per day

5. **Save output**
   - Save to `reports/{###}-{course}-plan-{YYYY-MM-DD}.md`
   - Log session in `data/progress.md`
