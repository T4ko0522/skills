{
  description = "T4ko0522's skills managed with agent-skills-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cloudflare-skills = {
      url = "github:cloudflare/skills/b052c32bab7dd493513260228a36c88294f343f1";
      flake = false;
    };
    yutakobayashidev-skills = {
      url = "github:yutakobayashidev/skills/e29d115339db439f40d38ed6be75664628f7ff3a";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    agent-skills,
    cloudflare-skills,
    yutakobayashidev-skills,
    ...
  }: let
    catalog = import ./catalog.nix {
      inherit cloudflare-skills yutakobayashidev-skills;
    };
    agentLib = agent-skills.lib.agent-skills;
    selection = agentLib.selectSkills {
      catalog = agentLib.discoverCatalog catalog.sources;
      sources = catalog.sources;
      skills = catalog.skills.explicit;
      allowlist = [];
    };
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux" "aarch64-darwin"];
    bundleFor = system:
      agentLib.mkBundle {
        pkgs = nixpkgs.legacyPackages.${system};
        inherit selection;
      };
  in {
    homeManagerModules.default = {
      imports = [agent-skills.homeManagerModules.default];
      programs.agent-skills = catalog // {enable = true;};
    };

    packages = forAllSystems (system: {default = bundleFor system;});
    checks = forAllSystems (system: {bundle = bundleFor system;});
  };
}
