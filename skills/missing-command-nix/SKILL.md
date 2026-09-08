---
name: missing-command-nix
description: Run a missing command through an existing Nix project environment or a one-shot Nix shell. Use before proposing a host-wide installation.
---

# Missing command with Nix

Treat a missing command as an execution-environment question, not evidence that it must be installed globally.

1. Check the repository instructions and local files for `flake.nix`, `devenv.nix`, `shell.nix`, or an existing command wrapper.
2. If the project environment provides the command, use its documented entry point. For a flake this is usually `nix develop -c <command> <args>`.
3. A flake can exist without defining the requested command. Inspect its `devShells` and documented commands; if it does not provide the command, use a scoped one-shot environment instead of changing the flake merely to run a task tool.
4. When no project environment provides it, use `nix shell nixpkgs#<package> -c <command> <args>`. Use `nix-shell -p <package> --run '<command> <args>'` when that is the available or repository-standard interface.

Identify the package that provides the executable from project documentation or the [Nix package search](https://search.nixos.org/packages). Keep the invocation scoped to the task. Do not infer that a missing command authorizes a global installation or a host configuration change.

Examples:

```sh
nix develop -c rg pattern .
nix shell nixpkgs#jq -c jq --version
```
