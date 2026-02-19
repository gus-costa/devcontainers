#!/bin/bash
# Git Config Feature Install Script
# Mounts host's .gitconfig and copies it to the container user's home directory.

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
trap 'echo "Error: Git Config feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

# No installation needed - .gitconfig is mounted and copied via postStartCommand
# The postStartCommand in devcontainer-feature.json handles copying the file after container starts
