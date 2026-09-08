# Generating Playwright tests

Use this reference when the user asks to create or repair Playwright tests. First inspect the existing test runner, configuration, fixtures, and package scripts. Reuse the repository's installed Playwright version and established test structure; do not bootstrap Playwright or add dependencies unless the user requests that setup work.

Explore the requested flow with `playwright-cli` and snapshots. Its action output can provide locator-based Playwright code, but write assertions deliberately around observable behavior. Prefer role, label, and test-id locators over brittle CSS selectors.

For debugging an existing test, start that test through its existing package-manager or Nix command with `--debug=cli`, then attach `playwright-cli` to the reported session. Keep the debug process running only while it is needed and rerun the targeted test after a change.

Capture a plan or annotated review only when the user asks for one or it is needed to resolve a concrete product ambiguity. A normal UI review can use snapshots and screenshots directly.

For command details, read [playwright-tests.md](playwright-tests.md), [session-management.md](session-management.md), and the [Playwright test documentation](https://playwright.dev/docs/test-intro).
