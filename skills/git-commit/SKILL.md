---
name: git-commit
description: ユーザーの指示に基づき、Conventional Commits 形式の日本語メッセージで安全に Git コミットを作成する。gitmoji 自動付与フック、変更単位の分割、具体的なステージングがある環境で使う。
---

# Git Commit

コミットメッセージ案や変更の分割相談にも使う。skill を使うこと自体は commit の実行許可ではない。実際の commit と push は、それぞれユーザーが明示的に依頼したときだけ行う。履歴の書き換えや未依頼のファイルの追加は含まない。

## メッセージ

通常は `type(scope): 日本語の要約`。type は変更の性質から選ぶ（`feat`、`fix`、`docs`、`style`、`refactor`、`perf`、`test`、`build`、`ci`、`chore`、`remove`、`deploy`、`revert`）。scope は必要な場合だけ付ける。英語はユーザーが指定した場合だけ使う。

この環境の `prepare-commit-msg` hook は type を対応する gitmoji に置き換える。入力メッセージに絵文字を手で入れない。ログにも type を残す必要があれば先頭に `gm `、絵文字を付けないなら `n ` を付ける。どちらも半角スペースを含むプレフィックスで、hook が最終メッセージから取り除く。

```text
feat(editor): 検索結果を絞り込む       # -> ✨ editor: 検索結果を絞り込む
gm fix(api): タイムアウトを処理する    # -> fix(api): 🐛 タイムアウトを処理する
n chore: 一時的な移行を記録する        # -> chore: 一時的な移行を記録する
```

## 作業方法

1. `git status`、`git diff`、必要なら最近の `git log` で対象と既存の慣行を確認する。
2. レビュー・戻しやすさの単位で変更をまとめる。独立した変更は分け、密接に結び付く変更は同じコミットにする。
3. `git add <対象ファイル>` を使う。同一ファイルを分ける必要がある場合だけ `git add -p` を使う。`git add .` と `git add -A` は使わない。
4. hook を有効にしたまま `git commit` し、`git status` と最終メッセージを確認する。

差分を分けるために checkout/reset や編集でワークツリーを巻き戻し、差分を再生成しない。分割不能な混在は一つにまとめ、メッセージ本文で理由を補う。

## 境界

- `--no-verify` は使わない。
- 機密ファイルや意図不明な untracked file はステージしない。必要なら対象をユーザーに確認する。
- ユーザーが commit だけを依頼した場合は commit 後に止める。`git push` は明示依頼時だけ行う。
