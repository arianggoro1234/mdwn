#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function directory_operation() {
    while true; do
        echo -e "\nCurrent Directory: $(pwd)"
        echo "Options:"
        echo "  1) Back to Main Menu"
        echo "  2) Show current directory (pwd)"
        echo "  3) List directory contents (ls -lah)"

        # Ambil folder biasa dan hidden, lalu gabungkan
        mapfile -t normal_folders < <(find . -maxdepth 1 -type d ! -name '.' ! -name '.*' | sed 's|^\./||' | sort)
        mapfile -t hidden_folders < <(find . -maxdepth 1 -type d -name '.*' ! -name '.' | sed 's|^\./||' | sort)

        all_folders=("${normal_folders[@]}" "${hidden_folders[@]}")

        # Tampilkan semua folder dengan penomoran lanjut
        index=4
        for folder in "${all_folders[@]}"; do
            printf "  %d) %s\n" "$index" "$folder"
            ((index++))
        done

        # Input user
        read -rp "Enter a number: " choice

        # Validasi input angka
        if [[ "$choice" =~ ^[0-9]+$ ]]; then
            case $choice in
                1) break ;;
                2) execute_cmd "pwd" ;;
                3) execute_cmd "ls -lah" ;;
                *)
                    folder_index=$((choice - 4))
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