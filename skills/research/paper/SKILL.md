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

Local first: `pandoc <file>.report.md -o <file>.report.docx` or `libreoffice --headless --convert-to pdf`; complex recipes: `doc` skill ([`doc-recipes.md`](../doc/references/doc-recipes.md)). Verify with `pdfinfo` + `pdftotext`.

## Third-party skills (fetched per session)

Third-party tools are fetched on demand for the current session with `scripts/fetch-session.sh`.

Use `citation-management` only for requested work. Before external lookup, confirm the
provider; send public bibliographic terms only, never private drafts. Do not use
credentials or proxies without approval or bypass access limits; verify metadata.

Use `litreview` only when requested. Before sending queries, screening data, or manuscript
text externally, confirm the provider and data; default to public search terms. Review
scripts before running them. Do not use Parallel/OpenRouter, read `.env` credentials, or
install dependencies without explicit approval. Treat results as aids, not proof of
systematic-review completeness; verify sources, coverage, and counts.

Use `citation-verification` as guidance: prefer DOI/publisher, arXiv, or Crossref records;
Google Scholar is discovery only. Citation counts are not quality evidence; verify
claims in the source.

Use `ppt-master` only for requested presentations and review scripts before running.
Confirm the provider and approval before sending content to external services. Never read
or transmit `.env` credentials; use API keys or install dependencies only with approval.
Keep outputs in the requested location.

Use `avoid-ai-writing` only for requested edits to authorized prose. Never evade AI
detection or misrepresent authorship. Patterns are fallible; preserve meaning, sources,
attribution, and protected content.

## references

Citation formats: [`citation-styles.md`](references/citation-styles.md). Source credibility: [`source-assessment.md`](references/source-assessment.md). Synthesis: [`synthesis.md`](references/synthesis.md). Reporting principles: [`reporting-principles-sources.md`](references/reporting-principles-sources.md). Natural prose: [`ai-writing-tells.md`](references/ai-writing-tells.md) + [`slop-scoring.md`](references/slop-scoring.md) — sweep against both before delivering.
