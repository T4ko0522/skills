---
name: vitest-testing
description: Write or review Vitest tests with clear behaviour-focused assertions, appropriate globals/imports, file snapshots for terminal output, and readable fixture setup. Use when adding tests, fixing Vitest failures, or improving TypeScript test quality.
---

# Vitest Testing

Use the `tdd` skill when the task is a logic change or bug fix that should start with a failing test. This skill covers Vitest-specific test shape and review rules.

## Setup

- Check `vitest.config.*` before assuming globals are enabled.
- If globals are enabled, use `describe`, `it`, `expect`, `vi`, `beforeEach`, and `assert` directly without importing them.
- If globals are not enabled, import only the Vitest APIs used by the file.
- Prefer static imports for ordinary test setup. Use dynamic import when module evaluation must occur after setup—for example to test lazy loading, isolate import-time environment reads, or pair it with `vi.resetModules()` / module mocking. Keep that ordering explicit in the test.
- Use `vi.stubEnv()` instead of mutating `process.env` directly. Confirm `test.unstubEnvs: true`; otherwise restore stubs with `afterEach(() => vi.unstubAllEnvs())`.

## Readability

- Test one behaviour per `it`.
- Name tests after observable behaviour, not implementation details.
- Avoid `try`/`catch` for expected failures. Use `expect(...).toThrow()`, `await expect(...).rejects`, or explicit Result failure assertions.
- Avoid `if` branches inside test bodies. Split behaviours into separate tests or use `it.each` for table-driven cases.
- KISS > DRY: do not over-DRY tests. Keep repeated setup inline when it makes the behaviour easier to read.
- Keep assertions in the test unless a helper name is clearer than the assertion it hides.
- Use `assert` to make preconditions explicit and narrow nullable values instead of using non-null assertions.

## Output Tests

- Prefer JSON assertions for structured behaviour.
- Use file snapshots with `toMatchFileSnapshot` for human-readable CLI/table output so layout changes are reviewable. It is asynchronous: write `await expect(value).toMatchFileSnapshot(path)`.
- For responsive terminal output, capture or set the terminal width used by the command.

## Examples

Expected failure:

```ts
it('rejects invalid config', async () => {
	await expect(loadConfig('bad.json')).rejects.toThrow(Error);
});
```

Table-driven case:

```ts
it.each([
	['daily', '2026-05-16'],
	['monthly', '2026-05'],
])('groups %s rows by period', (reportType, expectedPeriod) => {
	const rows = groupUsage(reportType, usage);

	expect(rows[0]?.period).toBe(expectedPeriod);
});
```

Narrowing with `assert`:

```ts
it('returns the first row', () => {
	const rows = getRows();
	const firstRow = rows[0];
	assert.isDefined(firstRow, 'expected at least one row');

	expect(firstRow.id).toBe('row-1');
});
```
