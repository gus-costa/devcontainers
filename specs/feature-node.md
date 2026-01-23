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

Downloads official Node.js binaries from nodejs.org with GPG signature verification.

Installs:
- Node.js runtime
- npm (bundled with Node.js)
- `@antfu/ni` global package manager helper

## Environment Variables

- `NODE_OPTIONS=--max-old-space-size=2048` - Sets default heap size to 2GB

## Volumes

- `node_modules` - Mounted as a volume at workspace root for better performance

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
