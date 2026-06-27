---
name: batched-search-discipline
description: Use for local rg/grep/AST searches. Enforces narrow, batched searches instead of whole-home, whole-config, node_modules, logs, database, snapshot, or cache scans.
---

# Batched Search Discipline

Use this skill before any local text or structural search.

## Rules

- Do not run whole-home, whole-workspace-root, or mixed broad searches such as `rg PATTERN /home/wt ~/.config/opencode project/.opencode`.
- Search one known file or one small known directory at a time.
- Split searches into batches by source type: config files, logs, source files, generated/cache directories, package metadata.
- Exclude heavy directories unless explicitly required: `node_modules`, `.git`, `target`, `build`, `dist`, `logs`, `snapshot`, `storage`, `.cache`, database files, lockfile-adjacent dependency trees.
- Prefer `read` for known config files and short JSON files instead of `rg`.
- Prefer tool-specific status commands, for example `opencode mcp list`, before searching internal storage.
- If a search returns huge output, stop and narrow the path or pattern before continuing.

## Safe Patterns

Known files:

```bash
rg -n "pattern" "/exact/file.json"
```

Small config batch:

```bash
rg -n "pattern" "/home/wt/.config/opencode/opencode.json" "/home/wt/.config/opencode/oh-my-openagent.json"
```

Small source batch:

```bash
rg -n --glob '!**/node_modules/**' --glob '!**/target/**' "pattern" "src/main/java"
```

## Before Searching

State the batch scope in plain language: what files or directories are included, what is excluded, and why this batch is small enough.

## After Searching

Summarize only the relevant matches. Do not paste large unrelated output.
