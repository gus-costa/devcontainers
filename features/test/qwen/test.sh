#!/bin/bash
# Qwen Feature Test Suite - Default Configuration
# Tests the Qwen feature with default options

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test CLI Installation
# =============================================================================

# Verify Qwen CLI is installed via npm global
check "qwen-cli-installed" npm list -g @qwen-code/qwen-code

# =============================================================================
# Test Configuration Directory
# =============================================================================

# Verify .qwen directory exists in user's home
check "qwen-dir-exists" test -d $HOME/.qwen

# Report results
reportResults
