# Base Image Specification

## Location

`images/base/`

## Structure

```
images/base/
├── .devcontainer/
│   ├── devcontainer.json
│   └── Dockerfile
├── devcontainer-template.json
└── test-project/
    ├── test.sh
    └── test-utils.sh
```

## Base OS

Debian bookworm-slim

## Installed Packages

**Essential tools:**
- git, vim, curl, ca-certificates, gnupg, sudo, less, unzip, jq, man-db, procps

**Locale/Timezone:**
- locales, tzdata

**Shell:**
- zsh with Oh My Zsh (via zsh-in-docker, powerlevel10k default theme)
- Oh My Zsh plugins: git, fzf
- fzf for fuzzy finding

**Git enhancements:**
- git-delta for better diffs (with side-by-side view and hyperlinks)

## User Configuration

- Non-root user `dev` with UID 1000
- Default shell: zsh
- Home directory: `/home/dev`

## Environment Variables

**Locale:**
- `LANG=en_US.UTF-8`
- `LC_ALL=en_US.UTF-8`
- `LANGUAGE=en_US:en`

**Shell:**
- `SHELL=/bin/zsh`
- `POWERLEVEL9K_DISABLE_GITSTATUS=true`

**Container identification:**
- `DEVCONTAINER=true`

## Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `TIMEZONE` | `UTC` | Container timezone |
| `FZF_VERSION` | `0.67.0` | fzf version to install |

## Volumes

- Shell history persistence (`/commandhistory`) - stores both bash and zsh history

## devcontainer.json

Key settings:
- `remoteUser`: `dev` (non-root user)
- `waitFor: postStartCommand`: ensures features complete initialization before use
- VS Code terminal default profile: zsh

## Usage

Basic:
```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:1.0"
}
```

With features:
```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:1.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1": {},
    "ghcr.io/gus-costa/devcontainers/features/puppeteer:1": {}
  }
}
```
