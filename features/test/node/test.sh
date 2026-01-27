#!/bin/bash
# Node.js Feature Test Suite - Default Configuration
# Tests the Node.js feature with default options (version 22)
# See: specs/feature-node.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test Node.js Installation
# See: specs/feature-node.md#installation
# =============================================================================

check "node-installed" node --version
check "npm-installed" npm --version

# Verify default version (22.x)
# See: specs/feature-node.md#options
NODE_VERSION=$(node --version)
check "node-version-22" bash -c "echo $NODE_VERSION | grep '^v22\.'"

# =============================================================================
# Test Environment Variables
# See: specs/feature-node.md#environment-variables
# =============================================================================

# NODE_OPTIONS should be set to limit heap size
check "node-options-set" bash -c "echo \$NODE_OPTIONS | grep -- '--max-old-space-size=2048'"

# =============================================================================
# Test node_modules Volume
# See: specs/feature-node.md#volumes
# =============================================================================

# node_modules directory should exist at workspace root
check "node-modules-dir-exists" test -d /workspace/node_modules

# Verify node_modules is writable (important for npm install)
check "node-modules-writable" bash -c "touch /workspace/node_modules/.test && rm /workspace/node_modules/.test"

# =============================================================================
# Test npm Functionality
# =============================================================================

# Test that npm can list global packages (verifies npm is working)
check "npm-list-global" npm list -g --depth=0

# Verify @antfu/ni is in global packages
check "npm-ni-global" npm list -g @antfu/ni

# Report results
reportResults