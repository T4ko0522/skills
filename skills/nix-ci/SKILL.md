---
name: nix-ci
description: GitHub Actions で Nix を使う CI を作成・変更する際に、nixbuild/nix-quick-install-action で Nix を導入する。既存 installer からの移行にも使う。ローカルの Nix 環境構築や他の CI サービスは対象外。
---

# Nix を使う GitHub Actions

GitHub Actions で Nix を導入する際は `nixbuild/nix-quick-install-action` を使う。

- 対象 workflow と呼び出し先の reusable workflow / composite action を確認し、Nix を使う job の最初の Nix コマンドより前に導入 step を置く。既存 installer を移行する場合は置き換え、二重に導入しない。
- GitHub-hosted Linux / macOS runner が対象。self-hosted runner は公式に非対応なので、この action を機械的に適用せず、既存の Nix 導入方法と runner の制約を確認する。
- 導入時に[公式リリース](https://github.com/nixbuild/nix-quick-install-action/releases)を確認し、安定版を選ぶ。SHA 固定などリポジトリの既存方針に合わせる。以下の `v35` は記述時点の例であり、最新版と決めつけない。

既存の checkout step に続ける最小例:

```yaml
- uses: nixbuild/nix-quick-install-action@v35
- run: nix flake check
```

検証コマンドは対象リポジトリの既存 CI に合わせる。Nix の導入変更に伴って check / build の対象を変更しない。

## 設定と移行

- Nix のバージョン要件がある場合は `with.nix_version` に指定し、選んだ action の対応バージョンを確認する。省略時はその action リリースの既定値を使う。
- 追加の Nix 設定には `with.nix_conf` を使う。既存 installer 固有の inputs をそのままコピーせず、必要な設定を[公式 README](https://github.com/nixbuild/nix-quick-install-action#readme)と選んだ revision の `action.yml` に照らして移行する。
- この action は Nix > 2.13 で `nix-command` / `flakes` を既定で有効にするため、有効化だけの設定を重複して追加する必要はない。
- single-user インストールであり、`nix-daemon`、channels、`NIX_PATH` は提供されない。移行前のコマンドがこれらに依存する場合は、置き換え可能か確認する。
- キャッシュは別途確認する。既存のキャッシュ設定を維持し、Cachix action は Nix 導入後に置く。installer の変更だけを理由に新たなキャッシュサービスを追加しない。

変更後は利用可能な workflow 検証と対象の Nix コマンドで確認する。ローカル検証と GitHub Actions 上での実行結果は区別して報告する。
