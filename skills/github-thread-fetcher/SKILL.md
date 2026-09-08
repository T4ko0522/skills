---
name: github-thread-fetcher
description: GitHub Issue または PR の本文、会話、レビュー、未解決スレッド、CI、リンク済み Issue を gh で漏れなく取得し、会話と対応待ちを分けて整理する。
---

# GitHub Thread Fetcher

Issue/PR URL または番号を対象にする。指定がなければ現在のブランチの PR を解決する。対象が曖昧な場合だけ確認する。`gh auth status` が失敗した場合は認証を案内して止める。

## 取得

- Issue: `gh issue view <number> --json title,body,author,state,labels,comments,url`。
- PR のメタデータ、review summary、files、checks: `gh pr view <number> --json title,body,author,state,baseRefName,headRefName,reviewDecision,reviews,files,commits,statusCheckRollup,url`。
- PR の会話コメント、review thread、thread 内コメント、closing issue: bundled helper を使う。

```sh
python "<skill>/scripts/fetch_pr_discussion.py" --repo owner/repo --pr <number>
```

helper は GraphQL connection の `pageInfo` を使い、PR 会話、review thread、各 review thread のコメントを最後まで取得する。`--repo` は URL から得た owner/repo を指定し、URL がないときは `gh repo view --json nameWithOwner` で解決する。REST の `pulls/<number>/comments` を併用する場合も `--paginate` を付け、thread helper の結果と二重計上しない。

checks は `gh pr checks <number> --json name,state,bucket,link,workflow,startedAt,completedAt` で確認する。失敗だけを深掘りし、GitHub Actions 以外は URL を報告する。

## 整理

- 会話コメント、review summary、レビュー行コメントを分ける。
- `isResolved: false` を対応待ちとして示す。解決済みは件数のみでよい。
- bot は一律に除外しない。ユーザーへの対応依頼、失敗通知、セキュリティ・品質上の情報を持つ bot 投稿は残す。表示を減らす場合は、除外基準と件数を示す。
- 同じ著者・同じ本文の連続通知は一件に圧縮する。
- 要約で要求の強さを変えない。行位置があれば `<path>:<line>` と元 URL を添える。

## 出力

必要な情報だけを、本文、会話、未解決スレッド、CI、リンク済み Issue の順で示す。コメントが多い場合は、総数と省略・圧縮の基準を明記する。
