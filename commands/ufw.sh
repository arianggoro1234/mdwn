#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function ufw_menu() {
    local options=(
      "Back to Main Menu"
      "Install UFW"
      "Uninstall UFW"
      "Enable UFW"
      "Disable UFW"
      "Check UFW status"
      "Check UFW status (verbose)"
      "Check UFW status (numbered)"
      "Reload UFW"
      "Reset UFW (delete all rules)"
      "Allow port"
      "Deny port"
      "Delete rule by number"
      "Allow specific IP"
      "Deny specific IP"
      "Allow from IP to port"
      "Deny from IP to port"
      "Allow SSH (port 22)"
      "Allow HTTP (port 80)"
      "Allow HTTPS (port 443)"
      "Allow FTP (port 21)"
      "Allow MySQL (port 3306)"
      "Allow PostgreSQL (port 5432)"
      "Allow MongoDB (port 27017)"
      "Allow Redis (port 6379)"
      "Allow port range"
      "Deny port range"
      "Allow service by name"
      "Deny service by name"
      "Set default incoming policy"
      "Set default outgoing policy"
      "Set default routed policy"
      "Enable logging"
      "Disable logging"
      "Set logging level"
      "Show listening ports"
      "Show added rules"
      "Show raw rules"
      "Allow from subnet"
      "Deny from subnet"
      "Allow to specific interface"
      "Limit connections (rate limiting)"
      "Delete rule by specification"
      "Insert rule at position"
      "Show application profiles"
      "Allow application profile"
      "Deny application profile"
    )
    PS3="Choose a UFW command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2)
                echo "Installing UFW..."
                sudo apt update && sudo apt install -y ufw
                ;;
            3)
                echo "Uninstalling UFW..."
                sudo apt remove -y ufw
                ;;
            4) sudo ufw enable;;
            5) sudo ufw disable;;
            6) sudo ufw status;;
            7) sudo ufw status verbose;;
            8) sudo ufw status numbered;;
            9) sudo ufw reload;;
            10)
                read -rp "Are you sure you want to reset UFW? (yes/no): " confirm
                if [ "$confirm" = "yes" ]; then
                    sudo ufw --force reset
                fi
                ;;
            11)
                read -rp "Port number to allow: " port
                sudo ufw allow "$port"
                ;;
            12)
                read -rp "Port number to deny: " port
                sudo ufw deny "$port"
                ;;
            13)
                sudo ufw status numbered
                read -rp "Rule number to delete: " num
                sudo ufw --force delete "$num"
                ;;
            14)
                read -rp "IP address to allow: " ip
                sudo ufw allow from "$ip"
                ;;
            15)
                read -rp "IP address to deny: " ip
                sudo ufw deny from "$ip"
                ;;
            16)
                read -rp "IP address: " ip
                read -rp "Port number: " port
                sudo ufw allow from "$ip" to any port "$port"
                ;;
            17)
                read -rp "IP address: " ip
                read -rp "Port number: " port
                sudo ufw deny from "$ip" to any port "$port"
                ;;
            18) sudo ufw allow 22/tcp;;
            19) sudo ufw allow 80/tcp;;
            20) sudo ufw allow 443/tcp;;
            21) sudo ufw allow 21/tcp;;
            22) sudo ufw allow 3306/tcp;;
            23) sudo ufw allow 5432/tcp;;
            24) sudo ufw allow 27017/tcp;;
            25) sudo ufw allow 6379/tcp;;
            26)
                read -rp "Start port: " start
                read -rp "End port: " end
                read -rp "Protocol (tcp/udp): " proto
                sudo ufw allow "$start:$end/$proto"
                ;;
            27)
                read -rp "Start port: " start
                read -rp "End port: " end
                read -rp "Protocol (tcp/udp): " proto
                sudo ufw deny "$start:$end/$proto"
                ;;
            28)
                read -rp "Service name (e.g., ssh, http): " service
                sudo ufw allow "$service"
                ;;
            29)
                read -rp "Service name (e.g., ssh, http): " service
                sudo ufw deny "$service"
                ;;
            30)
                read -rp "Policy (allow/deny/reject): " policy
                sudo ufw default "$policy" incoming
                ;;
            31)
                read -rp "Policy (allow/deny/reject): " policy
                sudo ufw default "$policy" outgoing
                ;;
            32)
                read -rp "Policy (allow/deny/reject): " policy
                sudo ufw default "$policy" routed
                ;;
            33) sudo ufw logging on;;
            34) sudo ufw logging off;;
            35)
                read -rp "Logging level (low/medium/high/full): " level
                sudo ufw logging "$level"
                ;;
            36) sudo ufw show listening;;
            37) sudo ufw show added;;
            38) sudo ufw show raw;;
            39)
                read -rp "Subnet (e.g., 192.168.1.0/24): " subnet
                sudo ufw allow from "$subnet"
                ;;
            40)
                read -rp "Subnet (e.g., 192.168.1.0/24): " subnet
                sudo ufw deny from "$subnet"
                ;;
            41)
                read -rp "Interface name (e.g., eth0): " iface
                read -rp "Port number: " port
                sudo ufw allow in on "$iface" to any port "$port"
                ;;
            42)
                read -rp "Port number to limit: " port
                sudo ufw limit "$port"
                ;;
            43)
                read -rp "Rule specification (e.g., allow 80/tcp): " rule
                sudo ufw delete $rule
                ;;
            44)
                read -rp "Position number: " pos
                read -rp "Rule specification (e.g., allow 80/tcp): " rule
                sudo ufw insert "$pos" $rule
                ;;
            45) sudo ufw app list;;
            46)
                read -rp "Application profile name: " app
                sudo ufw allow "$app"
                ;;
            47)
                read -rp "Application profile name: " app
                sudo ufw deny "$app"
                ;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

ufw_menu
