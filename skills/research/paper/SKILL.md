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
|International-standard|[`references/report-academic.md`](references/report-academic.md)|Research structure, methods, citations; choose by study type; claim compliance only after checklist.|
|Vietnamese public-facing|[`references/report-template.md`](references/report-template.md)|General readers; preserve evidence and limitations.|

Shared rules: [`references/output-format.md`](references/output-format.md). Extract sources with the relevant skill first.

## Workflow rules

1. Use the `orchestrator` gate for form, audience, purpose, language, and format; don't repeat answered questions.
2. Follow one form; match requested language. Keep findings in `.report.md`, supporting extracts/tables/logs separate.
3. Prefer local tools; use network only as requested and never switch services silently.
4. Save `<source_name>.report.md` beside, never over, the source. Invent no data, citations, or pages; distinguish fact, observation, and inference.
5. Verify citations, links, consistency, and local DOCX/PDF exports; disclose limits. Reply in the user's language and name created files.

## DOCX and PDF export

Use `pandoc` for DOCX or `libreoffice --headless --convert-to pdf`; see [`doc-recipes.md`](../doc/references/doc-recipes.md) for complex cases. Verify with `pdfinfo` and `pdftotext`.

## Third-party skills (fetched per session)

Fetched per session with `scripts/fetch-session.sh`; use only on request.

- `citation-management`: approve provider; public queries only. No private drafts, unapproved credentials, proxies, or rate-limit bypasses; verify metadata.
- `litreview`: approve provider/data; review scripts. No Parallel/OpenRouter, `.env` credentials, or installs without approval. Verify sources/counts; don't claim completeness.
- `citation-verification`: prefer DOI/publisher, arXiv, or Crossref; Scholar is discovery only. Verify claims; counts don't prove quality.
- `ppt-master`: review scripts; approve provider, external content, keys, and installs. Never read `.env`; save only where requested.
- `avoid-ai-writing` / `humanizer`: edit authorized prose only; preserve claims, sources, attribution; no detector evasion or authorship misrepresentation.
- `tech-writing-proofread`: suggest, don't rewrite authorized English technical prose; flag factual concerns. No external sharing without approval.
- `write-in-my-voice`: use authorized samples only; never imitate others. Keep samples local unless hosted use approved; preview and get separate publish confirmation.
- `stakeholder-investor-reports`: process advice or empty templates only; no financial/legal/tax advice or employee/customer data. Verify figures; never share business data without approval. Notion is manual; never request credentials.
- `survey-generator`: source-check papers and citations; review scripts. Fireworks rendering sends the bundle to a paid external API: get explicit approval for provider/model, data, and budget first. Never send secrets or private data; never read `.env`. Inspect the HTML; don't publish or host it.

## references

Citation formats: [`citation-styles.md`](references/citation-styles.md). Source credibility: [`source-assessment.md`](references/source-assessment.md). Synthesis: [`synthesis.md`](references/synthesis.md). Reporting principles: [`reporting-principles-sources.md`](references/reporting-principles-sources.md). Natural prose: [`ai-writing-tells.md`](references/ai-writing-tells.md) + [`slop-scoring.md`](references/slop-scoring.md) — sweep against both before delivering.
