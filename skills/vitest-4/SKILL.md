---
name: vitest-4
description: Write, debug, and configure tests for projects using Vitest 4.x. Check the target package's installed version or lockfile first. For Vitest 5.x, including prereleases, use vitest-5.
---

# Vitest 4

## Select the version and runtime

Confirm the target package's resolved Vitest major version from its installed CLI or lockfile. In a mixed-version monorepo, check each package separately. Apply this skill to 4.x; use `vitest-5` for 5.x. If the version is unresolved, establish it before choosing version-specific APIs. Do not upgrade dependencies just to match a skill.

Use the project's package manager and test scripts, including wrappers such as Vite+. Inspect the selected config and runtime before changing tests: Node, jsdom, Browser Mode, and a Workers pool have different capabilities. Preserve existing plugins, setup files, bindings, and pool configuration. For Cloudflare tests, use the installed integration's types and [Cloudflare testing documentation](https://developers.cloudflare.com/workers/testing/) alongside the Vitest references.

## Run focused checks

For a direct Vitest command, `vitest run path/to/file.test.ts -t 'test name'` runs a targeted check without watch mode. Add `--project NAME` when the configuration defines multiple projects. Use the equivalent arguments through the project's existing script; do not assume every wrapper forwards them identically. See [test filtering](https://v4.vitest.dev/guide/filtering).

## Version-sensitive decisions

- **Configuration:** a separate `vitest.config.*` takes precedence over `vite.config.*`; it does not automatically extend it. Preserve or explicitly merge the Vite configuration when plugins or aliases are needed. See [configuration](https://v4.vitest.dev/config/).
- **Projects:** use `test.projects` for new multi-project configuration. Inline projects need `extends: true` when they should inherit the root configuration; do not assume inheritance. See [test projects](https://v4.vitest.dev/guide/projects).
- **Module mocking:** `vi.mock` is hoisted. Use `vi.hoisted` for values a mock factory needs before imports, and account for modules already imported by setup files. Browser Mode uses native ESM and has different spying constraints. See [module mocking](https://v4.vitest.dev/guide/mocking/modules).
- **Mock cleanup:** `vi.restoreAllMocks()` restores manually created spies; it does not replace clearing call history or resetting every mock implementation. Choose cleanup according to the test's isolation needs. See [mocking changes in v4](https://v4.vitest.dev/guide/migration#changes-to-mocking).
- **Browser Mode:** use a provider object, such as `playwright()` from `@vitest/browser-playwright`, with `browser.instances`. Do not copy the old `provider: 'playwright'` form. Keep Browser Mode distinct from jsdom and standalone Playwright E2E tests. See [Browser Mode](https://v4.vitest.dev/guide/browser/).
- **Coverage:** v4 removed `coverage.all` and `coverage.extensions`. Set `coverage.include` if the requested report must include files that tests never import. Do not update snapshots or thresholds merely to hide changes in coverage remapping. See [v4 migration](https://v4.vitest.dev/guide/migration).

For additional APIs, use the [Vitest 4 documentation](https://v4.vitest.dev/) and the installed package's types. Minor-version features may differ from the documentation snapshot. Check the relevant page rather than applying examples from the latest major version.
