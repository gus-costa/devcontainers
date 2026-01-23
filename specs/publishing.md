# Publishing Specification

## Published Components

| Component | Registry Path |
|-----------|---------------|
| Base image | `ghcr.io/gus-costa/devcontainers/base` |
| Node feature | `ghcr.io/gus-costa/devcontainers/features/node` |
| Python feature | `ghcr.io/gus-costa/devcontainers/features/python` |
| Puppeteer feature | `ghcr.io/gus-costa/devcontainers/features/puppeteer` |
| Claude feature | `ghcr.io/gus-costa/devcontainers/features/claude` |
| GitHub feature | `ghcr.io/gus-costa/devcontainers/features/github` |
| Firewall feature | `ghcr.io/gus-costa/devcontainers/features/firewall` |
| Proxy feature | `ghcr.io/gus-costa/devcontainers/features/proxy` |

## Versioning

**Base image:** `major.minor`
- Minor: non-breaking additions
- Major: breaking changes

**Features:** `major.minor.patch` (semver)

## Collection Metadata

File `devcontainer-collection.json` at repo root declares all publishable components.

## Publishing Commands

Uses the Dev Container CLI:

```bash
npm install -g @devcontainers/cli

# Build and publish base image
devcontainer build --workspace-folder images/base --push true --image-name gus-costa/devcontainers/base

# Publish features
devcontainer features publish ./features --namespace gus-costa/devcontainers/features
```

## Package Visibility

Set to public in GitHub package settings, or use `--visibility public` flag.
