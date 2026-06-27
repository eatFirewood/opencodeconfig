---
name: github-research
description: Use gh CLI for GitHub repository research, open-source project evaluation, issues, PRs, releases, and maintenance analysis.
---

# GitHub Research

Use this skill when researching GitHub projects, comparing open-source implementations, evaluating repository maturity, or collecting issue/PR/release evidence.

Prefer `gh` CLI when available. Use web search only to discover candidates or official context that is not conveniently available through GitHub.

## Core Commands

Repository discovery and overview:

```bash
gh search repos "query"
gh repo view OWNER/REPO
gh repo view OWNER/REPO --json name,description,stargazerCount,forkCount,watchers,defaultBranchRef,licenseInfo,pushedAt,updatedAt,url
```

Issues and PRs:

```bash
gh issue list --repo OWNER/REPO
gh issue view ID --repo OWNER/REPO --json title,body,comments,labels,state,createdAt,updatedAt,url
gh pr list --repo OWNER/REPO
gh pr view ID --repo OWNER/REPO --json title,body,files,commits,reviews,comments,state,createdAt,updatedAt,url
gh pr diff ID --repo OWNER/REPO
```

Releases and metadata:

```bash
gh release list --repo OWNER/REPO
gh release view TAG --repo OWNER/REPO
gh api repos/OWNER/REPO
```

## Research Flow

1. Discover candidate repositories with `gh search repos` and web search when needed.
2. Inspect README, docs, examples, and configuration files.
3. Check maintenance signals: recent commits, release cadence, open issues, stale PRs, and maintainer responses.
4. Distinguish facts from assumptions. Do not infer support for a feature unless README, docs, code, issue, or PR evidence confirms it.
5. Clone or fetch source only when source-level analysis is needed.
6. Use local `rg` after cloning for implementation details.
7. Summarize findings with repository name, relevant files or docs, evidence, and practical takeaways.

## Output Expectations

When reporting findings, include:

- project name and URL;
- language/framework;
- what the project actually does;
- whether it is directly usable or only useful as a reference;
- notable features and limitations;
- maintenance status and risk signals;
- evidence-backed conclusions, not guesses.

## Cautions

- Do not treat stars as proof of quality.
- Do not treat README claims as complete implementation proof when the source code contradicts them.
- Do not list abandoned projects as recommendations without marking the risk.
- Do not perform write operations on GitHub unless explicitly requested by the user.
