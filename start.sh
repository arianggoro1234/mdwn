#!/bin/bash

# Color variables
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
reset='\033[0m'

# Separator line
function print_line() {
    echo -e "${green}=============================================${reset}\n"
}

function print_start() {
    echo -e "${yellow}============= START ===============${reset}"
}

function print_end() {
    echo -e "${yellow}============== END ================${reset}\n"
}

# Command execution function
function execute_cmd() {
  local command=$1
  print_start
  echo -e "Executing => ${green}$command${reset}"
  print_line
  eval "$command"
  print_end
  read -rp "Press Enter to return to menu..."
}

# Navigation Submenu
function navigation_menu() {
    local options=(
      "Show current directory (pwd)"
      "Change directory (cd)"
      "List directory contents (ls)"
      "Back to Main Menu"
    )
    PS3="Choose a navigation option: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) execute_cmd "pwd";;
            2) read -rp "Enter directory path: " path && cd "$path" || echo "Directory not found.";;
            3) execute_cmd "ls -lah";;
            4) break;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

# File & Directory Submenu
function file_menu() {
    local options=(
      "Create directory (mkdir)"
      "Delete file (rm)"
      "Copy file (cp)"
      "Move/rename file (mv)"
      "Create empty file (touch)"
      "Check file type (file)"
      "Edit file (nano)"
      "Concatenate & display file (cat)"
      "Search string in file (grep)"
      "Replace text content (sed)"
      "View first 10 lines (head)"
      "View last 10 lines (tail)"
      "Sort file contents (sort)"
      "Cut text section from file (cut)"
      "Compare two files (diff)"
      "Back to Main Menu"
    )
    PS3="Choose a file & directory command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) read -rp "Directory name: " name && mkdir -p "$name";;
            2) read -rp "File name: " name && rm -i "$name";;
            3) read -rp "Source: " src && read -rp "Destination: " dest && cp -r "$src" "$dest";;
            4) read -rp "Source: " src && read -rp "Destination: " dest && mv "$src" "$dest";;
            5) read -rp "File name: " name && touch "$name";;
            6) read -rp "File name: " name && execute_cmd "file $name";;
            7) read -rp "File name: " name && nano "$name";;
            8) read -rp "File name: " name && execute_cmd "cat $name";;
            9) read -rp "Search for: " text && read -rp "File: " name && execute_cmd "grep '$text' $name";;
            10) read -rp "Pattern: " pattern && read -rp "File: " name && execute_cmd "sed '$pattern' $name";;
            11) read -rp "File: " name && execute_cmd "head $name";;
            12) read -rp "File: " name && execute_cmd "tail $name";;
            13) read -rp "File: " name && execute_cmd "sort $name";;
            14) read -rp "File: " name && execute_cmd "cut -d' ' -f1 $name";;
            15) read -rp "File 1: " f1 && read -rp "File 2: " f2 && execute_cmd "diff $f1 $f2";;
            16) break;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

# Network Submenu
function network_menu() {
    local options=(
      "Show IP address (ip a)"
      "Ping an address"
      "Download file (wget)"
      "Curl a URL (curl)"
      "Show routing table (netstat -r)"
      "Traceroute to host"
      "DNS lookup (dig)"
      "Back to Main Menu"
    )
    PS3="Choose a network command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) execute_cmd "ip a";;
            2) read -rp "Host address: " host && execute_cmd "ping -c 4 $host";;
            3) read -rp "URL: " url && execute_cmd "wget $url";;
            4) read -rp "URL: " url && execute_cmd "curl -I $url";;
            5) execute_cmd "netstat -r";;
            6) read -rp "Host: " host && execute_cmd "traceroute $host";;
            7) read -rp "Host: " host && execute_cmd "dig $host";;
            8) break;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

# User Submenu
function user_menu() {
    local options=(
      "Show current user (whoami)"
      "Add user (useradd)"
      "Delete user (userdel)"
      "Change file permission (chmod)"
      "Change file owner (chown)"
      "Back to Main Menu"
    )
    PS3="Choose a user command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) execute_cmd "whoami";;
            2) read -rp "Username: " user && sudo useradd "$user" && echo "User $user added.";;
            3) read -rp "Username: " user && sudo userdel "$user" && echo "User $user deleted.";;
            4) read -rp "File: " file && read -rp "Permission (e.g. 755): " perm && chmod "$perm" "$file";;
            5) read -rp "File: " file && read -rp "Owner: " owner && chown "$owner" "$file";;
            6) break;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

check_update(){
  cd ~/mdwn/ || exit
  echo "Checking for updates..."
  git pull
}

# Main Menu
function main_menu() {
    clear
    echo -e "${green}===== BASIC LINUX COMMANDS MENU =====${reset}"
    local options=(
      "System Navigation"
      "Files & Directories"
      "Networking"
      "User Management"
      "Check Update"
      "Exit"
    )
    PS3="Choose an option: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) navigation_menu;;
            2) file_menu;;
            3) network_menu;;
            4) user_menu;;
            5) check_update;;
            6) echo "Goodbye." && exit 0;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

main_menu
