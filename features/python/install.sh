#!/bin/bash
# Python Feature Install Script
# Installs Python runtime with uv package manager.
# See: specs/feature-python.md

set -e

# Feature option: Python version (default: 3.12)
VERSION="${VERSION:-3.12}"

echo "Installing Python ${VERSION}..."

# Ensure dependencies are installed
apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    software-properties-common

# Add deadsnakes PPA for Ubuntu-based systems or install from Debian repos
# Note: deadsnakes PPA is for Ubuntu; for Debian, we use available packages
if command -v add-apt-repository &> /dev/null && grep -qi ubuntu /etc/os-release; then
    # Ubuntu: use deadsnakes PPA for latest Python versions
    add-apt-repository -y ppa:deadsnakes/ppa
    apt-get update
    apt-get install -y --no-install-recommends \
        python${VERSION} \
        python${VERSION}-venv \
        python${VERSION}-dev
else
    # Debian: install from available repositories
    # Try python3 package (will get default version) or specific version if available
    apt-get install -y --no-install-recommends \
        python3 \
        python3-venv \
        python3-dev \
        python3-pip
fi

# Install uv package manager via official installer
# uv respects proxy environment variables from base template
# See: specs/feature-python.md#proxy-considerations
echo "Installing uv package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH for all users
# The installer puts uv in ~/.local/bin, but we need it system-wide
if [ -f /root/.local/bin/uv ]; then
    mv /root/.local/bin/uv /usr/local/bin/uv
    chmod +x /usr/local/bin/uv
fi

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

# Verify installation
echo "Python $(python3 --version) installed successfully"
echo "uv $(uv --version) installed successfully"
