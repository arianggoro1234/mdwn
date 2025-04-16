#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function apache_menu() {
    local options=(
      "Back to Main Menu"
      "Install Apache2"
      "Uninstall Apache2"
      "Start Apache2 service"
      "Stop Apache2 service"
      "Restart Apache2 service"
      "Enable Apache2 on boot"
      "Disable Apache2 on boot"
      "Reload Apache2 config"
      "Check Apache2 status"
      "Test Apache2 config (apache2ctl configtest)"
      "Graceful restart (apache2ctl graceful)"
      "Full restart (apache2ctl restart)"
      "Check Apache2 version"
      "Show server info (apache2ctl -V)"
      "List enabled modules"
      "Enable module (a2enmod)"
      "Disable module (a2dismod)"
      "List enabled sites"
      "Enable site (a2ensite)"
      "Disable site (a2dissite)"
      "Show help (apache2ctl -h)"
    )
    PS3="Choose an Apache2 command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2)
                echo "Installing Apache2..."
                sudo apt update && sudo apt install -y apache2
                ;;
            3)
                echo "Uninstalling Apache2..."
                sudo apt remove -y apache2 apache2-utils apache2-bin apache2.2-common
                ;;
            4) sudo systemctl start apache2;;
            5) sudo systemctl stop apache2;;
            6) sudo systemctl restart apache2;;
            7) sudo systemctl enable apache2;;
            8) sudo systemctl disable apache2;;
            9) sudo systemctl reload apache2;;
            10) sudo systemctl status apache2;;
            11) sudo apache2ctl configtest;;
            12) sudo apache2ctl graceful;;
            13) sudo apache2ctl restart;;
            14) apache2 -v;;
            15) apache2ctl -V;;
            16) apache2ctl -M;;
            17)
                read -rp "Module to enable: " mod
                sudo a2enmod "$mod" && sudo systemctl restart apache2
                ;;
            18)
                read -rp "Module to disable: " mod
                sudo a2dismod "$mod" && sudo systemctl restart apache2
                ;;
            19) ls /etc/apache2/sites-enabled;;
            20)
                read -rp "Site config to enable (e.g. mysite.conf): " site
                sudo a2ensite "$site" && sudo systemctl reload apache2
                ;;
            21)
                read -rp "Site config to disable (e.g. mysite.conf): " site
                sudo a2dissite "$site" && sudo systemctl reload apache2
                ;;
            22) apache2ctl -h;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

apache_menu
