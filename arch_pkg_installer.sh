#!/bin/bash

# This script automates the installation of a comprehensive developer environment on Arch Linux.
# It performs checks for existing installations to avoid re-running unnecessary steps.
# It will exit immediately if any command fails.
set -e

# --- Welcome Message ---
echo "🚀 Starting comprehensive developer tool setup for Arch Linux..."
echo ""

# --- System Updates ---
echo "--> Step 0: Updating the system..."
sudo pacman -Syu --noconfirm
echo "✅ System update complete."
echo ""

echo "--> Installing base utilities..."
base_packages_pacman=(
    "curl" 
    "vim" 
    "zip"
    "unzip"
)

for pacman_pkg in "${base_packages_pacman[@]}"; do
    echo "Installing $pacman_pkg.."
    sudo pacman -S "$pacman_pkg" --noconfirm
done

echo "--> Base util using pacman done!"
echo ""
echo "--> Installing base utilities..."
base_packages_yay=(
    "docker"
    "docker-compose"
    "google-chrome"
    "zoom"
    "lazydocker"
)

for yay_pkg in "${base_packages_yay[@]}"; do
    echo "Installing $yay_pkg.."
    yay -S "$yay_pkg" --noconfirm
done
echo "--> Base util using yay done!"
echo ""

echo "--> Starting docker"
sudo systemctl enable docker.service

echo ""
sudo systemctl start docker.service

echo "--> creating docker group and assign user"
sudo usermod -aG docker $USER

newgrp docker
echo "Done!"

# --- SDKMAN!, Java, and Maven ---
echo "--> Step 1: Setting up SDKMAN!, Java, and Maven..."

JAVA_VERSION="21.0.6-amzn"
MAVEN_VERSION="3.9.11"

# Check if SDKMAN is installed by looking for the 'sdk' command
if ! command -v sdk &> /dev/null; then
    echo "SDKMAN not found. Installing now..."
    export SDKMAN_AUTO_ANSWER=true
    curl -s "https://get.sdkman.io" | bash
    # Source SDKMAN for the current script session
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    echo "✅ SDKMAN installed."
else
    echo "✅ SDKMAN is already installed. Sourcing for this session..."
    source "$HOME/.sdkman/bin/sdkman-init.sh"
fi

# Explicitly check if the specific Java version is already installed
if sdk list java | grep "$JAVA_VERSION" | grep -q 'installed'; then
    echo "✅ Java ${JAVA_VERSION} is already installed."
else
    echo "Installing Java ${JAVA_VERSION}..."
    sdk install java "$JAVA_VERSION"
fi

# Explicitly check if the specific Maven version is already installed
if sdk list maven | grep "$MAVEN_VERSION" | grep -q 'installed'; then
    echo "✅ Maven ${MAVEN_VERSION} is already installed."
else
    echo "Installing Maven ${MAVEN_VERSION}..."
    sdk install maven "$MAVEN_VERSION"
fi
echo "✅ Java and Maven setup complete."
echo ""

# --- NVM and Node.js ---
echo "--> Step 2: Setting up NVM and Node.js..."

# NOTE: Versions were adjusted to recent, valid releases.
NVM_VERSION="0.39.7"
NODE_VERSION="22.2.0"

# Source NVM if it's already installed, otherwise install it
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    echo "✅ NVM is already installed. Sourcing for this session..."
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
else
    echo "NVM not found. Installing NVM v${NVM_VERSION}..."
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
fi

# Check if the specific node version is installed
if nvm ls "$NODE_VERSION" &> /dev/null; then
    echo "✅ Node.js v${NODE_VERSION} is already installed."
else
    echo "Installing Node.js v${NODE_VERSION}..."
    nvm install "$NODE_VERSION"
fi
echo "✅ NVM and Node.js setup complete."
echo ""

# --- Final Message ---
echo "🎉 All developer tools have been set up!"
echo "For all tools, you should close and reopen your terminal after the script has finished."

exit 0
