#!/bin/bash
# Firewall Feature Install Script
# Installs iptables firewall packages and initialization script for traffic isolation.
# See: specs/feature-firewall.md

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
# See: specs/feature-firewall.md for installation details
trap 'echo "Error: Firewall feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

apt-get update
# Install networking and firewall packages for traffic isolation
# See: specs/feature-firewall.md#installation
apt-get install -y --no-install-recommends \
    sudo \
    iptables \
    ipset \
    iproute2 \
    dnsutils
apt-get clean
rm -rf /var/lib/apt/lists/*

# Install firewall initialization script to /usr/local/bin
# See: specs/feature-firewall.md#installation
cp init-firewall.sh /usr/local/bin/
chmod +x /usr/local/bin/init-firewall.sh

# Configure passwordless sudo for firewall script only
# See: specs/feature-firewall.md#installation
mkdir -p /etc/sudoers.d
echo "${_REMOTE_USER} ALL=(root) SETENV: NOPASSWD: /usr/local/bin/init-firewall.sh" >> /etc/sudoers.d/${_REMOTE_USER}-firewall
chmod 0440 /etc/sudoers.d/${_REMOTE_USER}-firewall
