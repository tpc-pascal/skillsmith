# AGENTS.md

A repository collecting agent skill sets. Shared collections live under root `skills/`, are self-contained, and install independently. Conventions for working in this repo:

## Structure

- Each collection lives at `<collection>/`; every skill inside has a single `SKILL.md` (English); `references/` (if present) holds supporting detail read on demand.
- The skill list of each collection and how to install: see that collection's `README.md` (e.g. [`skills/research/README.md`](skills/research/README.md)).
- Mandatory: every new skill collection must live under `skills/<collection>/<skill>/` — no collections at repo root. `scripts/smoke.sh` fails if any `SKILL.md` is found outside `skills/`.
- Shared skills are the canonical source. OpenCode discovers them through `.agents/skills/`, whose entries link directly to the matching `skills/<collection>/<skill>/`. Keep the discovery links aligned with the collection sources; do not maintain duplicate skill content.

## Skill file structure

Every `SKILL.md` must follow this exact order:

1. YAML frontmatter: `name`, `description`, `license`, `metadata`.
2. `# H1` and a one-paragraph intro.
3. `##` sections in order: routing table → specialist section (if any) → `Rules` → `Third-party skills (fetched per session)` (if any) → `references` / `scripts` (if any) → combined flows.

Length: keep `SKILL.md` lean — it loads on every session, so aim for ~45 lines / 2500 characters and push detail into `references/` (read on demand, token-efficient); the hard cap is **70 lines / 4000 characters**, enforced by `scripts/smoke.sh` (which also checks section order, heading vocabulary, and table column consistency). Reference files (`references/`) and READMEs (except the root `README.md`, which opens with the logo) keep `# H1` → intro → `##` sections.

## Third-party skills

- Loaded per session, never installed permanently into an agent's skill directory. Use `scripts/fetch-session.sh`:

```bash
./scripts/fetch-session.sh --list
./scripts/fetch-session.sh --skill <skill-name>
./scripts/fetch-session.sh --all <commit-SHA>
```

- Never commit downloaded files; only pin URL + commit-SHA inside the skill.

## Third-party adaptations

- Skills adapted from other collections are rewritten into this repository's template (routing table, rules, references, combined flows, lean length) — never copied verbatim.
- Every adapted skill records its upstream in frontmatter metadata (`origin: <repo>@<commit>`) and a distilled-from note in its reference, with the upstream license.
- Adapted skill files are self-contained: the upstream repository is not required at run time. Session-fetched skills (above) are the only optional runtime dependency, disclosed per skill.

## Local-first

- Prefer local tools for local files; state when required CLIs, models, and data must already be installed/cached.
- URLs, search, APIs, third-party skill downloads, and external renderers require connectivity. Do not describe them as offline-capable unless the repository has a real local cache/backend.
- Do not send input to external services through automatic fallback. Network backends must be explicitly selected, and that dependency must be disclosed.

## History

- Follow Conventional Commits for all changes.
- For commits materially assisted by Pascal Automation Agent, include `Co-authored-by: pascal-automation-agent[bot] <348848148+pascal-automation-agent[bot]@users.noreply.github.com>` so GitHub can attribute the bot as a co-author.
- Add each third-party session skill in exactly one `feat` commit, in the order skills are introduced. Use `feat(<collection>:<folder>:<third-party-skill>): add <source>/<skill> session skill`; for example, `feat(research:media:watch): add bradautomates/claude-video session skill`.
- Keep that skill's fetch mapping, pin (when first using an upstream), catalog entries, relevant usage guidance, and changelog note together in its commit. A commit must not add multiple third-party skills.
- Do not impose a fixed total commit count or rewrite published history unless explicitly requested.

## Releases

- Collections are independent: no cross-collection routing, references, or install dependencies between them.
- Each third-party skill addition lands in its own `feat` commit (see History), and updates `CHANGELOG.md` in that same commit.
- Third-party attribution (frontmatter `origin:` and the reference distilled-from note) rides the same fold as the skill content it describes — never a standalone commit.
- Releases follow SemVer only: move the `[Unreleased]` CHANGELOG entries into a `## [vX.Y.Z] - date` section, commit, then run `scripts/release.sh vX.Y.Z`; the pushed tag triggers the release workflow, whose notes come from that CHANGELOG section. There are no collection- or skill-level tags.

## Checks

- Run `./scripts/smoke.sh` before committing/PR: frontmatter validity, secret scan, script checks, and skill file structure template checks.
