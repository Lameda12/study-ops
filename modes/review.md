# Mode: review — Review Notes and Find Gaps

**Triggered by:** `/study-ops review {course}`

---

## Steps

1. **Read all course notes**
   - Read every file in `notes/{course-short}/`
   - Read `config/profile.yml` to get the course's known `weak_areas` and exam date

2. **Build a topic map**

   For each file/topic found in notes:
   - Estimate coverage depth:
     - **Strong** — multiple headings, definitions, examples, > 200 words
     - **Thin** — exists but minimal content, < 100 words or missing examples
   - List topics not present in notes at all (cross-reference against any syllabus references found in notes or profile)

3. **Output the review report**

   ```
   # Notes Review: {Course Name}
   Date: {today}
   Exam: {exam_date} ({X} days away)

   ## Topics with Strong Notes (ready to quiz)
   - {topic} — {brief reason why it looks strong}
   - ...

   ## Topics with Thin Notes (need more content)
   - {topic} — {what's missing: no examples, no definitions, etc.}
   - ...

   ## Topics Not Found in Notes (potential blind spots)
   - {topic} — not found. If this was covered in lecture, you need notes here.
   - ...

   ## Recommended Next Actions
   1. Run /study-ops quiz {course} {strong-topic} — you're ready for this
   2. Add notes on {thin-topic} then run /study-ops explain {thin-topic}
   3. {topic missing from notes} — run /study-ops explain {topic} to get a baseline
   ```

4. **Update weak_areas in profile** (only if the student agrees)
   - If new gaps are found that aren't in `config/profile.yml`, ask:
     > "Should I add {topic} to your weak areas in your profile?"

5. **Save and log**
   - Save to `reports/{###}-{course}-review-{YYYY-MM-DD}.md`
   - Log in `data/progress.md`
