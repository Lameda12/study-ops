# Mode: flashcards — Generate Flashcard Set

**Triggered by:** `/study-ops flashcards {topic}`

---

## Steps

1. **Load source material**
   - Determine which course `{topic}` belongs to (check profile and notes directories)
   - Read the relevant notes file(s) for that topic
   - Only use content found in the student's notes — do not invent definitions

2. **Generate 15–20 Q&A pairs**

   Rules:
   - Cover all major terms, definitions, formulas, and concepts from the notes
   - Aim for atomic cards: one concept per card
   - Vary question style:
     - Definition recall: "What is X?"
     - Reverse recall: "What term describes Y?"
     - Application: "When would you use X over Y?"
     - Formula/process: "What are the steps to do X?"

3. **Group by subtopic**

   Output format:
   ```
   # Flashcards: {Topic}
   Course: {course}
   Generated: {today}
   Total cards: {N}

   ---

   ## {Subtopic A}

   Q: {question}
   A: {answer}

   Q: {question}
   A: {answer}

   ---

   ## {Subtopic B}

   Q: {question}
   A: {answer}

   ...
   ```

4. **After presenting cards, offer drill mode**
   Ask:
   > "Want me to drill you on these? I'll show you each Q one at a time and you answer — then I'll tell you if you're right."

   If yes: go through each card one at a time, wait for answer, give feedback.

5. **Save and log**
   - Save to `reports/{###}-{topic}-flashcards-{YYYY-MM-DD}.md`
   - Log in `data/progress.md`
