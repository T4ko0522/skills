---
name: "gh-fix-ci"
description: "GitHub Actions PR checks の失敗を gh で診断し、ユーザーが修正を依頼していれば原因に絞って修正・検証する。外部 CI は詳細 URL を報告する。"
---


# GitHub Actions CI 修正

## Overview

`gh` で失敗した PR check と GitHub Actions のログを調べ、原因を要約する。診断だけの依頼なら修正案までに留める。修正依頼済みなら、原因に絞って修正・検証する。

最初に `gh auth status` を確認する。未認証なら必要な権限で `gh auth login` を案内して止める。

## Inputs

- `repo`: 対象リポジトリ内の path（既定 `.`）
- `pr`: PR 番号または URL（省略時は現在のブランチ）

## Quick start

- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "<number-or-url>"`
- 要約用の JSON が必要なら `--json` を付ける。

## Workflow

1. `gh auth status` を確認し、PR 指定がなければ `gh pr view --json number,url` で現在の PR を解決する。
2. GitHub Actions の失敗を調べる。`gh pr checks --json` は failure や pending で非ゼロ終了しても有効な JSON を返すため、bundled script は JSON を優先して読み、field 差異時だけ fallback する。
     - `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "<number-or-url>"`
     - Add `--json` for machine-friendly output.
   - 手動 fallback:
     - `gh pr checks <pr> --json name,state,bucket,link,startedAt,completedAt,workflow`
       - If a field is rejected, rerun with the available fields reported by `gh`.
     - 各失敗 check は `link` を優先し、なければ `detailsUrl` から run id を得て実行する:
       - `gh run view <run_id> --json name,workflowName,conclusion,status,url,event,headBranch,headSha`
       - `gh run view <run_id> --log`
     - run log が実行中なら job log を直接取得する:
       - `gh api "/repos/<owner>/<repo>/actions/jobs/<job_id>/logs" > "<path>"`
3. `link`（なければ `detailsUrl`）が GitHub Actions 以外なら外部 CI として URL だけを報告する。Buildkite などへはアクセスしない。
4. check 名、run URL、失敗ログの要点、取得できないログを簡潔に示す。
5. 修正依頼があれば、ログから確認できる原因だけを修正する。不確実な大きな方針変更は選択肢を示して確認する。
6. 修正後は対象のローカル検証と `gh pr checks` を確認する。PR 作成、push、再実行は明示依頼時だけ行う。

## Bundled Resources

### scripts/inspect_pr_checks.py

Fetch failing PR checks, pull GitHub Actions logs, and extract a failure snippet. Exits non-zero when failures remain so it can be used in automation.

Usage examples:
- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "123"`
- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --pr "https://github.com/org/repo/pull/123" --json`
- `python "<path-to-skill>/scripts/inspect_pr_checks.py" --repo "." --max-lines 200 --context 40`
