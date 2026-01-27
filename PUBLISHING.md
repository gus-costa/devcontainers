# Publishing Guide

This guide explains how to publish the base image and features to GitHub Container Registry (GHCR).

## Quick Start

The simplest way to publish a new version:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This automatically triggers the publishing workflow that builds and pushes both the base image and all features to GHCR.

## Publishing Methods

### 1. Automated Publishing (Recommended)

**Workflow:** `.github/workflows/push-image.yml`

**Trigger:** Automatically runs when you push a git tag starting with `v`

**What gets published:**
- Base image → `ghcr.io/gus-costa/devcontainers/base:{version}` and `:latest`
- All 7 features from `./features/src` → `ghcr.io/gus-costa/devcontainers/features/*`

**Process:**

```bash
# 1. Ensure you're on main and have the latest changes
git checkout main
git pull

# 2. Create and push a version tag
git tag v1.0.0
git push origin v1.0.0

# 3. Monitor the workflow
# Go to: https://github.com/gus-costa/devcontainers/actions
# Watch the "Build and push images" workflow complete
```

**What the workflow does:**
1. Checks out the repository
2. Logs into GHCR using `GITHUB_TOKEN`
3. Installs `@devcontainers/cli`
4. Builds and pushes base image with both version tag and `:latest`
5. Publishes all features from `./features/src` directory

**Requirements:**
- Must have write access to the repository
- `GITHUB_TOKEN` is automatically provided by GitHub Actions
- Package visibility must be set to public (see Package Visibility section)

### 2. Release Pull Request Workflow

**Workflow:** `.github/workflows/release-pr-image.yml`

**Trigger:** Manual via GitHub Actions UI

**Purpose:** Creates a release PR that bumps versions in manifest files

**Process:**

1. Go to: https://github.com/gus-costa/devcontainers/actions
2. Select "Create release pull request"
3. Click "Run workflow"
4. Enter version (e.g., `v0.4.1`)
5. Workflow creates branch `rel/v0.4.1` with:
   - Bumped versions in `images/*/manifest.json`
   - Updated devcontainer lock files via `devcontainer upgrade`
6. Review and merge the PR
7. Create git tag to trigger actual publishing

**What it runs:**
- Executes `build/prepare-release.sh`
- Updates manifest files with new version
- Creates release branch and PR

**Requirements:**
- `PAT` (Personal Access Token) secret configured for creating PRs
- Must provide version in format `v0.4.x`

### 3. Feature-Only Publishing

**Workflow:** `.github/workflows/release-feature.yml`

**Trigger:** Manual via GitHub Actions UI

**Purpose:** Publishes features and auto-generates documentation

**Process:**

1. Go to: https://github.com/gus-costa/devcontainers/actions
2. Select "Release dev container features & Generate Documentation"
3. Click "Run workflow"
4. Must be on `main` branch
5. Workflow:
   - Publishes features using `devcontainers/action@v1`
   - Generates README documentation for each feature
   - Creates PR with documentation updates if changes detected

**What gets published:**
- All features from `./features/src` directory
- Auto-generated README.md files for each feature

**Requirements:**
- Must be on `main` branch
- `GITHUB_TOKEN` automatically provided

## Manual Publishing via CLI

If you need to publish manually without GitHub Actions:

### Prerequisites

```bash
# Install devcontainer CLI
npm install -g @devcontainers/cli

# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### Publish Base Image

```bash
devcontainer build \
  --workspace-folder images/base \
  --image-name ghcr.io/gus-costa/devcontainers/base:v1.0.0 \
  --image-name ghcr.io/gus-costa/devcontainers/base:latest \
  --push
```

### Publish All Features

```bash
devcontainer features publish \
  --namespace gus-costa/devcontainers/features \
  --registry ghcr.io \
  ./features/src
```

## Testing Workflows

These workflows run automatically to validate changes before publishing:

### Feature Testing (`test-feature.yml`)

**Triggers:**
- Push to `main` branch
- Pull requests
- Manual workflow dispatch

**What it tests:**
- All 7 features against multiple base images (debian:latest, ubuntu:latest, mcr.microsoft.com/devcontainers/base:ubuntu)
- Scenario-based tests for each feature
- Global scenarios

**Matrix:**
- Features: node, python, puppeteer, claude, github, firewall, proxy
- Base images: debian:latest, ubuntu:latest, devcontainers base

### Feature Validation (`validate-feature.yml`)

**Triggers:**
- Pull requests
- Manual workflow dispatch

**What it validates:**
- Syntax and structure of all `devcontainer-feature.json` files
- Uses `devcontainers/action@v1` with `validate-only: true`

### Base Image Testing (`test-base.yml`)

**Triggers:**
- Pull requests affecting `images/base/**`
- Pushes to `main` branch
- Manual workflow dispatch

**What it tests:**
- Builds the base image
- Runs smoke tests from `images/base/test-project/`
- Validates image size and tags

## Version Management

### Version Format

- **Base image:** `v{major}.{minor}.{patch}` (e.g., `v1.0.0`)
- **Features:** `{major}.{minor}.{patch}` (e.g., `1.0.0`)

### Version Bumping

Versions are stored in:
- Base image: `images/base/manifest.json`
- Features: `features/*/devcontainer-feature.json`
- Collection metadata: `devcontainer-collection.json`

The `build/prepare-release.sh` script handles version bumping:

```bash
# Monthly release (bumps all images)
./build/prepare-release.sh

# Ad-hoc release (bumps only changed images since commit)
./build/prepare-release.sh <commit-hash>
```

## Package Visibility

After first publish, set packages to public:

1. Go to: https://github.com/gus-costa?tab=packages
2. Select each package (base, node, python, etc.)
3. Click "Package settings"
4. Under "Danger Zone", click "Change visibility"
5. Select "Public"

Alternatively, use `--visibility public` flag when publishing manually.

## Registry Structure

Published components follow this structure:

```
ghcr.io/gus-costa/devcontainers/
├── base:v1.0.0              # Base image (version tag)
├── base:latest              # Base image (latest tag)
└── features/
    ├── node:1.0.0
    ├── python:1.0.0
    ├── puppeteer:1.0.0
    ├── claude:1.0.0
    ├── github:1.0.0
    ├── firewall:1.0.0
    └── proxy:1.0.0
```

## Usage After Publishing

Once published, users can reference your components:

```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:v1.0.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1.0.0": {
      "version": "20"
    },
    "ghcr.io/gus-costa/devcontainers/features/firewall:1.0.0": {},
    "ghcr.io/gus-costa/devcontainers/features/proxy:1.0.0": {}
  }
}
```

## Troubleshooting

### Workflow Fails with Authentication Error

- Check that `GITHUB_TOKEN` has `packages: write` permission
- Verify repository settings allow package publishing

### Features Don't Appear in Registry

- Ensure package visibility is set to "Public"
- Check that `devcontainer-feature.json` files are valid
- Run validation workflow to check for errors

### Base Image Build Fails

- Check `.github/actions/test-image` logs for errors
- Verify `images/base/.devcontainer/Dockerfile` is valid
- Test local build: `devcontainer build --workspace-folder images/base`

### Version Already Exists

- Cannot overwrite existing tags in GHCR
- Bump version and create new tag
- Delete old tag if needed: `git tag -d v1.0.0 && git push origin :refs/tags/v1.0.0`

## Best Practices

1. **Test before publishing**: Run test workflows locally or via PR
2. **Use semantic versioning**: Follow semver for version bumps
3. **Update collection metadata**: Keep `devcontainer-collection.json` in sync
4. **Document changes**: Update README and feature docs when publishing
5. **Monitor workflows**: Check Actions tab after pushing tags
6. **Keep features independent**: Each feature should work standalone
7. **Test with base image**: Verify features work with published base image

## Required Secrets

Configure these in repository settings:

| Secret | Purpose | Required For |
|--------|---------|--------------|
| `GITHUB_TOKEN` | Authenticate to GHCR | push-image.yml (auto-provided) |
| `PAT` | Create PRs | release-pr-image.yml |

`GITHUB_TOKEN` is automatically provided by GitHub Actions. Only `PAT` needs manual configuration for the release PR workflow.
