#!/bin/bash

# GLOBAL Helper
source "$(dirname "$0")/commands/lib/alacarte.sh"

function main_menu() {
    while true; do
        clear
        echo -e "${green}===== BASIC LINUX COMMANDS MENU =====${reset}"
        local options=(
          "Exit"
          "Check mdwn Update"
          "Directories Navigation"
          "Files & Directories"
          "Package Manager"
          "Power Operation"
          "Journalctl Operation"
          "Log Operation"
          "Btop Monitoring"
          "Screenfetch Monitoring"
          "User Management"
          "Apache Operation"
          "Docker Operation"
          "FTP Operation"
          "MariaDB Operation"
          "Microk8s Operation"
          "MongoDB Operation"
          "MySQL Operation"
          "Networking"
          "PHP 56 Operation"
          "PHP 70 Operation"
          "PHP 72 Operation"
          "PHP 73 Operation"
          "PHP 74 Operation"
          "PHP 80 Operation"
          "PHP 81 Operation"
          "PHP 82 Operation"
          "PostgresSQL Operation"
          "Redis Operation"
          "SSH Operation"
          "Composer Operation"
          "ZIP Operation"
          "TAR Operation"
          "Webmin Operation"
          "Hestia Operation"
          "CASAOS Operation"
          "Supervisor Operation"
          "UFW Operation"
        )
        PS3="Choose an option: "
        select _ in "${options[@]}"; do
            case "$REPLY" in
                1) echo "Goodbye." && exit 0;;
                2) ~/mdwn/commands/mdwn_updater.sh;;
                3) ~/mdwn/commands/directory_operation.sh;;
                4) ~/mdwn/commands/file_operation.sh;;
                5) ~/mdwn/commands/package_manager.sh;;
                6) ~/mdwn/commands/power_operation.sh;;
                7) ~/mdwn/commands/journalctl_operation.sh;;
                8) ~/mdwn/commands/tail_log_operation.sh;;
                9) ~/mdwn/commands/btop_operation.sh;;
                10) ~/mdwn/commands/screenfetch_operation.sh;;
                11) ~/mdwn/commands/user_manager.sh;;
                12) ~/mdwn/commands/apache_operation.sh;;
                13) ~/mdwn/commands/docker_operation.sh;;
                14) ~/mdwn/commands/ftp_operation.sh;;
                15) ~/mdwn/commands/mariadb_operation.sh;;
                16) ~/mdwn/commands/microk8s_operation.sh;;
                17) ~/mdwn/commands/mongodb_operation.sh;;
                18) ~/mdwn/commands/mysql_operation.sh;;
                19) ~/mdwn/commands/network_operation.sh;;
                20) ~/mdwn/commands/php56_operation.sh;;
                21) ~/mdwn/commands/php70_operation.sh;;
                22) ~/mdwn/commands/php72_operation.sh;;
                23) ~/mdwn/commands/php73_operation.sh;;
                24) ~/mdwn/commands/php74_operation.sh;;
                25) ~/mdwn/commands/php80_operation.sh;;
                26) ~/mdwn/commands/php81_operation.sh;;
                27) ~/mdwn/commands/php82_operation.sh;;
                28) ~/mdwn/commands/postgresql_operation.sh;;
                29) ~/mdwn/commands/redis_operation.sh;;
                30) ~/mdwn/commands/ssh_operation.sh;;
                31) ~/mdwn/commands/composer_operation.sh;;
                32) ~/mdwn/commands/zip_operation.sh;;
                33) ~/mdwn/commands/tar_operation.sh;;
                34) ~/mdwn/commands/webmin_operation.sh;;
                35) ~/mdwn/commands/hestia_operation.sh;;
                36) ~/mdwn/commands/casaos.sh;;
                37) ~/mdwn/commands/supervisor.sh;;
                38) ~/mdwn/commands/ufw.sh;;
                *) echo -e "${red}Invalid option${reset}";;
            esac
            break
        done
    done
}

main_menu
