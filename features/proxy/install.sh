#!/bin/bash
# Proxy Feature Install Script
# Configures environment variables to route traffic through Squid proxy.
# Firewall initialization happens via postStartCommand (see devcontainer-feature.json).
# See: specs/feature-proxy.md

set -e

# No installation needed - environment variables are set in devcontainer-feature.json
# postStartCommand triggers firewall initialization: sudo -E /usr/local/bin/init-firewall.sh
