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

The `init-firewall.sh` script is executed at container startup via the `postStartCommand` defined in the proxy feature. It orchestrates the firewall setup as follows:

1.  **Preserves Docker DNS:** Before flushing any rules, it saves the existing Docker DNS `iptables` rules.
2.  **Flushes Rules:** It flushes all existing `iptables` rules to ensure a clean state.
3.  **Restores Docker DNS:** It restores the previously saved Docker DNS rules, ensuring that the container can still resolve internal hostnames.
4.  **Default Drop Policy:** Sets the default policy for `INPUT`, `FORWARD`, and `OUTPUT` chains to `DROP`, blocking all traffic by default.
5.  **Allows Loopback:** Allows all traffic on the loopback interface (`lo`), which is essential for local services.
6.  **Allows Established Connections:** Allows `ESTABLISHED` and `RELATED` connections, which is necessary for receiving responses to outbound connections.
7.  **Allows Squid Proxy:** Resolves the IP address of the `squid` hostname and allows outbound connections to it on port `3128`.
8.  **Verification:** Performs connectivity tests to verify that direct connections are blocked and that connections through the proxy are successful.
9.  **Error Handling:** The script will exit with an error if the `squid` hostname cannot be resolved.

## Required Capabilities

- `NET_ADMIN` - Required for iptables manipulation.
- `NET_RAW` - Required for raw socket access.

## Dependencies

Configured to install after language runtime and CLI features (Python, Node.js, Claude, Puppeteer, GitHub) to ensure they can download dependencies during build without firewall interference.

The proxy feature depends on this feature and triggers firewall initialization.

## Verification

After the container starts, you can verify that the firewall is working correctly:

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
