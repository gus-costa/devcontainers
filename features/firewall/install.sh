#!/bin/bash

set -e

apt-get update
# Networking/Firewall - required for traffic isolation
apt-get install -y --no-install-recommends \
    iptables \
    ipset \
    iproute2 \
    dnsutils
apt-get clean
rm -rf /var/lib/apt/lists/*

cp init-firewall.sh /usr/local/bin/
chmod +x /usr/local/bin/init-firewall.sh

# Passwordless sudo for firewall script only
echo "dev ALL=(root) SETENV: NOPASSWD: /usr/local/bin/init-firewall.sh" >> /etc/sudoers.d/dev-firewall
chmod 0440 /etc/sudoers.d/dev-firewall
