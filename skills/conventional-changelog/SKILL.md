---
name: conventional-changelog
description: Conventional Commits を基にしたリリース設計と CHANGELOG 自動生成を、既存リポジトリに合うツールと履歴形式で決める。
---

# Conventional Changelog

リリースフローを新設・統一するときに使う。既存のタグ、公開先、CI、commit message と CHANGELOG を先に確認し、導入済みの仕組みを置き換える必要があるか判断する。タグ作成、リリース公開、push はユーザーの明示的な依頼がある場合だけ行う。

## 設計の判断

- commit から release PR、version、tag、CHANGELOG を一貫して作るなら **release-please**。
- npm workspace で、PR ごとに公開対象を明示してまとめるなら **Changesets**。
- 言語を問わず既存の Conventional Commit 履歴から CHANGELOG を生成するなら **git-cliff** または **conventional-changelog**。
- Python でニュースフラグメントをレビュー単位で管理したいなら **towncrier**。

採用前に、version の所有者（manifest/package manager/release tool）、tag 形式、公開の起点、monorepo の version 方針を決める。一つの version を複数ツールに更新させない。

## 履歴との整合

Conventional Commit の入力は `feat: ...`、`fix: ...`、`feat!: ...` または `BREAKING CHANGE:` footer を基本にする。`feat` は通常 minor、`fix` は patch、breaking change は major と扱う。実際の parser が採用する type と release 規則を設定で明示する。

gitmoji hook が type を絵文字へ置換する履歴では、標準の `^feat` / `^fix` parser は使えない。次のいずれかを選ぶ。

1. `gm ` を使い `feat:` / `fix:` を最終履歴に残し、Conventional Commit parser を使う。
2. 最終履歴の絵文字を parser の入力にし、対応する絵文字と SemVer 規則を設定する。
3. 既存履歴を対象外にして、以後の release 用 commit を parser が読める形式に統一する。

履歴を書き換えて整合させない。手書き CHANGELOG と自動生成を混在させる場合は、どちらが各セクションを所有するか定める。

公式仕様と各ツールの現在の設定項目は、採用する段階で公式ドキュメントを確認する。具体的な設定例は [references/release-design.md](references/release-design.md) を読む。
