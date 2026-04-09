# study-ops

A Claude-powered study assistant for university exam prep — built for any subject, any course load.

Drop in your lecture notes, run a command, and get quizzes, flashcards, study plans, gap analysis, and full mock exams — all generated from *your actual notes*, not generic content.

---

## Inspiration

study-ops is directly inspired by [career-ops](https://github.com/santifer/career-ops) by [@santifer](https://github.com/santifer) — a Claude-powered career assistant that uses a clean mode-based architecture (CLAUDE.md + modes/ + skill router) to handle job searching, offer evaluation, and interview prep.

study-ops takes that exact pattern and adapts it for academic study:

| career-ops | study-ops |
|------------|-----------|
| Evaluate a job offer | Build a study plan |
| Scan job portals | Review notes for gaps |
| Interview prep | Mock exam simulation |
| Resume tailoring | Flashcard generation |

The architecture — CLAUDE.md as master config, a `modes/` folder per task type, a `_profile.md` for personal context, and a SKILL.md router — is preserved wholesale. Credit for the pattern goes entirely to career-ops.

---

## What it does

study-ops gives you a set of slash commands that Claude executes against your own lecture notes:

| Command | What happens |
|---------|-------------|
| `/study-ops` | Show all available commands |
| `/study-ops plan {course}` | Build a day-by-day study plan until your exam date |
| `/study-ops quiz {course} {topic}` | Generate 10 mixed questions from your notes, scored with explanations |
| `/study-ops explain {concept}` | Plain-language explanation → example → technical definition → connections |
| `/study-ops review {course}` | Map your notes: strong topics, thin topics, missing topics |
| `/study-ops flashcards {topic}` | Generate 15–20 Q&A flashcard pairs, grouped by subtopic |
| `/study-ops mock {course}` | Simulate a full timed exam, scored section by section |
| `/study-ops tracker` | Dashboard: days until each exam, sessions done, weak areas, next action |

Everything is generated from **your notes** — not hallucinated content. If it's not in your notes, Claude says so.

---

## Getting started

### 1. Clone the repo

```bash
git clone https://github.com/Lameda12/study-ops.git
cd study-ops
```

### 2. Add your lecture notes

Notes go in `notes/{course-short}/`. One markdown file per lecture or week works best.

```
notes/
├── ds/
│   ├── week1-arrays.md
│   ├── week2-linked-lists.md
│   └── week3-sorting.md
└── calc/
    ├── week1-limits.md
    └── week2-derivatives.md
```

If your notes are in PDF format, use the included conversion script:

```bash
# Convert all PDFs in raw/{course}/ to markdown in notes/{course}/
bash scripts/pdf-to-notes.sh raw/ds/ notes/ds/
```

See [Working with PDFs](#working-with-pdfs) below for details.

### 3. Open Claude Code in the repo folder

```bash
claude  # opens Claude Code in current directory
```

Claude will detect the empty profile and run onboarding automatically — it will ask for your name, courses, exam dates, and study preferences.

### 4. Run commands

```
/study-ops plan DS
/study-ops quiz DS sorting
/study-ops mock CALC
```

---

## File structure

```
study-ops/
├── CLAUDE.md                        ← master instructions for Claude
├── config/
│   └── profile.yml                  ← your courses, exam dates, study style
├── modes/
│   ├── _shared.md                   ← global rules applied to all modes
│   ├── _profile.md                  ← your personal context (never auto-overwritten)
│   ├── _profile.template.md         ← copy this to start your profile
│   ├── plan.md
│   ├── quiz.md
│   ├── explain.md
│   ├── review.md
│   ├── flashcards.md
│   ├── tracker.md
│   └── mock-exam.md
├── data/
│   └── progress.md                  ← session log (auto-updated after each mode)
├── notes/                           ← your lecture notes go here (gitignored)
├── raw/                             ← drop PDFs here before converting (gitignored)
├── reports/                         ← generated output: plans, quizzes, exams (gitignored)
├── scripts/
│   └── pdf-to-notes.sh              ← PDF → Markdown conversion helper
└── .claude/
    └── skills/
        └── study-ops/
            └── SKILL.md             ← command router
```

---

## Working with PDFs

PDFs cost more tokens and can't be searched. Converting to Markdown before using study-ops gives you:
- Lower token usage per session
- Grep-searchable notes (used by review, quiz, mock-exam modes)
- Accurate topic maps in `review` mode
- Better quiz and flashcard quality

### Quick conversion

```bash
# Single file
bash scripts/pdf-to-notes.sh raw/ds/week1-arrays.pdf notes/ds/

# Whole folder
bash scripts/pdf-to-notes.sh raw/ds/ notes/ds/
```

The script tries `marker` (best quality) → `pandoc` → `pdftotext` (fastest), using whichever is installed.

### After converting

Do a quick pass on each file:
- Remove slide numbers (`Slide 3 of 40`, page footers)
- Fix garbled equations — rewrite in plain text or LaTeX
- Add a heading at the top: `# Week 1 — Arrays and Pointers`

One file per lecture, named by topic. This is what lets `plan` and `review` modes build accurate topic maps.

---

## Modes in detail

### plan
Reads your notes and exam date, calculates days left, and outputs a day-by-day schedule. Assigns the right mode per day (new topic → explain + flashcards, familiar topic → quiz, final days → mock exam). Adapts difficulty based on how close the exam is.

### quiz
Generates exactly 10 questions — mix of multiple choice, short answer, and definition recall — pulled from your notes. After you answer, scores each question, explains wrong answers, and flags any topic where you scored under 60%.

### explain
Explains a concept in four layers: plain language → concrete example → technical definition → connections to other concepts. Checks your notes first and flags if the concept is missing from them.

### review
Reads all notes for a course and builds a topic map: strong coverage, thin coverage, and missing topics. Recommends specific next commands for each gap.

### flashcards
Generates 15–20 Q&A pairs from your notes, grouped by subtopic. Offers an interactive drill mode where it shows one card at a time.

### mock-exam
Generates a 20–30 question exam weighted by topic coverage in your notes. You set a timer, answer all questions, then get a full section-by-section breakdown with a final grade and ranked weak areas.

### tracker
Dashboard view across all your courses: days until each exam, sessions done, last mode used, weak areas. Flags any course where the exam is close and sessions are low. Suggests the next command for each course.

---

## Contributing

Contributions are welcome. study-ops is intentionally simple — a set of markdown instruction files plus a skill router. New modes, improvements to existing ones, or better onboarding flows are all fair game.

### Ideas for new modes

- `summarize` — condense a lecture into key points
- `compare` — compare two concepts side by side
- `timeline` — generate a historical/chronological overview for humanities courses
- `formula-sheet` — extract all formulas from notes into a single cheat sheet
- `essay-plan` — outline an essay response for a given prompt

### How to contribute

1. Fork the repo
2. Create a branch: `git checkout -b feature/your-mode-name`
3. Add your mode file to `modes/your-mode.md`
4. Add routing for it in `.claude/skills/study-ops/SKILL.md`
5. Add the command to the menu in `CLAUDE.md`
6. Open a pull request with a description of what the mode does

Keep mode files focused: one file, one job, clear step-by-step instructions for Claude to follow.

---

## License

MIT — see [LICENSE](LICENSE).

Use it, fork it, adapt it for your courses.
