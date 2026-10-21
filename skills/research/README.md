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
| `watch` | bradautomates/claude-video | media content summaries for `media` |
| `agent-reach` | Panniantong/Agent-Reach | web/social/search backends for `web` |
| `docling` | docling-project/docling | PDF/DOCX conversion for `doc` |
| `docx`, `pdf` | anthropics/skills | styled DOCX/PDF export for `doc` (fallback: local pandoc/libreoffice) |
| `archify` | tt-a1i/archify | code-backed diagrams + one-page explainers for `orchestrator` (MIT, requires Node) |
| `impeccable` | pbakaus/impeccable | system-UI design language for `web` (Apache-2.0) |
| `citation-management`, `litreview` | K-Dense-AI/scientific-agent-skills | citations and source scoring for `paper` |
| `exploratory-data-analysis`, `statistical-analysis`, `matplotlib` | K-Dense-AI/scientific-agent-skills | data methodology (test selection, checks) and standard charts for `doc` |
| `ppt-master` | hugohe3/ppt-master | PPTX deck creation for `paper` (MIT) |
| `taste-skill` | Leonxlnx/taste-skill | HTML/one-pager design-quality gate for `web` (MIT) |
| `deep-research` | asgeirtj/system_prompts_leaks | Anthropic official deep-research harness (fan-out, dedup, adversarial verify) for `web` (CC0) |
| `last30days` | mvanhorn/last30days-skill | research breadth / signal discovery over the last 30 days for `web` (MIT) |
| `efficient-web-research`, `wiki-researcher` | sickn33/agentic-awesome-skills | token-efficient research for `web` (MIT) |
| `citation-verification` | galaxy-dawn/claude-scholar | citation verification with authority-order checking for `paper` (MIT) |
| `tech-writing-proofread` | sickn33/agentic-awesome-skills | proofreading for `paper` (MIT) |
| `write-in-my-voice`, `stakeholder-investor-reports` | sickn33/agentic-awesome-skills | voice/business reports for `paper` (MIT) |
| `survey-generator` | sickn33/agentic-awesome-skills | survey papers for `paper` (MIT) |
| `avoid-ai-writing` | conorbronsdon/avoid-ai-writing | prose audit / AI-ism removal for `paper` (MIT) |

## Install

```bash
npx skills add tpc-pascal/skillsmith --skill orchestrator --skill doc --skill media --skill paper --skill web
```

Replace the skill list with the names of the skills to install individually.

## General flow

```text
Request ▸ orchestrator ▸ doc / media / web ▸ paper ▸ session archify or docx if needed ▸ verify
```

`▸` means hand off to the next step; `/` means choose the relevant skill, not necessarily run all of them. Web/API sources require connectivity; local-file processing prefers local tools and can continue offline when required tools are available.

## Reports

The `paper` skill supports exactly two forms:

- **International-standard report:** follow the requirements of the relevant field, journal, or organization and guidance for the study type.
- **Vietnamese public-facing report:** explain content to general readers in clear Vietnamese; this is an editorial form, not an official national standard.

Before writing, confirm purpose, audience, report form, language, output, and source scope when not already clear. Keep the main report focused on content; put long extractions, raw data, and supporting assets in separate files when useful.

## Checks

Run `bash scripts/smoke.sh` from the repository root to check syntax, frontmatter, structure, and secrets.
