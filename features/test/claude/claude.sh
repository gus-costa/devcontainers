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
check "claude-cli-installed" bash -l -c "which claude"

# Verify Claude CLI can execute
check "claude-cli-executable" bash -l -c "claude --version"

# =============================================================================
# Test Configuration
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify .claude.json exists with expected settings
check "claude-config-exists" test -f /home/dev/.claude.json

# Verify .claude.json ownership is set to dev user
check "claude-config-ownership" bash -c "stat -c '%U' $HOME/.claude.json | grep -q 'dev'"

# Verify auto-compact is disabled
# See: specs/feature-claude.md#installation (optimized settings)
check "claude-config-auto-compact" jq -e '.autoCompactEnabled == false' /home/dev/.claude.json

# Verify onboarding completed
check "claude-config-onboarding" jq -e '.hasCompletedOnboarding == true' /home/dev/.claude.json

# =============================================================================
# Test Directory Structure
# See: specs/feature-claude.md#mounts
# =============================================================================

# Verify .claude directory exists and is accessible
check "claude-dir-exists" test -d /home/dev/.claude

# Verify directory ownership is set to dev user
check "claude-dir-ownership" bash -c "stat -c '%U' /home/dev/.claude | grep 'dev'"

# =============================================================================
# Test Mounts Configuration
# See: specs/feature-claude.md#mounts
# =============================================================================

# Verify the volume mount for persistent data is accessible
# The .claude directory should be writable (volume mount)
check "claude-volume-mount-writable" bash -c "touch /home/dev/.claude/.test-write && rm /home/dev/.claude/.test-write"

# Report results
reportResults
