#!/bin/bash
# Python Feature Install Script
# Installs Python runtime with uv package manager.
# See: specs/feature-python.md

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
# See: specs/feature-python.md for installation details
trap 'echo "Error: Python feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

# Feature option: Python version (default: 3.12)
VERSION="${VERSION:-3.12}"

echo "Installing Python ${VERSION}..."

# Download and verify uv installer before execution (avoid curl | sh pattern)
# See: specs/feature-python.md#installation
# Note: uv installer script fetches latest version; checksum verification not practical
# as the script changes with each release. Using download-then-execute for visibility.
# Note: Using 'su -' for login shell to ensure full environment initialization
su - ${_REMOTE_USER} <<EOSU
# Download installer to temporary file for inspection/execution
curl -LsSf https://astral.sh/uv/install.sh -o /tmp/uv-install.sh

# Execute the downloaded installer
sh /tmp/uv-install.sh

# Clean up installer
rm /tmp/uv-install.sh

source \$HOME/.local/bin/env

uv python install ${VERSION} --default

# Verify installation
echo "Python \$(python --version) installed successfully"
echo "uv \$(uv --version) installed successfully"
EOSU
