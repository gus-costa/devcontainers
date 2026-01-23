#!/bin/bash
# Puppeteer Feature Test Suite - Default Configuration
# Tests the Puppeteer feature with default options
# See: specs/feature-puppeteer.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test Chromium Installation
# See: specs/feature-puppeteer.md#installation
# =============================================================================

check "chromium-installed" which chromium
check "chromium-executable" chromium --version

# Verify Chromium can run (headless check)
check "chromium-headless" chromium --headless --disable-gpu --dump-dom about:blank

# =============================================================================
# Test System Dependencies
# See: specs/feature-puppeteer.md#system-dependencies
# =============================================================================

# Verify required libraries are installed
check "libnss3-installed" dpkg -l | grep -q libnss3
check "libatk-bridge2.0-0-installed" dpkg -l | grep -q libatk-bridge2.0-0
check "libdrm2-installed" dpkg -l | grep -q libdrm2
check "libxkbcommon0-installed" dpkg -l | grep -q libxkbcommon0
check "libgbm1-installed" dpkg -l | grep -q libgbm1
check "libasound2-installed" dpkg -l | grep -q libasound2
check "libxss1-installed" dpkg -l | grep -q libxss1
check "libgtk-3-0-installed" dpkg -l | grep -q libgtk-3-0

# =============================================================================
# Test Font Installation
# See: specs/feature-puppeteer.md#system-dependencies
# =============================================================================

# Verify international fonts are installed
check "fonts-ipafont-gothic-installed" dpkg -l | grep -q fonts-ipafont-gothic
check "fonts-wqy-zenhei-installed" dpkg -l | grep -q fonts-wqy-zenhei
check "fonts-thai-tlwg-installed" dpkg -l | grep -q fonts-thai-tlwg
check "fonts-kacst-installed" dpkg -l | grep -q fonts-kacst
check "fonts-freefont-ttf-installed" dpkg -l | grep -q fonts-freefont-ttf

# =============================================================================
# Test Environment Variables
# See: specs/feature-puppeteer.md#environment-variables
# =============================================================================

# PUPPETEER_SKIP_CHROMIUM_DOWNLOAD should prevent downloading bundled Chromium
check "puppeteer-skip-download-set" bash -c "echo \$PUPPETEER_SKIP_CHROMIUM_DOWNLOAD | grep -q 'true'"

# PUPPETEER_EXECUTABLE_PATH should point to system Chromium
check "puppeteer-executable-path-set" bash -c "echo \$PUPPETEER_EXECUTABLE_PATH | grep -q '/usr/bin/chromium'"

# Verify the path actually exists
check "chromium-path-exists" test -f "$PUPPETEER_EXECUTABLE_PATH"

# =============================================================================
# Test Puppeteer MCP Installation
# See: specs/feature-puppeteer.md#puppeteer-mcp
# =============================================================================

# Verify puppeteer-mcp directory exists at correct location
check "puppeteer-mcp-dir-exists" test -d /home/dev/puppeteer-mcp

# Verify package.json exists
check "puppeteer-mcp-package-json" test -f /home/dev/puppeteer-mcp/package.json

# Verify node_modules directory exists (npm install ran)
check "puppeteer-mcp-node-modules" test -d /home/dev/puppeteer-mcp/node_modules

# Verify ownership is set to dev user
check "puppeteer-mcp-ownership" bash -c "stat -c '%U' /home/dev/puppeteer-mcp | grep -q 'dev'"

# Verify tsconfig files exist
check "puppeteer-mcp-tsconfig" test -f /home/dev/puppeteer-mcp/tsconfig.json
check "puppeteer-mcp-tsconfig-root" test -f /home/dev/puppeteer-mcp/tsconfig-root.json

# Report results
reportResults
