#!/bin/bash
# Claude Feature Install Script
# Installs Claude Code CLI and sets up configuration.
# See: specs/feature-claude.md

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
# See: specs/feature-claude.md for installation details
trap 'echo "Error: Claude feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

# Install required dependencies if not already present
PACKAGES_TO_INSTALL=()

if ! command -v curl &> /dev/null; then
    PACKAGES_TO_INSTALL+=(curl)
fi

# ca-certificates is harder to check, but we can check if the cert directory exists
if [ ! -d "/etc/ssl/certs" ] || [ -z "$(ls -A /etc/ssl/certs)" ]; then
    PACKAGES_TO_INSTALL+=(ca-certificates)
fi

# Only run apt-get if we have packages to install
if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends "${PACKAGES_TO_INSTALL[@]}"
    apt-get clean
    rm -rf /var/lib/apt/lists/*
fi

echo "Installing Claude Code..."

TARGET_HOME=/home/${_REMOTE_USER}

if [ "${_REMOTE_USER}" = "root" ]; then
    TARGET_HOME=/root
fi

# Create .claude directory structure first
# See: specs/feature-claude.md#installation
mkdir -p ${TARGET_HOME}/.claude

# Copy pre-configured settings optimized for devcontainer use
# See: specs/feature-claude.md#installation
cp claude-init-config.json ${TARGET_HOME}/.claude.json

# Set ownership for both .claude directory and .claude.json file
chown -R ${_REMOTE_USER}:${_REMOTE_USER} ${TARGET_HOME}/.claude
chown ${_REMOTE_USER}:${_REMOTE_USER} ${TARGET_HOME}/.claude.json

# Install Claude Code CLI via official installer (download-then-execute pattern)
# See: specs/feature-claude.md#installation
# Note: Claude installer script fetches latest version; checksum verification not practical
# as the script changes with each release. Using download-then-execute for visibility.
# Note: Using 'su -' for login shell to ensure full environment initialization
su - ${_REMOTE_USER} <<EOSU
# Download installer to temporary file for inspection/execution
curl -fsSL https://claude.ai/install.sh -o /tmp/claude-install.sh

# Execute the downloaded installer
bash /tmp/claude-install.sh

# Clean up installer
rm /tmp/claude-install.sh
EOSU
