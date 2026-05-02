#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Helper to load NVM into the current shell session
load_nvm() {
    # Check for global installation first, then local
    if [ -d "/usr/local/nvm" ]; then
        export NVM_DIR="/usr/local/nvm"
    else
        export NVM_DIR="$HOME/.nvm"
    fi

    if [ -s "$NVM_DIR/nvm.sh" ]; then
        # shellcheck source=/dev/null
        \. "$NVM_DIR/nvm.sh"
        # shellcheck source=/dev/null
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        return 0
    else
        return 1
    fi
}

function nvm_menu() {
  while true; do
    clear
    echo -e "${green}===== NVM & NODE.JS MANAGEMENT =====${reset}"
    
    # Check current NVM status
    if load_nvm; then
        echo -e "Status: ${green}NVM Loaded${reset} ($NVM_DIR)"
    else
        echo -e "Status: ${red}NVM Not Found${reset}"
    fi
    echo ""

    local options=(
      "Back to Main Menu"
      "Install NVM Local (Current User)"
      "Install NVM Global (All Users - Sudo Required)"
      "Update NVM"
      "Uninstall NVM (Local)"
      "Uninstall NVM (Global)"
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
          echo "Installing NVM Local..."
          curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
          echo "✅ NVM Local installed."
          load_nvm
          read -rp "Press Enter to continue..."
          break
          ;;
        3)
          echo "Installing NVM Global (All Users)..."
          if [[ $EUID -ne 0 ]]; then
              echo -e "${yellow}Asking for sudo permissions...${reset}"
          fi
          
          sudo mkdir -p /usr/local/nvm
          # We use git to manage global nvm more easily
          if ! command -v git &> /dev/null; then
              sudo apt update && sudo apt install -y git
          fi
          
          if [ ! -d "/usr/local/nvm/.git" ]; then
              sudo git clone https://github.com/nvm-sh/nvm.git /usr/local/nvm
          fi
          
          cd /usr/local/nvm || exit
          sudo git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))"
          
          # Set permissions so all users can use NVM and install packages
          sudo chmod -R 777 /usr/local/nvm
          
          # Create profile script for all users
          echo 'export NVM_DIR="/usr/local/nvm"' | sudo tee /etc/profile.d/nvm.sh
          echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' | sudo tee -a /etc/profile.d/nvm.sh
          echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' | sudo tee -a /etc/profile.d/nvm.sh
          
          echo "✅ NVM Global installed. All users will have NVM available on next login."
          load_nvm
          read -rp "Press Enter to continue..."
          break
          ;;
        4)
          echo "Updating NVM..."
          if [ "$NVM_DIR" == "/usr/local/nvm" ]; then
              cd /usr/local/nvm || exit
              sudo git fetch --tags
              sudo git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))"
              sudo chmod -R 777 /usr/local/nvm
          else
              curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
          fi
          load_nvm
          echo "✅ NVM updated."
          read -rp "Press Enter to continue..."
          break
          ;;
        5)
          echo -e "${red}WARNING: This will remove Local NVM and all its Node.js versions.${reset}"
          read -rp "Are you sure? (y/n): " confirm
          if [[ $confirm == [yY] ]]; then
            rm -rf "$HOME/.nvm"
            sed -i '/export NVM_DIR/d' "$HOME/.bashrc"
            sed -i '/\[ -s "$NVM_DIR\/nvm.sh" \]/d' "$HOME/.bashrc"
            sed -i '/\[ -s "$NVM_DIR\/bash_completion" \]/d' "$HOME/.bashrc"
            echo "✅ Local NVM uninstalled."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        6)
          echo -e "${red}WARNING: This will remove Global NVM and all its Node.js versions.${reset}"
          read -rp "Are you sure? (y/n): " confirm
          if [[ $confirm == [yY] ]]; then
            sudo rm -rf "/usr/local/nvm"
            sudo rm -f "/etc/profile.d/nvm.sh"
            echo "✅ Global NVM uninstalled."
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        7)
          if load_nvm; then
            nvm install --lts
            nvm alias default 'lts/*'
            echo "✅ Node.js LTS installed and set as default."
          else
            echo -e "${red}Please install NVM first!${reset}"
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        8)
          if load_nvm; then
            nvm install node
            nvm alias default node
            echo "✅ Latest stable Node.js installed and set as default."
          else
            echo -e "${red}Please install NVM first!${reset}"
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        9)
          if load_nvm; then
            read -rp "Enter Node.js version to install (e.g., 20.10.0): " version
            nvm install "$version"
            echo "✅ Node.js $version installed."
          else
            echo -e "${red}Please install NVM first!${reset}"
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        10)
          if load_nvm; then
            echo "Installed versions:"
            nvm ls
            read -rp "Enter version to use: " version
            nvm use "$version"
            nvm alias default "$version"
            echo "✅ Switched to Node.js $version and set as default."
          else
            echo -e "${red}Please install NVM first!${reset}"
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        11)
          if load_nvm; then
            nvm ls
          else
            echo -e "${red}Please install NVM first!${reset}"
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        12)
          if load_nvm; then
            nvm ls-remote | tail -n 20
          else
            echo -e "${red}Please install NVM first!${reset}"
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        13)
          if load_nvm; then
            nvm ls
            read -rp "Enter Node.js version to uninstall: " version
            nvm uninstall "$version"
            echo "✅ Node.js $version uninstalled."
          else
            echo -e "${red}Please install NVM first!${reset}"
          fi
          read -rp "Press Enter to continue..."
          break
          ;;
        14)
          if load_nvm; then
            echo -n "Node version: "
            node -v
            echo -n "NPM version:  "
            npm -v
            echo -n "NVM version:  "
            nvm --version
          else
            echo -e "${red}NVM not loaded. Please install it first.${reset}"
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
