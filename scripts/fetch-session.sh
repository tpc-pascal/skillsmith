#!/usr/bin/env bash
# fetch-session.sh — fetch skills from their official source repos into a TEMP session directory.
# Nothing is installed permanently: the directory disappears on reboot / tmp cleanup.
# Every source is pinned by commit SHA (no tags/branches, to avoid silent drift).
set -euo pipefail

CV_URL="https://github.com/bradautomates/claude-video.git"
CV_SHA="03ceb42f7fa2c4439aca01752118044baabffb8f"
AR_URL="https://github.com/Panniantong/Agent-Reach.git"
AR_SHA="94f06c1969dfc1834001269d79d3ad0972d9dee6"
AS_URL="https://github.com/anthropics/skills.git"
AS_SHA="dbd4588f9e1033efb41dad4bef2f7947c8993d44"
DL_URL="https://github.com/docling-project/docling.git"
DL_SHA="dd477a9f5feb3c505caeb6e73931bf93cecc79f4"
KS_URL="https://github.com/K-Dense-AI/scientific-agent-skills.git"
KS_SHA="a1043ef544e3a100c28e70a736b6cf32554d0677"
AX_URL="https://github.com/tt-a1i/archify.git"
AX_SHA="25cf37080fc8b1dbe758a4efc3935b55f3327083"
IM_URL="https://github.com/pbakaus/impeccable.git"
IM_SHA="dad8dbb3aac21ad1fa236c110315ef4abece23e8"
PX_URL="https://github.com/hugohe3/ppt-master.git"
PX_SHA="c350bc31e6d43b7bcf5234183d650ba8f9f4c9d7"
TS_URL="https://github.com/Leonxlnx/taste-skill.git"
TS_SHA="63aba5f43b5056758b15bbe7d683da8c86a7a7ad"
AAS_URL="https://github.com/sickn33/agentic-awesome-skills.git"
AAS_SHA="c808e6e480696d243e0668ebbc3499bb8e7e10a4"
CB_URL="https://github.com/conorbronsdon/avoid-ai-writing.git"
CB_SHA="209815cdeb4af942616daec89a5e0a706c804e3a"
ASG_URL="https://github.com/asgeirtj/system_prompts_leaks.git"
ASG_SHA="e7e53f2bc29199dfada98aa9f5d24621c2f65684"
GD_URL="https://github.com/galaxy-dawn/claude-scholar.git"
GD_SHA="d394fb599ed9e6ea2212a9e6daa864345fe97a26"
L30_URL="https://github.com/mvanhorn/last30days-skill.git"
L30_SHA="832d09591568e37dd990ccb9d5c51fb4a403f5ed"

# name|url|sha|skill path in the repo
TABLE='
watch|$CV_URL|$CV_SHA|skills/watch
agent-reach|$AR_URL|$AR_SHA|agent_reach/skill
docling|$DL_URL|$DL_SHA|docling/.agents/skills/docling
docx|$AS_URL|$AS_SHA|skills/docx
pdf|$AS_URL|$AS_SHA|skills/pdf
citation-management|$KS_URL|$KS_SHA|skills/citation-management
litreview|$KS_URL|$KS_SHA|skills/literature-review
exploratory-data-analysis|$KS_URL|$KS_SHA|skills/exploratory-data-analysis
statistical-analysis|$KS_URL|$KS_SHA|skills/statistical-analysis
matplotlib|$KS_URL|$KS_SHA|skills/matplotlib
archify|$AX_URL|$AX_SHA|archify
impeccable|$IM_URL|$IM_SHA|.agents/skills/impeccable
ppt-master|$PX_URL|$PX_SHA|skills/ppt-master
taste-skill|$TS_URL|$TS_SHA|skills/taste-skill
deep-research|$ASG_URL|$ASG_SHA|Anthropic/claude-code/skills/anthropic-skills/deep-research
last30days|$L30_URL|$L30_SHA|skills/last30days
efficient-web-research|$AAS_URL|$AAS_SHA|plugins/agentic-awesome-skills-claude/skills/efficient-web-research
wiki-researcher|$AAS_URL|$AAS_SHA|plugins/agentic-awesome-skills-claude/skills/wiki-researcher
citation-verification|$GD_URL|$GD_SHA|skills/citation-verification
tech-writing-proofread|$AAS_URL|$AAS_SHA|plugins/agentic-awesome-skills-claude/skills/tech-writing-proofread
write-in-my-voice|$AAS_URL|$AAS_SHA|plugins/agentic-awesome-skills-claude/skills/write-in-my-voice
stakeholder-investor-reports|$AAS_URL|$AAS_SHA|plugins/agentic-awesome-skills-claude/skills/stakeholder-investor-reports
survey-generator|$AAS_URL|$AAS_SHA|plugins/agentic-awesome-skills-claude/skills/survey-generator
avoid-ai-writing|$CB_URL|$CB_SHA|skills/avoid-ai-writing
'

OUT="" PICK=()
while [ $# -gt 0 ]; do
  case "$1" in
    --list)   awk -F'|' '$1{gsub(/ /,"",$1);print $1}' <<<"$TABLE"; exit 0 ;;
    --all)    mapfile -t PICK < <(awk -F'|' '$1{gsub(/ /,"",$1);print $1}' <<<"$TABLE") ;;
    --skill)  PICK+=("$2"); shift ;;
    --out)    OUT="$2"; shift ;;
    *) echo "usage: $0 [--list|--all|--skill NAME] [--out DIR]" >&2; exit 2 ;;
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
  git -C "$dir" sparse-checkout set "$path"
  git -C "$dir" checkout -q FETCH_HEAD
  rm -rf "$OUT/$dest"
  cp -R "$dir/$path" "$OUT/$dest"
}

for name in "${PICK[@]}"; do
  line=$(grep -E "^$name\|" <<<"$TABLE") || { echo "unknown skill '$name' (see --list)" >&2; exit 1; }
  IFS='|' read -r _ url sha path <<<"$line"
  url="${url//\$CV_URL/$CV_URL}"; url="${url//\$AR_URL/$AR_URL}"
  url="${url//\$AS_URL/$AS_URL}"; url="${url//\$DL_URL/$DL_URL}"
  url="${url//\$KS_URL/$KS_URL}"; url="${url//\$AX_URL/$AX_URL}"
  url="${url//\$IM_URL/$IM_URL}"; url="${url//\$PX_URL/$PX_URL}"
  url="${url//\$TS_URL/$TS_URL}"; url="${url//\$AAS_URL/$AAS_URL}"
  url="${url//\$CB_URL/$CB_URL}"; url="${url//\$ASG_URL/$ASG_URL}"
  url="${url//\$GD_URL/$GD_URL}"; url="${url//\$L30_URL/$L30_URL}"
  sha="${sha//\$CV_SHA/$CV_SHA}"; sha="${sha//\$AR_SHA/$AR_SHA}"
  sha="${sha//\$AS_SHA/$AS_SHA}"; sha="${sha//\$DL_SHA/$DL_SHA}"
  sha="${sha//\$KS_SHA/$KS_SHA}"; sha="${sha//\$AX_SHA/$AX_SHA}"
  sha="${sha//\$IM_SHA/$IM_SHA}"; sha="${sha//\$PX_SHA/$PX_SHA}"
  sha="${sha//\$TS_SHA/$TS_SHA}"; sha="${sha//\$AAS_SHA/$AAS_SHA}"
  sha="${sha//\$CB_SHA/$CB_SHA}"; sha="${sha//\$ASG_SHA/$ASG_SHA}"
  sha="${sha//\$GD_SHA/$GD_SHA}"; sha="${sha//\$L30_SHA/$L30_SHA}"
  grab "$url" "$sha" "$path" "$name"
  echo "✓ $name → $OUT/$name"
done
echo "SESSION DIR: $OUT (${#PICK[@]} skills) — session-only, nothing is installed"
