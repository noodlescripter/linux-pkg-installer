#!/bin/bash

# This script automates the installation of a comprehensive developer environment.
# It performs checks for existing installations to avoid re-running unnecessary steps.
# It will exit immediately if any command fails.
set -e

# --- Welcome Message ---
echo "🚀 Starting comprehensive developer tool setup..."
echo ""

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

# --- Docker and Docker Compose ---
echo "--> Step 3: Setting up Docker and Docker Compose..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing Docker Engine..."
    
    # 1. Uninstall any old or conflicting packages
    echo "Removing any old Docker-related packages..."
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
        sudo apt-get remove -y $pkg || true # '|| true' ignores errors if a package isn't installed
    done

    # 2. Set up Docker's official GPG key and repository
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 3. Install the Docker packages
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
    echo "✅ Docker Engine installed."
else
    echo "✅ Docker is already installed. Skipping installation."
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose not found. Installing now..."
    # NOTE: Your requested v2.39.2 does not exist. Using a recent stable version.
    COMPOSE_VERSION="v2.27.0"
    sudo curl -SL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose installed."
else
    echo "✅ Docker Compose is already installed. Skipping installation."
fi
echo "✅ Docker setup complete."
echo ""

# --- Final Message ---
echo "🎉 All developer tools have been set up!"
echo "💡 IMPORTANT: To run Docker commands without 'sudo', add your user to the 'docker' group:"
echo "   sudo usermod -aG docker \$USER"
echo "After running the command above, you must LOG OUT and LOG BACK IN for the change to take effect."
echo "For all other tools, simply close and reopen your terminal."

exit 0