---
name: skill-audit
description: Audit the project-local skill catalog for invalid frontmatter, missing provenance records, broken relative references, duplicate names, and overlapping triggers. Use only when explicitly invoked to maintain skills.
disable-model-invocation: true
allowed-tools: Bash(python3:*)
---

# Skill audit

Run this audit only when explicitly asked to inspect or maintain the local skill catalog. It reports problems and does not modify skills.

```bash
python3 .agents/skills/skill-audit/scripts/audit_skills.py
```

Pass a different skill root only when auditing another catalog:

```bash
python3 .agents/skills/skill-audit/scripts/audit_skills.py /path/to/skills
```

Fix reported errors deliberately. Potential trigger overlaps are review prompts, not automatic deletion criteria.
