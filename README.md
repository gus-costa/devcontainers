# Devcontainers

Development containers with network isolation for AI agent security.

## Overview

This repository provides a base Dev Container template with 7 optional features for development workflows. All traffic is filtered through a shared Squid proxy with iptables firewall enforcement.

## Components

| Component | Location | Description |
|-----------|----------|-------------|
| Base template | `images/base/` | General-purpose container with zsh, git-delta, fzf, and essential development tools |
| Squid proxy | `squid/` | Shared traffic filtering for all containers with domain whitelist |
| Features | `features/` | 7 optional features (see Features section below) |

## Features

All features are designed to work with the base template and network isolation:

| Feature | Description | Key Capabilities |
|---------|-------------|------------------|
| **node** | Node.js runtime with npm | Version selection, GPG-verified downloads, @antfu/ni, node_modules volume mount |
| **python** | Python runtime with uv | Version selection, uv package manager, VS Code Python extensions |
| **puppeteer** | Browser automation | Chromium, system dependencies, fonts, puppeteer-mcp integration |
| **claude** | Claude Code integration | CLI installation, VS Code extension, persistent configuration |
| **github** | GitHub CLI | gh CLI from official apt repository |
| **firewall** | Network isolation | iptables rules blocking direct connections except to proxy |
| **proxy** | Proxy configuration | HTTP/HTTPS environment variables, automatic firewall initialization |

## Quick Start

### 1. Start Squid Proxy

```bash
docker compose -f squid/docker-compose.yml up -d
```

### 2. Use the Base Template

**Option A: Local Development (before publishing)**

Copy the `.devcontainer` directory to your project:

```bash
cp -r images/base/.devcontainer /path/to/your/project/
```

**Option B: Run your own OCI server locally**

Run zot using docker:

```bash
docker run --rm -d -p 5000:5000 --name oras-quickstart ghcr.io/project-zot/zot-linux-amd64:latest
```

Build and publish the image:

```bash
devcontainer build --workspace-folder images/base --push true --image-name localhost:5000/base:1.0.0
```

Add `.devcontainer/devcontainer.json` to your project referencing the image:

```json
{
	"name": "Test",
	"image": "localhost:5000/base:1.0.0",
	"features": {
		"localhost:5000/python/python:latest": {
			"version": "3.13"
		},
	},
	"workspaceMount": "source=${localWorkspaceFolder},target=/workspace,type=bind,consistency=delegated",
	"workspaceFolder": "/workspace",
	"runArgs": [
		"--network=devcontainer-proxy"
	]
}
```

**Option C: Published Template (after publishing to GHCR)**

Reference the published image in your `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:1.0.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1.0.0": {},
    "ghcr.io/gus-costa/devcontainers/features/firewall:1.0.0": {},
    "ghcr.io/gus-costa/devcontainers/features/proxy:1.0.0": {}
  }
}
```

### 3. Open in VS Code

```bash
code /path/to/your/project
```

Then use "Dev Containers: Reopen in Container".

## Usage Examples

### Node.js Project with Network Isolation

```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:1.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1.0": {
      "version": "20"
    },
    "ghcr.io/gus-costa/devcontainers/features/firewall:1.0": {},
    "ghcr.io/gus-costa/devcontainers/features/proxy:1.0": {}
  }
}
```

### Python Development with Claude

```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:1.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/python:1.0": {
      "version": "3.12"
    },
    "ghcr.io/gus-costa/devcontainers/features/claude:1.0": {},
    "ghcr.io/gus-costa/devcontainers/features/github:1.0": {},
    "ghcr.io/gus-costa/devcontainers/features/firewall:1.0": {},
    "ghcr.io/gus-costa/devcontainers/features/proxy:1.0": {}
  }
}
```

### Browser Automation with Puppeteer

```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:1.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1.0": {
      "version": "20"
    },
    "ghcr.io/gus-costa/devcontainers/features/puppeteer:1.0": {},
    "ghcr.io/gus-costa/devcontainers/features/firewall:1.0": {},
    "ghcr.io/gus-costa/devcontainers/features/proxy:1.0": {}
  }
}
```

**Note:** The `firewall` and `proxy` features should always be used together for network isolation. The `proxy` feature automatically initializes the firewall at container start.

## Proxy Configuration

The proxy feature supports configurable proxy settings for different deployment scenarios:

```json
{
  "image": "ghcr.io/gus-costa/devcontainers/base:1.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/firewall:1.0": {},
    "ghcr.io/gus-costa/devcontainers/features/proxy:1.0": {}
  },
  "containerEnv": {
    "PROXY_HOST": "squid",
    "PROXY_PORT": "3128",
    "NO_PROXY": "localhost,127.0.0.1,.internal.example.com"
  }
}
```

**Environment Varialbes:**

| Option | Default | Description |
|--------|---------|-------------|
| `PROXY_HOST` | `squid` | Hostname or IP address of the proxy server |
| `PROXY_PORT` | `3128` | Port number of the proxy server |
| `NO_PROXY` | `localhost,127.0.0.1` | Comma-separated list of domains that should bypass the proxy |

These settings configure both the HTTP/HTTPS proxy environment variables and the firewall rules to allow traffic to the specified proxy.

## Security Model

Network isolation is enforced through a two-layer architecture:

1. **Squid proxy** (`squid/`) - Application-level filtering with domain whitelist
   - Allows: github.com, npmjs.org, pypi.org, pythonhosted.org, githubusercontent.com, docker.io
   - Denies all other domains
   - Runs in separate container on `squid-network`

2. **iptables firewall** (`firewall` feature) - Network-level enforcement
   - Blocks ALL outbound traffic except to Squid proxy host
   - Prevents bypass via direct connections or tools that ignore proxy settings
   - Initialized automatically via `proxy` feature's postStartCommand

The `proxy` feature sets HTTP_PROXY and HTTPS_PROXY environment variables and depends on the `firewall` feature to ensure all traffic goes through Squid.

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

## Publishing Status

This repository is **ready for publishing** to GitHub Container Registry (GHCR):

- Base template: Ready at version 1.0.0
- All 7 features: Ready at version 1.0.0
- Automated publishing: Available via GitHub Actions workflow
- Manual publishing: Available via devcontainer CLI

To publish:
```bash
# Publish base template
devcontainer build --workspace-folder images/base --push --image-name ghcr.io/gus-costa/devcontainers/base:1.0.0

# Publish all features
devcontainer features publish --namespace gus-costa/devcontainers/features --registry ghcr.io ./features
```

See [specs/publishing.md](./specs/publishing.md) for detailed publishing instructions.

## Documentation

See the [specs/](./specs/) directory for detailed technical specifications:

- [architecture.md](./specs/architecture.md) - System architecture overview
- [base-template.md](./specs/base-template.md) - Base container specification
- [squid-proxy.md](./specs/squid-proxy.md) - Proxy infrastructure
- [testing.md](./specs/testing.md) - Testing procedures
- [publishing.md](./specs/publishing.md) - Publishing workflow
- [feature-*.md](./specs/) - Individual feature specifications

## Adding Domains to Whitelist

Edit `squid/squid.conf` and add a new ACL line:

```
acl whitelisted_domains dstdomain .example.com
```

Then restart Squid:

```bash
docker compose -f squid/docker-compose.yml restart
```
