#!/bin/bash

Check if the script is run as root, if not, inform the user to use sudo and exit with a countdown
if [[ "$EUID" -ne 0 ]]; then
    echo -e "${red}This script must be run with superuser privileges (sudo). Exiting in..."
    for i in 4 3 2 1; do
        echo -ne " $i..."
        sleep 1
    done
    echo
    exit 1
fi


# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# --- Installation Variables ---
default_hestia_user="admin"
hestia_password=""
install_postgresql="no"
install_multiphp="no"
php_versions="7.4 8.0 8.1 8.2 8.3" # Default PHP versions to install

# --- Functions ---

# Function to prompt user for Hestia username
function ask_hestia_username() {
    read -rp "Enter HestiaCP username [$default_hestia_user]: " custom_user
    if [[ -z "$custom_user" ]]; then
        hestia_user="$default_hestia_user"
    else
        hestia_user="$custom_user"
    fi
    echo "HestiaCP username will be: ${hestia_user}"
}

# Function to prompt user for Hestia password
function ask_hestia_password() {
    while [[ -z "$hestia_password" ]]; do
        read -rsp "Enter HestiaCP password: " hestia_password
        echo
        read -rsp "Confirm HestiaCP password: " confirm_password
        echo
        if [[ "$hestia_password" != "$confirm_password" ]]; then
            echo -e "${red}Passwords do not match. Please try again.${reset}"
            hestia_password=""
        fi
    done
    echo "HestiaCP password has been set."
}

# Function to ask whether to install PostgreSQL
function ask_install_postgresql() {
    read -rp "Install PostgreSQL? (y/N): " install_pgsql_input
    install_postgresql=$(echo "$install_pgsql_input" | tr '[:upper:]' '[:lower:]')
    if [[ "$install_postgresql" == "y" ]]; then
        echo "PostgreSQL will be installed."
    else
        echo "PostgreSQL will not be installed."
    fi
}

# Function to ask whether to install multi-PHP
function ask_install_multiphp() {
    read -rp "Install multi-PHP? (y/N): " install_php_input
    install_multiphp=$(echo "$install_php_input" | tr '[:upper:]' '[:lower:]')
    if [[ "$install_multiphp" == "y" ]]; then
        echo "Multi-PHP (${php_versions}) will be installed."
    else
        echo "Multi-PHP will not be installed."
    fi
}

# Function to perform HestiaCP installation
function install_hestiacp() {
    echo "Starting HestiaCP installation..."

    # Download the installation script
    wget -O /tmp/hestia-install.sh https://raw.githubusercontent.com/hestiacp/hestiacp/release/install/hst-install.sh

    if [[ -f "/tmp/hestia-install.sh" ]]; then
        chmod +x /tmp/hestia-install.sh

        # Build install command with user-provided options
        install_command="/tmp/hestia-install.sh -u ${hestia_user} -p ${hestia_password}"
        if [[ "$install_postgresql" == "y" ]]; then
            install_command+=" --with-postgresql yes"
        fi
        if [[ "$install_multiphp" == "y" ]]; then
            install_command+=" --with-multiphp yes --php-version '${php_versions}'"
        fi
        install_command+=" --force" # Add --force to skip some prompts (use with caution)

        echo "Running installation command: ${install_command}"
        bash -c "${install_command}"

        rm -f /tmp/hestia-install.sh
        echo -e "${green}HestiaCP installation completed. Please check the output above for any important information.${reset}"
    else
        echo -e "${red}Failed to download HestiaCP installation script.${reset}"
    fi
}

# Function to manage HestiaCP services (using systemctl)
function manage_hestia_service() {
    local service_name="hestia" # Main Hestia service name
    local options=(
        "Back"
        "Start HestiaCP service"
        "Stop HestiaCP service"
        "Restart HestiaCP service"
        "Check HestiaCP service status"
    )
    PS3="Choose a HestiaCP service command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2) echo "Starting ${service_name} service..."; sudo systemctl start "${service_name}";;
            3) echo "Stopping ${service_name} service..."; sudo systemctl stop "${service_name}";;
            4) echo "Restarting ${service_name} service..."; sudo systemctl restart "${service_name}";;
            5) echo "Checking ${service_name} service status..."; sudo systemctl status "${service_name}";;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

# Function to manage HestiaCP firewall (using v-add/list/delete-firewall)
function manage_hestia_firewall() {
    local options=(
        "Back"
        "List firewall rules"
        "Add firewall rule"
        "Delete firewall rule"
    )
    PS3="Choose a HestiaCP firewall command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2) sudo v-list-firewall;;
            3)
                read -rp "Port to open: " port
                read -rp "Protocol (TCP/UDP/TCP+UDP/ALL): " protocol
                read -rp "Source (IP/ALL): " source
                sudo v-add-firewall-rule "$port" "$protocol" "$source"
                ;;
            4)
                read -rp "Rule ID to delete: " rule_id
                sudo v-delete-firewall-rule "$rule_id"
                ;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

# Main HestiaCP menu
function hestia_menu() {
    local options=(
        "Back to Main Menu"
        "Install HestiaCP"
        "Manage HestiaCP Service"
        "Manage HestiaCP Firewall"
        # Add more HestiaCP management options here in the future
    )
    PS3="Choose a HestiaCP command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2)
                ask_hestia_username
                ask_hestia_password
                ask_install_postgresql
                ask_install_multiphp
                install_hestiacp
                ;;
            3) manage_hestia_service;;
            4) manage_hestia_firewall;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

hestia_menu