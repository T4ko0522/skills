# skills

[agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) で、自作 skills と外部 skills の選択を管理するリポジトリです。

- `skills/<name>/`: 自作・ローカル改修した skill の `SKILL.md` と参照ファイル。
- `catalog.nix`: source と利用する skills の明示的な選択。
- `flake.nix` / `flake.lock`: 外部依存と Home Manager module、bundle の定義。

Vitest は `vitest-4` と `vitest-5` を別名で配布し、対象 package の実際のバージョンに合う方を使います。4 系は公式 v4 ドキュメントに基づくローカル skill、5 系は antfu 版を取り込んで改修したローカル skill です。

## Home Manager から利用する

利用側の flake に input を追加します。

```nix
inputs.personal-skills = {
  url = "github:T4ko0522/skills";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

既存の `nixpkgs` と `home-manager` inputs を使う standalone Home Manager の例です。`outputs` 内で module を読み込み、配置先を有効にします。この module は upstream module も読み込みます。

```nix
outputs = { nixpkgs, home-manager, personal-skills, ... }: {
  homeConfigurations.t4ko = home-manager.lib.homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    modules = [
      ./home.nix
      personal-skills.homeManagerModules.default
      {
        programs.agent-skills.targets = {
          agents.enable = true;
          claude.enable = true;
          codex.enable = true;
          opencode.enable = true;
        };
      }
    ];
  };
};
```

`./home.nix` は既存のユーザー設定です。NixOS 統合では、同じ module を `home-manager.sharedModules` に追加します。既存設定から移行する際は、従来の upstream module の import と source・選択設定を置き換えてください。既存ディレクトリの引き継ぎ処理は利用側で管理します。

## 編集と確認

ローカル skill を追加したら `catalog.nix` の `skills.explicit` に登録します。外部参照の skills は `flake.nix` の固定 revision と `flake.lock` を更新します。ローカルに取り込んだ skills の取得元・revision・ライセンスは `vendored-sources.json` と各ディレクトリのライセンスファイルに記録しています。更新は上流との差分を確認して取り込み、ローカル改修を保持してください。

個人 skill の作成・取得先はこのリポジトリの `skills/` に統一します。Nix の配置先へ直接追加すると次回同期で消えるため、登録と検証をここで行ってから利用側で反映してください。

```sh
alejandra --check .
nix flake check
nix build
```

`nix build` は選択した skills の bundle を `result/` に生成します。Home Manager による配置は行いません。初回の未追跡ファイルを含めて確認する場合は `nix flake check path:.` と `nix build path:.` を使います。
