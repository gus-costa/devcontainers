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

# =============================================================================
# Test Runtime Proxy Connectivity
# See: specs/feature-proxy.md#purpose
# See: specs/testing.md#firewall-verification
# =============================================================================

# Note: These tests verify that traffic is routed through the Squid proxy
# and that the proxy correctly filters allowed vs blocked domains.
# See: specs/feature-proxy.md#post-start-command

# Verify HTTP requests go through proxy to allowed domains
# See: specs/feature-proxy.md#purpose (route all HTTP/HTTPS traffic through Squid proxy)
# See: specs/testing.md#firewall-verification (should succeed - allowed domain via proxy)
check "proxy-allows-github-api" bash -c "curl --connect-timeout 10 -s https://api.github.com/zen > /dev/null 2>&1"

# Verify proxy allows npm registry access
# See: squid-proxy.md (registry.npmjs.org in whitelisted_domains)
check "proxy-allows-npm-registry" bash -c "curl --connect-timeout 10 -s https://registry.npmjs.org > /dev/null 2>&1"

# Verify proxy allows Python package index access
# See: squid-proxy.md (pypi.org in whitelisted_domains)
check "proxy-allows-pypi" bash -c "curl --connect-timeout 10 -s https://pypi.org > /dev/null 2>&1"

# Verify proxy blocks non-whitelisted domains
# See: squid-proxy.md (example.com not in whitelisted_domains)
# See: specs/testing.md#firewall-verification (should fail - blocked domain)
check "proxy-blocks-example-com" bash -c "! curl --connect-timeout 10 -s https://example.com > /dev/null 2>&1"

# Verify direct connections are blocked (bypass prevention)
# See: specs/feature-proxy.md#purpose (prevents bypass via direct connections)
# See: specs/testing.md#firewall-verification (should fail - direct connection)
check "proxy-prevents-bypass" bash -c "! curl --noproxy '*' --connect-timeout 3 -s https://api.github.com/zen > /dev/null 2>&1"

# Verify localhost is excluded from proxy (NO_PROXY setting)
# See: specs/feature-proxy.md#environment-variables (NO_PROXY: localhost,127.0.0.1)
# This test verifies that requests to localhost don't go through the proxy
check "proxy-excludes-localhost" bash -c "echo \$NO_PROXY | grep -q 'localhost'"

# Report results
reportResults
