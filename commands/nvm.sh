#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Helper to load NVM into the current shell session
load_nvm() {
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        # shellcheck source=/dev/null
        \. "$NVM_DIR/nvm.sh"
        # shellcheck source=/dev/null
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    else
        echo -e "${red}NVM is not installed or not found in $NVM_DIR${reset}"
        return 1
    fi
}

function nvm_menu() {
  while true; do
    clear
    echo -e "${green}===== NVM & NODE.JS MANAGEMENT =====${reset}"
    local options=(
      "Back to Main Menu"
      "Install NVM (Latest)"
      "Update NVM"
      "Uninstall NVM"
      "Install Node.js (LTS)"
      "Install Node.js (Latest Stable)"
      "Install Specific Node.js Version"
      "Switch Node.js Version"
      "List Installed Node.js Versions"
      "List Available Node.js Versions (Remote)"
      "Uninstall Specific Node.js Version"
      "Show Current Node & NPM Version"
    )

    PS3="Choose an NVM/Node.js option: "
    select opt in "${options[@]}"; do
      case $REPLY in
        1) return ;;
        2)
          echo "Installing NVM..."
          curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
          echo "✅ NVM installed. Please restart your terminal or source your profile to use it globally."
          load_nvm
          read -rp "Press Enter to continue..."
          break
          ;;
        3)
          echo "Updating NVM..."
          curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
          load_nvm
          echo "✅ NVM updated."
          read -rp "Press Enter to continue..."
          break
          ;;
        4)
          echo -e "${red}WARNING: This will remove NVM and all installed Node.js versions.${reset}"
          read -rp "Are you sure? (y/n): " confirm
          if [[ $confirm == [yY] ]]; then
            rm -rf "$HOME/.nvm"
            sed -i '/export NVM_DIR/d' "$HOME/.bashrc"
            sed -i '/\[ -s "$NVM_DIR\/nvm.sh" \]/d' "$HOME/.bashrc"
            sed -i '/\[ -s "$NVM_DIR\/bash_completion" \]/d' "$HOME/.bashrc"
            echo "✅ NVM uninstalled. Please restart your terminal."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        5)
          if load_nvm; then
            nvm install --lts
            nvm alias default 'lts/*'
            echo "✅ Node.js LTS installed and set as default."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        6)
          if load_nvm; then
            nvm install node
            nvm alias default node
            echo "✅ Latest stable Node.js installed and set as default."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        7)
          if load_nvm; then
            read -rp "Enter Node.js version to install (e.g., 20.10.0): " version
            nvm install "$version"
            echo "✅ Node.js $version installed."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        8)
          if load_nvm; then
            echo "Installed versions:"
            nvm ls
            read -rp "Enter version to use: " version
            nvm use "$version"
            nvm alias default "$version"
            echo "✅ Switched to Node.js $version and set as default."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        9)
          if load_nvm; then
            nvm ls
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        10)
          if load_nvm; then
            nvm ls-remote | tail -n 20
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        11)
          if load_nvm; then
            nvm ls
            read -rp "Enter Node.js version to uninstall: " version
            nvm uninstall "$version"
            echo "✅ Node.js $version uninstalled."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        12)
          if load_nvm; then
            echo -n "Node version: "
            node -v
            echo -n "NPM version:  "
            npm -v
            echo -n "NVM version:  "
            nvm --version
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        *)
          echo -e "${red}Invalid option${reset}"
          break
          ;;
      esac
    done
  done
}

nvm_menu
