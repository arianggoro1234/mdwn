#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"


function zip_menu() {
    local options=(
        "Back"
        "Create ZIP archive"
        "Extract ZIP archive"
        "List contents of ZIP archive"
        "Remove __MACOSX and .DS_Store from ZIP"
    )
    PS3="Choose a ZIP operation: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2)
                read -rp "Source directory/files to archive: " source
                read -rp "Destination ZIP file (e.g., archive.zip): " dest_zip
                local include_hidden_input
                read -rp "Include hidden files? (y/N): " include_hidden_input
                local include_hidden
                include_hidden=$(echo "$include_hidden_input" | tr '[:upper:]' '[:lower:]')

                echo "Creating ZIP archive: $dest_zip from $source"
                if [[ "$include_hidden" == "y" ]]; then
                    zip -r "${dest_zip}" "${source}" -d .
                else
                    zip -r "${dest_zip}" "${source}"
                fi

                if [[ -f "$dest_zip" ]]; then
                    local remove_macos_input
                    read -rp "Remove __MACOSX and .DS_Store? (y/N): " remove_macos_input
                    local remove_macos
                    remove_macos=$(echo "$remove_macos_input" | tr '[:upper:]' '[:lower:]')
                    if [[ "$remove_macos" == "y" ]]; then
                        echo "Removing __MACOSX and .DS_Store from $dest_zip..."
                        zip -d "${dest_zip}" "__MACOSX*" ".DS_Store"
                        if zip -T "${dest_zip}" > /dev/null 2>&1; then
                            echo "Successfully removed __MACOSX and .DS_Store."
                        else
                            echo -e "${yellow}Warning: Could not find or remove __MACOSX or .DS_Store, or ZIP might be corrupted.${reset}"
                        fi
                    fi
                fi
                echo "ZIP operation completed."
                ;;
            3)
                read -rp "ZIP file to extract: " zip_file
                read -rp "Destination directory (leave blank for current): " dest_dir
                if [[ -z "$dest_dir" ]]; then
                    unzip "$zip_file"
                    echo "Extracted $zip_file to current directory."
                else
                    mkdir -p "$dest_dir"
                    unzip "$zip_file" -d "$dest_dir"
                    echo "Extracted $zip_file to $dest_dir."
                fi
                ;;
            4)
                read -rp "ZIP file to list: " zip_file
                unzip -l "$zip_file"
                ;;
            5) # Dedicated option to remove __MACOSX and .DS_Store
                read -rp "ZIP file to clean: " zip_file_clean
                if [[ -f "$zip_file_clean" ]]; then
                    echo "Removing __MACOSX and .DS_Store from $zip_file_clean..."
                    zip -d "${zip_file_clean}" "__MACOSX*" ".DS_Store"
                    if zip -T "${zip_file_clean}" > /dev/null 2>&1; then
                        echo "Successfully removed __MACOSX and .DS_Store."
                    else
                        echo -e "${yellow}Warning: Could not find or remove __MACOSX or .DS_Store, or ZIP might be corrupted.${reset}"
                    fi
                else
                    echo -e "${red}Error: ZIP file '$zip_file_clean' not found.${reset}"
                fi
                ;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

zip_menu