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
