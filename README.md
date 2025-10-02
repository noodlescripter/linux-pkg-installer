# Linux Package Installer for Arch

A comprehensive developer environment setup script for Arch Linux that automates the installation of essential tools, utilities, and development environments.

## Features

- System updates and base utilities installation
- Docker setup with proper user permissions
- Java development environment with SDKMAN, Amazon Corretto JDK, and Maven
- Node.js setup with NVM
- Essential developer tools and utilities

## Quick Install

Run the installer directly with a single command:

```bash
curl -sSL https://raw.githubusercontent.com/noodlescripter/linux-pkg-installer/main/arch_pkg_installer.sh | bash
```

## Manual Installation

If you prefer to review the script before running:

```bash
# Download the script
curl -sSL -o arch_pkg_installer.sh https://raw.githubusercontent.com/noodlescripter/linux-pkg-installer/main/arch_pkg_installer.sh

# Make it executable
chmod +x arch_pkg_installer.sh

# Run it
./arch_pkg_installer.sh
```

## What Gets Installed

### Pacman Packages
- curl
- vim
- zip
- unzip
- git

### AUR Packages (via yay)
- docker
- docker-compose
- google-chrome
- zoom
- lazydocker

### Development Environments
- SDKMAN with Amazon Corretto JDK 21 and Maven 3.9.11
- NVM with Node.js 22.2.0

## Requirements

- Arch Linux or Arch-based distribution
- `sudo` privileges
- Internet connection
- `yay` AUR helper (for AUR packages)

## After Installation

You should close and reopen your terminal after the script completes to ensure all environment variables are properly set.

## Contributing

Feel free to fork this repository and submit pull requests to add more features or improve existing ones.

## License

MIT License