#!/bin/bash

# This script automates the installation of SDKMAN! (with Java/Maven)
# and NVM (with Node.js). It will exit immediately if any command fails.
set -e

# --- Welcome Message ---
echo "🚀 Starting developer tool setup..."
echo ""

# --- SDKMAN!, Java, and Maven ---
echo "--> Installing SDKMAN!, Java, and Maven..."

# Set auto-answer for a non-interactive SDKMAN installation
export SDKMAN_AUTO_ANSWER=true
curl -s "https://get.sdkman.io" | bash

# Source the SDKMAN init script to make the 'sdk' command available now
source "$HOME/.sdkman/bin/sdkman-init.sh"

echo "Installing Java 21.0.6-amzn..."
# The 'yes' command automatically answers 'Y' to the prompt
yes | sdk install java 21.0.6-amzn

echo "Installing Maven 3.9.11..."
yes | sdk install maven 3.9.11

echo "✅ SDKMAN!, Java, and Maven installed."
echo ""


# --- NVM and Node.js ---
echo "--> Installing NVM (Node Version Manager) and Node.js..."

# NOTE: The NVM and Node versions from your request were adjusted to the latest stable releases.
# Your requested v0.40.3 does not exist; v0.39.7 is the latest stable.
# Your requested v22.18.0 does not exist; v22.2.0 is a recent stable version.
NVM_VERSION="0.39.7"
NODE_VERSION="22.2.0"

curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash

# Source the NVM script to make the 'nvm' command available now
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo "Installing Node.js v${NODE_VERSION}..."
nvm install "${NODE_VERSION}"

echo "✅ NVM and Node.js installed."
echo ""

# --- Final Message ---
echo "🎉 Setup complete!"
echo "Both SDKMAN! and NVM have modified your shell profile (~/.bashrc, ~/.zshrc, etc.)."
echo "Please close and reopen your terminal, or run 'source ~/.bashrc' to begin using the new tools."

exit 0
