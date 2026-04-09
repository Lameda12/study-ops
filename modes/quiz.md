# Mode: quiz — Generate Quiz Questions

**Triggered by:** `/study-ops quiz {course} {topic}`

---

## Steps

1. **Load source material**
   - If `{topic}` is specified: read `notes/{course-short}/{topic}` (or nearest matching file)
   - If no topic specified: read all files in `notes/{course-short}/`
   - Do not invent content not in the notes

2. **Generate exactly 10 questions**

   Mix of question types:
   - 3–4 multiple choice (4 options each, only one correct)
   - 3–4 short answer (1–3 sentence expected response)
   - 2–3 definition recall ("Define X" or "What is X?")

   Format:
   ```
   # Quiz: {Course} — {Topic}
   Date: {today}

   **Q1. [Multiple Choice]**
   {question text}
   A) {option}
   B) {option}
   C) {option}
   D) {option}

   **Q2. [Short Answer]**
   {question text}

   **Q3. [Definition]**
   Define: {term}

   ...
   ```

3. **Wait for student to answer**
   - Present all 10 questions first
   - Ask: "Answer each question below, then I'll score you."

4. **After student answers: score and explain**

   For each question:
   - Mark correct (✓) or incorrect (✗)
   - For incorrect answers: explain the right answer, reference the relevant part of their notes

   Output format:
   ```
   ## Results

   Q1 ✓ — Correct.
   Q2 ✗ — Your answer: {their answer}. Correct: {correct answer}. 
           Explanation: {explanation from notes}
   ...

   ## Score: {X}/10

   ### By Topic:
   - {Subtopic A}: {X}/3
   - {Subtopic B}: {X}/4

   ### Weak Areas Flagged:
   - You missed {X}/{Y} questions on {topic} — this needs work.
   ```

5. **Suggest next action** based on score (follow `_shared.md` scoring rules)

6. **Save and log**
   - Save quiz + results to `reports/{###}-{course}-quiz-{YYYY-MM-DD}.md`
   - Log in `data/progress.md`
