# OpenCode setup

OpenCode discovers project skills from `.agents/skills/<name>/SKILL.md` (as well as `.opencode/skills/<name>/SKILL.md`) and user skills from `~/.config/opencode/skills/<name>/SKILL.md`. This is the currently supported integration; the shared skill collections are designed to grow to additional platforms over time.

The shared skill source remains under `skills/<collection>/<name>/`. Each `.agents/skills/<name>` entry links directly to the corresponding shared skill, using OpenCode's Agent Skills discovery path without a separate platform-link directory. The existing install commands continue to use the shared collection.

## Install with the skills CLI

Requires Node.js 22.20 or later:

```bash
# Install selected skills for OpenCode
npx skills add tpc-pascal/skillsmith -a opencode

# Install every skill at user level
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
ls .opencode/skills             # project scope
ls ~/.config/opencode/skills    # user scope
```

Each skill directory contains a `SKILL.md` with `name` and `description` frontmatter; OpenCode exposes skills through its `skill` tool.
