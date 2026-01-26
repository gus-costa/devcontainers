#!/bin/bash
# Proxy Feature Install Script
# Configures environment variables to route traffic through Squid proxy.
# Firewall initialization happens via postStartCommand (see devcontainer-feature.json).
# See: specs/feature-proxy.md

set -e

# =============================================================================
# Read Configuration Options
# Options are provided as uppercase environment variables by devcontainer CLI
# See: specs/feature-proxy.md
# =============================================================================

PROXY_HOST="${PROXYHOST:-squid}"
PROXY_PORT="${PROXYPORT:-3128}"
NO_PROXY="${NOPROXY:-localhost,127.0.0.1}"

echo "Configuring proxy settings..."
echo "  Proxy: ${PROXY_HOST}:${PROXY_PORT}"
echo "  No proxy: ${NO_PROXY}"

# =============================================================================
# Configure Proxy Environment Variables
# Write to /etc/environment for system-wide availability
# Both uppercase and lowercase variants for compatibility
# =============================================================================

PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

cat >> /etc/environment << EOF
HTTP_PROXY=${PROXY_URL}
http_proxy=${PROXY_URL}
HTTPS_PROXY=${PROXY_URL}
https_proxy=${PROXY_URL}
NO_PROXY=${NO_PROXY}
no_proxy=${NO_PROXY}
SQUID_HOST=${PROXY_HOST}
SQUID_PORT=${PROXY_PORT}
EOF

echo "Proxy environment variables configured successfully"
