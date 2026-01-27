#!/bin/bash
# Puppeteer Feature Install Script
# Installs Chromium and system dependencies for headless browser automation.
# See: specs/feature-puppeteer.md

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
# See: specs/feature-puppeteer.md for installation details
trap 'echo "Error: Puppeteer feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

echo "Installing Chromium and Puppeteer dependencies..."

# Update package lists first
apt-get update

# Determine correct chromium package name (debian uses 'chromium', ubuntu uses 'chromium-browser')
# Use apt-cache policy to check if package is actually installable (has a non-empty candidate)
if apt-cache policy chromium 2>/dev/null | grep -E "Candidate:.*[0-9]" | grep -qv "(none)"; then
    CHROMIUM_PKG="chromium"
elif apt-cache policy chromium-browser 2>/dev/null | grep -E "Candidate:.*[0-9]" | grep -qv "(none)"; then
    CHROMIUM_PKG="chromium-browser"
else
    echo "Error: Chromium package not found in repositories" >&2
    exit 1
fi

# Install Chromium and required system libraries
# See: specs/feature-puppeteer.md#system-dependencies
apt-get install -y --no-install-recommends \
    $CHROMIUM_PKG \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libgbm1 \
    libasound2 \
    libxss1 \
    libgtk-3-0

# Install fonts for international text rendering
# See: specs/feature-puppeteer.md#system-dependencies
apt-get install -y --no-install-recommends \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf

apt-get install -y --no-install-recommends \
    git

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

TARGET_HOME=/home/${_REMOTE_USER}

if [ "${_REMOTE_USER}" = "root" ]; then
    TARGET_HOME=/root
fi

TMP_DIR=/tmp/puppeteer-install
mkdir -p $TMP_DIR
cd $TMP_DIR
git clone --filter=blob:none --no-checkout https://github.com/modelcontextprotocol/servers-archived
cd servers-archived
git sparse-checkout set src/puppeteer tsconfig.json
git checkout main
cp -r src/puppeteer ${TARGET_HOME}/puppeteer-mcp
cp tsconfig.json ${TARGET_HOME}/puppeteer-mcp/tsconfig-root.json
chown -R ${_REMOTE_USER}:${_REMOTE_USER} ${TARGET_HOME}/puppeteer-mcp
cd ${TARGET_HOME}/puppeteer-mcp
rm -rf $TMP_DIR
sed -i 's/..\/..\/tsconfig/.\/tsconfig-root/g' tsconfig.json
# Install npm dependencies as dev user to avoid permission issues
# See: specs/feature-puppeteer.md#puppeteer-mcp
# Note: Using 'su -' for login shell to ensure full environment initialization
su - ${_REMOTE_USER} -c "cd ${TARGET_HOME}/puppeteer-mcp && npm install"

# Verify installation
echo "Chromium $($CHROMIUM_PKG --version) installed successfully"
