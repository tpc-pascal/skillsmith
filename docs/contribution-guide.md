# Skillsmith Documentation Hub

> **Version**: 1.0.0  
> **Last Updated**: 2026-11-15  
> **Source**: Official [skillsmith](https://github.com/tpc-pascal/skillsmith) documentation  
> **Purpose**: Single source of truth for repository conventions, commit rules, and contribution workflows

---

## 📌 TABLE OF CONTENTS

1. [Repository Conventions](#1-repository-conventions)
2. [Commit Conventions](#2-commit-conventions)
3. [Contribution Workflow](#3-contribution-workflow)
4. [Repository Structure](#4-repository-structure)
5. [Skill File Structure](#5-skill-file-structure)
6. [Third-Party Skills Management](#6-third-party-skills-management)
7. [Change Grouping Rules](#7-change-grouping-rules)
8. [Delivery Workflow](#8-delivery-workflow)
9. [Validation Requirements](#9-validation-requirements)
10. [Workflow Examples](#10-workflow-examples)
11. [Quick Reference](#11-quick-reference)
12. [Appendices](#12-appendices)

---

## 1. Repository Conventions

*This section is the single source of truth for the repository's structure, skill content, third-party skill handling, and validation rules.*

### 1.1 Repository Structure

- Keep all skill collections under `skills/<collection>/<skill>/`; do not add collections at the repository root.
- Keep each collection self-contained and independently installable. Do not add cross-collection routing, references, or install dependencies.
- Treat the files under `skills/` as canonical skill content. OpenCode discovers them through `.agents/skills/` symlinks; keep those links aligned with their source skills and do not duplicate content.
- Document collection skills and installation in that collection's `README.md`.

```text
.
├── .agents/
│   └── skills/              # Symlinks to skills/ for OpenCode discovery
├── skills/
│   └── <collection>/       # One skill collection (e.g., research/)
│       └── <skill>/        # Each skill in its own subdirectory
│           ├── SKILL.md    # Skill file (English)
│           └── references/ # Reference material (optional)
├── scripts/                # Automation scripts
│   ├── fetch-session.sh    # Fetch third-party skills
│   ├── smoke.sh            # Validation checks
│   ├── bump-pins.sh        # Update third-party SHAs
│   ├── release.sh          # Release automation
│   ├── install.sh          # Collection installation
│   └── sync-licenses.py    # License synchronization
├── docs/                   # Documentation
│   └── contribution-guide.md # This file
├── .github/
│   └── workflows/          # CI/CD workflows
├── AGENTS.md              # Agent instructions
├── CONTRIBUTING.md        # Contribution guide
├── CHANGELOG.md           # Release notes
├── README.md              # Repository overview
└── package.json           # npm configuration
```

### 1.2 Skill File Structure

Every `SKILL.md` follows this order:

1. YAML frontmatter containing `name`, `description`, `license`, and `metadata`.
2. `# H1` and one introductory paragraph.
3. `##` sections in this order: routing table; specialist section, if needed; `Rules`; `Third-party skills (fetched per session)`, if needed; `references` or `scripts`, if needed; combined flows.

Keep `SKILL.md` lean because it loads in every session: aim for about 45 lines or 2,500 characters, and never exceed 70 lines or 4,000 characters. Put supporting detail in `references/` for on-demand reading. The smoke check validates the hard limits, section order, heading vocabulary, and table column consistency.

Reference files and READMEs use `# H1`, an introduction, then `##` sections. The root `README.md` is the exception and opens with the repository logo.

### 1.3 Third-Party Skills

- Fetch optional upstream skills per session with `scripts/fetch-session.sh`; do not install them permanently or commit fetched files. Keep their source URL and commit-SHA pin in the fetch mapping.
- Use `./scripts/fetch-session.sh --list` to list integrations, `./scripts/fetch-session.sh --skill <skill-name>` for one skill, and `./scripts/fetch-session.sh --all` for all configured skills.
- Preserve and document upstream license declarations. Review applicable terms before using or redistributing third-party material.

### 1.4 Adapted Skills

- Rewrite skills adapted from other collections into this repository's template. Do not copy upstream skill text verbatim.
- Record the upstream repository and commit in frontmatter metadata as `origin: <repo>@<commit>`, and include a distilled-from note and upstream license in the relevant reference.
- Make adapted skills self-contained; they must not require the upstream repository at runtime.

### 1.5 Local-First Behavior

- Prefer local tools for local files, and state when required CLIs, models, or data must already be installed or cached.
- URLs, search, APIs, third-party downloads, and external renderers require connectivity. Do not describe them as offline-capable without a real local cache or backend.
- Do not automatically send input to external services as a fallback. Require explicit selection of network backends and disclose that dependency.

### 1.6 Validation

Run `bash scripts/smoke.sh` before committing or opening a pull request. It checks shell syntax, skill frontmatter and placement, platform discovery links, secrets, markdown structure, and skill template constraints.

When checking upstream license declarations, run `python3 scripts/sync-licenses.py --check` after installing the script's documented YAML dependency.

### 1.7 Adding a Collection

1. Add each skill under `skills/<collection>/<skill>/SKILL.md` with `name`, `description`, and `license` frontmatter.
2. Add the collection and skills to the root and collection READMEs, and keep platform discovery links in sync.
3. Run the smoke check and submit the changes according to [CONTRIBUTING.md](../CONTRIBUTING.md).

---

## 2. Commit Conventions

*This section is the single source of truth for commit messages, change grouping, delivery paths, and releases in Skillsmith.*

### 2.1 Commit Messages

Use Conventional Commits with a concise, specific subject:

```text
<type>(<scope>): <imperative summary>
```

Examples:

```text
feat(research:doc:docx): add anthropics/skills session skill
chore(release): consolidate prior releases into v0.2.0
```

Use the type and scope that describe the actual change. For a third-party session skill, use:

```text
feat(<collection>:<folder>:<third-party-skill>): add <source>/<skill> session skill
```

Every commit must include a descriptive body with all four sections:

```text
Work done:
- Describe the concrete changes made.

Effect:
- Explain the resulting behavior or repository state.

Benefits:
- Explain the practical benefit.

Files changed: path/to/file, path/to/another-file
```

Keep each section accurate and specific. `Files changed` must name every file changed by that commit and no files that were not changed.

When Pascal Automation Agent materially assists with a commit, include this co-author trailer:

```text
Co-authored-by: pascal-automation-agent[bot] <348848148+pascal-automation-agent[bot]@users.noreply.github.com>
```

Never add `Co-authored-by: Copilot`.

### 2.2 Change Grouping

- Keep each logically independent change in its own commit; do not enforce a fixed total commit count.
- Add each third-party session skill in exactly one `feat` commit, in the order the skills are introduced. A commit must not add multiple third-party skills.
- Include the skill's pinned fetch mapping, pin when first using an upstream, relevant catalog and usage documentation, and `CHANGELOG.md` entry in that skill's commit.
- Fold a correction into the related change when it is tightly coupled, rather than leaving an unnecessary standalone fix commit.
- Do not rewrite published history unless explicitly requested.

### 2.3 Delivery Workflow

- Maintainer-authored feature commits may be committed directly to `main`.
- External contributions are submitted as pull requests, following [CONTRIBUTING.md](../CONTRIBUTING.md).
- Upstream pin and license inventory updates are handled by their existing workflows and reviewed through the pull requests they create. Do not bypass these workflows with manual updates.
- Prepare a release through a pull request that updates the changelog; after it is merged, run `scripts/release.sh vX.Y.Z` from a clean, up-to-date `main`.

### 2.4 Releases

- Use Semantic Versioning. Release versions apply to the repository, not to an individual collection or skill; do not create collection- or skill-level tags.
- Bundle related changelog entries into project releases rather than cutting a release for every skill addition.
- Move the entries being released from `[Unreleased]` into `## [vX.Y.Z] - YYYY-MM-DD`. The pushed tag starts the release workflow, which publishes notes from that changelog section.
- Third-party skills remain fetched per session and are not redistributed. Preserve upstream license declarations and disclose applicable terms.

---

## 3. Contribution Workflow

*This section outlines how to contribute to Skillsmith.*

### 3.1 Quick Start

1. Fork the repository and create a feature branch.
2. Follow the [repository conventions](#1-repository-conventions) for the content being changed and the [commit conventions](#2-commit-conventions) for commits and releases.
3. Follow the [validation requirements](#16-validation).
4. Follow the [Code of Conduct](../CODE_OF_CONDUCT.md).
5. Open a pull request describing the change.

### 3.2 Workflow Symbols

In workflow documentation, `▸` means hand off to the next step, `→` means the flow continues, and `[]` in a diagram describes a source/result type. These symbols are not report source labels.

---

## 4. Repository Structure

*Visual representation of the repository layout.*

```text
.
├── .agents/
│   └── skills/              # Symlinks to skills/ for OpenCode discovery
├── skills/
│   └── <collection>/       # One skill collection (e.g., research/)
│       └── <skill>/        # Each skill in its own subdirectory
│           ├── SKILL.md    # Skill file (English)
│           └── references/ # Reference material (optional)
├── scripts/                # Automation scripts
│   ├── fetch-session.sh    # Fetch third-party skills
│   ├── smoke.sh            # Validation checks
│   ├── bump-pins.sh        # Update third-party SHAs
│   ├── release.sh          # Release automation
│   ├── install.sh          # Collection installation
│   └── sync-licenses.py    # License synchronization
├── docs/                   # Documentation
│   └── contribution-guide.md # This file
├── .github/
│   └── workflows/          # CI/CD workflows
├── AGENTS.md              # Agent instructions
├── CONTRIBUTING.md        # Contribution guide
├── CHANGELOG.md           # Release notes
├── README.md              # Repository overview
└── package.json           # npm configuration
```

---

## 5. Skill File Structure

*Every `SKILL.md` follows this exact structure.*

### 5.1 SKILL.md Format

Every `SKILL.md` **MUST** follow this exact structure:

```markdown
---
name: skill-name
description: Short description of what the skill does
license: MIT
metadata:
  type: skill
---

# H1 Title

Introductory paragraph explaining the skill's purpose.

## Routing table by input type

| Input Type | Action |
|------------|--------|
| PDF | Process with docling |

## Routing table by need

| Need | Action |
|------|--------|
| Convert PDF | Use doc skill |

## Rules

- Rule 1: Always validate input
- Rule 2: Never send data to external services without consent

## Third-party skills (fetched per session)

| Skill | Source | Used for |
|-------|--------|----------|
| docling | https://github.com/docling-project/docling | PDF conversion |

## references

See [reference-file.md](./references/reference-file.md) for details.
```

### 5.2 Constraints
- **Maximum size**: 70 lines OR 4,000 characters (whichever comes first)
- **Target size**: ~45 lines or ~2,500 characters
- **Validation**: Run `bash scripts/smoke.sh` to check

### 5.3 Section Order (MANDATORY)
1. YAML frontmatter (`name`, `description`, `license`, `metadata`)
2. `# H1` and introductory paragraph
3. `## Routing table by input type` (if applicable)
4. `## Routing table by need` (if applicable)
5. Specialist section (if needed)
6. `## Rules` (MANDATORY)
7. `## Third-party skills (fetched per session)` (if applicable)
8. `## references` or `## scripts` (if applicable)
9. `## Common combined flows` (if applicable)

---

## 6. Third-Party Skills Management

*This section explains how to manage third-party skills in Skillsmith.*

### 6.1 Overview
Third-party skills are **fetched per session** and **never installed permanently**. They are defined in `scripts/fetch-session.sh`.

### 6.2 fetch-session.sh Structure

```bash
#!/usr/bin/env bash
# fetch-session.sh — fetch skills from their official source repos into a TEMP session directory.
# Nothing is installed permanently: the directory disappears on reboot / tmp cleanup.
# Every source is pinned by commit SHA (no tags/branches, to avoid silent drift).

# 1. URL/SHA Variables (Group by source repository)
WATCH_URL="https://github.com/bradautomates/claude-video.git"
WATCH_SHA="03ceb42f7fa2c4439aca01752118044baabffb8f"

AGENTREACH_URL="https://github.com/Panniantong/Agent-Reach.git"
AGENTREACH_SHA="7a38047acf26a729cbb27851e3cb81639da86b29"

# 2. TABLE Definition (name|url|sha|skill path in the repo)
TABLE='
watch|$WATCH_URL|$WATCH_SHA|skills/watch
agent-reach|$AGENTREACH_URL|$AGENTREACH_SHA|agent_reach/skill
docling|$DOCLING_URL|$DOCLING_SHA|docling/.agents/skills/docling
'

# 3. Command Line Interface
# Usage: ./scripts/fetch-session.sh [--list|--all|--skill NAME] [--out DIR] [--licenses-out DIR]
```

### 6.3 Adding a New Third-Party Skill

#### Step 1: Add URL/SHA Variables
```bash
# Add at the end of the variables section (before TABLE)
NEW_SKILL_URL="https://github.com/owner/repo.git"
NEW_SKILL_SHA="abc123def456..."  # Get from: git ls-remote https://github.com/owner/repo.git HEAD
```

#### Step 2: Add to TABLE
```bash
# Add to TABLE section
new-skill|$NEW_SKILL_URL|$NEW_SKILL_SHA|path/to/skill
```

#### Step 3: Verify
```bash
# Check syntax
bash -n scripts/fetch-session.sh

# List all skills
bash scripts/fetch-session.sh --list

# Test fetching a specific skill
bash scripts/fetch-session.sh --skill new-skill --out /tmp/test
```

### 6.4 Current Third-Party Skills (as of 2026-11-15)

| Skill | Source | SHA | Path |
|-------|--------|-----|------|
| watch | bradautomates/claude-video | 03ceb42f | skills/watch |
| agent-reach | Panniantong/Agent-Reach | 7a38047a | agent_reach/skill |
| docling | docling-project/docling | 07154cdc | docling/.agents/skills/docling |
| docx | anthropics/skills | ca45fc49 | skills/docx |
| pdf | anthropics/skills | ca45fc49 | skills/pdf |
| citation-management | K-Dense-AI/scientific-agent-skills | a25cf9ec | skills/citation-management |
| litreview | K-Dense-AI/scientific-agent-skills | a25cf9ec | skills/literature-review |
| exploratory-data-analysis | K-Dense-AI/scientific-agent-skills | a25cf9ec | skills/exploratory-data-analysis |
| statistical-analysis | K-Dense-AI/scientific-agent-skills | a25cf9ec | skills/statistical-analysis |
| matplotlib | K-Dense-AI/scientific-agent-skills | a25cf9ec | skills/matplotlib |
| efficient-web-research | sickn33/agentic-awesome-skills | 8aa41239 | plugins/agentic-awesome-skills-claude/skills/efficient-web-research |
| wiki-researcher | sickn33/agentic-awesome-skills | 8aa41239 | plugins/agentic-awesome-skills-claude/skills/wiki-researcher |
| tech-writing-proofread | sickn33/agentic-awesome-skills | 8aa41239 | plugins/agentic-awesome-skills-claude/skills/tech-writing-proofread |
| write-in-my-voice | sickn33/agentic-awesome-skills | 8aa41239 | plugins/agentic-awesome-skills-claude/skills/write-in-my-voice |
| stakeholder-investor-reports | sickn33/agentic-awesome-skills | 8aa41239 | plugins/agentic-awesome-skills-claude/skills/stakeholder-investor-reports |
| survey-generator | sickn33/agentic-awesome-skills | 8aa41239 | plugins/agentic-awesome-skills-claude/skills/survey-generator |
| last30days | mvanhorn/last30days-skill | 6894d44e | skills/last30days |
| academic-paper | Imbad0202/academic-research-skills | 2e02041a | academic-paper |
| academic-paper-reviewer | Imbad0202/academic-research-skills | 2e02041a | academic-paper-reviewer |
| academic-pipeline | Imbad0202/academic-research-skills | 2e02041a | academic-pipeline |
| academic-deep-research | Imbad0202/academic-research-skills | 2e02041a | deep-research |
| sr-screener | Imbad0202/academic-research-skills | 2e02041a | sr-screener |
| citation-verification | galaxy-dawn/claude-scholar | d394fb59 | skills/citation-verification |
| deep-research | asgeirtj/system_prompts_leaks | 50a261eb | Anthropic/claude-code/skills/anthropic-skills/deep-research |
| archify | tt-a1i/archify | a4065941 | archify |
| impeccable | pbakaus/impeccable | e89e3ada | .agents/skills/impeccable |
| ppt-master | hugohe3/ppt-master | 5e8856be | skills/ppt-master |
| taste-skill | Leonxlnx/taste-skill | 12af471f | skills/taste-skill |
| avoid-ai-writing | conorbronsdon/avoid-ai-writing | 933496df | skills/avoid-ai-writing |
| humanizer | blader/humanizer | 0ef9fe5b | . |

---

## 7. Change Grouping Rules

*This section defines how to group changes in commits.*

### 7.1 One Skill Per Commit
✅ **DO**: Each third-party session skill in exactly one `feat` commit  
❌ **DON'T**: Add multiple third-party skills in one commit

**Example**:
```bash
# ✅ CORRECT: 3 separate commits
git commit -m "feat(research:doc:docx): add anthropics/skills session skill..."
git commit -m "feat(research:doc:pdf): add anthropics/skills session skill..."
git commit -m "feat(research:web:deep-research): add asgeirtj/system_prompts_leaks session skill..."

# ❌ WRONG: All in one commit
git commit -m "feat: add docx, pdf, deep-research skills..."
```

### 7.2 Include All Related Changes
Each skill commit **MUST** include:
- ✅ The skill's pinned fetch mapping (URL/SHA variables)
- ✅ The skill's entry in TABLE
- ✅ Pin when first using an upstream repository
- ✅ Relevant catalog and usage documentation updates
- ✅ `CHANGELOG.md` entry for the skill

### 7.3 Order of Introduction
- Add skills **in the order they are introduced**
- Do not reorder commits after creation

### 7.4 Folding Corrections
- **Fold** tightly coupled corrections into the related change
- Do **not** leave unnecessary standalone fix commits

### 7.5 History Rewriting
- **DO NOT** rewrite published history unless explicitly requested

---

## 8. Delivery Workflow

*This section outlines the delivery workflow for different types of contributors.*

### 8.1 For Maintainers (tpc-pascal)

```mermaid
graph TD
    A[Make Changes] --> B[git add files]
    B --> C[git commit -m "feat(...)"]
    C --> D[Run smoke.sh]
    D -->|Pass| E[git push origin main]
    D -->|Fail| C
    E --> F[Done]
```

**Commands**:
```bash
# Make changes to fetch-session.sh
nano scripts/fetch-session.sh

# Add and commit (1 skill per commit)
git add scripts/fetch-session.sh
git commit -m "feat(research:doc:docx): add anthropics/skills session skill

Work done:
- Add AS_URL and AS_SHA variables for anthropics/skills repository.
- Add docx entry to TABLE in fetch-session.sh with path skills/docx.

Effect:
- docx skill is now available for session fetching.

Benefits:
- Enables DOCX file processing capabilities in the research collection.

Files changed: scripts/fetch-session.sh
Co-authored-by: pascal-automation-agent[bot] <348848148+pascal-automation-agent[bot]@users.noreply.github.com>"

# Run validation
bash scripts/smoke.sh

# Push directly to main
git push origin main
```

### 8.2 For External Contributors

```mermaid
graph TD
    A[Fork Repository] --> B[Create Feature Branch]
    B --> C[Make Changes]
    C --> D[git add files]
    D --> E[git commit -m "feat(...)"]
    E --> F[Run smoke.sh]
    F -->|Pass| G[git push origin branch]
    F -->|Fail| E
    G --> H[Open Pull Request]
    H --> I[Wait for Review]
    I --> J[Done]
```

**Commands**:
```bash
# Fork the repository on GitHub
# Clone your fork
cd /home/tpc-pascal/Work
git clone https://github.com/your-username/skillsmith.git
cd skillsmith

# Create feature branch
git checkout -b feat/add-docx-pdf-deep-research

# Make changes (3 separate commits)
# ... (see section 2.1)

# Run validation
bash scripts/smoke.sh

# Push to your fork
git push origin feat/add-docx-pdf-deep-research

# Open Pull Request on GitHub
# From: feat/add-docx-pdf-deep-research
# To: tpc-pascal/skillsmith:main
```

### 8.3 For Workflow Automations (CI/CD)

- Upstream pin and license inventory updates are **handled by existing workflows**
- These create **automatic Pull Requests** (e.g., `#45`, `#48`)
- **DO NOT** bypass these workflows with manual updates

**Example workflow commits**:
```text
chore(licenses): sync third-party skill declarations (#45)
chore(pins): bump third-party skill SHAs to upstream HEAD (#48)
```

---

## 9. Validation Requirements

*This section outlines the validation requirements before committing or opening a pull request.*

### 9.1 Before Committing

Run the **smoke check**:
```bash
bash scripts/smoke.sh
```

**What it checks**:
1. ✅ Bash syntax in all scripts
2. ✅ SKILL.md frontmatter (name, description, license)
3. ✅ All SKILL.md files under `skills/` directory
4. ✅ OpenCode platform links in `.agents/skills/`
5. ✅ No secrets in the repository
6. ✅ Markdown template structure
7. ✅ Table column consistency
8. ✅ Report contract and changelog

### 9.2 Before Opening a Pull Request

1. **Run smoke.sh**:
   ```bash
   bash scripts/smoke.sh
   ```

2. **Check license sync** (if applicable):
   ```bash
   pip install pyyaml
   python3 scripts/sync-licenses.py --check
   ```

3. **Verify fetch-session.sh**:
   ```bash
   bash -n scripts/fetch-session.sh
   bash scripts/fetch-session.sh --list
   ```

### 9.3 Common Validation Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `missing name` | SKILL.md missing frontmatter | Add `name:` to frontmatter |
| `missing description` | SKILL.md missing description | Add `description:` to frontmatter |
| `missing license` | SKILL.md missing license | Add `license:` to frontmatter |
| `SKILL.md outside skills/` | SKILL.md in wrong location | Move to `skills/<collection>/<skill>/SKILL.md` |
| `duplicate skill names` | Multiple skills with same name | Rename one of them |
| `unclosed code fence` | Markdown syntax error | Fix ``` blocks |
| `inconsistent table column count` | Table has uneven columns | Fix table formatting |

---

## 10. Workflow Examples

### 9.1 Example 1: Adding a New Third-Party Skill (Maintainer)

**Goal**: Add `docx` skill from anthropics/skills

#### Step 1: Clone and Prepare
```bash
cd /home/tpc-pascal/Work/skillsmith
git pull origin main
git status  # Ensure clean working tree
```

#### Step 2: Edit fetch-session.sh
```bash
nano scripts/fetch-session.sh
```

Add variables (after line 48):
```bash
AS_URL="https://github.com/anthropics/skills.git"
AS_SHA="ca45fc496a3436251f191354091d557da31c15b5"
```

Add to TABLE (after docling line):
```bash
docx|$AS_URL|$AS_SHA|skills/docx
```

#### Step 3: Validate
```bash
bash -n scripts/fetch-session.sh
bash scripts/fetch-session.sh --list | grep docx
```

#### Step 4: Commit
```bash
git add scripts/fetch-session.sh
git commit -m "feat(research:doc:docx): add anthropics/skills session skill

Work done:
- Add AS_URL and AS_SHA variables for anthropics/skills repository.
- Add docx entry to TABLE in fetch-session.sh with path skills/docx.

Effect:
- docx skill is now available for session fetching.
- Users can fetch docx skill via scripts/fetch-session.sh --skill docx.

Benefits:
- Enables DOCX file processing capabilities in the research collection.

Files changed: scripts/fetch-session.sh
Co-authored-by: pascal-automation-agent[bot] <348848148+pascal-automation-agent[bot]@users.noreply.github.com>"
```

#### Step 5: Push
```bash
git push origin main
```

---

### 9.2 Example 2: Adding Multiple Skills (Maintainer)

**Goal**: Add `docx`, `pdf`, and `deep-research` skills

#### Step 1: Add docx (Commit 1)
```bash
# Edit fetch-session.sh: Add AS_URL, AS_SHA, and docx to TABLE
git add scripts/fetch-session.sh
git commit -m "feat(research:doc:docx): add anthropics/skills session skill..."
```

#### Step 2: Add pdf (Commit 2)
```bash
# Edit fetch-session.sh: Add pdf to TABLE (AS_URL, AS_SHA already exist)
git add scripts/fetch-session.sh
git commit -m "feat(research:doc:pdf): add anthropics/skills session skill..."
```

#### Step 3: Add deep-research (Commit 3)
```bash
# Edit fetch-session.sh: Add ASG_URL, ASG_SHA, and deep-research to TABLE
git add scripts/fetch-session.sh
git commit -m "feat(research:web:deep-research): add asgeirtj/system_prompts_leaks session skill..."
```

#### Step 4: Push All Commits
```bash
git push origin main
```

---

## 11. Quick Reference

### 10.1 Git Commands

| Action | Command |
|--------|---------|
| Clone repository | `git clone https://github.com/tpc-pascal/skillsmith.git` |
| Create branch | `git checkout -b feat/add-skill` |
| Add file | `git add scripts/fetch-session.sh` |
| Commit | `git commit -m "feat(...): ..."` |
| Push | `git push origin branch-name` |
| Pull | `git pull origin main` |

### 10.2 Validation Commands

| Action | Command |
|--------|---------|
| Run all checks | `bash scripts/smoke.sh` |
| Check Bash syntax | `bash -n scripts/fetch-session.sh` |
| List third-party skills | `bash scripts/fetch-session.sh --list` |
| Fetch all skills | `bash scripts/fetch-session.sh --all --out /tmp/skills` |

### 10.3 Key Rules

- ✅ **1 skill = 1 commit** (for third-party skills)
- ✅ **Conventional Commits format**: `type(scope): summary`
- ✅ **4 sections**: Work done, Effect, Benefits, Files changed
- ✅ **Co-author**: `pascal-automation-agent[bot] <348848148+...>`
- ✅ **Run smoke.sh** before committing

---

## 12. Appendices

### 12.1 References

1. [Skillsmith Repository](https://github.com/tpc-pascal/skillsmith)
2. [Conventional Commits](https://www.conventionalcommits.org/)
3. [GitHub Co-authored Commits](https://docs.github.com/en/pull-requests/committing-changes-to-your-project/creating-and-editing-commits/creating-a-commit-with-multiple-authors)
4. [Semantic Versioning](https://semver.org/)
5. [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)

### 12.2 Related Files

- [AGENTS.md](../AGENTS.md) - Agent instructions
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution workflow
- [CHANGELOG.md](../CHANGELOG.md) - Release notes
- [README.md](../README.md) - Repository overview

---

**💡 Note**: This document is the single source of truth for all repository conventions, commit rules, and contribution workflows. It consolidates the content from the original `commit-conventions.md` and `repository-conventions.md` files.