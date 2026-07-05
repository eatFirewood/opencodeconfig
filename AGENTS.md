# Global OpenCode Rules

## Code Documentation

After writing or modifying code, add or update comments for every new or changed class, method, and member.

- Class comments must explain the class responsibility and when it should be used.
- Method comments must explain what the method does, important parameters, return value, and side effects when relevant.
- Member comments must explain the purpose of fields, properties, constants, and configuration values when the name alone is not enough.
- Keep comments concise and accurate. Do not restate obvious implementation details.
- Write newly added code comments in Chinese.
- If a language has a standard documentation format, use it, for example JSDoc, TSDoc, JavaDoc, docstrings, XML documentation comments, or Rust doc comments.
- When editing existing code, update stale comments in the touched area so they still match behavior.

## Effective Additions, Minimal Mutation

Before and after implementation, keep changes reviewable by favoring effective additions and minimizing mutation of existing behavior.

- New code is often easier to review than broad edits to existing code; use additive, well-bounded components when they keep old behavior isolated.
- Mutating existing code carries higher review cost. Every changed line in existing code must pass this test: if removed, would the requested behavior fail or become unverified?
- In central orchestration methods, change only the necessary routing/filtering decision points; keep calculations, policy, and new behavior in narrow helpers or new components.
- Do not add defensive side paths for states the current business rules exclude.
- Do not change comments, formatting, unrelated tests, DTO/API shapes, public interfaces, or nearby cleanup unless required for the requested behavior.
- Before finalizing, inspect the diff and remove your own nice-to-have, incidental, or speculative changes.
- If a dirty worktree contains pre-existing or user-owned changes, leave them untouched and call them out instead of reverting them.

## Architecture Research Source Priority

When analyzing architecture, module boundaries, call chains, or implementation ownership for any project, use the original project repository source code as the primary source of truth.

- Inspect the upstream or target repository code before making architecture claims.
- Prefer concrete files, functions, modules, and call paths from the original repository over local notes, summaries, generated docs, or Obsidian pages.
- Treat Obsidian and other local documents as secondary records for context and follow-up writing only; do not use them as proof when source code can be checked.
- If local documentation conflicts with repository source code, trust the source code and explicitly note that the documentation is outdated or needs correction.
- For external projects such as Blockscout, verify conclusions against the external project's real repository before updating notes or advising on architecture.

## Mandatory Development Process Contract

- Before starting implementation for a code task, read and follow:
  `/home/wt/Documents/obsidian/hyperchain/hyperchain/dev流程/neovim-开发流程.md`.
- Use feature/fix分支工作流，不得在主干直接接收功能变更。
- 每个新实现任务必须从最新 `origin/dev` 新建专用 git worktree；禁止在主仓工作树（如 `/home/wt/Projects/blockchain`）直接修改代码。
- PR 必须按 `Draft -> Ready for review` 运行。
- 提交信息使用 Conventional Commits（`type(scope): subject`）。
- PR 需携带可复现测试记录，且避免无关文件修改。
- 代码变更优先使用 rebase 线性提交；优先修复并补齐回归用例。

## Opencode 开发流程强制映射（不在仓库提交）

- 该约束用于 OpenCode 本地执行，不作为项目源码文件修改。
- 约束来源：`/home/wt/Documents/obsidian/hyperchain/hyperchain/dev流程/neovim-开发流程.md`。
- 每次实现任务必须在开始时确认：
  - 是否有对应 issue/问题定义与复现信息。
  - 是否已为当前任务新建专用 worktree，且没有在主仓工作树直接修改代码。
  - 是否已在 feature/fix 分支。
  - 是否准备好 Draft PR 与 test 命令清单。
  - 是否使用 Conventional Commits。
