# skills

[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) で、自作 skills と外部 skills の選択を管理するリポジトリです。

- `skills/<name>/`: 自作・ローカル改修した skill の `SKILL.md` と参照ファイル。
- `catalog.nix`: source と利用する skills の明示的な選択。
- `flake.nix` / `flake.lock`: 外部依存と Home Manager module、bundle の定義。