#!/bin/bash
# Firewall Initialization Script
# See: specs/base-template.md#firewall-script
#
# Purpose: Enforce network isolation by blocking all outbound traffic except
# to the Squid proxy. This prevents bypass via direct connections or tools
# that ignore proxy settings.
#
# Security Model: See specs/architecture.md#security-model

set -e

# =============================================================================
# Configuration
# =============================================================================

SQUID_HOST="squid"
SQUID_PORT="3128"
TEST_DOMAIN="github.com"

echo "=== Initializing Firewall ==="

# =============================================================================
# Step 1: Flush Existing Rules
# Preserves Docker DNS functionality
# =============================================================================

echo "Flushing existing iptables rules..."
iptables -F OUTPUT
iptables -F INPUT

# =============================================================================
# Step 2: Set Default Policy to DROP
# All traffic blocked by default
# =============================================================================

echo "Setting default OUTPUT policy to DROP..."
iptables -P OUTPUT DROP

# =============================================================================
# Step 3: Allow Loopback Traffic
# Required for local services
# =============================================================================

echo "Allowing loopback traffic..."
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT

# =============================================================================
# Step 4: Allow Established Connections
# Required for response packets
# =============================================================================

echo "Allowing established connections..."
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# =============================================================================
# Step 5: Allow DNS Resolution
# Required to resolve squid hostname
# =============================================================================

echo "Allowing DNS resolution..."
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT

# =============================================================================
# Step 6: Resolve Squid IP and Allow Connections
# Only traffic to Squid proxy is permitted
# =============================================================================

echo "Resolving Squid proxy IP..."
SQUID_IP=$(getent hosts ${SQUID_HOST} | awk '{ print $1 }')

if [ -z "$SQUID_IP" ]; then
    echo "ERROR: Could not resolve Squid host '${SQUID_HOST}'"
    echo "Make sure the Squid proxy container is running:"
    echo "  docker compose -f squid/docker-compose.yml up -d"
    exit 1
fi

echo "Squid IP: ${SQUID_IP}"
echo "Allowing connections to Squid proxy..."
iptables -A OUTPUT -p tcp -d ${SQUID_IP} --dport ${SQUID_PORT} -j ACCEPT

# =============================================================================
# Step 7: Verify Firewall Configuration
# =============================================================================

echo ""
echo "=== Verifying Firewall Configuration ==="

# Test 1: Direct connection should be blocked
echo -n "Testing direct connection (should fail)... "
if curl --noproxy '*' --connect-timeout 3 -s "https://${TEST_DOMAIN}" > /dev/null 2>&1; then
    echo "FAILED - Direct connections are NOT blocked!"
    exit 1
else
    echo "OK (blocked as expected)"
fi

# Test 2: Proxy connection should work
echo -n "Testing proxy connection (should succeed)... "
if curl --connect-timeout 10 -s "https://${TEST_DOMAIN}" > /dev/null 2>&1; then
    echo "OK"
else
    echo "FAILED - Proxy connections are not working!"
    echo "Check Squid proxy logs: docker logs devcontainer-squid"
    exit 1
fi

echo ""
echo "=== Firewall Initialized Successfully ==="
echo "All outbound traffic is now routed through Squid proxy at ${SQUID_IP}:${SQUID_PORT}"
