---
name: gen-commit-message
description: Draft a commit message that matches the current repository's existing git history. Use when the user asks for a commit message, wants help wording a commit, or wants a message that stays consistent with prior Conventional Commit style in the repo. Do not use for writing the commit itself unless the user asks.
---

# Gen Commit Message

Write commit messages in the style already used in this repository.

## Workflow

1. Inspect recent history first:

```bash
git log --oneline -n 20
```

2. Inspect the current change set:

```bash
git diff --stat
git diff --cached --stat
```

3. Infer the dominant change type from the diff:
   - `feat:` for user-visible additions
   - `fix:` for bug fixes or behavior corrections
   - `refactor:` for code structure changes without behavior change
   - `chore:` for maintenance work such as version bumps or cleanup

4. Mirror the repo's current style:
   - lowercase Conventional Commit prefix
   - short imperative English summary
   - no trailing period
   - one line unless the user asks for a body

5. Return the best single message first. Optionally include 2-3 alternatives only when the scope is ambiguous.

## Current house style

Recent examples in this repo include:

- `refactor: simplify WorldDetail navigation buttons`
- `feat: add TipKit guidance and improve worlds list UI`
- `fix: correct world map vertical scan limit and render ice surfaces`
- `chore: increment build version`

Prefer concrete nouns from the affected feature area over vague summaries like `update app` or `misc fixes`.
