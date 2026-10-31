#!/usr/bin/env bash
# bump-pins.sh — refresh third-party skill SHAs in fetch-session.sh to upstream HEAD.
# --check (default): report drift only, never edit.
# --write: validate each new SHA is fetchable, rewrite the XX_SHA lines, then run
#          fetch-session.sh --all so an upstream path restructure can never reach a PR.
# Writes pins-report.md (markdown table) and unreachable.txt (empty when healthy).
set -euo pipefail
cd "$(dirname "$0")/.."

FETCH=scripts/fetch-session.sh
MODE="${1:---check}"
REPORT=pins-report.md
PART=pins-report.part.md
UNREACH=unreachable.txt
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

: >"$PART"
: >"$UNREACH"

PREFIXES=$(sed -nE 's/^([A-Z0-9]+)_URL=".*"$/\1/p' "$FETCH")

for n in $PREFIXES; do
  url=$(sed -n "s/^${n}_URL=\"\(.*\)\"$/\1/p" "$FETCH")
  pin=$(sed -n "s/^${n}_SHA=\"\(.*\)\"$/\1/p" "$FETCH")
  head=$(git ls-remote "$url" HEAD 2>/dev/null | cut -f1 || true)
  if [ -z "$head" ]; then
    echo "unreachable $n $url" >>"$UNREACH"
    continue
  fi
  if [ "$head" = "$pin" ]; then
    echo "ok        $n ${pin:0:7}"
    continue
  fi
  dir="$WORK/$n"
  if ! git clone -q --filter=blob:none --no-checkout "$url" "$dir" 2>/dev/null ||
    ! git -C "$dir" fetch -q --depth 1 origin "$head" 2>/dev/null; then
    echo "unreachable-sha $n ${head:0:7} $url" >>"$UNREACH"
    continue
  fi
  echo "stale     $n ${pin:0:7} -> ${head:0:7}"
  echo "| \`$n\` | \`$url\` | \`${pin:0:7}\` | \`${head:0:7}\` |" >>"$PART"
  if [ "$MODE" = "--write" ]; then
    sed -i "s/^${n}_SHA=\".*\"$/${n}_SHA=\"${head}\"/" "$FETCH"
  fi
done

if [ -s "$PART" ] && [ "$MODE" = "--write" ]; then
  echo "== post-bump smoke: fetch-session.sh --all"
  ./scripts/fetch-session.sh --all --out "$WORK/smoke" >/dev/null
fi

{
  echo "## Third-party pin bumps"
  echo
  if [ -s "$PART" ]; then
    echo "| Prefix | Repository | Old pin | New HEAD |"
    echo "|---|---|---|---|"
    cat "$PART"
  else
    echo "All pins already track upstream HEAD."
  fi
  if [ -s "$UNREACH" ]; then
    echo
    echo "### Unreachable upstreams (pins kept unchanged)"
    echo '```'
    cat "$UNREACH"
    echo '```'
  fi
} >"$REPORT"
rm -f "$PART"

echo "bump-pins done (mode=$MODE): $(grep -c '^|' "$REPORT") table lines, $(wc -l <"$UNREACH") unreachable"
