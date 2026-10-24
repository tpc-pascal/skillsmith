<p align="center">
  <img src="assets/logo.svg" alt="skillsmith" width="560"/>
</p>

<p align="center">
  <a href="https://github.com/tpc-pascal/skillsmith/stargazers"><img src="https://img.shields.io/github/stars/tpc-pascal/skillsmith?label=stars" alt="Stars"></a>
  <a href="https://github.com/tpc-pascal/skillsmith/releases"><img src="https://img.shields.io/github/v/release/tpc-pascal/skillsmith" alt="Release"></a>
  <a href="https://github.com/tpc-pascal/skillsmith/actions/workflows/ci.yml"><img src="https://github.com/tpc-pascal/skillsmith/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

> Compatibility depends on the operating system, agent, and tools required by each skill. Check the skill guide before running it.

The repository currently ships one self-contained collection under `skills/` — every skill installs on its own: [`skills/research/`](skills/research/README.md) (research and reporting).

## Skills

| Collection | Skill | Role | Third-party (per session) |
|---|---|---|---|
| `research` | [`orchestrator`](skills/research/orchestrator/SKILL.md) | Identify needs and coordinate skills | - [tt-a1i/archify](https://github.com/tt-a1i/archify) — `archify` (requires Node) |
|  | [`doc`](skills/research/doc/SKILL.md) | Read/convert PDF, DOCX, and XLSX | - [docling-project/docling](https://github.com/docling-project/docling) — `docling`<br>- [anthropics/skills](https://github.com/anthropics/skills) — `docx`, `pdf` (export, non-MIT license)<br>- [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) — `exploratory-data-analysis`, `statistical-analysis`, `matplotlib` |
|  | [`media`](skills/research/media/SKILL.md) | Process video, audio, and images | - [bradautomates/claude-video](https://github.com/bradautomates/claude-video) — `watch` |
|  | [`web`](skills/research/web/SKILL.md) | Read and search online sources | - [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) — `agent-reach`<br>- [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) — `taste-skill`<br>- [pbakaus/impeccable](https://github.com/pbakaus/impeccable) — `impeccable` (Apache-2.0)<br>- [sickn33/agentic-awesome-skills](https://github.com/sickn33/agentic-awesome-skills) — `efficient-web-research`, `wiki-researcher`<br>- [asgeirtj/system_prompts_leaks](https://github.com/asgeirtj/system_prompts_leaks) — `deep-research` (CC0)<br>- [mvanhorn/last30days-skill](https://github.com/mvanhorn/last30days-skill) — `last30days` |
|  | [`paper`](skills/research/paper/SKILL.md) | Write international-standard or Vietnamese public-facing reports | - [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) — `citation-management`, `litreview`<br>- [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) — `ppt-master`<br>- [sickn33/agentic-awesome-skills](https://github.com/sickn33/agentic-awesome-skills) — `tech-writing-proofread`, `write-in-my-voice`, `stakeholder-investor-reports`, `survey-generator`<br>- [galaxy-dawn/claude-scholar](https://github.com/galaxy-dawn/claude-scholar) — `citation-verification`<br>- [conorbronsdon/avoid-ai-writing](https://github.com/conorbronsdon/avoid-ai-writing) — `avoid-ai-writing`<br>- [blader/humanizer](https://github.com/blader/humanizer) — `humanizer` |

Third-party skills are fetched per session via `scripts/fetch-session.sh`, never installed permanently.

## Install

One collection, one command (omit `<collection>` to list them; append `-g` for user level):

```bash
npx -y github:tpc-pascal/skillsmith <collection>
```

Single skills through the [skills directory](https://skills.sh/tpc-pascal/skillsmith) (skills CLI, Node.js 22.20 or later) — replace `<skill>` and `<agent>` with concrete names:

```bash
npx skills add tpc-pascal/skillsmith --skill <skill> -a <agent>
```

Claude Code plugins:

```bash
claude plugin marketplace add tpc-pascal/skillsmith
claude plugin install <collection>@skillsmith
```

Working inside a clone? OpenCode discovers every skill through `.opencode/skills/` — no install step. Per-tool guides: [OpenCode](docs/opencode-setup.md), [Claude Code](docs/claude-code-setup.md), [Cursor](docs/cursor-setup.md).

## Releases

Versions follow SemVer: every `vX.Y.Z` tag carries a GitHub Release whose notes come from the matching [CHANGELOG.md](CHANGELOG.md) section, cut with `scripts/release.sh vX.Y.Z` and published by CI.

## Features

- **Self-contained** — each collection and skill installs independently.
- **Session-scoped third-party skills** — `scripts/fetch-session.sh` pins URL + commit-SHA, fetched per session, never installed permanently.
- **Local-first** — local CLIs for local files; web sources and APIs require connectivity.

## Repo structure

```text
skills/
  <collection>/       # one skill collection (e.g. research/)
    <skill>/          # each skill in its own subdirectory
      SKILL.md        # skill file (English)
      references/     # reference material (optional)
scripts/              # smoke.sh, fetch-session.sh, install.sh, release.sh
.claude-plugin/       # Claude Code marketplace manifest (research)
.opencode/skills/     # symlinks flattening skills/ for in-place OpenCode discovery
docs/                 # per-tool setup guides
.github/workflows/    # CI running smoke checks
```

Contribution details, the collection checklist, and workflow symbols: [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Code of Conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md); by participating you agree to abide by its code. Report unacceptable behavior privately through a [GitHub security advisory](https://github.com/tpc-pascal/skillsmith/security/advisories/new) or via the maintainer's [GitHub profile](https://github.com/tpc-pascal).

## License

MIT — see [LICENSE](LICENSE). Third-party skills keep their upstream license.
