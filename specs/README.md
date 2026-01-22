# Specifications

Technical specifications for the devcontainers repository.

## Documents

| File | Description |
|------|-------------|
| [architecture.md](./architecture.md) | System overview, component relationships, network topology |
| [base-template.md](./base-template.md) | Base template: packages, user config, proxy setup |
| [feature-node.md](./feature-node.md) | Node.js feature with npm |
| [feature-python.md](./feature-python.md) | Python feature with uv |
| [feature-puppeteer.md](./feature-puppeteer.md) | Puppeteer feature for browser automation |
| [squid-proxy.md](./squid-proxy.md) | Shared proxy for traffic filtering |
| [testing.md](./testing.md) | Test structure and validation |
| [publishing.md](./publishing.md) | Versioning and ghcr.io publishing |

## Reading Order

1. **architecture.md** - Big picture
2. **base-template.md** - Foundation everything builds on
3. **squid-proxy.md** - Network setup
4. **feature-*.md** - Optional capabilities
5. **testing.md** / **publishing.md** - When ready to ship
