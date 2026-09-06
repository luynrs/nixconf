# Working Rules

* Solve only the requested task. Prefer the smallest correct diff that fixes the problem without expanding scope
* Read relevant repository guidance and nearby code before editing. For non-trivial bugs, trace the real call path and fix the root cause at the correct shared boundary
* Reuse existing project code when appropriate. Otherwise prefer the standard library and native platform features before adding abstractions, dependencies, caches, hashes, compatibility layers, or extra state
* Do not refactor, rename, reformat, or clean up unrelated code unless required
* Treat staged, unstaged, untracked, and unrelated worktree changes as intentional. Do not revert, rewrite, or overwrite them
* Preserve validation, security, error handling, compatibility, persisted formats, stable identifiers, and platform behavior unless required
* Avoid churn in generated files, vendored code, lockfiles, snapshots, formatting, and unrelated tests
* For platform bugs, identify whether the issue belongs to the process model, runtime, OS, or platform API before adding a workaround

## Code Style

* Match local style and keep code direct
* If a variable is used once and its name does not materially improve clarity, debugging, typing, or correctness, inline it
* Avoid helpers, wrappers, or abstractions for trivial single-use logic unless they improve clarity or enforce an invariant
* Use multiline formatting only when it materially improves readability or is required by style, tooling, or line length. Prefer a compact single-line form when it remains clear

## Comments

* Add comments only for non-obvious rationale, constraints, invariants, platform behavior, or failure modes
* Do not narrate code or describe only a new feature in a comment attached to a broader function. Either describe the whole function or omit it
* Keep comments simple, factual, and short. Avoid comparisons, historical narration, diary-style comments, and periods at the end
* Remove stale, misleading, or redundant comments

## Ambiguity

* Ask when uncertainty could materially affect behavior, compatibility, architecture, data format, or scope
* Ask before choices that may be costly, destructive, externally visible, or hard to reverse
* Do not invent requirements, migrations, fallbacks, guarantees, or edge-case behavior
* If a safe, minimal, reversible default exists, use it and briefly state the assumption

## Verification

* Run the narrowest meaningful verification using existing tests, linting, type checks, or builds
* Add focused regression coverage for non-trivial logic when appropriate. For platform code, run the relevant build or cross-build when feasible
* Do not weaken or rewrite meaningful tests just to make the change pass
* State what was verified and do not claim broader coverage than you checked

## Scope and Git

* Do not expand the task into adjacent improvements. Leave unrelated issues untouched unless they block it
* Never commit, amend, push, create a branch, open a PR, or modify remote state unless explicitly requested

## Final Response

* Keep it concise: what changed, why, important assumptions or skipped scope, and what was verified
