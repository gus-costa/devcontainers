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

Requires `jq` to be installed for version parsing.

Downloads official Node.js binaries from nodejs.org, verifying their integrity with GPG signatures from the official Node.js keyring.

Installs:
- Node.js runtime
- npm (bundled with Node.js)
- `@antfu/ni` global package manager helper for the non-root user (`dev`)

## Environment Variables

- `NODE_OPTIONS=--max-old-space-size=2048` - Sets default heap size to 2GB

## Mounts

- A named volume is mounted at the container's workspace folder (`${containerWorkspaceFolder}/node_modules`) to persist `node_modules` and improve performance.

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

npm respects the `HTTP_PROXY` and `HTTPS_PROXY` environment variables set by the proxy feature.
