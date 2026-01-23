# Specifications

Technical specifications for the devcontainers repository.

## Documents

| File | Description |
|------|-------------|
| [architecture.md](./architecture.md) | System overview, component relationships, network topology |
| [base-template.md](./base-template.md) | Base image: packages, shell, user config |
| [feature-node.md](./feature-node.md) | Node.js feature with npm |
| [feature-python.md](./feature-python.md) | Python feature with uv |
| [feature-puppeteer.md](./feature-puppeteer.md) | Puppeteer feature for browser automation |
| [feature-claude.md](./feature-claude.md) | Claude Code CLI and configuration |
| [feature-github.md](./feature-github.md) | GitHub CLI (gh) |
| [feature-firewall.md](./feature-firewall.md) | iptables firewall enforcement |
| [feature-proxy.md](./feature-proxy.md) | Proxy environment configuration |
| [squid-proxy.md](./squid-proxy.md) | Shared proxy for traffic filtering |
| [testing.md](./testing.md) | Test structure and validation |
| [publishing.md](./publishing.md) | Versioning and ghcr.io publishing |

## Reading Order

1. **architecture.md** - Big picture
2. **base-template.md** - Base image everything builds on
3. **squid-proxy.md** - Proxy server configuration
4. **feature-firewall.md** / **feature-proxy.md** - Network isolation
5. **feature-*.md** - Runtime features (node, python, puppeteer, claude, github)
6. **testing.md** / **publishing.md** - When ready to ship
