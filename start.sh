#!/bin/bash

# GLOBAL Helper
# shellcheck source=./commands/lib/alacarte.sh
source "$(dirname "$0")/commands/lib/alacarte.sh"

# Main Menu
function main_menu() {
    while true; do
        clear
        echo -e "${green}===== BASIC LINUX COMMANDS MENU =====${reset}"
        local options=(
          "Exit"
          "Check mdwn Update"
          "Directories Navigation"
          "Files & Directories"
          "Networking"
          "User Management"
          "Package Manager"
          "Docker Operation"
          "Apache Operation"
          "PostgresSQL Operation"
          "Microk8s Operation"
          "PHP 56 Operation"
          "PHP 70 Operation"
          "PHP 72 Operation"
          "PHP 73 Operation"
          "PHP 74 Operation"
          "PHP 80 Operation"
          "PHP 81 Operation"
          "PHP 82 Operation"
          "MariaDB Operation"
          "MySQL Operation"
          "Redis Operation"
          "MongoDB Operation"
          "Journalctl Operation"
          "Log Operation"
          "Btop Monitoring"
          "SSH Operation"
          "FTP Operation"
        )
        PS3="Choose an option: "
        select _ in "${options[@]}"; do
            case $REPLY in
                1) echo "Goodbye." && exit 0 ;;
                2) ~/mdwn/commands/mdwn_updater.sh ;;
                3) ~/mdwn/commands/directory_operation.sh ;;
                4) ~/mdwn/commands/file_operation.sh ;;
                5) ~/mdwn/commands/network_operation.sh ;;
                6) ~/mdwn/commands/user_manager.sh ;;
                7) ~/mdwn/commands/package_manager.sh;;
                8) ~/mdwn/commands/docker_operation.sh;;
                9) ~/mdwn/commands/apache_operation.sh;;
                10) ~/mdwn/commands/postgresql_operation.sh;;
                11) ~/mdwn/commands/microk8s_operation.sh;;
                12) ~/mdwn/commands/php56_operation.sh;;
                13) ~/mdwn/commands/php70_operation.sh;;
                14) ~/mdwn/commands/php72_operation.sh;;
                15) ~/mdwn/commands/php73_operation.sh;;
                16) ~/mdwn/commands/php74_operation.sh;;
                17) ~/mdwn/commands/php80_operation.sh;;
                18) ~/mdwn/commands/php81_operation.sh;;
                19) ~/mdwn/commands/php82_operation.sh;;
                20) ~/mdwn/commands/mariadb_operation.sh;;
                21) ~/mdwn/commands/mysql_operation.sh;;
                22) ~/mdwn/commands/redis_operation.sh;;
                23) ~/mdwn/commands/mongodb_operation.sh;;
                24) ~/mdwn/commands/journalctl_operation.sh;;
                25) ~/mdwn/commands/tail_log_operation.sh;;
                26) ~/mdwn/commands/btop_operation.sh.sh;;
                27) ~/mdwn/commands/ssh_operation.sh;;
                28) ~/mdwn/commands/ftp_operation.sh;;
                *) echo -e "${red}Invalid option${reset}" ;;
            esac
            break  # After executing a command, go back to the main menu
        done
    done
}

main_menu
