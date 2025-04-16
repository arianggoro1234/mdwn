#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# User Submenu
function user_menu() {
    local options=(
      "Back to Main Menu"
      "Show current user (whoami)"
      "Add user (useradd)"
      "Delete user (userdel)"
      "Change file permission (chmod)"
      "Change file owner (chown)"
    )
    PS3="Choose a user command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;  # Back to Main Menu
            2) execute_cmd "whoami";;
            3) read -rp "Username: " user && sudo useradd "$user" && echo "User $user added.";;
            4) read -rp "Username: " user && sudo userdel "$user" && echo "User $user deleted.";;
            5) read -rp "File: " file && read -rp "Permission (e.g. 755): " perm && chmod "$perm" "$file";;
            6) read -rp "File: " file && read -rp "Owner: " owner && chown "$owner" "$file";;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

user_menu
