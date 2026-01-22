# Devcontainers

Development containers with network isolation for AI agent security.

## Overview

This repository provides a base Dev Container template with optional features for Node.js, Python, and browser automation. All traffic is filtered through a shared Squid proxy with iptables firewall enforcement.

## Components

| Component | Location | Description |
|-----------|----------|-------------|
| Base template | `templates/base/` | General-purpose container with zsh, git-delta, proxy setup |
| Squid proxy | `squid/` | Shared traffic filtering for all containers |
| Features | `features/` | Optional: Node.js, Python, Puppeteer |

## Quick Start

### 1. Start Squid Proxy

```bash
docker compose -f squid/docker-compose.yml up -d
```

### 2. Use the Base Template

Copy the `.devcontainer` directory to your project:

```bash
cp -r templates/base/.devcontainer /path/to/your/project/
```

Or reference the published template:

```json
{
  "template": "ghcr.io/gus-costa/devcontainers/base:1.0"
}
```

### 3. Open in VS Code

```bash
code /path/to/your/project
```

Then use "Dev Containers: Reopen in Container".

## Security Model

Traffic filtering uses two layers:

1. **Squid proxy** - Whitelists allowed domains (GitHub, npm, PyPI, etc.)
2. **iptables firewall** - Blocks ALL outbound traffic except to Squid

This prevents bypass via direct connections or tools that ignore proxy settings.

## Documentation

See the [specs/](./specs/) directory for detailed technical specifications.

## Adding Domains to Whitelist

Edit `squid/squid.conf` and add a new ACL line:

```
acl whitelisted_domains dstdomain .example.com
```

Then restart Squid:

```bash
docker compose -f squid/docker-compose.yml restart
```
