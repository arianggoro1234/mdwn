#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Function to remove __MACOSX and .DS_Store from a ZIP archive
function clean_macos_zip() {
    read -rp "ZIP file to clean: " zip_file
    if [[ -f "$zip_file" ]]; then
        echo "Removing __MACOSX and .DS_Store from $zip_file..."
        zip -d "$zip_file" "__MACOSX*" ".DS_Store"
        if zip -T "$zip_file" > /dev/null 2>&1; then
            echo "Successfully removed __MACOSX and .DS_Store from $zip_file."
        else
            echo -e "${yellow}Warning: Could not find or remove __MACOSX or .DS_Store in $zip_file.${reset}"
        fi
    else
        echo -e "${red}Error: ZIP file '$zip_file' not found.${reset}"
    fi
}

# Function to handle TAR archive management
function tar_menu() {
    local options=(
        "Back"
        "Create TAR archive"
        "Create Gzip compressed TAR archive (.tar.gz)"
        "Create Bzip2 compressed TAR archive (.tar.bz2)"
        "Extract TAR archive"
        "Extract Gzip compressed TAR archive (.tar.gz)"
        "Extract Bzip2 compressed TAR archive (.tar.bz2)"
        "List contents of TAR archive"
        "List contents of Gzip compressed TAR archive (.tar.gz)"
        "List contents of Bzip2 compressed TAR archive (.tar.bz2)"
        "Remove __MACOSX and .DS_Store from ZIP" # Added this option as requested
    )
    PS3="Choose a TAR operation: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;; # Go back to the main menu
            2) # Create TAR archive
                read -rp "Source directory/files to archive: " source
                read -rp "Destination TAR file (e.g., archive.tar): " dest_tar
                read -rp "Include hidden files? (y/N): " include_hidden_input
                include_hidden=$(echo "$include_hidden_input" | tr '[:upper:]' '[:lower:]')
                tar_command="tar -cvf \"$dest_tar\" \"$source\""
                if [[ "$include_hidden" == "y" ]]; then
                    tar_command+=" --exclude='./*/\.*' --exclude='./\.*'"
                fi
                echo "Creating TAR archive: $dest_tar from $source"
                eval "$tar_command"
                echo "TAR operation completed."
                ;;
            3) # Create Gzip compressed TAR archive
                read -rp "Source directory/files to archive: " source
                read -rp "Destination TAR.GZ file (e.g., archive.tar.gz): " dest_targz
                read -rp "Include hidden files? (y/N): " include_hidden_input
                include_hidden=$(echo "$include_hidden_input" | tr '[:upper:]' '[:lower:]')
                tar_command="tar -czvf \"$dest_targz\" \"$source\""
                if [[ "$include_hidden" == "y" ]]; then
                    tar_command+=" --exclude='./*/\.*' --exclude='./\.*'"
                fi
                echo "Creating TAR.GZ archive: $dest_targz from $source"
                eval "$tar_command"
                echo "TAR.GZ operation completed."
                ;;
            4) # Create Bzip2 compressed TAR archive
                read -rp "Source directory/files to archive: " source
                read -rp "Destination TAR.BZ2 file (e.g., archive.tar.bz2): " dest_tarbz2
                read -rp "Include hidden files? (y/N): " include_hidden_input
                include_hidden=$(echo "$include_hidden_input" | tr '[:upper:]' '[:lower:]')
                tar_command="tar -cjvf \"$dest_tarbz2\" \"$source\""
                if [[ "$include_hidden" == "y" ]]; then
                    tar_command+=" --exclude='./*/\.*' --exclude='./\.*'"
                fi
                echo "Creating TAR.BZ2 archive: $dest_tarbz2 from $source"
                eval "$tar_command"
                echo "TAR.BZ2 operation completed."
                ;;
            5) # Extract TAR archive
                read -rp "TAR file to extract: " tar_file
                read -rp "Destination directory (leave blank for current): " dest_dir
                if [[ -z "$dest_dir" ]]; then
                    tar -xvf "$tar_file"
                    echo "Extracted $tar_file to current directory."
                else
                    mkdir -p "$dest_dir"
                    tar -xvf "$tar_file" -C "$dest_dir"
                    echo "Extracted $tar_file to $dest_dir."
                fi
                ;;
            6) # Extract Gzip compressed TAR archive
                read -rp "TAR.GZ file to extract: " targz_file
                read -rp "Destination directory (leave blank for current): " dest_dir
                if [[ -z "$dest_dir" ]]; then
                    tar -xzvf "$targz_file"
                    echo "Extracted $targz_file to current directory."
                else
                    mkdir -p "$dest_dir"
                    tar -xzvf "$targz_file" -C "$dest_dir"
                    echo "Extracted $targz_file to $dest_dir."
                fi
                ;;
            7) # Extract Bzip2 compressed TAR archive
                read -rp "TAR.BZ2 file to extract: " tarbz2_file
                read -rp "Destination directory (leave blank for current): " dest_dir
                if [[ -z "$dest_dir" ]]; then
                    tar -xjvf "$tarbz2_file"
                    echo "Extracted $tarbz2_file to current directory."
                else
                    mkdir -p "$dest_dir"
                    tar -xjvf "$tarbz2_file" -C "$dest_dir"
                    echo "Extracted $tarbz2_file to $dest_dir."
                fi
                ;;
            8) # List contents of TAR archive
                read -rp "TAR file to list: " tar_file
                tar -tvf "$tar_file"
                ;;
            9) # List contents of Gzip compressed TAR archive
                read -rp "TAR.GZ file to list: " targz_file
                tar -tzvf "$targz_file"
                ;;
            10) # List contents of Bzip2 compressed TAR archive
                read -rp "TAR.BZ2 file to list: " tarbz2_file
                tar -tjvf "$tarbz2_file"
                ;;
            11) # Remove __MACOSX and .DS_Store from ZIP
                clean_macos_zip
                ;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

tar_menu