#!/bin/bash
# Puppeteer Feature Install Script
# Installs Chromium and system dependencies for headless browser automation.
# See: specs/feature-puppeteer.md

set -e

echo "Installing Chromium and Puppeteer dependencies..."

# Install Chromium and required system libraries
# See: specs/feature-puppeteer.md#system-dependencies
apt-get update
apt-get install -y --no-install-recommends \
    chromium \
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

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

TMP_DIR=/tmp/puppeteer-install
mkdir -p $TMP_DIR
cd $TMP_DIR
git clone --filter=blob:none --no-checkout https://github.com/modelcontextprotocol/servers-archived
cd servers-archived
git sparse-checkout set src/puppeteer tsconfig.json
git checkout main
cp -r src/puppeteer /home/${_REMOTE_USER}/puppeteer-mcp
cp tsconfig.json /home/${_REMOTE_USER}/puppeteer-mcp/tsconfig-root.json
chown -R ${_REMOTE_USER}:${_REMOTE_USER} /home/${_REMOTE_USER}/puppeteer-mcp
cd /home/${_REMOTE_USER}/puppeteer-mcp
rm -rf $TMP_DIR
sed -i 's/..\/..\/tsconfig/.\/tsconfig-root/g' tsconfig.json
# Install npm dependencies as dev user to avoid permission issues
# See: specs/feature-puppeteer.md#puppeteer-mcp
# Note: Using 'su -' for login shell to ensure full environment initialization
su - ${_REMOTE_USER} -c "cd /home/${_REMOTE_USER}/puppeteer-mcp && npm install"

# Verify installation
echo "Chromium $(chromium --version) installed successfully"
