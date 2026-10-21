# Cursor setup

Cursor discovers skills from `.agents/skills/<name>/SKILL.md` in the project and `~/.cursor/skills/<name>/SKILL.md` globally.

## Install with the skills CLI

Requires Node.js 22.20 or later:

```bash
# pick skills and agents interactively
npx skills add tpc-pascal/skillsmith

# non-interactive: every skill, user level
npx skills add tpc-pascal/skillsmith -a cursor -g -y
```

## Install a whole collection

Each collection installs as one unit through the repository installer; extra arguments are forwarded to the skills CLI:

```bash
npx -y github:tpc-pascal/skillsmith research -a cursor
```

Omit the collection name to list them; append `-g` to install at user level.

## Verify

```bash
ls .agents/skills      # project scope
ls ~/.cursor/skills    # global scope
```

Each skill directory contains a `SKILL.md` with `name` and `description` frontmatter following the shared Agent Skills specification.
