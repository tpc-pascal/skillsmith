#!/usr/bin/env bash
# Cut an immutable project version tag vX.Y.Z at HEAD and push it; the release
# workflow publishes the GitHub Release with notes from the matching section
# of CHANGELOG.md. Usage: scripts/release.sh vX.Y.Z
set -euo pipefail
cd "$(dirname "$0")/.."

version="${1:-}"
if [[ ! "$version" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "usage: scripts/release.sh vX.Y.Z" >&2
  exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "dirty working tree — commit before cutting a version" >&2
  exit 1
fi

git fetch --quiet origin main
if [[ "$(git rev-parse --abbrev-ref HEAD)" != "main" ]]; then
  echo "must be on main" >&2
  exit 1
fi
if [[ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]]; then
  echo "HEAD does not match origin/main — push first" >&2
  exit 1
fi

if ! grep -q "^## \[$version\]" CHANGELOG.md; then
  echo "CHANGELOG.md has no ## [$version] section — move the [Unreleased] entries first" >&2
  exit 1
fi

if git rev-parse -q --verify "refs/tags/$version" >/dev/null 2>&1; then
  echo "tag $version already exists locally — versions are immutable" >&2
  exit 1
fi
if git ls-remote --exit-code --tags origin "refs/tags/$version" >/dev/null 2>&1; then
  echo "tag $version already exists on origin — versions are immutable" >&2
  exit 1
fi

git tag -a "$version" -m "skillsmith $version"
git push origin "refs/tags/$version"
echo "ok: $version -> $(git rev-parse --short HEAD) — CI will publish the release from CHANGELOG"
