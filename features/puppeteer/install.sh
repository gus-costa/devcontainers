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

# Verify installation
# Note: Environment variables PUPPETEER_SKIP_CHROMIUM_DOWNLOAD and
# PUPPETEER_EXECUTABLE_PATH are set in devcontainer-feature.json
echo "Chromium $(chromium --version) installed successfully"
