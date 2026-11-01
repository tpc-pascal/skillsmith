<p align="center">
  <img src="assets/logo.svg" alt="skillsmith" width="560"/>
</p>

<p align="center">
  <a href="https://github.com/tpc-pascal/skillsmith/stargazers"><img src="https://img.shields.io/github/stars/tpc-pascal/skillsmith?label=stars" alt="Stars"></a>
  <a href="https://github.com/tpc-pascal/skillsmith/releases"><img src="https://img.shields.io/github/v/release/tpc-pascal/skillsmith" alt="Release"></a>
  <a href="https://github.com/tpc-pascal/skillsmith/actions/workflows/ci.yml"><img src="https://github.com/tpc-pascal/skillsmith/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

> Compatibility depends on the operating system, agent, and tools required by each skill. Check the skill guide before running it.

Collections live under `skills/`. See the [research collection](skills/research/README.md) for its skills and usage.

## Skills

<table>
  <thead>
    <tr>
      <th>Collection</th>
      <th>Skill</th>
      <th>Role</th>
      <th>Third-party (per session)</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="5"><code>research</code></td>
      <td><a href="skills/research/orchestrator/SKILL.md"><code>orchestrator</code></a></td>
      <td>Identify needs and coordinate skills</td>
      <td><a href="https://github.com/tt-a1i/archify">tt-a1i/archify</a> — <code>archify</code></td>
    </tr>
    <tr>
      <td><a href="skills/research/doc/SKILL.md"><code>doc</code></a></td>
      <td>Read/convert PDF, DOCX, and XLSX</td>
      <td><a href="https://github.com/docling-project/docling">docling-project/docling</a> — <code>docling</code><br><a href="https://github.com/K-Dense-AI/scientific-agent-skills">K-Dense-AI/scientific-agent-skills</a> — <code>exploratory-data-analysis</code><br><a href="https://github.com/K-Dense-AI/scientific-agent-skills">K-Dense-AI/scientific-agent-skills</a> — <code>statistical-analysis</code><br><a href="https://github.com/K-Dense-AI/scientific-agent-skills">K-Dense-AI/scientific-agent-skills</a> — <code>matplotlib</code></td>
    </tr>
    <tr>
      <td><a href="skills/research/media/SKILL.md"><code>media</code></a></td>
      <td>Process video, audio, and images</td>
      <td><a href="https://github.com/bradautomates/claude-video">bradautomates/claude-video</a> — <code>watch</code></td>
    </tr>
    <tr>
      <td><a href="skills/research/web/SKILL.md"><code>web</code></a></td>
      <td>Read and search online sources</td>
      <td><a href="https://github.com/Panniantong/Agent-Reach">Panniantong/Agent-Reach</a> — <code>agent-reach</code><br><a href="https://github.com/pbakaus/impeccable">pbakaus/impeccable</a> — <code>impeccable</code><br><a href="https://github.com/Leonxlnx/taste-skill">Leonxlnx/taste-skill</a> — <code>taste-skill</code><br><a href="https://github.com/sickn33/agentic-awesome-skills">sickn33/agentic-awesome-skills</a> — <code>efficient-web-research</code><br><a href="https://github.com/sickn33/agentic-awesome-skills">sickn33/agentic-awesome-skills</a> — <code>wiki-researcher</code></td>
    </tr>
    <tr>
      <td><a href="skills/research/paper/SKILL.md"><code>paper</code></a></td>
      <td>Write international-standard or Vietnamese public-facing reports</td>
      <td><a href="https://github.com/K-Dense-AI/scientific-agent-skills">K-Dense-AI/scientific-agent-skills</a> — <code>citation-management</code><br><a href="https://github.com/K-Dense-AI/scientific-agent-skills">K-Dense-AI/scientific-agent-skills</a> — <code>litreview</code><br><a href="https://github.com/galaxy-dawn/claude-scholar">galaxy-dawn/claude-scholar</a> — <code>citation-verification</code><br><a href="https://github.com/hugohe3/ppt-master">hugohe3/ppt-master</a> — <code>ppt-master</code><br><a href="https://github.com/conorbronsdon/avoid-ai-writing">conorbronsdon/avoid-ai-writing</a> — <code>avoid-ai-writing</code></td>
    </tr>
  </tbody>
</table>

Third-party skills are fetched per session via `scripts/fetch-session.sh`, never installed permanently.

## Install

```bash
# One collection, one command (omit <collection> to list them; append -g for user level)
npx -y github:tpc-pascal/skillsmith <collection>
```

<details>
<summary>Setup guides</summary>

| Platform | Guide |
|---|---|
| OpenCode | [Setup and installation](docs/opencode-setup.md) |

</details>

## Releases

Versions follow SemVer: every `vX.Y.Z` tag carries a GitHub Release whose notes come from the matching [CHANGELOG.md](CHANGELOG.md) section, cut with `scripts/release.sh vX.Y.Z` and published by CI.

## Features

- **Self-contained** — each collection and skill installs independently.
- **Session-scoped third-party skills** — `scripts/fetch-session.sh` pins URL + commit-SHA, fetched per session, never installed permanently.
- **Local-first** — local CLIs for local files; web sources and APIs require connectivity.

## Repo structure

```text
.agents/
  skills/             # discovery links for shared skills
skills/
  <collection>/       # one skill collection (e.g. research/)
    <skill>/          # each skill in its own subdirectory
      SKILL.md        # skill file (English)
      references/     # reference material (optional)
scripts/              # install.sh, fetch-session.sh, bump-pins.sh, smoke.sh, release.sh, sync-licenses.py
docs/                 # platform setup guides
.github/workflows/    # CI, release, pin, and license synchronization
```

Contribution details, the collection checklist, and workflow symbols: [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Code of Conduct

This project follows the [Contributor Covenant](CODE_OF_CONDUCT.md); by participating you agree to abide by its code. Report unacceptable behavior privately through a [GitHub security advisory](https://github.com/tpc-pascal/skillsmith/security/advisories/new) or via the maintainer's [GitHub profile](https://github.com/tpc-pascal).

## License

MIT — see [LICENSE](LICENSE). Third-party skills keep their upstream license.
