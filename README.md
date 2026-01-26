# Devcontainers

Development containers with network isolation for AI agent security.

## Overview

This repository provides a base Dev Container template with optional features for Node.js, Python, and browser automation. All traffic is filtered through a shared Squid proxy with iptables firewall enforcement.

## Components

| Component | Location | Description |
|-----------|----------|-------------|
| Base template | `images/base/` | General-purpose container with zsh, git-delta, proxy setup |
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
cp -r images/base/.devcontainer /path/to/your/project/
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

## Testing

Test projects are located in `test/` and `images/base/test-project/` to verify the templates and features work correctly:

| Test Project | Purpose |
|--------------|---------|
| `images/base/test-project/` | Tests base template (zsh, git-delta, essential packages) |
| `test/node/` | Tests Node.js feature (Node.js + npm through proxy) |
| `test/python/` | Tests Python feature (Python + uv through proxy) |
| `test/puppeteer/` | Tests Puppeteer feature (Chromium, system dependencies, puppeteer-mcp) |
| `test/claude/` | Tests Claude feature (CLI installation, configuration, mounts) |
| `test/github/` | Tests GitHub CLI feature (gh CLI installation, repository configuration) |
| `test/firewall/` | Tests Firewall feature (iptables, init script, sudoers, runtime blocking behavior) |
| `test/proxy/` | Tests Proxy feature (environment variables, connectivity, domain filtering) |

To test:

1. Start Squid proxy: `docker compose -f squid/docker-compose.yml up -d`
2. Open a test project in VS Code
3. Use "Dev Containers: Reopen in Container"
4. Verify the test scenarios described in each devcontainer.json

See [specs/testing.md](./specs/testing.md) for firewall verification commands.

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
