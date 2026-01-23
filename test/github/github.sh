#!/bin/bash
# GitHub Feature Test Suite - Scenario Configuration
# Tests the GitHub CLI feature with basic setup
# See: specs/feature-github.md and test/github/scenarios.json

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# =============================================================================
# Test CLI Installation
# See: specs/feature-github.md#installation
# =============================================================================

# Verify GitHub CLI is installed and accessible
check "gh-cli-installed" which gh

# Verify GitHub CLI can execute
check "gh-cli-executable" gh --version

# =============================================================================
# Test Repository Configuration
# See: specs/feature-github.md#installation
# =============================================================================

# Verify GPG key and apt repository are configured
check "gh-gpg-key-exists" test -f /etc/apt/keyrings/githubcli-archive-keyring.gpg
check "gh-apt-repo-exists" test -f /etc/apt/sources.list.d/github-cli.list

# Report results
reportResults
