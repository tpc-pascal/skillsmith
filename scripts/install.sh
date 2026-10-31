#!/usr/bin/env bash
# install.sh — install a whole skill collection for OpenCode
set -euo pipefail

# run from a local clone, the npx build (.bin path is a symlink), or via curl
script="$(readlink -f -- "$0" 2>/dev/null || printf %s "$0")"
if [ -f "$script" ] && [ -d "$(dirname "$script")/../skills" ]; then
  root="$(cd "$(dirname "$script")/.." && pwd)"
else
  root="$(mktemp -d)"
  git clone -q --depth 1 https://github.com/tpc-pascal/skillsmith.git "$root"
  trap 'rm -rf "$root"' EXIT
fi

usage() {
  echo "usage: $0 <collection> [-g]" >&2
  echo "available collections:" >&2
  for d in "$root"/skills/*/; do
    [ -d "$d" ] && echo "  $(basename "$d")" >&2
  done
  exit 1
}

[ $# -ge 1 ] || usage
collection="$1"; shift
[ "$#" -le 1 ] && { [ "$#" -eq 0 ] || [ "$1" = "-g" ]; } || usage

[ -d "$root/skills/$collection" ] || { echo "no collection '$collection'" >&2; usage; }

args=()
for d in "$root/skills/$collection"/*/; do
  args+=(--skill "$(basename "$d")")
done

npx -y skills add tpc-pascal/skillsmith "${args[@]}" -a opencode "$@"
