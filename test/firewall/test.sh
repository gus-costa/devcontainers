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
check "sudoers-file-exists" test -f /etc/sudoers.d/dev-firewall

# Verify sudoers file has correct permissions (0440)
# See: specs/feature-firewall.md#installation
check "sudoers-file-permissions" bash -c "stat -c '%a' /etc/sudoers.d/dev-firewall | grep -q '^440$'"

# Verify sudoers file contains dev user entry
# See: specs/feature-firewall.md#installation
check "sudoers-dev-user-entry" grep -q "^dev ALL=(root) SETENV: NOPASSWD: /usr/local/bin/init-firewall.sh" /etc/sudoers.d/dev-firewall

# Verify sudoers file allows init-firewall.sh script only
# See: specs/feature-firewall.md#installation (passwordless sudo for firewall script only)
check "sudoers-restricts-to-init-firewall" grep -q "/usr/local/bin/init-firewall.sh" /etc/sudoers.d/dev-firewall

# Report results
reportResults
