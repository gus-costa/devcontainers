#!/bin/bash
# Qwen Feature Install Script
# Installs Qwen Code CLI and sets up configuration.

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
trap 'echo "Error: Qwen feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

echo "Installing Qwen Code..."

TARGET_HOME=/home/${_REMOTE_USER}

if [ "${_REMOTE_USER}" = "root" ]; then
    TARGET_HOME=/root
fi

# Create .qwen directory structure first
mkdir -p ${TARGET_HOME}/.qwen

# Set ownership for both .qwen directory
chown -R ${_REMOTE_USER}:${_REMOTE_USER} ${TARGET_HOME}/.qwen

# Install Qwen Code CLI via npm
# Using 'su -' for login shell to ensure full environment initialization
su - ${_REMOTE_USER} <<EOSU
# Install qwen-code globally using npm
npm install -g @qwen-code/qwen-code@latest
EOSU
