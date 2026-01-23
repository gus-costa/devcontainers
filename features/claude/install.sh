#!/bin/bash

set -e

echo "Installing Claude Code..."

cp claude-init-config.json /home/${_REMOTE_USER}/.claude.json

mkdir -p /home/${_REMOTE_USER}/.claude
chown -R ${_REMOTE_USER}:${_REMOTE_USER} /home/${_REMOTE_USER}/.claude

su - ${_REMOTE_USER} <<EOSU
curl -fsSL https://claude.ai/install.sh | bash
EOSU
