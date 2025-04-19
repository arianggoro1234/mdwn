#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Define Webmin URL
webmin_url="https://your_server_ip:10000/"

# Function to install Webmin
function install_webmin() {
    echo "Installing Webmin..."
    if dpkg -s webmin >/dev/null 2>&1; then
        echo "Webmin is already installed."
        return 0
    fi

    # Add Webmin repository
    echo "Adding Webmin repository..."
    sudo sh -c 'echo "deb https://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
    wget -qO - https://www.webmin.com/jcameron-key.asc | sudo apt-key add -

    # Update package list and install Webmin
    sudo apt update
    sudo apt install -y webmin

    if dpkg -s webmin >/dev/null 2>&1; then
        echo -e "${green}Webmin installed successfully. You can access it at ${webmin_url}${reset}"
    else
        echo -e "${red}Webmin installation failed. Please check the output above for errors.${reset}"
    fi
}

# Function to uninstall Webmin
function uninstall_webmin() {
    echo "Uninstalling Webmin..."
    if ! dpkg -s webmin >/dev/null 2>&1; then
        echo "Webmin is not installed."
        return 0
    fi

    sudo apt purge -y webmin
    sudo apt autoremove -y
    sudo rm -rf /etc/webmin /usr/share/webmin

    # Remove repository entry
    sudo rm -f /etc/apt/sources.list.d/webmin.list
    sudo apt update

    echo -e "${green}Webmin uninstalled successfully.${reset}"
}

# Function to start Webmin service
function start_webmin() {
    echo "Starting Webmin service..."
    sudo systemctl start webmin
    if systemctl is-active --quiet webmin; then
        echo -e "${green}Webmin service started.${reset}"
    else
        echo -e "${red}Failed to start Webmin service.${reset}"
    fi
}

# Function to stop Webmin service
function stop_webmin() {
    echo "Stopping Webmin service..."
    sudo systemctl stop webmin
    if ! systemctl is-active --quiet webmin; then
        echo -e "${green}Webmin service stopped.${reset}"
    else
        echo -e "${red}Failed to stop Webmin service.${reset}"
    fi
}

# Function to restart Webmin service
function restart_webmin() {
    echo "Restarting Webmin service..."
    sudo systemctl restart webmin
    if systemctl is-active --quiet webmin; then
        echo -e "${green}Webmin service restarted.${reset}"
    else
        echo -e "${red}Failed to restart Webmin service.${reset}"
    fi
}

# Function to check Webmin service status
function status_webmin() {
    echo "Checking Webmin service status..."
    sudo systemctl status webmin
}

# Function to enable Webmin on boot
function enable_boot_webmin() {
    echo "Enabling Webmin on boot..."
    sudo systemctl enable webmin
    if systemctl is-enabled --quiet webmin; then
        echo -e "${green}Webmin enabled on boot.${reset}"
    else
        echo -e "${red}Failed to enable Webmin on boot.${reset}"
    fi
}

# Function to disable Webmin on boot
function disable_boot_webmin() {
    echo "Disabling Webmin on boot..."
    sudo systemctl disable webmin
    if ! systemctl is-enabled --quiet webmin; then
        echo -e "${green}Webmin disabled on boot.${reset}"
    else
        echo -e "${red}Failed to disable Webmin on boot.${reset}"
    fi
}

# Function to access Webmin configuration (opens web browser - requires 'xdg-open')
function config_webmin() {
    echo "Opening Webmin configuration in your web browser..."
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "${webmin_url}"
    else
        echo -e "${yellow}Please open your web browser and navigate to ${webmin_url}${reset}"
    fi
}

# Function to view Webmin manual (if installed - usually online)
function manual_webmin() {
    echo "Webmin manual is usually available online at https://docs.webmin.com/"
    echo "You can also try 'man webmin' if a local manual page is installed."
    man webmin || echo -e "${yellow}No local Webmin manual page found.${reset}"
}

# Main Webmin menu
function webmin_menu() {
    local options=(
        "Back to Main Menu"
        "Install Webmin"
        "Uninstall Webmin"
        "Start Webmin service"
        "Stop Webmin service"
        "Restart Webmin service"
        "Check Webmin service status"
        "Enable Webmin on boot"
        "Disable Webmin on boot"
        "Access Webmin configuration (browser)"
        "View Webmin manual"
    )
    PS3="Choose a Webmin command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2) install_webmin;;
            3) uninstall_webmin;;
            4) start_webmin;;
            5) stop_webmin;;
            6) restart_webmin;;
            7) status_webmin;;
            8) enable_boot_webmin;;
            9) disable_boot_webmin;;
            10) config_webmin;;
            11) manual_webmin;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

webmin_menu