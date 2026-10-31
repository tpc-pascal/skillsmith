# Changelog

All notable changes to this repository are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and versions follow [Semantic Versioning](https://semver.org/): every release is a `vX.Y.Z` tag whose GitHub Release notes are taken from the matching section below, cut with `scripts/release.sh vX.Y.Z`.

This repository restarted its history on 2026-10-20. Commits, tags, and releases from before the restart were removed from GitHub and are kept only in the maintainer's local git refs.

## [Unreleased]

## [v0.1.1] - 2026-11-01

### Added

- `research/web`: Add session skill `agent-reach` from `Panniantong/Agent-Reach`, pinned by commit SHA.

## [v0.1.0] - 2026-11-01

### Added

- `research/media`: Add session skill `watch` from `bradautomates/claude-video`, pinned by commit SHA.

## [Repository baseline] - 2026-10-20

Initial release of the restarted repository: the `research` collection, its installation paths for the three supported tools, and the full release and contribution tooling.

### Added

- Collection `research` with five self-contained, independently installable skills — `orchestrator`, `doc`, `media`, `web`, `paper` — with optional upstream session integrations managed by `scripts/fetch-session.sh`.
- Self-authored media recipes (`skills/research/media/references/media-recipes.md`): transcription, cutting/concat/GIF/frames, subtitles, scene detection, OCR, audio normalization, music metadata, and downloads with local CLIs — no third-party media wrapper scripts.
- Claude Code marketplace manifest (`.claude-plugin/marketplace.json`) with the `research` plugin, and OpenCode skill links under `.opencode/skills/` so a clone discovers every skill in place.
- skills.sh directory listing with the skills CLI install path documented in the README; all five skills resolve from `npx skills add tpc-pascal/skillsmith`.
- Setup guides for OpenCode, Claude Code, and Cursor under `docs/`, the collection checklist and workflow symbols in `AGENTS.md` and `CONTRIBUTING.md`, and `CODE_OF_CONDUCT.md` (Contributor Covenant 2.1, reporting through a GitHub security advisory or the maintainer's GitHub profile).
- CI smoke checks (frontmatter, skill structure, secrets, table consistency) on every push, `scripts/release.sh vX.Y.Z` for SemVer releases with notes from this changelog, the MIT license, the security policy, and the repository logo.
