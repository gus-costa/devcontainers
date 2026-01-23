#!/bin/bash
# Puppeteer Feature Test Suite - Scenario Configuration
# Tests the Puppeteer feature in combination with Node feature
# See: specs/feature-puppeteer.md and test/puppeteer/scenarios.json

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# =============================================================================
# Test Chromium Installation
# See: specs/feature-puppeteer.md#installation
# =============================================================================

check "chromium-installed" which chromium
check "chromium-executable" chromium --version

# =============================================================================
# Test Environment Variables
# See: specs/feature-puppeteer.md#environment-variables
# =============================================================================

# PUPPETEER_SKIP_CHROMIUM_DOWNLOAD should be set
check "puppeteer-skip-download-set" bash -c "echo \$PUPPETEER_SKIP_CHROMIUM_DOWNLOAD | grep -q 'true'"

# PUPPETEER_EXECUTABLE_PATH should point to system Chromium
check "puppeteer-executable-path-set" bash -c "echo \$PUPPETEER_EXECUTABLE_PATH | grep -q '/usr/bin/chromium'"

# =============================================================================
# Test Puppeteer MCP Installation
# See: specs/feature-puppeteer.md#puppeteer-mcp
# =============================================================================

# Verify puppeteer-mcp is installed and dependencies are present
check "puppeteer-mcp-dir-exists" test -d /home/dev/puppeteer-mcp
check "puppeteer-mcp-node-modules" test -d /home/dev/puppeteer-mcp/node_modules

# =============================================================================
# Test Node.js Integration
# See: specs/feature-puppeteer.md#dependencies
# =============================================================================

# Puppeteer requires Node.js - verify it's available
check "node-installed" node --version
check "npm-installed" npm --version

# Report results
reportResults
