#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Function to handle the installation part
install_supervisor() {
    print_start
    echo -e "${green}--- Install Supervisor ---\nThis will install supervisor if not present.${reset}"
    
    # Check if Supervisor is already installed
    if ! command -v supervisorctl &> /dev/null; then
        echo "Supervisor not found. Installing..."
        sudo apt-get update
        sudo apt-get install -y supervisor
        echo "Supervisor installed successfully."
    else
        echo "Supervisor is already installed."
    fi
    
    print_end
    read -rp "Press Enter to return to menu..."
}

# Function to handle the Web UI configuration
configure_web_ui() {
    print_start
    echo -e "${green}--- Configure Supervisor Web UI ---\nThis will configure the web interface for Supervisor.${reset}"

    if ! command -v supervisorctl &> /dev/null; then
        echo -e "${red}Supervisor is not installed. Please install it first.${reset}"
        print_end
        read -rp "Press Enter to return to menu..."
        return
    fi

    echo
    echo "--- Configuring Supervisor Web UI ---"
    read -p "Enter a username for the web UI: " SUPERVISOR_USER
    read -sp "Enter a password for the web UI: " SUPERVISOR_PASS
    echo
    echo

    if [ -z "$SUPERVISOR_USER" ] || [ -z "$SUPERVISOR_PASS" ]; then
        echo -e "${red}Username and password cannot be empty. Aborting web UI setup.${reset}"
        print_end
        read -rp "Press Enter to return to menu..."
        return
    fi

    # Create config for the web UI.
    CONFIG_PATH="/etc/supervisor/conf.d/supervisord_web.conf"
    echo "Creating web UI config at $CONFIG_PATH"
    cat << EOF | sudo tee "$CONFIG_PATH" > /dev/null
[inet_http_server]
port=*:9001
username=$SUPERVISOR_USER
password=$SUPERVISOR_PASS
EOF
    
    echo "Applying configuration..."
    sudo supervisorctl reread
    sudo supervisorctl update
    
    echo "Restarting Supervisor service to activate web UI..."
    sudo systemctl restart supervisor

    echo
    echo "--- Configuration Complete ---"
    echo "The Supervisor web UI is configured."
    echo "Access it at: http://<your-server-ip>:9001"

    print_end
    read -rp "Press Enter to return to menu..."
}

# Main menu function for supervisor operations
supervisor_operation() {
    while true; do
        echo -e "\n${yellow}--- Supervisor Operation Menu ---${reset}"
        echo "  1) Back to Main Menu"
        echo "  2) Install Supervisor"
        echo "  3) Configure Web UI"
        echo "  4) Show Status"
        echo "  5) Start a Process"
        echo "  6) Stop a Process"
        echo "  7) Restart a Process"
        echo "  8) Reread Config Files"
        echo "  9) Update Process Groups"
        
        read -rp "Enter your choice: " choice

        case $choice in
            1)
                break
                ;; 
            2)
                install_supervisor
                ;; 
            3)
                configure_web_ui
                ;;
            4)
                execute_cmd "sudo supervisorctl status"
                ;; 
            5)
                read -rp "Enter process name (or 'all'): " app_name
                if [ -n "$app_name" ]; then
                    execute_cmd "sudo supervisorctl start $app_name"
                else
                    echo -e "${red}Process name cannot be empty.${reset}"
                fi
                ;; 
            6)
                read -rp "Enter process name (or 'all'): " app_name
                if [ -n "$app_name" ]; then
                    execute_cmd "sudo supervisorctl stop $app_name"
                else
                    echo -e "${red}Process name cannot be empty.${reset}"
                fi
                ;; 
            7)
                read -rp "Enter process name (or 'all'): " app_name
                if [ -n "$app_name" ]; then
                    execute_cmd "sudo supervisorctl restart $app_name"
                else
                    echo -e "${red}Process name cannot be empty.${reset}"
                fi
                ;; 
            8)
                execute_cmd "sudo supervisorctl reread"
                ;; 
            9)
                execute_cmd "sudo supervisorctl update"
                ;; 
            *)
                echo -e "${red}Invalid option. Please try again.${reset}"
                ;; 
        esac
    done
}

# Run the main function
supervisor_operation
