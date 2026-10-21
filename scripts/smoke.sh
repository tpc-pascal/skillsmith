#!/usr/bin/env bash
# smoke.sh — quick checks, run locally and on CI
set -euo pipefail
cd "$(dirname "$0")/.."

echo "== checking bash syntax"
bash -n scripts/fetch-session.sh
bash -n scripts/smoke.sh
bash -n scripts/install.sh
bash -n scripts/release.sh

echo "== checking SKILL frontmatter"
python3 - <<'PY'
import glob, sys
try:
    import yaml
except ImportError:
    sys.exit("pyyaml required: pip install pyyaml")
for f in sorted(glob.glob("skills/*/*/SKILL.md")):
    fm = open(f, encoding="utf-8").read().split("---", 2)[1]
    d = yaml.safe_load(fm)
    for k in ("name", "description", "license"):
        assert d.get(k), f"{f}: missing {k}"
    print("ok", f, d["name"], len(d["description"]))
PY

echo "== every skill collection must live under skills/ (mandatory)"
stray=$(git ls-files | grep -E '(^|/)SKILL\.md$' | grep -v '^skills/' || true)
if [ -n "$stray" ]; then
  echo "FAIL: SKILL.md outside skills/:" >&2
  echo "$stray" >&2
  exit 1
fi

echo "== running fetch-session --list (offline)"
./scripts/fetch-session.sh --list | grep -q watch

echo "== secret scan"
if git grep -nE "ghp_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{8,}|AKIA[0-9A-Z]{16}|xox-[A-Za-z-]+|/home/[a-z]+"; then
  echo "possible secret or personal path" >&2
  exit 1
fi
echo "== checking markdown template structure"
python3 - <<'PY'
import re, sys
from pathlib import Path

ALLOWED = {
    "Routing table by input type",
    "Routing table by need",
    "Confirm report requirements",
    "Orchestration rules",
    "Workflow rules",
    "Rules",
    "Common combined flows",
    "Third-party skills (fetched per session)",
    "Two report forms",
    "DOCX and PDF export",
    "Research sources",
    "references",
    "scripts",
}
errors = []

def split_frontmatter(text):
    if not text.startswith("---\n"):
        return None, text
    end = text.find("\n---\n", 3)
    if end == -1:
        return None, text
    return text[4:end], text[end + 5:]

def strip_fences(lines):
    out, in_fence = [], False
    for line in lines:
        if line.lstrip().startswith("```"):
            in_fence = not in_fence
            out.append(None)
        else:
            out.append(None if in_fence else line)
    return out, in_fence

def h2_list(out_lines):
    res = []
    for line in out_lines:
        if line is None:
            continue
        m = re.match(r"^(##) (.+)$", line)
        if m:
            res.append(m.group(2).strip())
    return res

def check_tables(path, out_lines, unclosed_fence):
    if unclosed_fence:
        errors.append(f"{path}: unclosed code fence")
    block = []
    def flush(block):
        if len(block) < 2:
            return
        counts = [len(ln.split("|")[1:-1]) for ln in block]
        if len(set(counts)) > 1:
            errors.append(f"{path}: inconsistent table column count {counts}: {block[0][:60]!r}")
    for line in out_lines:
        if line is not None and line.startswith("|"):
            block.append(line)
        else:
            flush(block)
            block = []
    flush(block)

for md in sorted(Path(".").rglob("*.md")):
    if ".git" in md.parts:
        continue
    fm, body = split_frontmatter(md.read_text(encoding="utf-8"))
    out, unclosed = strip_fences(body.split("\n"))
    check_tables(md, out, unclosed)
    if md != Path("README.md") and not any(l for l in out if l and re.match(r"^# [^#]", l)):
        errors.append(f"{md}: missing H1")
    if md.name != "SKILL.md":
        continue
    if fm is None:
        errors.append(f"{md}: missing frontmatter")
        continue
    for key in ("name:", "description:", "license:"):
        if key not in fm:
            errors.append(f"{md}: frontmatter missing {key}")
    h2 = h2_list(out)
    for h in h2:
        if h not in ALLOWED:
            errors.append(f"{md}: heading outside the allowed vocabulary: {h!r}")
    def idx(prefix):
        return next((i for i, h in enumerate(h2) if h.startswith(prefix)), None)
    route = idx("Routing table")
    rules = next((i for i, h in enumerate(h2) if h == "Rules" or h.endswith(" rules")), None)
    third = idx("Third-party skills")
    primary = idx("Two report forms")
    if route is None and primary is None:
        errors.append(f"{md}: missing routing/specialist section")
    if rules is None:
        errors.append(f"{md}: missing Rules section")
    if route is not None and rules is not None and route > rules:
        errors.append(f"{md}: routing table must precede Rules")
    if third is not None and rules is not None and third < rules:
            errors.append(f"{md}: Third-party skills section must follow Rules")
    n_lines = len(body.rstrip("\n").split("\n"))
    n_chars = len(body)
    if n_lines > 70 or n_chars > 4000:
        errors.append(f"{md}: exceeds the limit {n_lines} lines/{n_chars} chars (max 70/4000)")

for sk in sorted(Path(".").glob("skills/*/*/SKILL.md")):
    _, body = split_frontmatter(sk.read_text(encoding="utf-8"))
    if "references/" in body:
        if not (sk.parent / "references").is_dir():
            errors.append(f"{sk}: body references references/ but the references directory is missing")

if errors:
    print("\n".join(errors), file=sys.stderr)
    sys.exit(f"template structure check failed: {len(errors)} error(s)")
print("template structure OK")
PY

echo "== checking report contract and changelog"
python3 - <<'PY'
from pathlib import Path

paper = Path("skills/research/paper")
skill = (paper / "SKILL.md").read_text(encoding="utf-8")
for phrase in ("report-academic.md", "report-template.md", "output-format.md", "reporting-principles-sources.md"):
  assert phrase in skill, f"SKILL.md: missing {phrase}"
for ref in ("report-academic", "report-template", "output-format", "reporting-principles-sources"):
  assert (paper / "references" / f"{ref}.md").is_file(), f"missing {ref}.md"

changelog = Path("CHANGELOG.md").read_text(encoding="utf-8")
collections = [d.name for d in Path("skills").iterdir() if d.is_dir()]
for c in collections:
  assert c in changelog, f"CHANGELOG.md does not mention collection: {c}"
PY

echo "smoke OK"
