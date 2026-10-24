---
name: paper
description: Write international-standard or Vietnamese public-facing reports from collected sources, export `.report.md`/`.docx`. Use when a report is requested.
license: MIT
metadata:
  audience: reporting
  origin: custom
---

# paper — report writing

Writes reports from collected sources — choose **one** form; never mix both frameworks.

## Two report forms

|Form|Reference|Use when|
|---|---|---|
|International-standard report|[`references/report-academic.md`](references/report-academic.md)|Research structure, assessable methods, full citations; pick the guideline by study type, no compliance claim without a checklist.|
|Vietnamese popular report|[`references/report-template.md`](references/report-template.md)|For a general Vietnamese audience; evidence and limitations preserved.|

Shared rules: [`references/output-format.md`](references/output-format.md). Extract documents/media with the relevant skill first.

## Workflow rules

1. Use the `orchestrator` question gate for form, audience, purpose, language, format; do not re-ask answered questions.
2. Use only the selected report framework. Match the requested/contextual language; do not force bilingual output.
3. Keep `.report.md` on findings/reasoning; raw extracts, large tables, tool logs go to support files (see `references/output-format.md`).
4. Prefer local tools; network only when the source/request requires it; never switch services silently.
5. Save `<source_name>.report.md` next to the source; never overwrite sources.
6. Do not invent data, citations, or page numbers. Cite claims; mark facts vs observations vs inferences.
7. Check citations/links/consistency; verify DOCX/PDF exports with local tools; disclose unavailable ones.
8. Respond in the user's language; name every file created.

## DOCX and PDF export

Local first: `pandoc <file>.report.md -o <file>.report.docx` or `libreoffice --headless --convert-to pdf`; complex recipes: `doc` skill ([`doc-recipes.md`](../doc/references/doc-recipes.md)). Verify with `pdfinfo` + `pdftotext`. For slide decks use session skill `ppt-master` ([`references/pptx-decks.md`](references/pptx-decks.md)).

## Third-party skills (fetched per session)

`citation-management` + `litreview`: `./scripts/fetch-session.sh --skill citation-management --skill litreview` → temp, never installed.

PPTX decks: `--skill ppt-master` — brief → outline → styled `.pptx`, verify by re-opening; workflow + offline fallbacks in [`references/pptx-decks.md`](references/pptx-decks.md).

Verification/writing helpers: `--skill citation-verification` (galaxy-dawn/claude-scholar, MIT — authority-order citation checking: DOI → CrossRef → Semantic Scholar → Zotero, claim-level), agentic-awesome-skills `--skill tech-writing-proofread` (itemized Original → Suggestion → Reason), `--skill write-in-my-voice` (draft in the author's existing voice), `--skill stakeholder-investor-reports` (investor/board report register), `--skill survey-generator` (source-backed survey-paper artifacts). Prose audit: `--skill avoid-ai-writing` (conorbronsdon/avoid-ai-writing, MIT — 7-skill anti-slop kit with editing contract and voice profiles; run together with the prose sweep in `references/ai-writing-tells.md` + `references/slop-scoring.md`), `--skill humanizer` (blader/humanizer, MIT — pattern catalogue and rewrite moves for removing AI writing tells).

Academic research & review pipeline: `--skill academic-paper`, `--skill academic-paper-reviewer`, `--skill academic-pipeline`, `--skill academic-deep-research`, `--skill sr-screener` (Imbad0202/academic-research-skills, CC-BY-NC-4.0 — 12-agent writing pipeline, 5-seat reviewer panel, and protocol-driven study screening).

## references

Citation formats: [`citation-styles.md`](references/citation-styles.md). Source credibility: [`source-assessment.md`](references/source-assessment.md). Synthesis: [`synthesis.md`](references/synthesis.md). Reporting principles: [`reporting-principles-sources.md`](references/reporting-principles-sources.md). Natural prose: [`ai-writing-tells.md`](references/ai-writing-tells.md) + [`slop-scoring.md`](references/slop-scoring.md) — sweep against both before delivering.
