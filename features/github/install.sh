#!/bin/bash
# GitHub Feature Install Script
# Installs GitHub CLI (gh) from official apt repository.
# See: specs/feature-github.md

set -e

echo "Installing GitHub CLI..."

# Add GitHub CLI GPG key
# See: specs/feature-github.md#installation
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg

# Add GitHub CLI apt repository
# See: specs/feature-github.md#installation
mkdir -p -m 755 /etc/apt/sources.list.d
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Install gh package
# See: specs/feature-github.md#installation
apt-get update
apt-get install gh -y
apt-get clean
rm -rf /var/lib/apt/lists/*