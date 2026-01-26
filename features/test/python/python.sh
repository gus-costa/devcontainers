#!/bin/bash
# Python Feature Test Suite - Version Scenario
# Tests the Python feature with version option set to 3.13
# See: specs/feature-python.md and test/python/scenarios.json

set -e

# Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# =============================================================================
# Test Python Installation with Custom Version
# See: specs/feature-python.md#options
# =============================================================================

check "python-installed" python --version
check "python3-installed" python3 --version

# Verify specified version (3.13.x) - from scenarios.json
PYTHON_VERSION=$(python --version)
check "python-version-3.13" bash -c "echo $PYTHON_VERSION | grep '^Python 3\.13\.'"

# =============================================================================
# Test uv Package Manager
# See: specs/feature-python.md#installation
# =============================================================================

# uv should be installed regardless of Python version
check "uv-installed" which uv
check "uv-executable" uv --version

# =============================================================================
# Test Python as Default
# See: specs/feature-python.md#installation
# =============================================================================

# Verify that the specified version is set as default
check "python-is-default" bash -c "which python"
check "python-matches-python3" bash -c "python --version | grep -q '3\.13' && python3 --version | grep -q '3\.13'"

# =============================================================================
# Test uv Functionality
# =============================================================================

# Test that uv can list installed Python versions
check "uv-python-list" uv python list

# Verify the installed Python version is listed
check "uv-python-installed" bash -c "uv python list | grep -q '3\.13'"

# Report results
reportResults