#!/bin/bash
# Gemini Feature Install Script
# Installs Gemini CLI and sets up configuration.

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
trap 'echo "Error: Gemini feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

echo "Installing Gemini CLI..."

TARGET_HOME=/home/${_REMOTE_USER}

if [ "${_REMOTE_USER}" = "root" ]; then
    TARGET_HOME=/root
fi

# Create .gemini directory structure first
mkdir -p ${TARGET_HOME}/.gemini

# Set ownership for both .gemini directory
chown -R ${_REMOTE_USER}:${_REMOTE_USER} ${TARGET_HOME}/.gemini

# Install Gemini CLI via npm
# Using 'su -' for login shell to ensure full environment initialization
su - ${_REMOTE_USER} <<EOSU
# Install gemini-cli globally using npm
npm install -g @google/gemini-cli@latest
EOSU
