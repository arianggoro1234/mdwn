#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# File & Directory Submenu
function file_menu() {
    local options=(
      "Back to Main Menu"
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
    )
    PS3="Choose a file & directory command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break ;;
            2) read -rp "Directory name: " name && mkdir -p "$name" ;;
            3) read -rp "File name: " name && rm -i "$name" ;;
            4) read -rp "Source: " src && read -rp "Destination: " dest && cp -r "$src" "$dest" ;;
            5) read -rp "Source: " src && read -rp "Destination: " dest && mv "$src" "$dest" ;;
            6) read -rp "File name: " name && touch "$name" ;;
            7) read -rp "File name: " name && execute_cmd "file $name" ;;
            8) read -rp "File name: " name && nano "$name" ;;
            9) read -rp "File name: " name && execute_cmd "cat $name" ;;
            10) read -rp "Search for: " text && read -rp "File: " name && execute_cmd "grep '$text' $name" ;;
            11) read -rp "Pattern: " pattern && read -rp "File: " name && execute_cmd "sed '$pattern' $name" ;;
            12) read -rp "File: " name && execute_cmd "head $name" ;;
            13) read -rp "File: " name && execute_cmd "tail $name" ;;
            14) read -rp "File: " name && execute_cmd "sort $name" ;;
            15) read -rp "File: " name && execute_cmd "cut -d' ' -f1 $name" ;;
            16) read -rp "File 1: " f1 && read -rp "File 2: " f2 && execute_cmd "diff $f1 $f2" ;;
            *) echo -e "${red}Invalid option${reset}" ;;
        esac
    done
}

file_menu
