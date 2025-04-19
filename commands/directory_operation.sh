#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function directory_operation() {
    while true; do
        echo -e "\nCurrent Directory: $(pwd)"
        echo "Options:"
        echo "  1) Back to Main Menu"
        echo "  2) Go to Parent Directory (..)"
        echo "  3) Go to Home Directory (~)"
        echo "  4) Show current directory (pwd)"
        echo "  5) List directory contents (ls -lah)"

        # Get normal and hidden folders, then combine
        mapfile -t normal_folders < <(find . -maxdepth 1 -type d ! -name '.' ! -name '.*' | sed 's|^\./||' | sort)
        mapfile -t hidden_folders < <(find . -maxdepth 1 -type d -name '.*' ! -name '.' | sed 's|^\./||' | sort)

        all_folders=("${normal_folders[@]}" "${hidden_folders[@]}")

        # Display all folders starting from index 6
        index=6
        for folder in "${all_folders[@]}"; do
            printf "  %d) %s\n" "$index" "$folder"
            ((index++))
        done

        # Read user input
        read -rp "Enter a number: " choice

        # Validate number input
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            case $choice in
                1) break ;;
                2) cd .. || echo "Failed to go to parent directory." ;;
                3) cd ~ || echo "Failed to go to home directory." ;;
                4) execute_cmd "pwd" ;;
                5) execute_cmd "ls -lah" ;;
                *)
                    folder_index=$((choice - 6))
                    if (( folder_index >= 0 && folder_index < ${#all_folders[@]} )); then
                        cd "${all_folders[folder_index]}" || echo "Failed to change directory."
                    else
                        echo "Invalid option."
                    fi
                    ;;
            esac
        else
            echo "Please enter a valid number."
        fi
    done
}


directory_operation