# research — research skills

A collection for document extraction, media processing, web research, diagrams, and report writing. Each skill can be used independently; `orchestrator` routes workflows with multiple steps.

## Skills

| Skill | Role |
|---|---|
| [`orchestrator`](orchestrator/SKILL.md) | Identify needs and coordinate skills |
| [`doc`](doc/SKILL.md) | Read/convert PDF, DOCX, and XLSX |
| [`media`](media/SKILL.md) | Process video, audio, and images |
| [`web`](web/SKILL.md) | Read and search online sources |
| [`paper`](paper/SKILL.md) | Write international-standard or Vietnamese public-facing reports |

## Session skills (fetched per session, not redistributed)

Third-party skills are fetched with `scripts/fetch-session.sh` (URL + commit-SHA pin only, nothing committed here):

| Skill | Source | Used for |
|---|---|---|
| `archify` | [tt-a1i/archify](https://github.com/tt-a1i/archify) | On-demand diagrams and explainers |
| `docling` | [docling-project/docling](https://github.com/docling-project/docling) | Document conversion, OCR, and structured exports |
| `ppt-master` | [hugohe3/ppt-master](https://github.com/hugohe3/ppt-master) | Optional presentation authoring and editing |
| `citation-management` | [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Citation lookup, verification, and BibTeX |
| `litreview` | [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Reproducible literature reviews and evidence synthesis |
| `exploratory-data-analysis` | [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Bounded, local exploration of authorized scientific data |
| `statistical-analysis` | [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Test selection, assumptions, effect sizes, and uncertainty |
| `matplotlib` | [K-Dense-AI/scientific-agent-skills](https://github.com/K-Dense-AI/scientific-agent-skills) | Local scientific plotting and figure export |
| `citation-verification` | [galaxy-dawn/claude-scholar](https://github.com/galaxy-dawn/claude-scholar) | Reference verification principles |
| `avoid-ai-writing` | [conorbronsdon/avoid-ai-writing](https://github.com/conorbronsdon/avoid-ai-writing) | Optional user-authorized prose cleanup |
| `impeccable` | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) | Optional frontend design guidance |
| `taste-skill` | [Leonxlnx/taste-skill](https://github.com/Leonxlnx/taste-skill) | Optional frontend art direction and visual review |
| `watch` | [bradautomates/claude-video](https://github.com/bradautomates/claude-video) | Media content summaries |
| `agent-reach` | [Panniantong/Agent-Reach](https://github.com/Panniantong/Agent-Reach) | Optional public web and social reading |

## Install

```bash
npx skills add tpc-pascal/skillsmith --skill orchestrator --skill doc --skill media --skill paper --skill web
```

Replace the skill list with the names of the skills to install individually.

## General flow

```text
Request ▸ orchestrator ▸ doc / media / web ▸ paper ▸ optional session tools ▸ verify
```

`▸` means hand off to the next step; `/` means choose the relevant skill, not necessarily run all of them. Web/API sources require connectivity; local-file processing prefers local tools and can continue offline when required tools are available.

## Reports

The `paper` skill supports exactly two forms:

- **International-standard report:** follow the requirements of the relevant field, journal, or organization and guidance for the study type.
- **Vietnamese public-facing report:** explain content to general readers in clear Vietnamese; this is an editorial form, not an official national standard.

Before writing, confirm purpose, audience, report form, language, output, and source scope when not already clear. Keep the main report focused on content; put long extractions, raw data, and supporting assets in separate files when useful.

## Checks

Run `bash scripts/smoke.sh` from the repository root to check syntax, frontmatter, structure, and secrets.
