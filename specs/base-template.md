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

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `timezone` | string | `UTC` | Container timezone (e.g., America/New_York, Europe/London) |

## Installed Packages

**Essential tools:**
- git, vim, curl, ca-certificates, gnupg, sudo, less, unzip, jq, man-db, procps

**Locale/Timezone:**
- locales, tzdata

**Shell:**
- zsh with `zsh-in-docker` for easy configuration of powerlevel10k and plugins.
- Enabled plugins: `git`, `fzf`
- fzf for fuzzy finding

**Git enhancements:**
- git-delta for better diffs with:
  - Side-by-side view
  - Navigation between diff sections
  - Syntax highlighting with color-moved detection
  - Clickable hyperlinks in VS Code format
  - diff3 conflict style for easier merge conflict resolution

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
| `TIMEZONE` | `UTC` | Container timezone (maps to `TZ` build arg in devcontainer.json) |
| `FZF_VERSION` | `0.67.0` | fzf version to install |

**Note**: The Dockerfile uses `TIMEZONE` as the arg name, but when using with devcontainer.json, pass it as `TZ` in the build args.

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
