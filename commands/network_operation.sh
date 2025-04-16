#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Network Submenu
function network_menu() {
    local options=(
      "Back to Main Menu"
      "Show IP address (ip a)"
      "Ping an address"
      "Download file (wget)"
      "Curl a URL (curl)"
      "Show routing table (netstat -r)"
      "Traceroute to host"
      "DNS lookup (dig)"
    )
    PS3="Choose a network command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break ;;
            2) execute_cmd "ip a" ;;
            3) read -rp "Host address: " host && execute_cmd "ping -c 4 $host" ;;
            4) read -rp "URL: " url && execute_cmd "wget $url" ;;
            5) read -rp "URL: " url && execute_cmd "curl -I $url" ;;
            6) execute_cmd "netstat -r" ;;
            7) read -rp "Host: " host && execute_cmd "traceroute $host" ;;
            8) read -rp "Host: " host && execute_cmd "dig $host" ;;
            *) echo -e "${red}Invalid option${reset}" ;;
        esac
    done
}

network_menu
