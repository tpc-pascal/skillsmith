# Repository conventions

This document is the single source of truth for the repository's structure, skill content, third-party skill handling, and validation rules. For commit and release messages and workflow, see [commit and release conventions](commit-conventions.md).

## Repository structure

- Keep all skill collections under `skills/<collection>/<skill>/`; do not add collections at the repository root.
- Keep each collection self-contained and independently installable. Do not add cross-collection routing, references, or install dependencies.
- Treat the files under `skills/` as canonical skill content. OpenCode discovers them through `.agents/skills/` symlinks; keep those links aligned with their source skills and do not duplicate content.
- Document collection skills and installation in that collection's `README.md`.

## Skill file structure

Every `SKILL.md` follows this order:

1. YAML frontmatter containing `name`, `description`, `license`, and `metadata`.
2. `# H1` and one introductory paragraph.
3. `##` sections in this order: routing table; specialist section, if needed; `Rules`; `Third-party skills (fetched per session)`, if needed; `references` or `scripts`, if needed; combined flows.

Keep `SKILL.md` lean because it loads in every session: aim for about 45 lines or 2,500 characters, and never exceed 70 lines or 4,000 characters. Put supporting detail in `references/` for on-demand reading. The smoke check validates the hard limits, section order, heading vocabulary, and table column consistency.

Reference files and READMEs use `# H1`, an introduction, then `##` sections. The root `README.md` is the exception and opens with the repository logo.

## Third-party skills

- Fetch optional upstream skills per session with `scripts/fetch-session.sh`; do not install them permanently or commit fetched files. Keep their source URL and commit-SHA pin in the fetch mapping.
- Use `./scripts/fetch-session.sh --list` to list integrations, `./scripts/fetch-session.sh --skill <skill-name>` for one skill, and `./scripts/fetch-session.sh --all` for all configured skills.
- Preserve and document upstream license declarations. Review applicable terms before using or redistributing third-party material.

## Adapted skills

- Rewrite skills adapted from other collections into this repository's template. Do not copy upstream skill text verbatim.
- Record the upstream repository and commit in frontmatter metadata as `origin: <repo>@<commit>`, and include a distilled-from note and upstream license in the relevant reference.
- Make adapted skills self-contained; they must not require the upstream repository at runtime.

## Local-first behavior

- Prefer local tools for local files, and state when required CLIs, models, or data must already be installed or cached.
- URLs, search, APIs, third-party downloads, and external renderers require connectivity. Do not describe them as offline-capable without a real local cache or backend.
- Do not automatically send input to external services as a fallback. Require explicit selection of network backends and disclose that dependency.

## Validation

Run `bash scripts/smoke.sh` before committing or opening a pull request. It checks shell syntax, skill frontmatter and placement, platform discovery links, secrets, markdown structure, and skill template constraints.

When checking upstream license declarations, run `python3 scripts/sync-licenses.py --check` after installing the script's documented YAML dependency.

## Adding a collection

1. Add each skill under `skills/<collection>/<skill>/SKILL.md` with `name`, `description`, and `license` frontmatter.
2. Add the collection and skills to the root and collection READMEs, and keep platform discovery links in sync.
3. Run the smoke check and submit the changes according to [CONTRIBUTING.md](../CONTRIBUTING.md).
