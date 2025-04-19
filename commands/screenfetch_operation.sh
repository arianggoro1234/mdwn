#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Fungsi untuk cek dan tawarkan instalasi screenfetch jika belum terpasang
function check_install_screenfetch() {
  if ! command -v screenfetch &> /dev/null; then
    echo -e "${yellow}screenfetch is not installed.${reset}"
    read -rp "Do you want to install it now? [Y/n]: " confirm
    if [[ "$confirm" =~ ^[Yy]?$ ]]; then
      sudo apt update && sudo apt install -y screenfetch
    else
      echo -e "${red}screenfetch is required to use this menu.${reset}"
      return 1
    fi
  fi
  return 0
}

# Menu screenfetch
function screenfetch_menu() {
  check_install_screenfetch || return

  local options=(
    "Back to Main Menu"
    "Run screenfetch (default)"
    "Run with No ASCII Art"
    "Run with ASCII Art Only"
    "Run with Custom ASCII Distro"
    "Run with Debug Output"
    "Run with Specific Screenshot Command"
    "Display Version Info"
    "Display Help"
  )

  PS3="Choose an option for screenfetch: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2) screenfetch ;;
      3) screenfetch -n ;;
      4) screenfetch -A ;;
      5)
        read -rp "Enter distro name for ASCII art (e.g., Ubuntu, Arch): " distro
        if [[ -z "$distro" ]]; then
          echo -e "${red}You must provide a valid distro name.${reset}"
        else
          screenfetch -A "$distro"
        fi
        ;;
      6) screenfetch -v ;;
      7)
        read -rp "Enter custom screenshot command (e.g., scrot -d 5): " cmd
        if [[ -z "$cmd" ]]; then
          echo -e "${red}You must provide a valid screenshot command.${reset}"
        else
          screenfetch -S "$cmd"
        fi
        ;;
      8) screenfetch -V ;;
      9) screenfetch -h ;;
      *) echo -e "${red}Invalid option${reset}" ;;
    esac
  done
}

screenfetch_menu
