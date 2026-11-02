{
  description = "T4ko0522's skills managed with agent-skills-nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cloudflare-skills = {
      url = "github:cloudflare/skills/86505e44f87d801aa1864a3c4109e9a8ae5c409f";
      flake = false;
    };
    cloudflare-security-audit-skill = {
      url = "github:cloudflare/security-audit-skill/c1c8a8c1471069fb0e188eeaff69b8e8db6564a8";
      flake = false;
    };
    hyperframes = {
      url = "github:heygen-com/hyperframes/6feb4bec7aa046a8956efd8a718db55423e2e2ca";
      flake = false;
    };
    mattpocock-skills = {
      url = "github:mattpocock/skills/4ae2317ddb22b046e26455e4f9c9b3aaaf62212d";
      flake = false;
    };
    yomiyasu = {
      url = "github:nanaism/yomiyasu/29d67ccb05e370b5958d72920a9cd1aa829dee80";
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
    cloudflare-security-audit-skill,
    hyperframes,
    mattpocock-skills,
    yomiyasu,
    yutakobayashidev-skills,
    ...
  }: let
    catalog = import ./catalog.nix {
      inherit cloudflare-skills cloudflare-security-audit-skill hyperframes mattpocock-skills yomiyasu yutakobayashidev-skills;
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
