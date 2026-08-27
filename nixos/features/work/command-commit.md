---
description: Commit staged changes with a conventional commit message
---
Review the currently staged changes (`git diff --cached`) and create a single
git commit for them. Follow these rules:

- Use the Conventional Commits format: `type(scope): summary`
- Keep the summary under 72 characters, imperative mood, no trailing period
- Add a short body only if the "why" is not obvious from the diff
- Never commit secrets, credentials, or unrelated files
- Do not push after committing
