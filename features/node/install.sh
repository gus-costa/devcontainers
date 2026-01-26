#!/bin/bash
# Node.js Feature Install Script
# Installs Node.js runtime using NodeSource binaries.
# See: specs/feature-node.md

set -e

# Error handler to provide context when installation fails
# Displays feature name, failed line number, and command for easier debugging
# See: specs/feature-node.md for installation details
trap 'echo "Error: Node feature installation failed at line $LINENO: $BASH_COMMAND" >&2; exit 1' ERR

# Function to get the latest Node.js version for a specific major or major.minor release
# Usage: get_nodejs_version <major> or get_nodejs_version <major.minor>
# Example: get_nodejs_version 20
# Example: get_nodejs_version 20.11

get_nodejs_version() {
    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        echo "Error: jq is required but not installed." >&2
        echo "Install it with: sudo apt-get install jq" >&2
        return 1
    fi

    # Check arguments
    if [ $# -eq 0 ]; then
        echo "Usage: get_nodejs_version <major> or get_nodejs_version <major.minor>" >&2
        echo "Example: get_nodejs_version 20" >&2
        echo "Example: get_nodejs_version 20.11" >&2
        return 1
    fi

    local VERSION_PREFIX="$1"

    # Validate input format (should be number or number.number)
    if ! [[ "$VERSION_PREFIX" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "Error: Invalid version format. Use major (e.g., 20) or major.minor (e.g., 20.11)" >&2
        return 1
    fi

    # Fetch the release index
    local RELEASE_URL="https://nodejs.org/download/release/index.json"
    echo "Fetching release index from $RELEASE_URL..." >&2

    # Download and parse JSON to find the latest matching version
    local LATEST_VERSION=$(curl -s "$RELEASE_URL" | jq -r --arg prefix "v$VERSION_PREFIX" '
        map(select(.version | startswith($prefix)))
        | sort_by(.version | split(".") | [.[]|ltrimstr("v")] | map(tonumber))
        | reverse
        | .[0].version
    ')

    # Check if a version was found
    if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" = "null" ]; then
        echo "Error: No version found matching '$VERSION_PREFIX'" >&2
        return 1
    fi

    # Output the version (without the 'v' prefix for pure semver)
    echo "${LATEST_VERSION#v}"
}

# Feature option: Node.js major version (default: 22)
VERSION="${VERSION:-22}"

SEMVER=$(get_nodejs_version $VERSION)

FILENAME=node-v${SEMVER}-linux-x64.tar.gz

echo "Installing Node.js ${SEMVER}..."

# Create temporary directory for installation files
# See: specs/feature-node.md#installation
TMP_DIR=/tmp/node-install
mkdir -p $TMP_DIR
cd $TMP_DIR
curl -fsO "https://nodejs.org/download/release/v${SEMVER}/${FILENAME}"
curl -fsLo "nodejs-keyring.kbx" "https://github.com/nodejs/release-keys/raw/HEAD/gpg/pubring.kbx"
curl -fsO "https://nodejs.org/dist/v${SEMVER}/SHASUMS256.txt.asc" \
    && gpgv --keyring="./nodejs-keyring.kbx" --output SHASUMS256.txt < SHASUMS256.txt.asc \
    && shasum --check SHASUMS256.txt --ignore-missing
mkdir node
tar -xf $FILENAME -C ./node --strip-components 1
cp -r ./node/{lib,share,include,bin} /usr

# Clean up temporary directory
# See: specs/feature-node.md#installation
cd /
rm -rf $TMP_DIR

# Install @antfu/ni as dev user
# Note: Using 'su -' for login shell to ensure full environment initialization
su - ${_REMOTE_USER} -c "npm config set prefix ~/.local && npm install -g @antfu/ni"

mkdir -p /workspace/node_modules
chown -R ${_REMOTE_USER}:${_REMOTE_USER} /workspace

# Verify installation
echo "Node.js $(node --version) installed successfully"
echo "npm $(npm --version) installed successfully"
