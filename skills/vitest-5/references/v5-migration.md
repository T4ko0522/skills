# Vitest 5 migration checks

Read this only when moving an existing suite to Vitest 5. Consult the [official migration guide](https://vitest.dev/guide/migration/) for the complete, current list and confirm each affected configuration against the installed package.

- Vitest 5 requires Vite 6.4+ and Node 22.12+.
- `clearMocks` now defaults to `true`; assertions that depend on calls made in setup or `beforeAll` need an intentional configuration or a different seam.
- Inline projects inherit the root configuration by default and may share its Vite server. Review `extends`, merged arrays such as `setupFiles`, and plugins with per-project assumptions.
- Browser Mode's `browser.api` option moved to the top-level `api` option.
- `vi.mock`, `vi.unmock`, and `vi.hoisted` must be at module top level. Use `vi.doMock` or `vi.doUnmock` when runtime ordering is required.
- Await asynchronous assertions such as `.resolves`, `.rejects`, and file snapshots. `expect.poll` now fails when it exceeds its timeout.
- The benchmark API runs through the `bench` test-context fixture rather than a top-level `bench` import.
- Custom matcher and assertion type declarations use `Matchers<R, T>` and `Assertion<R, T>`.

Browser Mode, reporters, and providers are integration-sensitive. Follow the official page for the installed major instead of copying obsolete provider syntax.
