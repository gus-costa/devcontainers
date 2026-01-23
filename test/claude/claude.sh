#!/bin/bash
# Claude Feature Test Suite - Scenario Configuration
# Tests the Claude feature with basic setup
# See: specs/feature-claude.md and test/claude/scenarios.json

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# =============================================================================
# Test CLI Installation
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify Claude CLI is installed and accessible
check "claude-cli-installed" which claude

# Verify Claude CLI can execute
check "claude-cli-executable" claude --version

# =============================================================================
# Test Configuration
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify .claude.json exists with expected settings
check "claude-config-exists" test -f /home/dev/.claude.json

# Verify auto-updates enabled
check "claude-config-auto-updates" bash -c "cat /home/dev/.claude.json | grep -q '\"autoUpdates\": true'"

# Verify onboarding completed
check "claude-config-onboarding" bash -c "cat /home/dev/.claude.json | grep -q '\"hasCompletedOnboarding\": true'"

# =============================================================================
# Test Directory Structure
# See: specs/feature-claude.md#mounts
# =============================================================================

# Verify .claude directory exists and is accessible
check "claude-dir-exists" test -d /home/dev/.claude

# Report results
reportResults
