#!/bin/bash
# Claude Feature Test Suite - Default Configuration
# Tests the Claude feature with default options
# See: specs/feature-claude.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test CLI Installation
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify Claude CLI is installed
check "claude-cli-installed" test -x $HOME/.local/bin/claude

# =============================================================================
# Test Configuration Directory
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify .claude directory exists in user's home
check "claude-dir-exists" test -d $HOME/.claude


# =============================================================================
# Test Configuration File
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify .claude.json exists
check "claude-config-exists" test -f $HOME/.claude.json

# Report results
reportResults
