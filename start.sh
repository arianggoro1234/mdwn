#!/bin/bash

# GLOBAL Helper
# shellcheck source=./commands/lib/alacarte.sh
source "$(dirname "$0")/commands/lib/alacarte.sh"

# Main Menu
function main_menu() {
    while true; do
        clear
        echo -e "${green}===== BASIC LINUX COMMANDS MENU =====${reset}"
        local options=(
          "Exit"
          "Directories Navigation"
          "Files & Directories"
          "Networking"
          "User Management"
          "Package Manager"
          "Check mdwn Update"
        )
        PS3="Choose an option: "
        select _ in "${options[@]}"; do
            case $REPLY in
                1) echo "Goodbye." && exit 0 ;;
                2) ~/mdwn/commands/directory_operation.sh ;;
                3) ~/mdwn/commands/file_operation.sh ;;
                4) ~/mdwn/commands/network_operation.sh ;;
                5) ~/mdwn/commands/user_manager.sh ;;
                6) ~/mdwn/commands/package_manager.sh;;
                7) ~/mdwn/commands/mdwn_updater.sh ;;
                *) echo -e "${red}Invalid option${reset}" ;;
            esac
            break  # After executing a command, go back to the main menu
        done
    done
}

main_menu
