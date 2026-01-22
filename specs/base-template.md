# Base Template Specification

## Location

`templates/base/`

## Structure

```
templates/base/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── init-firewall.sh
└── devcontainer-template.json
```

## Base OS

Debian bookworm-slim

## Installed Packages

**Essential tools:**
- git, vim, curl, wget, ca-certificates, gnupg, sudo, less, unzip, jq, man-db, procps

**Networking/Firewall:**
- iptables, ipset, iproute2, dnsutils

**Shell:**
- zsh with powerlevel10k (via zsh-in-docker)
- fzf for fuzzy finding

**Git enhancements:**
- git-delta for better diffs
- gh (GitHub CLI)

## User Configuration

- Non-root user `dev` with UID 1000
- Passwordless sudo for firewall script only
- Home directory: `/home/dev`

## Environment Variables

**Proxy:**
- `HTTP_PROXY` / `http_proxy` → `http://squid:3128`
- `HTTPS_PROXY` / `https_proxy` → `http://squid:3128`
- `NO_PROXY` / `no_proxy` → `localhost,127.0.0.1`

**Locale:**
- `LANG=en_US.UTF-8`
- `LC_ALL=en_US.UTF-8`
- `LANGUAGE=en_US:en`

**Container identification:**
- `DEVCONTAINER=true`

## Template Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `timezone` | string | `UTC` | Container timezone |

## Docker Compose

**Capabilities required:**
- `NET_ADMIN` - for iptables
- `NET_RAW` - for iptables

**Networks:**
- Connects to external `devcontainer-proxy` network

**Volumes:**
- Workspace mount
- Bash history persistence
- Optional: Claude config from host

## Firewall Script

`init-firewall.sh` runs as `postStartCommand`:

1. Flushes existing rules (preserves Docker DNS)
2. Sets default policy to DROP
3. Allows loopback traffic
4. Allows established connections
5. Resolves squid IP and allows connections to it
6. Verifies direct connections are blocked
7. Verifies proxy connections work

## devcontainer.json

Key settings:
- `postStartCommand`: runs firewall script with sudo
- `waitFor: postStartCommand`: ensures firewall is ready before use
- `remoteUser`: non-root user

## Usage

Basic:
```json
{
  "template": "ghcr.io/gus-costa/devcontainers/base:1.0"
}
```

With features:
```json
{
  "template": "ghcr.io/gus-costa/devcontainers/base:1.0",
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/node:1": {},
    "ghcr.io/gus-costa/devcontainers/features/puppeteer:1": {}
  }
}
```
