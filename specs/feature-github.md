# GitHub CLI Feature Specification

## Location

`features/github/`

## Structure

```
features/github/
├── devcontainer-feature.json
└── install.sh
```

## Options

None.

## Container Environment

None.

## Installation

Installs the GitHub CLI (`gh`) from the official GitHub CLI apt repository:
1. Adds the GitHub CLI GPG key
2. Adds the GitHub CLI apt repository
3. Installs the `gh` package

## Usage

```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/github:1": {}
  }
}
```

## Proxy Considerations

The GitHub CLI respects proxy environment variables set by the proxy feature.
