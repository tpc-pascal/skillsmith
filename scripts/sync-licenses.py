#!/usr/bin/env python3
"""Synchronize third-party skill license declarations from pinned SKILL.md files."""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
import tempfile
from pathlib import Path
from urllib.parse import urlparse

import yaml

ROOT = Path(__file__).resolve().parent.parent
FETCH_SCRIPT = ROOT / "scripts/fetch-session.sh"
LICENSE_FILE = ROOT / "LICENSE"
START_MARKER = "<!-- BEGIN THIRD-PARTY SKILL LICENSES -->"
END_MARKER = "<!-- END THIRD-PARTY SKILL LICENSES -->"


def fetch_entries() -> list[tuple[str, str, str, str]]:
    source = FETCH_SCRIPT.read_text(encoding="utf-8")
    prefixes: dict[str, dict[str, str]] = {}
    for prefix, field, value in re.findall(
        r'^([A-Z0-9]+)_(URL|SHA)="([^"]+)"$', source, flags=re.MULTILINE
    ):
        prefixes.setdefault(prefix, {})[field] = value

    entries = []
    for name, url_prefix, sha_prefix, skill_path in re.findall(
        r"^([a-z0-9-]+)\|\$([A-Z0-9]+)_URL\|\$([A-Z0-9]+)_SHA\|([^\n]+)$",
        source,
        flags=re.MULTILINE,
    ):
        if url_prefix != sha_prefix or url_prefix not in prefixes:
            raise ValueError(f"{name}: unresolved source variables")
        values = prefixes[url_prefix]
        url = values.get("URL", "")
        sha = values.get("SHA", "")
        parsed = urlparse(url)
        parts = parsed.path.removesuffix(".git").strip("/").split("/")
        if parsed.scheme != "https" or parsed.netloc != "github.com" or len(parts) != 2:
            raise ValueError(f"{name}: unsupported upstream URL {url!r}")
        if not re.fullmatch(r"[0-9a-f]{40}", sha):
            raise ValueError(f"{name}: invalid pinned commit SHA {sha!r}")
        entries.append((name, "/".join(parts), sha, skill_path.strip()))

    if len({name for name, _, _, _ in entries}) != len(entries):
        raise ValueError("duplicate third-party skill names in fetch-session.sh")
    return entries


def license_for_skill(skill_file: Path, license_dir: Path, name: str) -> str:
    text = skill_file.read_text(encoding="utf-8")
    if not text.startswith("---\n"):
        raise ValueError(f"{name}: missing YAML frontmatter in {skill_file}")
    end = text.find("\n---\n", 4)
    if end == -1:
        raise ValueError(f"{name}: unterminated YAML frontmatter in {skill_file}")
    metadata = yaml.safe_load(text[4:end])
    license_value = metadata.get("license") if isinstance(metadata, dict) else None
    if isinstance(license_value, str):
        license_text = license_value.strip()
    elif isinstance(license_value, list) and all(
        isinstance(item, str) and item.strip() for item in license_value
    ):
        license_text = "; ".join(item.strip() for item in license_value)
    elif isinstance(metadata, dict) and "license" not in metadata:
        license_file = next(
            (
                license_dir / name / filename
                for filename in (
                    "LICENSE-CONTENT",
                    "LICENSE-CONTENT.md",
                    "LICENSE-CONTENT.txt",
                    "LICENSE",
                    "LICENSE.md",
                    "LICENSE.txt",
                    "COPYING",
                    "COPYING.md",
                    "COPYING.txt",
                )
                if (license_dir / name / filename).is_file()
            ),
            None,
        )
        if license_file is None:
            raise ValueError(
                f"{name}: no license declaration in SKILL.md or upstream root license file"
            )
        license_contents = license_file.read_text(encoding="utf-8")
        title = next(
            (
                line.strip().removeprefix("#").strip()
                for line in license_contents.splitlines()
                if line.strip()
            ),
            "",
        )
        license_text = f"upstream {license_file.name}: {title or 'see pinned file'}"
        normalized_license = " ".join(license_contents.split())
        if re.search(
            r"Creative Commons\s+Attribution-NonCommercial\s+4\.0\s+International License",
            normalized_license,
            flags=re.IGNORECASE,
        ):
            license_text = "CC BY-NC 4.0 (https://creativecommons.org/licenses/by-nc/4.0/)"
        elif (
            license_file.name.startswith("LICENSE-CONTENT")
            and "Creative Commons Attribution 4.0 International" in normalized_license
        ):
            license_text = "CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/)"
    else:
        raise ValueError(f"{name}: missing or unsupported license declaration")
    if not license_text or "\n" in license_text or "|" in license_text:
        raise ValueError(f"{name}: invalid license declaration {license_text!r}")
    return license_text


def render_block(
    entries: list[tuple[str, str, str, str]],
    skills_dir: Path,
    license_dir: Path,
) -> str:
    if not entries:
        return ""
    lines = [
        START_MARKER,
        "License declarations come from upstream `SKILL.md` metadata or, when absent, an applicable root content license (`LICENSE-CONTENT`) before a generic root LICENSE/COPYING file at the pinned commit.",
        "Review the upstream terms before redistributing any fetched skill.",
        "",
    ]
    for name, repository, sha, _skill_path in entries:
        skill_file = skills_dir / name / "SKILL.md"
        license_text = license_for_skill(skill_file, license_dir, name)
        lines.append(
            f"- `{name}` — https://github.com/{repository} at `{sha}` — {license_text}"
        )
    lines.append(END_MARKER)
    return "\n".join(lines)


def replace_block(current: str, block: str) -> str:
    has_start = START_MARKER in current
    has_end = END_MARKER in current
    if has_start != has_end:
        raise ValueError("LICENSE contains only one third-party license marker")
    if not block:
        return current
    if has_start:
        pattern = re.compile(
            rf"{re.escape(START_MARKER)}.*?{re.escape(END_MARKER)}",
            flags=re.DOTALL,
        )
        updated, count = pattern.subn(block, current, count=1)
        if count != 1:
            raise ValueError("LICENSE has malformed third-party license markers")
        return updated

    intro = (
        "---\n\n"
        "Third-party skills — NOT bundled in this repository. They are fetched into a\n"
        "temporary session directory by scripts/fetch-session.sh from their upstream\n"
        "repositories:\n\n"
    )
    return f"{current.rstrip()}\n\n{intro}{block}\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true", help="report drift without editing")
    mode.add_argument("--write", action="store_true", help="update LICENSE")
    parser.add_argument(
        "--skills-dir",
        type=Path,
        help=argparse.SUPPRESS,
    )
    args = parser.parse_args()

    try:
        entries = fetch_entries()
        if not entries:
            current = LICENSE_FILE.read_text(encoding="utf-8")
            updated = current
        elif args.skills_dir:
            skills_dir = args.skills_dir
            block = render_block(entries, skills_dir, skills_dir / ".upstream-licenses")
            current = LICENSE_FILE.read_text(encoding="utf-8")
            updated = replace_block(current, block)
        else:
            with tempfile.TemporaryDirectory(prefix="skillsmith-license-sync-") as temp:
                skills_dir = Path(temp) / "skills"
                license_dir = Path(temp) / "licenses"
                subprocess.run(
                    [
                        str(FETCH_SCRIPT),
                        "--all",
                        "--out",
                        str(skills_dir),
                        "--licenses-out",
                        str(license_dir),
                    ],
                    cwd=ROOT,
                    check=True,
                )
                block = render_block(entries, skills_dir, license_dir)
                current = LICENSE_FILE.read_text(encoding="utf-8")
                updated = replace_block(current, block)
    except (OSError, ValueError, subprocess.CalledProcessError, yaml.YAMLError) as exc:
        print(f"sync-licenses: {exc}", file=sys.stderr)
        return 2

    if current == updated:
        print("LICENSE third-party skill declarations are up to date.")
        return 0

    if args.check:
        print("LICENSE third-party skill declarations are out of date.")
        return 1

    LICENSE_FILE.write_text(updated, encoding="utf-8")
    print(f"Updated LICENSE with declarations for {len(entries)} pinned skills.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
