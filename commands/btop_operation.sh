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
    "Show btop System Information"
    "Show btop CPU Information"
    "Show btop Memory Information"
    "Show btop Network Information"
    "Show btop Disk Information"
    "Show btop Process List"
    "Show btop Services"
    "Show btop Config File"
    "Uninstall btop"
  )

  PS3="Choose an option for btop: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2) btop ;;
      3) man btop ;;
      4) btop -i ;;
      5) btop -c ;;
      6) btop -m ;;
      7) btop -n ;;
      8) btop -d ;;
      9) btop -p ;;
      10) btop -s ;;
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
