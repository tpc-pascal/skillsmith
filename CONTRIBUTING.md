# Contributing

1. Fork and create a feature branch.
2. Keep third-party skills out of the repo (they are fetched per session via `scripts/fetch-session.sh`).
   Follow the file structure template in [`AGENTS.md`](AGENTS.md) — the "Skill file structure" section.
3. Run `bash scripts/smoke.sh` — it must pass.
4. Follow the [Code of Conduct](CODE_OF_CONDUCT.md).
5. Open a PR with a short description of the change.

## Adding a collection

1. Create `skills/<collection>/<skill>/SKILL.md` (frontmatter `name`/`description`/`license`).
2. Document the collection and its skills in `README.md`.
3. Run `bash scripts/smoke.sh`, then open a PR.

## Workflow symbols

In workflow documentation, `▸` means hand off to the next step, `→` means the flow continues, and `[]` in a diagram describes a source/result type. These symbols are not report source labels.
