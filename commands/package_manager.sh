#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# APT Package Manager Submenu
function apt_menu() {
    local options=(
      "Back to Main Menu"
      "Update package list (sudo apt update)"
      "Upgrade packages (sudo apt upgrade)"
      "Full upgrade (sudo apt full-upgrade)"
      "Install package (sudo apt install)"
      "Remove package (sudo apt remove)"
      "Search package (apt search)"
      "Show installed package info (apt show)"
      "Clean cache (sudo apt clean)"
      "Autoremove unused packages (sudo apt autoremove)"
    )
    PS3="Choose an APT command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;  # Back to Main Menu
            2) execute_cmd "sudo apt update";;
            3) execute_cmd "sudo apt upgrade -y";;
            4) execute_cmd "sudo apt full-upgrade -y";;
            5) read -rp "Package to install: " pkg && sudo apt install -y "$pkg";;
            6) read -rp "Package to remove: " pkg && sudo apt remove -y "$pkg";;
            7) read -rp "Package to search: " pkg && apt search "$pkg";;
            8) read -rp "Package to show: " pkg && apt show "$pkg";;
            9) execute_cmd "sudo apt clean";;
            10) execute_cmd "sudo apt autoremove -y";;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

apt_menu
