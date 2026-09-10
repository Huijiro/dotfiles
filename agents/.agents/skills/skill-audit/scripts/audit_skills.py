#!/usr/bin/env python3
"""Report structural issues in an Agent Skills directory without changing it."""

from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
LINK_PATTERN = re.compile(r"(?<!!)\[[^]]*\]\(([^)]+)\)")
WORD_PATTERN = re.compile(r"[a-z0-9]{4,}")


def frontmatter(path: Path) -> tuple[dict[str, str], list[str]]:
    lines = path.read_text(encoding="utf-8").splitlines()
    errors: list[str] = []
    if not lines or lines[0] != "---":
        return {}, ["missing opening frontmatter delimiter"]

    try:
        closing = lines.index("---", 1)
    except ValueError:
        return {}, ["missing closing frontmatter delimiter"]

    fields: dict[str, str] = {}
    for line in lines[1:closing]:
        if not line or line.lstrip().startswith("#"):
            continue
        if ":" not in line:
            errors.append(f"invalid frontmatter line: {line!r}")
            continue
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip().strip('"')
    return fields, errors


def referenced_files(path: Path) -> list[Path]:
    references: list[Path] = []
    for target in LINK_PATTERN.findall(path.read_text(encoding="utf-8")):
        target = target.split("#", 1)[0].strip()
        if not target or "://" in target or target.startswith("mailto:"):
            continue
        references.append(path.parent / target)
    return references


def trigger_terms(description: str) -> set[str]:
    return set(WORD_PATTERN.findall(description.lower())) - {
        "when", "with", "this", "that", "from", "into", "your", "uses", "user",
        "skill", "skills", "working", "requests", "asks", "use", "only",
    }


def main() -> int:
    root = Path(sys.argv[1]).resolve() if len(sys.argv) == 2 else Path(".agents/skills").resolve()
    if not root.is_dir():
        print(f"error: skill root does not exist: {root}")
        return 2
    if len(sys.argv) > 2:
        print("usage: audit_skills.py [skill-root]")
        return 2

    errors: list[str] = []
    warnings: list[str] = []
    names: defaultdict[str, list[Path]] = defaultdict(list)
    descriptions: dict[Path, str] = {}
    skill_files = sorted(root.glob("**/SKILL.md"))

    for skill_file in skill_files:
        directory = skill_file.parent
        relative = directory.relative_to(root)
        fields, field_errors = frontmatter(skill_file)
        errors.extend(f"{relative}: {error}" for error in field_errors)

        name = fields.get("name", "")
        description = fields.get("description", "")
        if not name:
            errors.append(f"{relative}: missing name")
        elif not NAME_PATTERN.fullmatch(name):
            errors.append(f"{relative}: invalid name {name!r}")
        else:
            names[name].append(directory)
        if not description:
            errors.append(f"{relative}: missing description")
        else:
            descriptions[directory] = description

        source = directory / "SOURCE.md"
        if not source.is_file():
            errors.append(f"{relative}: missing SOURCE.md")
        elif "**Origin:**" not in source.read_text(encoding="utf-8"):
            errors.append(f"{relative}: SOURCE.md has no Origin field")

        for reference in referenced_files(skill_file):
            if not reference.exists():
                errors.append(
                    f"{relative}: broken relative reference {reference.relative_to(directory)!s}"
                )

    for name, directories in names.items():
        if len(directories) > 1:
            joined = ", ".join(str(path.relative_to(root)) for path in directories)
            errors.append(f"duplicate skill name {name!r}: {joined}")

    items = sorted(descriptions.items(), key=lambda item: str(item[0]))
    for index, (left_dir, left_description) in enumerate(items):
        left_terms = trigger_terms(left_description)
        for right_dir, right_description in items[index + 1 :]:
            right_terms = trigger_terms(right_description)
            union = left_terms | right_terms
            if not union:
                continue
            similarity = len(left_terms & right_terms) / len(union)
            if similarity >= 0.45:
                warnings.append(
                    f"possible trigger overlap ({similarity:.0%}): "
                    f"{left_dir.relative_to(root)} and {right_dir.relative_to(root)}"
                )

    print(f"Audited {len(skill_files)} skill(s) in {root}")
    for message in errors:
        print(f"ERROR: {message}")
    for message in warnings:
        print(f"WARN: {message}")
    if not errors and not warnings:
        print("OK: no structural issues or strong trigger overlaps found")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
