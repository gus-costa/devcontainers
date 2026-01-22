#!/bin/bash
# Node.js Feature Install Script
# Installs Node.js runtime using NodeSource binaries.
# See: specs/feature-node.md

set -e

# Feature option: Node.js major version (default: 22)
VERSION="${VERSION:-22}"

echo "Installing Node.js ${VERSION}..."

# Ensure dependencies are installed
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg

# Add NodeSource GPG key
mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Add NodeSource repository
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${VERSION}.x nodistro main" \
    > /etc/apt/sources.list.d/nodesource.list

# Install Node.js (includes npm)
apt-get update
apt-get install -y --no-install-recommends nodejs

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Node.js $(node --version) installed successfully"
echo "npm $(npm --version) installed successfully"
