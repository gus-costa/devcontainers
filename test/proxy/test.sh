#!/bin/bash
# Proxy Feature Test Suite - Default Configuration
# Tests the Proxy feature environment variable configuration
# See: specs/feature-proxy.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test Proxy Environment Variables
# See: specs/feature-proxy.md#environment-variables
# =============================================================================

# Verify HTTP_PROXY (uppercase) is set
# See: specs/feature-proxy.md#environment-variables
check "http-proxy-uppercase-set" bash -c "echo \$HTTP_PROXY | grep -q 'http://squid:3128'"

# Verify http_proxy (lowercase) is set
# See: specs/feature-proxy.md#environment-variables
check "http-proxy-lowercase-set" bash -c "echo \$http_proxy | grep -q 'http://squid:3128'"

# Verify HTTPS_PROXY (uppercase) is set
# See: specs/feature-proxy.md#environment-variables
check "https-proxy-uppercase-set" bash -c "echo \$HTTPS_PROXY | grep -q 'http://squid:3128'"

# Verify https_proxy (lowercase) is set
# See: specs/feature-proxy.md#environment-variables
check "https-proxy-lowercase-set" bash -c "echo \$https_proxy | grep -q 'http://squid:3128'"

# Verify NO_PROXY (uppercase) is set
# See: specs/feature-proxy.md#environment-variables
check "no-proxy-uppercase-set" bash -c "echo \$NO_PROXY | grep -q 'localhost,127.0.0.1'"

# Verify no_proxy (lowercase) is set
# See: specs/feature-proxy.md#environment-variables
check "no-proxy-lowercase-set" bash -c "echo \$no_proxy | grep -q 'localhost,127.0.0.1'"

# =============================================================================
# Test Proxy Configuration Values
# See: specs/feature-proxy.md#environment-variables
# =============================================================================

# Verify proxy points to squid on port 3128
# See: specs/feature-proxy.md#environment-variables (http://squid:3128)
check "proxy-host-is-squid" bash -c "echo \$HTTP_PROXY | grep -q 'squid:3128'"

# Verify NO_PROXY excludes localhost
# See: specs/feature-proxy.md#environment-variables
check "no-proxy-includes-localhost" bash -c "echo \$NO_PROXY | grep -q 'localhost'"

# Verify NO_PROXY excludes 127.0.0.1
# See: specs/feature-proxy.md#environment-variables
check "no-proxy-includes-127-0-0-1" bash -c "echo \$NO_PROXY | grep -q '127.0.0.1'"

# =============================================================================
# Test Firewall Feature Dependency
# See: specs/feature-proxy.md#dependencies
# =============================================================================

# Verify firewall feature is installed (required dependency)
# See: specs/feature-proxy.md#dependencies
check "firewall-feature-installed" test -f /usr/local/bin/init-firewall.sh

# Verify firewall packages are available (indicates firewall feature worked)
# See: specs/feature-proxy.md#dependencies
check "iptables-available" which iptables

# Report results
reportResults
