#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Directory Submenu
function directory_operation() {
    local options=(
      "Back to Main Menu"
      "Show current directory (pwd)"
      "Change directory (cd)"
      "List directory contents (ls)"
    )
    PS3="Choose a navigation option: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break ;;
            2) execute_cmd "pwd" ;;
            3) read -rp "Enter directory path: " path && cd "$path" || echo "Directory not found." ;;
            4) execute_cmd "ls -lah" ;;
            *) echo -e "${red}Invalid option${reset}" ;;
        esac
    done
}

directory_operation
