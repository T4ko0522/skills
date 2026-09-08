---
name: playwright-cli
description: Use playwright-cli to inspect and automate an existing browser session, debug Playwright tests, or perform requested browser checks. Prefer the project's installed CLI and preserve the user's browser choice.
allowed-tools: Bash(playwright-cli:*) Bash(npx:*) Bash(npm:*)
---

# playwright-cli

Use the project's installed `playwright-cli` or its documented Nix/package-manager command. Do not add a global or `@latest` installation just to start a session.

Inspect the user's requested browser, an existing session, and the repository's test setup before opening a new browser. When a browser is already selected or running, attach to it when appropriate rather than silently changing browser, profile, or session. Treat persistent profiles, storage files, and browser cleanup as user data.

For an ordinary requested interaction, take a snapshot, use its current refs, act, then snapshot or inspect the requested result. Use screenshots when visual evidence matters.

| Need | Read |
| --- | --- |
| Attach to or manage sessions and browser selection | [references/session-management.md](references/session-management.md) |
| Debug an existing Playwright test | [references/playwright-tests.md](references/playwright-tests.md) |
| Turn a requested flow into a Playwright test | [references/test-generation.md](references/test-generation.md) |
| Browser state, network routing, or page code | [references/storage-state.md](references/storage-state.md), [references/request-mocking.md](references/request-mocking.md), or [references/running-code.md](references/running-code.md) |
| Trace or video evidence | [references/tracing.md](references/tracing.md) or [references/video-recording.md](references/video-recording.md) |

`playwright-cli show` can support a UI review, but only request user annotations when they would resolve an identified ambiguity. Do not turn ordinary UI review into an annotation task.

Use the CLI's own `--help` for command syntax that is not covered by the relevant reference. Do not execute examples merely to validate this skill.
