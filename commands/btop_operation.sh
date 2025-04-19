#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function check_and_install_btop() {
  if ! command -v btop &> /dev/null; then
    echo -e "${yellow}btop not found. Installing...${reset}"
    if command -v apt &> /dev/null; then
      sudo apt update && sudo apt install -y btop
    elif command -v dnf &> /dev/null; then
      sudo dnf install -y btop
    elif command -v pacman &> /dev/null; then
      sudo pacman -Sy --noconfirm btop
    elif command -v brew &> /dev/null; then
      brew install btop
    else
      echo -e "${red}Package manager not supported. Please install btop manually.${reset}"
      return 1
    fi
  fi
}

function uninstall_btop() {
  echo -e "${yellow}Uninstalling btop...${reset}"
  if command -v apt &> /dev/null; then
    sudo apt remove -y btop
  elif command -v dnf &> /dev/null; then
    sudo dnf remove -y btop
  elif command -v pacman &> /dev/null; then
    sudo pacman -Rns --noconfirm btop
  elif command -v brew &> /dev/null; then
    brew uninstall btop
  else
    echo -e "${red}Package manager not supported. Please uninstall btop manually.${reset}"
    return 1
  fi
}
function btop_menu() {
  check_and_install_btop || return

  local options=(
    "Back to Main Menu"
    "Launch btop"
    "View btop Help (man)"
    "Show System Information (uname -a)"
    "Show CPU Information (lscpu)"
    "Show Memory Usage (free -h)"
    "Show Network Info (ip a)"
    "Show Disk Usage (df -h)"
    "Show Running Processes (ps aux)"
    "Show Active Services (systemctl list-units --type=service --state=running)"
    "Show btop Config File"
    "Uninstall btop"
  )

  PS3="Choose an option for btop: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2) btop ;;
      3) man btop ;;
      4) uname -a ;;
      5) lscpu ;;
      6) free -h ;;
      7) ip a ;;
      8) df -h ;;
      9) ps aux | less ;;
      10) systemctl list-units --type=service --state=running | less ;;
      11) cat ~/.config/btop/btop.conf ;;
      12)
        uninstall_btop
        break
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

btop_menu