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

File `devcontainer-collection.json` at repo root declares all publishable components with their current versions and descriptions.

## GitHub Actions Workflows

### Release Pull Request (`release-pr.yml`)

Triggered manually via workflow dispatch to create a release PR.

**Process:**
1. Installs `@devcontainers/cli`
2. Runs `build/prepare-release.sh` to bump versions
3. Creates a branch `rel/v{version}`
4. Commits manifest updates
5. Opens PR to main branch

**Usage:**
```bash
# Trigger via GitHub UI with version input (e.g., v0.4.1)
```

### Build and Push (`push.yml`)

Triggered on version tags (`v*`) pushed to main branch.

**Process:**
1. Uses matrix strategy for parallel builds
2. Installs dependencies and `@devcontainers/cli`
3. Builds and pushes images using `build/vscdc push` command
4. Triggers version history extraction workflow

### Test Base Image (`test-base.yml`)

Runs on:
- Pull requests affecting `images/base/**`
- Pushes to main branch
- Manual workflow dispatch

**Process:**
1. Uses custom `.github/actions/test-image` action
2. Builds the base image
3. Runs test suite from `images/base/test-project/`

## Manual Publishing

Use the Dev Container CLI:

```bash
npm install -g @devcontainers/cli

# Build and publish base image
devcontainer build --workspace-folder images/base --push true --image-name gus-costa/devcontainers/base

# Publish features
devcontainer features publish ./features --namespace gus-costa/devcontainers/features
```

## Package Visibility

Set to public in GitHub package settings, or use `--visibility public` flag.
