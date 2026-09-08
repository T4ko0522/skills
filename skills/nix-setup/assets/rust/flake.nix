{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [(import rust-overlay)];
      };
      # Switch to `rust-bin.stable."1.91.0"` for reproducible pinning,
      # or read from `./rust-toolchain.toml` via `rust-bin.fromRustupToolchainFile`.
      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src" "rust-analyzer" "clippy" "rustfmt"];
        # targets = [ "wasm32-wasip1" "wasm32-unknown-unknown" ];
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          rustToolchain
        ];

        # pkg-config / linker deps for common crates go here:
        # buildInputs = [ pkgs.openssl pkgs.pkg-config ];

        RUST_BACKTRACE = "1";
      };
    });
}
