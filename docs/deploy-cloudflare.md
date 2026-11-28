# Deploying Escriba to Cloudflare Workers

Escriba is a static Flutter web build served by **Cloudflare Workers static
assets** (free tier; no Worker script). Cloudflare **Workers Builds** builds it
from this Git repository.

**Nothing is deployed until the operator connects the repository in the
Cloudflare dashboard** (steps below). Pushing to GitHub alone does nothing on
Cloudflare.

## What is in the repo

| File | Role |
| --- | --- |
| `wrangler.jsonc` | Worker `escriba`, assets from `./build/web`, SPA fallback, custom domain `escriba.tlatoani.net`, `workers.dev` kept on |
| `package.json` | `npm run build` → `scripts/cf-build.sh`; `npm run deploy` → `wrangler deploy`; pins `wrangler` 4.162.0 |
| `scripts/cf-build.sh` | Downloads Flutter 3.47.7 (stable) into `.cache/flutter-sdk/` if missing, runs `flutter build web --release`, fails non-zero on error |
| `web/_headers` | Copied to `build/web/_headers`; cache headers (`no-cache` for `index.html`, `flutter_service_worker.js`, bootstrap/main JS) |

Cloudflare's build image does not include Flutter, which is why the build
script fetches a pinned SDK itself. The first build takes a few extra minutes
for the ~1 GB SDK download; later builds reuse it when Cloudflare's build
cache keeps `.cache/`.

## Prerequisite: the custom domain

`wrangler.jsonc` declares:

```jsonc
"routes": [{ "pattern": "escriba.tlatoani.net", "custom_domain": true }],
"workers_dev": true
```

For this to work, **`tlatoani.net` must be a zone (an active domain) in the
same Cloudflare account** the Worker is deployed to. On the first deploy
Cloudflare creates the `escriba` DNS record and the certificate itself; there
must not already be a conflicting `escriba.tlatoani.net` DNS record. If the zone
is not in the account, the deploy fails at the custom-domain step; either add
the zone first or remove the `routes` entry. The app also stays reachable at
`https://escriba.<account-subdomain>.workers.dev` because `workers_dev` is on.

## One-time setup in the Cloudflare dashboard

1. **Workers & Pages → Create → Import a repository** (Workers tab, *not*
   Pages).
2. Connect the GitHub account/org and select the `escriba` repository.
3. Settings:
   - **Project name**: `escriba` (must match `name` in `wrangler.jsonc`).
   - **Production branch**: `main`.
   - **Build command**: `npm run build`
   - **Deploy command**: `npx wrangler deploy`
   - **Root directory**: `/` (repository root).
   - Build variables: none needed. Optional: `FLUTTER_VERSION` to override
     the pinned SDK (keep it at `3.47.7` unless upgrading deliberately).
4. **Non-production branch builds** (optional, Settings → Build → Branch
   control): enable builds for non-production branches, e.g. `integration`
   and `work/*`. Their deploy command stays `npx wrangler versions upload`
   (the dashboard default for non-production branches), which produces a
   preview URL without touching production.
5. Save and deploy. From then on every push to `main` builds and deploys
   production; pushes to the enabled non-production branches get preview
   versions.

## Local checks (no deploy)

```bash
npm ci                    # installs the pinned wrangler
npm run build             # same script Cloudflare runs
npx wrangler dev          # serve build/web locally like Workers would
```

`npm run deploy` / `npx wrangler deploy` *does* deploy to the account you are
logged into; do not run it locally unless you mean to.

## Branch discipline

This repo uses an integration branch: work happens on `work/*` branches,
merges into `integration` by pull request, and `main` (production) is only
updated by pull request from `integration`. Because Cloudflare deploys
production from `main`, a merge to `main` is the release.
