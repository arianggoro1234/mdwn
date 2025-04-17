#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function mariadb_menu() {
  local options=(
    "Back to Main Menu"
    "Install MariaDB"
    "Start MariaDB Service"
    "Stop MariaDB Service"
    "Restart MariaDB Service"
    "Enable MariaDB on Boot"
    "Check MariaDB Status"
    "Secure MariaDB Installation"
    "Login to MariaDB (mysql)"
    "Create Database"
    "Create User"
    "Grant Privileges"
    "List Databases"
    "List Users"
    "Run SQL Query"
    "Backup Database"
    "Restore Database"
    "Show MariaDB Version"
    "Show MariaDB Help (man)"
  )

  PS3="Choose a MariaDB management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo apt update
        sudo apt install -y mariadb-server mariadb-client
        echo "✅ MariaDB installed"
        ;;
      3)
        sudo systemctl start mariadb
        echo "✅ MariaDB started"
        ;;
      4)
        sudo systemctl stop mariadb
        echo "✅ MariaDB stopped"
        ;;
      5)
        sudo systemctl restart mariadb
        echo "✅ MariaDB restarted"
        ;;
      6)
        sudo systemctl enable mariadb
        echo "✅ MariaDB enabled on boot"
        ;;
      7)
        sudo systemctl status mariadb
        ;;
      8)
        sudo mysql_secure_installation
        ;;
      9)
        sudo mariadb -u root -p
        ;;
      10)
        read -rp "Enter new database name: " dbname
        sudo mariadb -u root -p -e "CREATE DATABASE ${dbname};"
        echo "✅ Database ${dbname} created"
        ;;
      11)
        read -rp "Enter new username: " username
        read -rp "Enter password: " password
        sudo mariadb -u root -p -e "CREATE USER '${username}'@'localhost' IDENTIFIED BY '${password}';"
        echo "✅ User ${username} created"
        ;;
      12)
        read -rp "Enter username: " username
        read -rp "Enter database name: " dbname
        sudo mariadb -u root -p -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost'; FLUSH PRIVILEGES;"
        echo "✅ Privileges granted"
        ;;
      13)
        sudo mariadb -u root -p -e "SHOW DATABASES;"
        ;;
      14)
        sudo mariadb -u root -p -e "SELECT user, host FROM mysql.user;"
        ;;
      15)
        read -rp "Enter SQL query: " sql
        sudo mariadb -u root -p -e "${sql}"
        ;;
      16)
        read -rp "Enter database name to back up: " dbname
        read -rp "Enter output file name: " outfile
        sudo mariadb-dump -u root -p "${dbname}" > "${outfile}"
        echo "✅ Backup saved to ${outfile}"
        ;;
      17)
        read -rp "Enter database name to restore to: " dbname
        read -rp "Enter input file: " infile
        sudo mariadb -u root -p "${dbname}" < "${infile}"
        echo "✅ Database ${dbname} restored"
        ;;
      18)
        mariadb --version
        ;;
      19)
        man mariadb | less
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

mariadb_menu
