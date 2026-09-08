---
name: vitest-5
description: Use for Vitest 5 tests, mocks, configuration, migration, coverage, or Browser Mode when the target package resolves to Vitest major 5.
metadata:
  source: Adapted locally from an antfu-generated Vitest skill
  official_docs_verified: "2026-09-08"
---

# Vitest 5

Vitest 5 is for packages whose lockfile or installed dependency resolution selects major 5. Do not upgrade dependencies merely to use this skill; use `vitest-4` when the target resolves to major 4.

Before changing configuration or tests, inspect the package's Vitest, Vite, Node, and browser-provider versions. Vitest 5 requires Vite 6.4+ and Node 22.12+.

Use the [official documentation](https://vitest.dev/) for everyday API, configuration, mocking, coverage, Browser Mode, and CLI questions. For an upgrade from v4, read [references/v5-migration.md](references/v5-migration.md) and the [official migration guide](https://vitest.dev/guide/migration/); verify provider setup and any deprecated API against the installed version before editing.
