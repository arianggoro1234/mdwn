#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function mysql_menu() {
  local options=(
    "Back to Main Menu"
    "Install MySQL"
    "Start MySQL Service"
    "Stop MySQL Service"
    "Restart MySQL Service"
    "Enable MySQL on Boot"
    "Check MySQL Status"
    "Secure MySQL Installation"
    "Login to MySQL (mysql)"
    "Create Database"
    "Create User"
    "Grant Privileges"
    "List Databases"
    "List Users"
    "Run SQL Query"
    "Backup Database"
    "Restore Database"
    "Show MySQL Version"
    "Show MySQL Help (man)"
  )

  PS3="Choose a MySQL management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo apt update
        sudo apt install -y mysql-server mysql-client
        echo "✅ MySQL installed"
        ;;
      3)
        sudo systemctl start mysql
        echo "✅ MySQL started"
        ;;
      4)
        sudo systemctl stop mysql
        echo "✅ MySQL stopped"
        ;;
      5)
        sudo systemctl restart mysql
        echo "✅ MySQL restarted"
        ;;
      6)
        sudo systemctl enable mysql
        echo "✅ MySQL enabled on boot"
        ;;
      7)
        sudo systemctl status mysql
        ;;
      8)
        sudo mysql_secure_installation
        ;;
      9)
        sudo mysql -u root -p
        ;;
      10)
        read -rp "Enter new database name: " dbname
        sudo mysql -u root -p -e "CREATE DATABASE ${dbname};"
        echo "✅ Database ${dbname} created"
        ;;
      11)
        read -rp "Enter new username: " username
        read -rp "Enter password: " password
        sudo mysql -u root -p -e "CREATE USER '${username}'@'localhost' IDENTIFIED BY '${password}';"
        echo "✅ User ${username} created"
        ;;
      12)
        read -rp "Enter username: " username
        read -rp "Enter database name: " dbname
        sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost'; FLUSH PRIVILEGES;"
        echo "✅ Privileges granted"
        ;;
      13)
        sudo mysql -u root -p -e "SHOW DATABASES;"
        ;;
      14)
        sudo mysql -u root -p -e "SELECT user, host FROM mysql.user;"
        ;;
      15)
        read -rp "Enter SQL query: " sql
        sudo mysql -u root -p -e "${sql}"
        ;;
      16)
        read -rp "Enter database name to back up: " dbname
        read -rp "Enter output file name: " outfile
        sudo mysqldump -u root -p "${dbname}" > "${outfile}"
        echo "✅ Backup saved to ${outfile}"
        ;;
      17)
        read -rp "Enter database name to restore to: " dbname
        read -rp "Enter input file: " infile
        sudo mysql -u root -p "${dbname}" < "${infile}"
        echo "✅ Database ${dbname} restored"
        ;;
      18)
        mysql --version
        ;;
      19)
        man mysql | less
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

mysql_menu
