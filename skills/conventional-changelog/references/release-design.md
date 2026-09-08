# リリース設計の確認項目

導入前に、次をリポジトリの実際の設定と照合する。

- 公開物と version の定義元
- tag の形式と既存 tag
- リリースを作る主体（人、merge 後の CI、Release PR）
- monorepo なら固定 version か package ごとの version か
- CHANGELOG を生成する範囲と、手書き箇所の有無
- parser が読む最終 commit message

release-please はリリース PR を使う構成に、Changesets は changeset file をレビューする npm workspace 構成に向く。git-cliff と conventional-changelog は既存履歴を再集計する用途に向く。towncrier は Python のニュースフラグメントを集約する方式である。複数を重ねる場合も、version bump と tag 作成の所有者は一つにする。

gitmoji 変換済み履歴を `git-cliff` で読む場合は、設定の `commit_parsers` を実際の最終件名に合わせる。例えば `✨` を feature、`🐛` を fix として対応付ける。`gm` により `feat:` / `fix:` を保持する運用なら Conventional Commit parser を選べる。どちらを採るか決めずに `^feat` だけを設定すると、CHANGELOG から変更が落ちる。
