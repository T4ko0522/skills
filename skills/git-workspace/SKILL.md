---
name: git-workspace
description: リポジトリの取得、Git ブランチや worktree の作成時に、ghq・git wt-add と個人の配置・命名規則を適用する。
---

# Git Workspace

## リポジトリの取得

- 通常のリポジトリは `ghq get <owner>/<repo>` で取得し、`~/Project/github.com/<owner>/<repo>` に置く。
- 既存の checkout は勝手に移動しない。

## ブランチ命名

- 新規ブランチは変更内容に対応する `<type>/<kebab-case-summary>` とする（例: `feat/add-search-filter`）。
- type は `feat`、`fix`、`docs`、`style`、`refactor`、`perf`、`test`、`build`、`ci`、`chore`、`remove`、`deploy`、`revert` から選ぶ。`agent/` など内容を表さない一律の prefix は使わない。
- ユーザーが指定したブランチ名を優先する。既存ブランチの利用時に命名規則のための改名はしない。

## worktree の作成

- 対象リポジトリ内で `git wt-add <branch> [<start-point>]` を使う。GitHub の `origin` が必要。
- 既存のローカルブランチには `<start-point>` を指定しない。新規ブランチで省略すると現在の `HEAD` が起点になる。
- 配置先は `~/Project/worktree/github.com/<owner>/<repo>/<worktree名>`。ブランチ名の `/` は `-` に変換される（`feat/add-search` → `feat-add-search`）。
- Codex などの管理 worktree ツールがこの配置を指定できない場合も、`git wt-add` を使う。
