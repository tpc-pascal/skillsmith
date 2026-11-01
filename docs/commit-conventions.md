# Commit and release conventions

This document is the single source of truth for commit messages, change grouping, delivery paths, and releases in Skillsmith.

## Commit messages

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

## Change grouping

- Keep each logically independent change in its own commit; do not enforce a fixed total commit count.
- Add each third-party session skill in exactly one `feat` commit, in the order the skills are introduced. A commit must not add multiple third-party skills.
- Include the skill's pinned fetch mapping, pin when first using an upstream, relevant catalog and usage documentation, and `CHANGELOG.md` entry in that skill's commit.
- Fold a correction into the related change when it is tightly coupled, rather than leaving an unnecessary standalone fix commit.
- Do not rewrite published history unless explicitly requested.

## Delivery workflow

- Maintainer-authored feature commits may be committed directly to `main`.
- External contributions are submitted as pull requests, following [CONTRIBUTING.md](../CONTRIBUTING.md).
- Upstream pin and license inventory updates are handled by their existing workflows and reviewed through the pull requests they create. Do not bypass these workflows with manual updates.
- Prepare a release through a pull request that updates the changelog; after it is merged, run `scripts/release.sh vX.Y.Z` from a clean, up-to-date `main`.

## Releases

- Use Semantic Versioning. Release versions apply to the repository, not to an individual collection or skill; do not create collection- or skill-level tags.
- Bundle related changelog entries into project releases rather than cutting a release for every skill addition.
- Move the entries being released from `[Unreleased]` into `## [vX.Y.Z] - YYYY-MM-DD`. The pushed tag starts the release workflow, which publishes notes from that changelog section.
- Third-party skills remain fetched per session and are not redistributed. Preserve upstream license declarations and disclose applicable terms.
