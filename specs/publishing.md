# Publishing Specification

## Published Components

| Component | Registry Path |
|-----------|---------------|
| Base template | `ghcr.io/gus-costa/devcontainers/base` |
| Node feature | `ghcr.io/gus-costa/devcontainers/features/node` |
| Python feature | `ghcr.io/gus-costa/devcontainers/features/python` |
| Puppeteer feature | `ghcr.io/gus-costa/devcontainers/features/puppeteer` |

## Versioning

**Templates:** `major.minor`
- Minor: non-breaking additions
- Major: breaking changes

**Features:** `major.minor.patch` (semver)

## Collection Metadata

File `devcontainer-collection.json` at repo root declares all publishable components.

## Publishing Commands

Uses the Dev Container CLI:

```bash
npm install -g @devcontainers/cli

# Publish template
devcontainer templates publish ./templates --namespace gus-costa/devcontainers

# Publish features
devcontainer features publish ./features --namespace gus-costa/devcontainers/features
```

## Package Visibility

Set to public in GitHub package settings, or use `--visibility public` flag.
