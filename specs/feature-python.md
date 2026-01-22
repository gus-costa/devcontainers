# Python Feature Specification

## Location

`features/python/`

## Structure

```
features/python/
├── devcontainer-feature.json
└── install.sh
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `3.12` | Python version |

## Installation

Installs Python from Debian repos or deadsnakes PPA, plus:
- `uv` package manager via official installer

Sets `UV_SYSTEM_PYTHON=1` to use system Python by default.

## Usage

Default (Python 3.12):
```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/python:1": {}
  }
}
```

Specific version:
```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/python:1": {
      "version": "3.11"
    }
  }
}
```

## Proxy Considerations

uv respects proxy environment variables set in the base template.
