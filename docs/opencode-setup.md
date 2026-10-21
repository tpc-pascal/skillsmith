# OpenCode setup

OpenCode discovers skills from `.opencode/skills/<name>/SKILL.md`, the Claude-compatible `.claude/skills/<name>/SKILL.md` and `.agents/skills/<name>/SKILL.md` in the project, plus `~/.config/opencode/skills/<name>/SKILL.md` globally.

## Install with the skills CLI

Requires Node.js 22.20 or later:

```bash
# pick skills and agents interactively
npx skills add tpc-pascal/skillsmith

# non-interactive: every skill, user level
npx skills add tpc-pascal/skillsmith -a opencode -g -y
```

## Install a whole collection

Each collection installs as one unit through the repository installer:

```bash
npx -y github:tpc-pascal/skillsmith research
```

Omit the collection name to list them; append `-g` to install at user level.

## Verify

```bash
ls .agents/skills          # project scope
ls ~/.config/opencode/skills   # global scope
```

Each skill directory contains a `SKILL.md` with `name` and `description` frontmatter; OpenCode exposes them through its `skill` tool.
