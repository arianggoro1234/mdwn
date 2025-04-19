#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function get_installed_php_versions() {
    local versions=()
    for version_dir in /usr/bin/php*; do
        if [[ "$version_dir" =~ php([0-9]+\.[0-9]+)$ ]]; then
            versions+=("${BASH_REMATCH[1]}")
        fi
    done
    echo "${versions[@]}" | sort -V
}

function set_composer_php_version() {
    local installed_versions
    installed_versions=$(get_installed_php_versions)
    local php_options=("auto")
    IFS=' ' read -ra php_versions_array <<< "$installed_versions"
    php_options+=("${php_versions_array[@]}")

    PS3="Choose a PHP version for Composer to use: "
    select php_version in "${php_options[@]}"; do
        if [[ -n "$php_version" ]]; then
            if [[ "$php_version" == "auto" ]]; then
                composer config platform.php "$(php -v | head -n 1 | awk '{print $2}')" --unset --global
                echo "Composer will use the system's default PHP version."
                break
            elif [[ "$installed_versions" =~ (^|[[:space:]])"$php_version"($|[[:space:]]) ]]; then
                composer config platform.php "$php_version" --global
                echo "Composer will now use PHP version $php_version."
                break
            else
                echo -e "${red}Invalid PHP version selected.${reset}"
            fi
        fi
    done
}

function composer_menu() {
    local options=(
        "Back to Main Menu"
        "About Composer"
        "Install Composer"
        "Update Composer"
        "Show Composer version"
        "Show Composer help"
        "Use specific PHP version for Composer"
        "Init: Create a basic composer.json file"
        "Install: Install the project dependencies"
        "Update: Update the project dependencies"
        "Require: Add a new dependency to composer.json"
        "Remove: Remove a dependency from composer.json"
        "Autoload: Regenerate the autoloader"
        "Dump-autoload: Regenerate the autoloader (alias)"
        "Validate: Validates the composer.json and composer.lock files"
        "Show: Show information about packages"
        "Search: Search for packages on Packagist"
        "Global: Manage global Composer commands"
        "Diagnose: Diagnose common Composer problems"
        "Clear-cache: Clears Composer's local package cache"
        "Licenses: Show the licenses of the installed packages"
        "Run-script: Executes the scripts defined in composer.json"
        "Config: Set config options"
        "Create-project: Create new project from a package"
        "Archive: Create a package archive (phar/zip/tar)"
    )
    PS3="Choose a Composer command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2) composer about;;
            3)
                if ! command -v composer &> /dev/null
                then
                    echo "Composer not found. Installing Composer..."
                    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
                    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
                    echo "Composer installed globally in /usr/local/bin/composer"
                    rm composer-setup.php
                else
                    echo "Composer is already installed."
                fi
                ;;
            4)
                if command -v composer &> /dev/null
                then
                    echo "Updating Composer..."
                    composer self-update
                else
                    echo "Composer is not installed. Please choose option 3 to install."
                fi
                ;;
            5) composer --version;;
            6) composer --help;;
            7) set_composer_php_version;;
            8) composer init;;
            9) composer install;;
            10) composer update;;
            11)
                read -rp "Package name to require: " package
                composer require "$package"
                ;;
            12)
                read -rp "Package name to remove: " package
                composer remove "$package"
                ;;
            13) composer autoload -o;;
            14) composer dump-autoload -o;;
            15) composer validate;;
            16)
                read -rp "Package name to show info: " package
                composer show "$package"
                ;;
            17)
                read -rp "Keywords to search: " keywords
                composer search "$keywords"
                ;;
            18) composer global;;
            19) composer diagnose;;
            20) composer clear-cache;;
            21) composer licenses;;
            22)
                read -rp "Script name to run: " script
                composer run-script "$script"
                ;;
            23)
                read -rp "Config setting (e.g., vendor-dir): " setting
                read -rp "Config value: " value
                composer config "$setting" "$value"
                ;;
            24)
                read -rp "Package name to create project: " package
                read -rp "Directory to install into: " directory
                composer create-project "$package" "$directory" --prefer-dist
                ;;
            25)
                read -rp "Format (phar, zip, tar): " format
                read -rp "Destination filename: " filename
                composer archive --format="$format" --file="$filename"
                ;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

composer_menu