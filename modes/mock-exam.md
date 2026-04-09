# Mode: mock-exam — Simulate a Full Exam

**Triggered by:** `/study-ops mock {course}`

---

## Steps

1. **Load all course material**
   - Read all files in `notes/{course-short}/`
   - Read `config/profile.yml` for exam date, weak areas, and course weight
   - Build a topic list with estimated importance (topics with more notes = higher weight)

2. **Set the exam up**

   Before generating questions, tell the student:
   ```
   Mock Exam: {Course Name}
   Questions: {20–30} (you'll see the count once generated)
   Suggested time: {expected exam duration or "set your own timer"}

   ⏱ Set a timer now. Do not look anything up. Answer from memory.
   Type "ready" when your timer is started.
   ```

   Wait for "ready" before continuing.

3. **Generate the exam: 20–30 questions**

   Weight questions by topic importance:
   - Topics with more notes → more questions
   - Topics in `weak_areas` → include at least 2 questions each
   - Question type distribution:
     - ~40% multiple choice
     - ~30% short answer
     - ~20% problem-solving or application (if applicable to course)
     - ~10% definition/recall

   Format:
   ```
   # Mock Exam: {Course Name}
   Date: {today}
   Total Questions: {N}

   ---

   **Section 1: {Topic A}** ({X} questions)

   Q1. [Multiple Choice]
   {question}
   A) ...  B) ...  C) ...  D) ...

   Q2. [Short Answer]
   {question}

   ---

   **Section 2: {Topic B}** ({X} questions)
   ...
   ```

4. **Wait for student to submit all answers**
   - Tell them: "Answer all questions, then paste your responses below. Write Q1: [answer], Q2: [answer], etc."

5. **Score the exam section by section**

   For each section:
   ```
   Section 1 ({Topic A}): {X}/{Y}
   - Q1 ✓
   - Q2 ✗ — Your answer: {answer}. Correct: {answer}. ({brief explanation})
   ```

   Then overall:
   ```
   ## Final Score: {X}/{N} ({percentage}%)

   ### Section Breakdown:
   | Section | Score | % |
   |---------|-------|---|
   | {Topic A} | {X}/{Y} | {%} |
   ...

   ### Weak Areas (ranked):
   1. {Topic with lowest score} — {X}/{Y} — review immediately
   2. {Next topic} — ...

   ### Verdict:
   {Honest assessment: "You're on track" / "This needs significant work" / "Ready to sit the exam"}
   ```

6. **Suggest next steps**
   Follow scoring rules from `_shared.md`. Be specific about which topics to target.

7. **Save and log**
   - Save full exam + results to `reports/{###}-{course}-mock-{YYYY-MM-DD}.md`
   - Log in `data/progress.md` with score
