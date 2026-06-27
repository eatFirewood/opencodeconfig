---
name: github-code-search
description: Use gh CLI, GitHub code search, cloning, rg, and ast-grep to find real implementation patterns across repositories.
---

# GitHub Code Search

Use this skill when looking for how a feature, framework pattern, API, protocol behavior, or architectural idea is implemented in real GitHub projects.

Prefer concrete code evidence over blog posts. Use official docs for API contracts and GitHub code for implementation patterns.

## Search Order

1. Discover repositories with `gh search repos` or web search.
2. Search code remotely with `gh search code` when the target pattern is clear.
3. Clone a small number of high-signal repositories when deeper inspection is needed.
4. Use local `rg` for broad text search.
5. Use AST search only when structural matching is materially better than text search.

## Useful Commands

Remote search:

```bash
gh search code "pattern" --repo OWNER/REPO
gh search code "pattern language:Java"
gh search code "pattern path:src"
```

Repository inspection:

```bash
gh repo clone OWNER/REPO
gh repo view OWNER/REPO --json name,description,defaultBranchRef,url
```

Local source search after cloning:

```bash
rg "pattern"
rg "class SomeName|interface SomeName"
rg "methodName\(" src
```

## Evidence Checklist

For each implementation pattern, capture:

- repository;
- file path;
- class/function/module name;
- surrounding architecture;
- why the pattern is relevant;
- what should not be copied directly;
- whether it is actively maintained or legacy code.

## Analysis Guidance

- Search for multiple independent implementations before concluding a pattern is common.
- Prefer maintained projects and production-oriented examples over toy repositories.
- Look for tests, configuration examples, and docs that confirm intended behavior.
- When comparing implementations, separate protocol-required behavior from project-specific choices.
- If results conflict, explain the tradeoff instead of forcing a single answer.

## Cautions

- Do not paste large source excerpts unless necessary.
- Do not copy license-sensitive code into the target project.
- Do not assume code search results are complete; GitHub code search may miss generated files, vendored code, or private repositories.
- Do not perform write operations on GitHub unless explicitly requested by the user.
