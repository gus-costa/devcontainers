# Firewall Feature Specification

## Location

`features/firewall/`

## Structure

```
features/firewall/
├── devcontainer-feature.json
├── init-firewall.sh
└── install.sh
```

## Options

None.

## Purpose

Enforces network isolation by blocking all outbound traffic except to the Squid proxy. This prevents bypass via direct connections or tools that ignore proxy settings.

## Installation

Installs networking and firewall packages:
- iptables
- ipset
- iproute2
- dnsutils

Copies the `init-firewall.sh` script to `/usr/local/bin/` and configures passwordless sudo access for the non-root user to run it.

## Firewall Initialization

The `init-firewall.sh` script runs at container start (via the proxy feature's postStartCommand):

1. Flushes existing iptables rules while preserving Docker DNS resolution
2. Sets default policy to DROP for INPUT, FORWARD, and OUTPUT
3. Allows loopback traffic (required for local services)
4. Allows established connections (required for response packets)
5. Resolves Squid proxy IP and allows connections to it on port 3128
6. Verifies configuration with connectivity tests

## Required Capabilities

- `NET_ADMIN` - Required for iptables manipulation
- `NET_RAW` - Required for raw socket access

## Dependencies

Should install after other features to ensure they can download dependencies during build. The proxy feature depends on this feature and triggers firewall initialization.

## Verification

After container starts, verify firewall is working:

**Should fail (direct connection):**
```bash
curl --noproxy '*' --connect-timeout 3 https://github.com
```

**Should succeed (via proxy):**
```bash
curl --connect-timeout 3 https://github.com
```

## Usage

```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/firewall:1": {}
  }
}
```

Typically used together with the proxy feature for complete network isolation.
