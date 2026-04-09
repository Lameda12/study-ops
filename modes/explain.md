# Mode: explain — Explain a Concept

**Triggered by:** `/study-ops explain {concept}`

---

## Steps

1. **Check notes first**
   - Search all `notes/` directories for mentions of `{concept}`
   - If found: use the student's notes as the base for the explanation
   - If not found: note that it's not in their notes, then explain from general knowledge — and flag this as a potential gap

2. **Deliver explanation in this exact order**

   ### Step 1 — Plain language (no jargon)
   One paragraph. Write as if explaining to someone who has never heard this term. No technical vocabulary yet.

   ### Step 2 — Concrete real-world example
   One specific, tangible example. Make it memorable. Not a textbook example — something the student can picture.

   ### Step 3 — Technical definition
   Now give the precise, academic definition. Include any notation, formulas, or formal language from their notes or the field.

   ### Step 4 — Connections to other concepts
   - What concepts does this build on?
   - What concepts build on this?
   - Where does this appear in the course (which topics, lectures, or assignments)?

   ### Step 5 — Check understanding
   Ask exactly this:
   > "Does that make sense, or do you want me to go deeper on any part?"

3. **If the concept was missing from notes**
   Add this warning after the explanation:
   > "⚠ This concept wasn't in your notes. Consider adding a note on it — if it came up in lecture, it may appear on the exam."

4. **Log session**
   - Do not save a report for explain mode (it's conversational)
   - Log in `data/progress.md` with mode = "explain" and topic = concept name
