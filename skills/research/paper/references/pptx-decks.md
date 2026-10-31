# PPTX decks for reports (ppt-master)

Distilled from [`hugohe3/ppt-master`](https://github.com/hugohe3/ppt-master) @ `c350bc31e6d43b7bcf5234183d650ba8f9f4c9d7` (MIT) — session-fetched, never vendored.

## When

A report needs a slide deck: briefings, investor/stakeholder updates, conference talks. Data and citations come from the report itself — never invent numbers for slides.

## Workflow

1. `./scripts/fetch-session.sh --skill ppt-master` → temp dir; read its `SKILL.md` and follow it (deck brief → outline → styled build → verify by re-opening the `.pptx`).
2. Feed it the finished `.report.md`: pick the key claims, one message per slide, evidence tables only where they earn their space.
3. Match the report's language and citation style; mark adapted/synthesized claims exactly like the report.
4. Verify the output opens (`python-pptx` or LibreOffice headless), slides match the outline, no clipped text.

## Offline fallbacks

- No network / no fetch: `pandoc <file>.report.md -o <file>.slides.pptx` (simple structure), or `python-pptx` scripts for custom layout.
- Re-style an existing deck with LibreOffice headless conversions; verify with `python-pptx` reads.
