# AGENTS.md — spec-kit-blueprint

This is a **SpecKit extension** (not a standalone app). It adds three slash commands to SpecKit: `/speckit.blueprint.vision`, `/speckit.blueprint.design`, and `/speckit.blueprint.archive`.

## SpecKit Context

This repo is a [SpecKit](https://github.com/github/spec-kit) extension. See [README § Motivation](README.md#motivation) for workflow diagrams and the full "Big Picture First" concept.

**Where this extension fits:**

```
/speckit.constitution → /speckit.blueprint.vision → /speckit.blueprint.design
                                                             ↓
                                         /speckit.specify [FT-ID]
                                                             ↓
                                   /speckit.plan → /speckit.tasks → /speckit.implement
                                                             ↓
                                             /speckit.blueprint.archive [FT-ID]
```

- Extensions are installed via `specify extension add <name> --from <url>`.
- `commands/*.md` files are consumed by the SpecKit runtime as markdown behavior definitions, not executable code.
- Generated artifacts (`vision.md`, `blueprint.md`) feed into the core `specify → plan → tasks → implement` cycle.

## Repo Structure

| Path | Purpose |
|------|---------|
| `extension.yml` | **Source of truth** for extension metadata, commands, hooks, and version. |
| `commands/{vision,design,archive}.md` | Command definitions consumed by SpecKit. Changing these changes runtime behavior. |
| `templates/*.md` | Draft templates for `vision.md`, `blueprint.md`, and `story.md`. |
| `examples/` | Worked examples referenced by README. |
| `docs/blueprint/` | **Generated output directory** (gitignored). Never commit this. |

## No Build / Test / Lint

There is no build system, package manager, test suite, or CI. Verification is manual review of markdown and YAML.

## Release Checklist (Manual)

When cutting a release, keep these in sync:

1. Bump `extension.yml` → `extension.version`.
2. Bump `README.md` version badge URL and `specify extension add` command URL.
3. Tag the commit with the same version (e.g., `v1.1.0`).

## Conventions

- Command IDs in `extension.yml` must match the slugs used in README (e.g., `speckit.blueprint.vision`).
- Feature IDs follow strict pattern `FT-[N].[N].[N]`; Story IDs `ST-[N].[N]`; Epic IDs `EP-[N]`.
- Templates use `<!-- ACTION REQUIRED -->` comments to guide users filling them in.
- The `External:` field in templates and examples is always `—` (em dash) until manually linked to an external tracker.

## What Not to Do

- Do not add generated `docs/blueprint/` files to git.
- Do not add implementation details or sprint plans to `vision.md` scope — those belong in `blueprint.md` or specs.
- Do not change command file names without updating `extension.yml` → `provides.commands[].file`.
