# Node.js Feature Specification

## Location

`features/node/`

## Structure

```
features/node/
├── devcontainer-feature.json
└── install.sh
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `22` | Node.js major version |

## Installation

Uses NodeSource or official Node.js binaries to install the specified version.

Installs:
- Node.js runtime
- npm (bundled with Node.js)

## Usage

Default (Node 22):
```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1": {}
  }
}
```

Specific version:
```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1": {
      "version": "20"
    }
  }
}
```

## Proxy Considerations

npm respects the `HTTP_PROXY` and `HTTPS_PROXY` environment variables set in the base template.
