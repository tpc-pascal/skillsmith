# Changelog

All notable changes to this repository are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and versions follow [Semantic Versioning](https://semver.org/): every release is a `vX.Y.Z` tag whose GitHub Release notes are taken from the matching section below, cut with `scripts/release.sh vX.Y.Z`.

This repository restarted its history on 2026-10-20. Commits, tags, and releases from before the restart were removed from GitHub and are kept only in the maintainer's local git refs.

## [Unreleased]

- `orchestrator`: diagram generation via session skill `archify` (tt-a1i/archify, MIT, requires Node) — CLI-generated workflow/sequence/ERD/tree/timeline diagrams + one-page explainers with a `candidate.json` verify loop; replaces the previous guidance-only `diagram-design`.
- `doc`: data methodology via session skills `exploratory-data-analysis`, `statistical-analysis`, `matplotlib` from K-Dense-AI/scientific-agent-skills (EDA checks, statistical test selection, standard charts — run with local pandas/matplotlib).
- `media`: YouTube transcript summaries via local `yt-dlp`/whisper (dropped session skill `youtube-summarizer` — duplicate routing already covered by `watch`).
- `web`: HTML/one-pager design-quality gate via session skill `taste-skill` (MIT), plus the `impeccable` design-language session skill (pbakaus/impeccable, Apache-2.0) for system UI, plus research workflow session skills `deep-research` (Anthropic official harness from asgeirtj/system_prompts_leaks, CC0 — fan-out/dedup/adversarial verify; replaces the prose AAS `deep-research-framework`), `last30days` (mvanhorn, MIT — signal discovery for research breadth), `efficient-web-research`, `wiki-researcher` (agentic-awesome-skills).
- `paper`: PPTX deck export via session skill `ppt-master` (workflow + offline fallbacks in `references/pptx-decks.md`), plus verification/writing session skills `citation-verification` (galaxy-dawn/claude-scholar, MIT — authority-order DOI → CrossRef → Semantic Scholar checking; replaces the AAS `verify-citations`), `tech-writing-proofread`, `write-in-my-voice`, `stakeholder-investor-reports`, `survey-generator` (agentic-awesome-skills). Prose audit now from `conorbronsdon/avoid-ai-writing` (MIT, 7-skill anti-slop kit with editing contract and voice profiles — replaces the AAS repack) and `blader/humanizer` (MIT — pattern catalogue and rewrite moves). Dropped `fact-check-x-unified` (duplicate routing already covered by `citation-verification`).

## [v0.1.0] - 2026-10-20

Initial release of the restarted repository: the `research` collection, its installation paths for the three supported tools, and the full release and contribution tooling.

### Added

- Collection `research` with five self-contained, independently installable skills — `orchestrator`, `doc`, `media`, `web`, `paper` — plus per-session third-party skills pinned by URL + commit-SHA in `scripts/fetch-session.sh` and never redistributed into the repository.
- Session export skills `docx` and `pdf` from `anthropics/skills` (non-MIT, fetched per session) for the `doc` skill, with local `pandoc`/`libreoffice` as the offline fallback.
- Self-authored media recipes (`skills/research/media/references/media-recipes.md`): transcription, cutting/concat/GIF/frames, subtitles, scene detection, OCR, audio normalization, music metadata, and downloads with local CLIs — no third-party media wrapper scripts.
- Claude Code marketplace manifest (`.claude-plugin/marketplace.json`) with the `research` plugin, and OpenCode skill links under `.opencode/skills/` so a clone discovers every skill in place.
- skills.sh directory listing with the skills CLI install path documented in the README; all five skills resolve from `npx skills add tpc-pascal/skillsmith`.
- Setup guides for OpenCode, Claude Code, and Cursor under `docs/`, the collection checklist and workflow symbols in `AGENTS.md` and `CONTRIBUTING.md`, and `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1, reporting through a GitHub security advisory or the maintainer's GitHub profile).
- CI smoke checks (frontmatter, skill structure, secrets, table consistency) on every push, `scripts/release.sh vX.Y.Z` for SemVer releases with notes from this changelog, the MIT license, the security policy, and the repository logo.
