---
name: nix-setup
description: Set up or repair a project-local Nix development environment. Use for a requested flake, dev shell, or reproducible toolchain; preserve an existing project environment and host configuration.
---

# Nix development environments

First inspect the repository. Preserve an existing `flake.nix`, `flake.lock`, `devbox.json`, `devenv.nix`, package-manager setup, and documented commands unless the user asks to change them. If a flake already provides the needed environment, extend or use it instead of introducing Devbox or replacing the flake.

For a new environment, choose the smallest project-local approach that fits the repository:

- Use an existing project convention when one exists.
- Use a flake when the project needs Nix expressions, pinned inputs, overlays, or a reusable `devShell`.
- Use Devbox only when the user requests it or the repository already uses it; it is an option, not a default.

Keep runtime and tooling dependencies in the project. Do not rewrite host Nix configuration, run an installer, remove unrelated Git/lockfiles, or create commits as part of ordinary setup. When a requested environment change needs a flake lock update, make that limited update; do not remove or regenerate unrelated lockfiles.

## Templates

The templates are starting points for a new project only. Read one before copying or adapting it; keep the project's existing package manager and tool versions when they are already specified.

| Need | Read |
| --- | --- |
| Node.js, TypeScript, pnpm | [assets/typescript/flake.nix](assets/typescript/flake.nix) |
| Rust with `rust-overlay` | [assets/rust/flake.nix](assets/rust/flake.nix) |
| Python with uv | [assets/python-uv/flake.nix](assets/python-uv/flake.nix) |
| An existing Devbox project | [assets/devbox/devbox.json](assets/devbox/devbox.json) and the [Devbox documentation](https://www.jetify.com/devbox/docs/) |

Use `nix develop` or the repository's documented command to enter a flake dev shell. Add `.envrc` only when the repository already uses direnv or the user asks for it.

For Nix installation, host policy, Home Manager, CI setup, unusual language toolchains, or package derivations, consult the relevant [official Nix documentation](https://nixos.org/manual/nix/stable/) and the project's own documentation before proposing a change.
