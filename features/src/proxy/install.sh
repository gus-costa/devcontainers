#!/bin/bash
# Proxy Feature Install Script
# Configures environment variables to route traffic through Squid proxy.
# Firewall initialization happens via postStartCommand (see devcontainer-feature.json).
# See: specs/feature-proxy.md

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
# See: specs/feature-proxy.md for installation details
trap 'echo "Error: Proxy feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

# No installation needed - environment variables are set in devcontainer-feature.json
# postStartCommand triggers firewall initialization: sudo -E /usr/local/bin/init-firewall.sh