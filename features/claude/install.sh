#!/bin/bash
# Claude Feature Install Script
# Installs Claude Code CLI and sets up configuration.
# See: specs/feature-claude.md

set -e

echo "Installing Claude Code..."

# Create .claude directory structure first
# See: specs/feature-claude.md#installation
mkdir -p /home/${_REMOTE_USER}/.claude

# Copy pre-configured settings optimized for devcontainer use
# See: specs/feature-claude.md#installation
cp claude-init-config.json /home/${_REMOTE_USER}/.claude.json

# Set ownership for both .claude directory and .claude.json file
chown -R ${_REMOTE_USER}:${_REMOTE_USER} /home/${_REMOTE_USER}/.claude
chown ${_REMOTE_USER}:${_REMOTE_USER} /home/${_REMOTE_USER}/.claude.json

# Install Claude Code CLI via official installer
# See: specs/feature-claude.md#installation
su - ${_REMOTE_USER} <<EOSU
curl -fsSL https://claude.ai/install.sh | bash
EOSU
