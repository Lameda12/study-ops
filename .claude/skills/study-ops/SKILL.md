# study-ops Skill Router

This skill routes `/study-ops` commands to the correct mode files.

---

## Routing Rules

Parse the command immediately after `/study-ops`:

### No argument → Show menu
```
/study-ops
```
Action: Display the full command menu from CLAUDE.md. Do not load any mode file.

---

### plan
```
/study-ops plan {course}
```
Action:
1. Read `modes/_shared.md`
2. Read `modes/plan.md`
3. Execute plan mode for `{course}`

---

### quiz
```
/study-ops quiz {course} {topic}
/study-ops quiz {course}
```
Action:
1. Read `modes/_shared.md`
2. Read `modes/quiz.md`
3. Execute quiz mode. `{topic}` is optional — if omitted, use all notes for the course.

---

### explain
```
/study-ops explain {concept}
```
Action:
1. Read `modes/_shared.md`
2. Read `modes/explain.md`
3. Execute explain mode for `{concept}`

---

### review
```
/study-ops review {course}
```
Action:
1. Read `modes/_shared.md`
2. Read `modes/review.md`
3. Execute review mode for `{course}`

---

### flashcards
```
/study-ops flashcards {topic}
```
Action:
1. Read `modes/_shared.md`
2. Read `modes/flashcards.md`
3. Execute flashcards mode for `{topic}`

---

### mock
```
/study-ops mock {course}
```
Action:
1. Read `modes/_shared.md`
2. Read `modes/mock-exam.md`
3. Execute mock exam mode for `{course}`

---

### tracker
```
/study-ops tracker
```
Action:
1. Read `modes/tracker.md` only (no _shared.md needed)
2. Execute tracker mode

---

## Before Any Mode Executes

Always do this first, regardless of which mode is being loaded:
1. Read `config/profile.yml`
2. Read `modes/_profile.md`
3. Check if onboarding is needed (name is empty in profile.yml) → if yes, run onboarding from CLAUDE.md before proceeding

---

## Argument Matching

- Match `{course}` against both the full course name and the `short` code in `config/profile.yml`
- If no match found: "I don't recognize '{course}'. Your registered courses are: {list from profile.yml}. Did you mean one of these?"
- If command not recognized: show the menu and explain valid commands

---

## Error Cases

| Situation | Response |
|-----------|----------|
| Course not in profile | List registered courses, ask for clarification |
| Notes directory empty | "No notes found for {course}. Add your notes to notes/{short}/ first." |
| Unknown command | Show menu |
| Missing argument | Tell the user what argument is required |
