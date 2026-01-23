#!/bin/bash
# GitHub Feature Test Suite - Default Configuration
# Tests the GitHub CLI feature with default options
# See: specs/feature-github.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test CLI Installation
# See: specs/feature-github.md#installation
# =============================================================================

# Verify GitHub CLI is installed and accessible
check "gh-cli-installed" which gh

# Verify GitHub CLI can execute (basic version check)
check "gh-cli-executable" gh --version

# Verify gh package is installed via apt
check "gh-package-installed" dpkg -l | grep -q "^ii.*gh "

# =============================================================================
# Test Repository Configuration
# See: specs/feature-github.md#installation
# =============================================================================

# Verify GitHub CLI GPG key exists
# See: specs/feature-github.md#installation (step 1)
check "gh-gpg-key-exists" test -f /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Verify GPG key has correct permissions
check "gh-gpg-key-readable" bash -c "stat -c '%a' /etc/apt/keyrings/githubcli-archive-keyring.gpg | grep -qE '^64[0-9]$'"

# Verify GitHub CLI apt repository is configured
# See: specs/feature-github.md#installation (step 2)
check "gh-apt-repo-exists" test -f /etc/apt/sources.list.d/github-cli.list

# Verify apt repository contains correct source
check "gh-apt-repo-content" cat /etc/apt/sources.list.d/github-cli.list | grep -q "cli.github.com/packages"

# Report results
reportResults
