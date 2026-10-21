---
name: orchestrator
description: Route input to the right skill (doc/media/web/paper + per-session diagram skill) and confirm report requirements before writing. Use when unsure which skill to use.
license: MIT
metadata:
  audience: orchestration
  origin: custom
---

# orchestrator — input orchestration

## Routing table by input type

|Input + need|Where to go|
|---|---|
|PDF/DOCX/XLSX (text, OCR, convert, merge/split)|skill `doc`|
|CSV/XLSX data → clean, describe, test, statistics|skill `doc` (to CSV/markdown) + local stats (`python`/pandas)|
|video/audio/image/URL media (summary, subtitles, cut, frames, download)|skill `media`|
|Web/social/search (URLs, articles, exa)|skill `web`|
|Write a report from sources|**Question gate** (below) → choose one `paper` format|
|Diagrams/charts for reports|session `archify` (needs Node; `.archify/<slug>/` HTML/SVG + `candidate.json` verify loop)|

## Confirm report requirements

Applies when the user asks to create or rewrite a report (not for extraction/conversion only): ask once, up to four questions, only what is missing, using the 4-group table in [`references/report-question-gate.md`](references/report-question-gate.md). If the user delegates decisions, state short assumptions. After extraction, write using exactly one `paper` format.

## Orchestration rules

1. **Match the input language** — answer in the language the user used.
2. **Name every output**: `<name>.<suffix>`, never overwrite the source. Suffixes: `.extract.md|.txt|.csv`, `.digest.md`, `.srt|.vtt`, `.clip-<t1>-<t2>.mp4`, `.report.md|.report.docx`.
3. **Never invent input** — only process real files; output next to or inside the source.
4. **Web/social/search input** → skill `web`; **media input** → skill `media`. Locked content → let agent-reach/Jina read it; never log in or bypass. **Local-first**: prefer local tools; offline, use only real local/cache sources; fetch third-party skills via `scripts/fetch-session.sh`.
5. **Always report the file written** (name + path); **verify every `.report.docx`** per skill `paper` (`pdfinfo` + `pdftotext`).

## Common combined flows

`▸` = hand off to the next step; `→` = flow continues; `[...]` = source/result type.

```text
PDF scan ▸ skill doc ▸ text/table ▸ skill paper ▸ report
CSV/XLSX ▸ skill doc (to CSV) ▸ local stats ▸ session archify ▸ skill paper
URL web/social ▸ skill web ▸ text ▸ skill paper (when a report is needed)
URL/file video ▸ skill media ▸ digest + frame ▸ skill paper (when a report is needed)
SRT/mm:ss ▸ skill media ▸ trim ▸ concat
```
