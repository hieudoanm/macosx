#!/bin/bash
set -e

# --------------------------------------
# Configuration
# --------------------------------------
REPO_RAW_URL="https://raw.githubusercontent.com/hieudoanm/bash/master/dist/full.bash"
INSTALL_DIR="/usr/local/bin"
INSTALL_NAME="full-bash"  # optional global name

# --------------------------------------
# Download full.bash
# --------------------------------------
echo "Downloading full.bash from GitHub..."
if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$REPO_RAW_URL" -o "./full.bash"
elif command -v wget >/dev/null 2>&1; then
    wget -qO "./full.bash" "$REPO_RAW_URL"
else
    echo "Error: curl or wget is required to download files."
    exit 1
fi

# Make executable
chmod +x ./full.bash
echo "full.bash downloaded and made executable."

# --------------------------------------
# Optionally install globally
# --------------------------------------
if [ -w "$INSTALL_DIR" ]; then
    echo "Installing globally to $INSTALL_DIR/$INSTALL_NAME..."
    cp ./full.bash "$INSTALL_DIR/$INSTALL_NAME"
    echo "Installed! You can run '$INSTALL_NAME' from anywhere."
else
    echo "Skipping global install (no write permission to $INSTALL_DIR)."
    echo "You can run it locally: ./full.bash"
fi
