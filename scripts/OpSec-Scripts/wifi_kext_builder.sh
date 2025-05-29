#!/bin/bash

# Set strict mode
set -euo pipefail

#Download Xcodes
# https://github.com/XcodesOrg/XcodesApp/releases/download/v2.4.1b30/Xcodes.zip
# sudo xcode-select --switch /Applications/Xcode-16.2.0.app
# cp -r /Users/x0r/Developer/Wifi-Intel-KextsBuilder/IntelBluetoothFirmware/build/Release ~/Desktop/IntelBluetoothFirmware-Release \
# && cp -r /Users/x0r/Developer/Wifi-Intel-KextsBuilder/itlwm/build/Release ~/Desktop/itlwm-Release

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'
print_message() {
  echo -e "\${1}"
}
echo -e "${BLUE}Starting Wifi Intel Kexts Builder Installation${NC}"

# Install Homebrew if not present
install_homebrew() {
  print_message "Installing Homebrew..."
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" <<EOF
        yes
EOF

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    print_message "Homebrew already installed"
  fi
}
install_homebrew

# Install mas-cli if not present
if ! command -v mas &>/dev/null; then
  echo -e "${BLUE}Installing Mac App Store CLI...${NC}"
  brew install mas
fi

# Check and install Xcode if needed
install_xcode() {
  if ! xcode-select -p &>/dev/null; then
    echo -e "${YELLOW}Xcode not found. Installing Xcode...${NC}"
    # Open Mac App Store to Xcode page
    mas install 497799835
    echo -e "${YELLOW}Please complete Xcode installation from the App Store${NC}"
    echo -e "${YELLOW}After installation completes, press any key to continue...${NC}"
    read -n 1 -s

    # Install Command Line Tools
    echo -e "${BLUE}Installing Xcode Command Line Tools...${NC}"
    xcode-select --install
    echo -e "${GREEN}Xcode installation completed!${NC}"
  else
    echo -e "${GREEN}Xcode is already installed${NC}"
  fi
}

# Run Xcode installation
install_xcode
install_xcode
# Reinstall Wifi-Intel-KextsBuilder if already installed
if [ -d \"/Applications/Wifi-Intel-KextsBuilder.app\" ]; then
  echo -e \"${BLUE}Wifi-Intel-KextsBuilder is already installed. Uninstalling...${NC}\"
  rm -rf \"/Applications/Wifi-Intel-KextsBuilder.app\"
fi
# Create temp directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download and extract
echo -e "${BLUE}Downloading Wifi Intel Kexts Builder...${NC}"
curl -L "https://github.com/chris1111/Wifi-Intel-KextsBuilder/releases/download/V1/Wifi-Intel-KextsBuilder.zip" -o WifiBuilder.zip
unzip WifiBuilder.zip

# Move to Applications
echo -e "${BLUE}Installing to Applications folder...${NC}"
cp -r "Wifi-Intel-KextsBuilder.app" /Applications/

# Disable Gatekeeper for the app
echo -e "${BLUE}Removing quarantine attribute...${NC}"
if [ -d \"/Applications/Wifi-Intel-KextsBuilder.app\" ]; then
  xattr -rd com.apple.quarantine \"/Applications/Wifi-Intel-KextsBuilder.app\"
else
  echo -e \"${RED}Error: Wifi-Intel-KextsBuilder.app not found in /Applications${NC}\"
fi

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "${GREEN}Installation completed successfully!${NC}"
echo -e "${BLUE}The application is now available in your Applications folder${NC}"
echo -e "${BLUE}Note: If the app doesn't open, allow it in System Settings > Security & Privacy${NC}"
