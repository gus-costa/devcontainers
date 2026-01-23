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

# Verify Claude CLI is installed and accessible
check "claude-cli-installed" which claude

# Verify Claude CLI can execute (basic version check)
check "claude-cli-executable" claude --version

# =============================================================================
# Test Configuration Directory
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify .claude directory exists in user's home
check "claude-dir-exists" test -d /home/dev/.claude

# Verify directory ownership is set to dev user
check "claude-dir-ownership" bash -c "stat -c '%U' /home/dev/.claude | grep -q 'dev'"

# =============================================================================
# Test Configuration File
# See: specs/feature-claude.md#installation
# =============================================================================

# Verify .claude.json exists
check "claude-config-exists" test -f /home/dev/.claude.json

# Verify .claude.json ownership is set to dev user
check "claude-config-ownership" bash -c "stat -c '%U' /home/dev/.claude.json | grep -q 'dev'"

# Verify auto-updates are enabled
# See: specs/feature-claude.md#installation (optimized settings)
check "claude-config-auto-updates" bash -c "cat /home/dev/.claude.json | grep -q '\"autoUpdates\": true'"

# Verify auto-compact is disabled
# See: specs/feature-claude.md#installation (optimized settings)
check "claude-config-auto-compact" bash -c "cat /home/dev/.claude.json | grep -q '\"autoCompactEnabled\": false'"

# Verify onboarding is marked as completed
# See: specs/feature-claude.md#installation (optimized settings)
check "claude-config-onboarding" bash -c "cat /home/dev/.claude.json | grep -q '\"hasCompletedOnboarding\": true'"

# =============================================================================
# Test Mounts Configuration
# See: specs/feature-claude.md#mounts
# =============================================================================

# Verify the volume mount for persistent data is accessible
# The .claude directory should be writable (volume mount)
check "claude-volume-mount-writable" bash -c "touch /home/dev/.claude/.test-write && rm /home/dev/.claude/.test-write"

# Report results
reportResults
