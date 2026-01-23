# Proxy Feature Specification

## Location

`features/proxy/`

## Structure

```
features/proxy/
├── devcontainer-feature.json
└── install.sh
```

## Options

None.

## Purpose

Configures the container to route all HTTP/HTTPS traffic through the Squid proxy and triggers firewall initialization at container start.

## Environment Variables

Sets proxy environment variables (both uppercase and lowercase for compatibility):

| Variable | Value |
|----------|-------|
| `HTTP_PROXY` / `http_proxy` | `http://squid:3128` |
| `HTTPS_PROXY` / `https_proxy` | `http://squid:3128` |
| `NO_PROXY` / `no_proxy` | `localhost,127.0.0.1` |

## Post-Start Command

Runs the firewall initialization script after container starts:
```bash
sudo -E /usr/local/bin/init-firewall.sh
```

The `-E` flag preserves environment variables so the firewall script can access proxy settings if needed.

## Dependencies

Requires the firewall feature, which provides the `init-firewall.sh` script and iptables packages.

## Usage

```json
{
  "features": {
    "ghcr.io/gus-costa/devcontainers/features/proxy:1": {}
  }
}
```

This feature automatically pulls in the firewall feature as a dependency.

## Network Requirements

The container must be connected to the `devcontainer-proxy` Docker network where the Squid proxy container is running.
