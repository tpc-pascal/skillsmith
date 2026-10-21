# Shared report rules

## Content and language

- Choose one of the two forms in the `paper` skill; include only sections that serve the agreed purpose and audience.
- Write in the requested language, defaulting to the conversation language. Use bilingual output only when requested or needed for the report's purpose.
- Keep the main report focused on the question, findings, explanation, and conclusion. Put raw extracts, large datasets, transcripts, tool logs, technical metadata, and long appendices in separate support files. Do not move information needed to understand the argument or verify citations out of the report.
- Do not add sections to pad length. Meet a requested page/word limit with useful content and state when the sources are insufficient.

## Evidence and notation

- Cite verifiable claims and include page, timestamp, or location when available. Never invent data, URLs, quotations, or source locations.
- Use labels when evidence status needs clarification; do not mechanically label every sentence:
   - `[observed]`: directly seen in an image/frame.
   - `[ocr]`: text recognized from an image or scanned document.
   - `[heard]`: recognized speech or subtitle content.
   - `[fact]`: information confirmed by a reliable source or measurement.
   - `[inference]`: interpretation, not directly stated by the source.
   - `[N/A]`: unavailable or unverifiable information; state why.
- Labels identify evidence type or claim status; they do not replace citations.
- Use `[standard knowledge]` only when the user permits expansion beyond the sources; name the specific reference.
- Distinguish results, interpretation, uncertainty, and limitations. Do not present correlation as causation or inference as established fact.

## Files and checks

- Write `.report.md` next to the source without overwriting it. For URLs, use the working/cache directory defined by the source skill.
- Give sidecars clear names/suffixes, such as `.sources.md`, `.extract.txt`, `.data.csv`, `.transcript.md`, or `.diagram.png`; create them only when useful.
- Keep necessary citations and references in the report. Use a separate source register when it is long or requested, and link it from the report.
- Prefer local tools. Never silently fall back to a network or remote service; disclose when a source or processing step requires connectivity.
- Before delivery, check citations, links, consistency, and source files. For DOCX/PDF, verify text/pages with available local tools and disclose any verification limitation.

## Sources

These principles synthesize ICMJE, the EQUATOR Network, and the National Academies. Details and links are in [`reporting-principles-sources.md`](reporting-principles-sources.md).
