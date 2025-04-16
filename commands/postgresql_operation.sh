#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function postgres_menu() {
    local options=(
      "Back to Main Menu"
      "Install PostgreSQL"
      "Uninstall PostgreSQL"
      "Start PostgreSQL service"
      "Stop PostgreSQL service"
      "Restart PostgreSQL service"
      "Enable PostgreSQL on boot"
      "Disable PostgreSQL on boot"
      "Reload PostgreSQL config"
      "Check PostgreSQL status"
      "Access PostgreSQL (psql)"
      "Check PostgreSQL version"
      "List all databases"
      "List all users"
      "Create new database"
      "Drop database"
      "Create new user"
      "Drop user"
      "Change user password"
      "Run SQL command"
      "Show PostgreSQL help"
    )
    PS3="Choose a PostgreSQL command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2)
                echo "Installing PostgreSQL..."
                sudo apt update && sudo apt install -y postgresql postgresql-contrib
                ;;
            3)
                echo "Uninstalling PostgreSQL..."
                sudo apt purge -y postgresql* && sudo apt autoremove -y
                ;;
            4) sudo systemctl start postgresql;;
            5) sudo systemctl stop postgresql;;
            6) sudo systemctl restart postgresql;;
            7) sudo systemctl enable postgresql;;
            8) sudo systemctl disable postgresql;;
            9) sudo systemctl reload postgresql;;
            10) sudo systemctl status postgresql;;
            11) sudo -u postgres psql;;
            12) postgres -V;;
            13) sudo -u postgres psql -c "\l";;
            14) sudo -u postgres psql -c "\du";;
            15)
                read -rp "New database name: " dbname
                sudo -u postgres createdb "$dbname"
                ;;
            16)
                read -rp "Database name to drop: " dbname
                sudo -u postgres dropdb "$dbname"
                ;;
            17)
                read -rp "New username: " username
                sudo -u postgres createuser --interactive "$username"
                ;;
            18)
                read -rp "Username to drop: " username
                sudo -u postgres dropuser "$username"
                ;;
            19)
                read -rp "Username: " username
                sudo -u postgres psql -c "ALTER USER $username WITH PASSWORD '$(read -rsp "New password: " pw && echo "$pw")';"
                ;;
            20)
                read -rp "Enter SQL command: " sql
                sudo -u postgres psql -c "$sql"
                ;;
            21) man postgres;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

postgres_menu
