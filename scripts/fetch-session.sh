#!/usr/bin/env bash
# fetch-session.sh — fetch skills from their official source repos into a TEMP session directory.
# Nothing is installed permanently: the directory disappears on reboot / tmp cleanup.
# Every source is pinned by commit SHA (no tags/branches, to avoid silent drift).
set -euo pipefail


WATCH_URL="https://github.com/bradautomates/claude-video.git"
WATCH_SHA="03ceb42f7fa2c4439aca01752118044baabffb8f"

AGENTREACH_URL="https://github.com/Panniantong/Agent-Reach.git"
AGENTREACH_SHA="7a38047acf26a729cbb27851e3cb81639da86b29"

DOCLING_URL="https://github.com/docling-project/docling.git"
DOCLING_SHA="07154cdc82500058ad9377bac92beed3de820458"

CITATION_URL="https://github.com/K-Dense-AI/scientific-agent-skills.git"
CITATION_SHA="5f2bc0341354fd5590aef76a533ada1e1e5b4e62"

SCHOLAR_URL="https://github.com/galaxy-dawn/claude-scholar.git"
SCHOLAR_SHA="d394fb599ed9e6ea2212a9e6daa864345fe97a26"

IMPECCABLE_URL="https://github.com/pbakaus/impeccable.git"
IMPECCABLE_SHA="e89e3ada3e875a89ac2c5d33d11e65ebef6fe285"

TASTE_URL="https://github.com/Leonxlnx/taste-skill.git"
TASTE_SHA="12af471f627f866411b4bd785b19646d3672784c"

ARCHIFY_URL="https://github.com/tt-a1i/archify.git"
ARCHIFY_SHA="a4065941f12be7967436261d9934784e381d423c"

PPT_URL="https://github.com/hugohe3/ppt-master.git"
PPT_SHA="5e8856be0da8e6bc85c4aa28acc614478f7b7137"

AVOID_AI_URL="https://github.com/conorbronsdon/avoid-ai-writing.git"
AVOID_AI_SHA=""

# name|url|sha|skill path in the repo
TABLE='
watch|$WATCH_URL|$WATCH_SHA|skills/watch
agent-reach|$AGENTREACH_URL|$AGENTREACH_SHA|agent_reach/skill
docling|$DOCLING_URL|$DOCLING_SHA|docling/.agents/skills/docling
citation-management|$CITATION_URL|$CITATION_SHA|skills/citation-management
citation-verification|$SCHOLAR_URL|$SCHOLAR_SHA|skills/citation-verification
impeccable|$IMPECCABLE_URL|$IMPECCABLE_SHA|.agents/skills/impeccable
taste-skill|$TASTE_URL|$TASTE_SHA|skills/taste-skill
archify|$ARCHIFY_URL|$ARCHIFY_SHA|archify
ppt-master|$PPT_URL|$PPT_SHA|skills/ppt-master
avoid-ai-writing|$AVOID_AI_URL|$AVOID_AI_SHA|skills/avoid-ai-writing
'

OUT="" LICENSES_OUT="" PICK=()
while [ $# -gt 0 ]; do
  case "$1" in
    --list)   awk -F'|' '$1{gsub(/ /,"",$1);print $1}' <<<"$TABLE"; exit 0 ;;
    --all)    mapfile -t PICK < <(awk -F'|' '$1{gsub(/ /,"",$1);print $1}' <<<"$TABLE") ;;
    --skill)  PICK+=("$2"); shift ;;
    --out)    OUT="$2"; shift ;;
    --licenses-out) LICENSES_OUT="$2"; shift ;;
    *) echo "usage: $0 [--list|--all|--skill NAME] [--out DIR] [--licenses-out DIR]" >&2; exit 2 ;;
  esac
  shift
done
[ ${#PICK[@]} -gt 0 ] || { echo "need --all or --skill NAME (see --list)" >&2; exit 2; }
OUT="${OUT:-$(mktemp -d "${TMPDIR:-/tmp}/skillsmith.XXXXXX")}"
mkdir -p "$OUT"
WORK=$(mktemp -d) ; trap 'rm -rf "$WORK"' EXIT

# clone+fetch the exact SHA, sparse-checkout only what is needed, copy into $OUT/<name>
grab() { # url sha path dest
  local url=$1 sha=$2 path=$3 dest=$4
  local key="${url##*/}-$sha" dir="$WORK/${url##*/}-$sha"
  if [ ! -d "$dir" ]; then
    git clone -q --filter=blob:none --no-checkout "$url" "$dir"
    git -C "$dir" sparse-checkout init --no-cone
    git -C "$dir" fetch -q --depth 1 origin "$sha"
  fi
  if [ "$path" = "." ] || [ -z "$path" ]; then
    git -C "$dir" sparse-checkout set "/*"
    git -C "$dir" checkout -q FETCH_HEAD
    rm -rf "$OUT/$dest"
    mkdir -p "$OUT/$dest"
    (shopt -s dotglob; cp -R "$dir"/* "$OUT/$dest"/)
    rm -rf "$OUT/$dest/.git"
  else
    git -C "$dir" sparse-checkout set "$path"
    git -C "$dir" checkout -q FETCH_HEAD
    rm -rf "$OUT/$dest"
    cp -R "$dir/$path" "$OUT/$dest"
  fi
  if [ -n "$LICENSES_OUT" ]; then
    local license_dir="$LICENSES_OUT/$dest"
    mkdir -p "$license_dir"
    for license_file in LICENSE LICENSE.md LICENSE.txt COPYING COPYING.md COPYING.txt; do
      rm -f -- "$license_dir/$license_file"
      if git -C "$dir" cat-file -e "FETCH_HEAD:$license_file" 2>/dev/null; then
        git -C "$dir" show "FETCH_HEAD:$license_file" > "$license_dir/$license_file"
      fi
    done
  fi
}

for name in "${PICK[@]}"; do
  line=$(grep -E "^$name\|" <<<"$TABLE") || { echo "unknown skill '$name' (see --list)" >&2; exit 1; }
  IFS='|' read -r _ url sha path <<<"$line"
  if [[ "$url" =~ ^\$([A-Z0-9]+)_URL$ ]]; then
    variable="${BASH_REMATCH[1]}_URL"
    url="${!variable:?missing source variable $variable}"
  fi
  if [[ "$sha" =~ ^\$([A-Z0-9]+)_SHA$ ]]; then
    variable="${BASH_REMATCH[1]}_SHA"
    sha="${!variable-}"
  fi
  grab "$url" "$sha" "$path" "$name"
  echo "✓ $name → $OUT/$name"
done
echo "SESSION DIR: $OUT (${#PICK[@]} skills) — session-only, nothing is installed"
