#!/bin/bash
# Python Feature Install Script
# Installs Python runtime with uv package manager.
# See: specs/feature-python.md

set -e

# Feature option: Python version (default: 3.12)
VERSION="${VERSION:-3.12}"

echo "Installing Python ${VERSION}..."

su - ${_REMOTE_USER} <<EOSU
curl -LsSf https://astral.sh/uv/install.sh | sh

source \$HOME/.local/bin/env

uv python install ${VERSION} --default

# Verify installation
echo "Python \$(python --version) installed successfully"
echo "uv \$(uv --version) installed successfully"
EOSU
