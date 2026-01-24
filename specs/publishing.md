# Publishing Specification

## Published Components

| Component | Type | Registry Path |
|-----------|------|---------------|
| Base | Image | `ghcr.io/gus-costa/devcontainers/base` |
| Node feature | Feature | `ghcr.io/gus-costa/devcontainers/features/node` |
| Python feature | Feature | `ghcr.io/gus-costa/devcontainers/features/python` |
| Puppeteer feature | Feature | `ghcr.io/gus-costa/devcontainers/features/puppeteer` |
| Claude feature | Feature | `ghcr.io/gus-costa/devcontainers/features/claude` |
| GitHub feature | Feature | `ghcr.io/gus-costa/devcontainers/features/github` |
| Firewall feature | Feature | `ghcr.io/gus-costa/devcontainers/features/firewall` |
| Proxy feature | Feature | `ghcr.io/gus-costa/devcontainers/features/proxy` |

## Versioning

**Base image:** `major.minor`
- Minor: non-breaking additions
- Major: breaking changes

**Features:** `major.minor.patch` (semver)
- Patch: bug fixes and minor updates
- Minor: new functionality, backwards compatible
- Major: breaking changes

## Collection Metadata

File `devcontainer-collection.json` at repo root declares all publishable components with their current versions and descriptions.

## GitHub Actions Workflows

### Release Pull Request (`release-pr-image.yml`)

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

### Build and Push Images (`push-image.yml`)

Triggered on version tags (`v*`) pushed to main branch.

**Process:**
1. Publishes base image to `ghcr.io/gus-costa/devcontainers/base`
2. Publishes all features to `ghcr.io/gus-costa/devcontainers/features/`
3. Uses `@devcontainers/cli` for build and publish operations

**Jobs:**
- `publish-base`: Builds and pushes base image with version tag and `latest`
- `publish-features`: Publishes all features from `./features` directory

### Release Features (`release-feature.yml`)

Triggered manually via workflow dispatch.

**Process:**
1. Publishes features using `devcontainers/action@v1`
2. Generates documentation automatically
3. Creates PR with documentation updates if changes detected

**Note:** Currently configured with incorrect path (`./src` instead of `./features`)

### Test Features (`test-feature.yml`)

Runs on push to main, pull requests, and manual dispatch.

**Process:**
1. Tests features against multiple base images
2. Runs scenario-based tests
3. Tests global scenarios

**Note:** Currently configured to test placeholder features (`color`, `hello`) instead of actual features

### Validate Features (`validate-feature.yml`)

Runs on pull requests and manual dispatch.

**Process:**
1. Validates `devcontainer-feature.json` files using `devcontainers/action@v1`

**Note:** Currently configured with incorrect path (`./src` instead of `./features`)

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
devcontainer build --workspace-folder images/base --push --image-name ghcr.io/gus-costa/devcontainers/base:latest

# Publish features
devcontainer features publish --namespace gus-costa/devcontainers/features --registry ghcr.io ./features
```

## Package Visibility

Set to public in GitHub package settings, or use `--visibility public` flag.
