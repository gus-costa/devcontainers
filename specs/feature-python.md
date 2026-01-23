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

Installs:
- `uv` package manager via official installer script
- Python runtime via `uv python install`

The specified Python version is set as the default.

## VS Code Extensions

Automatically installs:
- ms-python.black-formatter
- ms-python.python
- ms-python.isort
- ms-python.vscode-pylance
- ms-python.debugpy
- ms-python.vscode-python-envs

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
