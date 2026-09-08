---
name: cloudflare-deploy
description: Choose an appropriate Cloudflare product and deploy a project when the user asks to host, publish, or deploy it on Cloudflare.
---

# Cloudflare deployment

Start from the application's runtime, data, and delivery requirements, then inspect the repository's existing Cloudflare configuration and deployment commands. Preserve a user-specified product, deployment path, account, environment, and preview/production target.

## Product selection

| Requirement | Typical Cloudflare product |
| --- | --- |
| Edge HTTP application or API | Workers |
| Static or framework web site with Git-integrated delivery | Pages |
| Stateful per-entity coordination | Durable Objects |
| Scheduled or durable background work | Workers Cron Triggers or Workflows |
| SQLite, key-value, object storage, or queues | D1, KV, R2, or Queues |
| Existing infrastructure managed as code | Terraform, Pulumi, or the Cloudflare API |

Choose only after checking whether the project already has `wrangler.toml`, `wrangler.json`, `wrangler.jsonc`, Pages settings, or IaC. For features outside this table, use the [Cloudflare product documentation](https://developers.cloudflare.com/products/).

## Deploy entry point

Use the project's package-manager script, CI workflow, or documented deployment command when it exists. For Workers, Pages, Wrangler configuration, authentication, bindings, local development, and CLI diagnostics, use the dedicated `wrangler` skill when available. If it is not available, follow the current [Wrangler documentation](https://developers.cloudflare.com/workers/wrangler/).

Do not run a deployment, create remote resources, or alter secrets merely while inspecting or preparing the project. Before an actual deployment, confirm the requested target and use the project's supported authentication path. Report the resulting deployment URL or the concrete failure.

Projects containing `.openai/hosting.json` use the Sites workflow; follow that configuration and the user's hosting choice.
