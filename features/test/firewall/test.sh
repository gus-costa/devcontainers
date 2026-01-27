#!/bin/bash
# Firewall Feature Test Suite - Default Configuration
# Tests the Firewall feature installation and configuration
# See: specs/feature-firewall.md

set -e

# Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

# =============================================================================
# Test Package Installation
# See: specs/feature-firewall.md#installation
# =============================================================================

# Verify iptables package is installed
# See: specs/feature-firewall.md#installation (iptables)
check "iptables-package-installed" dpkg -l | grep -q "^ii.*iptables "

# Verify iptables command is available
check "iptables-command-available" which iptables

# Verify ipset package is installed
# See: specs/feature-firewall.md#installation (ipset)
check "ipset-package-installed" dpkg -l | grep -q "^ii.*ipset "

# Verify ipset command is available
check "ipset-command-available" which ipset

# Verify iproute2 package is installed
# See: specs/feature-firewall.md#installation (iproute2)
check "iproute2-package-installed" dpkg -l | grep -q "^ii.*iproute2 "

# Verify ip command is available (from iproute2)
check "ip-command-available" which ip

# Verify dnsutils package is installed
# See: specs/feature-firewall.md#installation (dnsutils)
check "dnsutils-package-installed" dpkg -l | grep -q "^ii.*dnsutils "

# Verify getent command is available (from dnsutils)
check "getent-command-available" which getent

# =============================================================================
# Test Firewall Script Installation
# See: specs/feature-firewall.md#installation
# =============================================================================

# Verify init-firewall.sh is copied to /usr/local/bin/
# See: specs/feature-firewall.md#installation
check "init-firewall-script-exists" test -f /usr/local/bin/init-firewall.sh

# Verify init-firewall.sh has executable permissions
# See: specs/feature-firewall.md#installation
check "init-firewall-script-executable" test -x /usr/local/bin/init-firewall.sh

# Verify init-firewall.sh contains expected configuration
# See: specs/feature-firewall.md#firewall-initialization
check "init-firewall-script-has-squid-config" grep -q "SQUID_HOST" /usr/local/bin/init-firewall.sh

# =============================================================================
# Test Sudoers Configuration
# See: specs/feature-firewall.md#installation
# =============================================================================

# Verify sudoers file exists for dev user
# See: specs/feature-firewall.md#installation
check "sudoers-file-exists" test -f /etc/sudoers.d/$(whoami)-firewall

# Verify sudoers file has correct permissions (0440)
# See: specs/feature-firewall.md#installation
check "sudoers-file-permissions" bash -c "stat -c '%a' /etc/sudoers.d/$(whoami)-firewall | grep -q '^440$'"

# Verify sudoers file contains dev user entry
# See: specs/feature-firewall.md#installation
check "sudoers-dev-user-entry" grep -q "^$(whoami) ALL=(root) SETENV: NOPASSWD: /usr/local/bin/init-firewall.sh" /etc/sudoers.d/$(whoami)-firewall

# Verify sudoers file allows init-firewall.sh script only
# See: specs/feature-firewall.md#installation (passwordless sudo for firewall script only)
check "sudoers-restricts-to-init-firewall" grep -q "/usr/local/bin/init-firewall.sh" /etc/sudoers.d/$(whoami)-firewall

# =============================================================================
# Test Runtime Firewall Behavior
# See: specs/feature-firewall.md#verification
# See: specs/testing.md#firewall-verification
# =============================================================================

# Note: These tests assume the firewall has been initialized via postStartCommand
# from the proxy feature. See: specs/feature-proxy.md#post-start-command

# Verify direct connections are blocked (firewall DROP policy)
# See: specs/feature-firewall.md#verification (should fail - direct connection)
# See: specs/testing.md#firewall-verification (should fail - direct connection)
check "firewall-blocks-direct-connection" bash -c "! curl --noproxy '*' --connect-timeout 3 -s https://api.github.com/zen > /dev/null 2>&1"

# Verify connections through proxy work for allowed domains
# See: specs/feature-firewall.md#verification (should succeed - via proxy)
# See: specs/testing.md#firewall-verification (should succeed - allowed domain via proxy)
check "firewall-allows-proxy-connection" bash -c "curl --connect-timeout 10 -s https://api.github.com/zen > /dev/null 2>&1"

# Verify blocked domains are rejected by Squid proxy
# See: specs/testing.md#firewall-verification (should fail - blocked domain)
# See: squid-proxy.md (example.com not in whitelisted_domains)
check "proxy-blocks-non-whitelisted-domain" bash -c "! curl --connect-timeout 10 -s https://example.com > /dev/null 2>&1"

# Verify firewall allows communication with Squid proxy only
# See: specs/feature-firewall.md#firewall-initialization (step 7 - Allows Squid Proxy)
# This test verifies iptables has a rule allowing traffic to squid on port 3128
check "firewall-allows-squid-only" bash -c "iptables -L OUTPUT -n | grep -q 'tcp dpt:3128'"

# Report results
reportResults
