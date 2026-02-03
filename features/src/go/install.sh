#!/bin/bash
# Go Feature Install Script
# Installs Go runtime

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
trap 'echo "Error: Go feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

# Install required dependencies if not already present
PACKAGES_TO_INSTALL=()

if ! command -v curl &> /dev/null; then
    PACKAGES_TO_INSTALL+=(curl)
fi

# Only run apt-get if we have packages to install
if [ ${#PACKAGES_TO_INSTALL[@]} -gt 0 ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get install -y --no-install-recommends "${PACKAGES_TO_INSTALL[@]}"
fi

# Feature option: Go version (default: 1.25.6)
VERSION="${VERSION:-1.25.6}"

echo "Installing Go ${VERSION}..."

# Download and extract go binaries
cd /tmp
curl -LsSfO https://go.dev/dl/go${VERSION}.linux-amd64.tar.gz

tar -C /usr/local -xzf go${VERSION}.linux-amd64.tar.gz

# Clean up installer
rm -f go${VERSION}.linux-amd64.tar.gz

# Add go binaries to the path
echo 'export PATH=$PATH:/usr/local/go/bin' > /etc/profile.d/go.sh
echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/zsh/zshenv

# Verify installation
echo "Go \$(go version) installed successfully"
