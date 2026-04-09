# _shared.md — Global Rules for All Modes

These rules apply to every mode without exception.

---

## Source of Truth Rules

- NEVER invent facts, definitions, formulas, or exam content. If unsure, say so explicitly.
- ALWAYS read `notes/{course}/` before generating any course-specific content (quizzes, flashcards, mock exams, plans).
- ALWAYS read `config/profile.yml` and `modes/_profile.md` before any session action.
- Use the student's actual notes as the source of truth. Do not supplement with outside knowledge unless notes are missing and the student asks you to.

---

## Output Rules

- Save all generated output to `reports/{###}-{course}-{mode}-{YYYY-MM-DD}.md`
  - `{###}` = three-digit sequence number (check existing reports to get next number)
  - Example: `reports/007-DS-quiz-2026-04-09.md`
- Track every study session in `data/progress.md` by appending a new row to the markdown table.
- Be direct. No filler phrases. No fake encouragement like "Great job!" or "You're doing amazing!"
- Give honest, specific feedback: name the exact topics where gaps exist.

---

## Difficulty Calibration

Adapt content difficulty based on time until exam (read from `config/profile.yml`):

| Days Until Exam | Strategy |
|----------------|----------|
| 21+ days | Go broad — cover all topics, build full picture |
| 8–20 days | Go medium — prioritize topics with thin notes or low scores |
| 1–7 days | Go deep — focus exclusively on weak areas, high-yield topics |
| Exam day | Review only: flashcards and key definitions only |

---

## Scoring Rules (quiz and mock-exam modes)

After any quiz or mock exam:
1. Score each question: correct / incorrect
2. Report score by section: "Section 2 (Sorting Algorithms): 3/5"
3. Give overall score: "Total: 14/20 (70%)"
4. Flag weak areas explicitly:
   - "You missed 3/4 questions on Binary Trees — this needs work."
5. Suggest next action based on score:
   - < 60%: "Run /study-ops review {course} to find gaps, then /study-ops flashcards {topic}"
   - 60–80%: "Run /study-ops quiz {course} {weak-topic} to drill specific gaps"
   - > 80%: "On track. Run /study-ops mock {course} for full exam simulation"

---

## Session Logging

After every mode execution, append to `data/progress.md`:

```
| {#} | {YYYY-MM-DD} | {course} | {mode} | {topics covered} | {score if applicable} | {notes} |
```
