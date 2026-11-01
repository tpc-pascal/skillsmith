# AI writing tells — natural-prose checklist

Distilled from [blader/humanizer](https://github.com/blader/humanizer) @ `8c307f367c91bd974002f10f2be2965d642c13df` (MIT, Siqi Chen), itself based on Wikipedia's [Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing). Sweep a report against this list before delivering it; see also [`slop-scoring.md`](slop-scoring.md) for the numeric self-audit.

## Principles

- **Signs, not sins.** Every pattern below can appear in good human writing. The giveaway is density and mechanical repetition — fix clusters, not isolated words.
- **Fix the cause, not the symptom.** A tell usually marks vagueness, puffery, or an unsupported claim. Restore the specific fact or cut the empty claim; do not just swap the flagged word.
- **Preserve truth and voice.** Never add, drop, or alter facts, figures, quotes, dates, or citations to sound less AI. Do not flatten a distinctive voice into blandness.
- **Every sentence must add something the reader does not already have.**

## Strongest tells

| # | Tell | Fix |
|---|---|---|
| 1 | Staging: a sentence signals importance instead of adding a fact (contrast-only clauses, "a revolutionary…" openers) | State the fact or cut the clause |
| 2 | One-line punchline closers and moral-of-the-story endings | End on the information, not a flourish |
| 3 | Rule-of-three triplets and em-dashes applied everywhere | Keep a triplet only when the meaning asks; ration em-dashes, prefer periods |
| 4 | Inflation: ordinary facts dressed as pivotal — "underscores", "stands as", "testament to", "delve", "tapestry", "landscape", "robust", "unlock" | Restore plain `is/are/has` and the concrete detail |
| 5 | Trailing "-ing" analysis clauses and subjectless fragments | Make it a full sentence with a subject, or delete |
| 6 | Vague attributions — "experts argue", "observers have noted" | Name the real source or delete the claim |
| 7 | Formatting by rule: `**bold lead-ins:**` on every bullet, Title Case headings, emoji bullets, "In conclusion / In summary" fillers | Sentence-case headings, sparing bold, plain closers |
| 8 | Chat leftovers: "Certainly! Here's…", offer-back closers, re-explaining background the reader already has | Write for the actual reader; decision first |

## Before delivering

1. Read the whole draft once; note the core message and intended voice.
2. Sweep for **clusters** of the tells above, not single occurrences.
3. Re-read against the sources to confirm no fact, citation, or nuance drifted.
