{
  description = "TypeScript development environment (nodejs + pnpm)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.nodejs_24

          # pnpm: use top-level `pkgs.pnpm`, NOT `nodePackages.pnpm`
          # (nodePackages.* was removed from nixpkgs in 2025).
          pkgs.pnpm
        ];

        shellHook = ''
          # Keep pnpm's global bin / store inside the project
          export PNPM_HOME="$PWD/.pnpm"
          export PATH="$PNPM_HOME:$PATH"
        '';
      };
    });
}
