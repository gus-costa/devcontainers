#!/bin/bash
# Node.js Feature Test Suite - Version Scenario
# Tests the Node.js feature with version option set to 24
# See: specs/feature-node.md and test/node/scenarios.json

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# =============================================================================
# Test Node.js Installation with Custom Version
# See: specs/feature-node.md#options
# =============================================================================

check "node-installed" node --version
check "npm-installed" npm --version

# Verify specified version (24.x) - from scenarios.json
NODE_VERSION=$(node --version)
check "node-version-24" bash -c "echo $NODE_VERSION | grep '^v24\.'"

# =============================================================================
# Test @antfu/ni Global Package
# See: specs/feature-node.md#installation
# =============================================================================

# ni should be installed globally regardless of Node version
check "ni-installed" bash -l -c "which ni"
check "ni-executable" bash -l -c "ni --version"

# =============================================================================
# Test Environment Variables
# See: specs/feature-node.md#environment-variables
# =============================================================================

# NODE_OPTIONS should be set regardless of Node version
check "node-options-set" bash -c "echo \$NODE_OPTIONS | grep -- '--max-old-space-size=2048'"

# =============================================================================
# Test node_modules Volume
# See: specs/feature-node.md#volumes
# =============================================================================

# node_modules directory should exist and be writable
check "node-modules-dir-exists" test -d /workspace/node_modules
check "node-modules-writable" bash -c "touch /workspace/node_modules/.test && rm /workspace/node_modules/.test"

# Report results
reportResults