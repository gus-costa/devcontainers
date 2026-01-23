#!/bin/bash
# Python Feature Test Suite - Default Configuration
# Tests the Python feature with default options (version 3.12)
# See: specs/feature-python.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test Python Installation
# See: specs/feature-python.md#installation
# =============================================================================

check "python-installed" python --version
check "python3-installed" python3 --version

# Verify default version (3.12.x)
# See: specs/feature-python.md#options
PYTHON_VERSION=$(python --version)
check "python-version-3.12" bash -c "echo $PYTHON_VERSION | grep '^Python 3\.12\.'"

# =============================================================================
# Test uv Package Manager
# See: specs/feature-python.md#installation
# =============================================================================

# uv should be installed via official installer script
check "uv-installed" which uv
check "uv-executable" uv --version

# =============================================================================
# Test Python as Default
# See: specs/feature-python.md#installation
# =============================================================================

# Verify that 'python' command points to the correct version
# uv python install --default should set this up
check "python-is-default" bash -c "which python"
check "python-matches-python3" bash -c "python --version | grep -q '3\.12' && python3 --version | grep -q '3\.12'"

# =============================================================================
# Test uv Functionality
# =============================================================================

# Test that uv can list installed Python versions
check "uv-python-list" uv python list

# Verify the installed Python version is listed
check "uv-python-installed" bash -c "uv python list | grep -q '3\.12'"

# Test that uv can show Python information
check "uv-python-find" uv python find

# Report results
reportResults