{
  cloudflare-skills,
  yutakobayashidev-skills,
}: {
  sources = {
    local.path = ./skills;
    cloudflare = {
      path = cloudflare-skills;
      subdir = "skills";
      idPrefix = "cloudflare";
    };
    yutakobayashidev = {
      path = yutakobayashidev-skills;
      subdir = "skills";
      idPrefix = "yutakobayashidev";
    };
  };

  skills.explicit = {
    adr = {
      from = "yutakobayashidev";
      path = "adr";
    };
    conventional-changelog = {
      from = "local";
      path = "conventional-changelog";
    };
    create-web-api = {
      from = "yutakobayashidev";
      path = "create-web-api";
    };
    deploy = {
      from = "local";
      path = "deploy";
    };
    frontend-design = {
      from = "local";
      path = "frontend-design";
    };
    functional-cohesion-components = {
      from = "local";
      path = "functional-cohesion-components";
    };
    gh-fix-ci = {
      from = "local";
      path = "gh-fix-ci";
    };
    git-commit = {
      from = "local";
      path = "git-commit";
    };
    github-thread-fetcher = {
      from = "local";
      path = "github-thread-fetcher";
    };
    missing-command-nix = {
      from = "local";
      path = "missing-command-nix";
    };
    nix-setup = {
      from = "local";
      path = "nix-setup";
    };
    playwright-cli = {
      from = "local";
      path = "playwright-cli";
    };
    pr-summarizer = {
      from = "local";
      path = "pr-summarizer";
    };
    tdd = {
      from = "local";
      path = "tdd";
    };
    typescript-design = {
      from = "local";
      path = "typescript-design";
    };
    vitest-4 = {
      from = "local";
      path = "vitest-4";
    };
    vitest-5 = {
      from = "local";
      path = "vitest-5";
    };
    vitest-testing = {
      from = "local";
      path = "vitest-testing";
    };
    wrangler = {
      from = "cloudflare";
      path = "wrangler";
    };
  };
}
