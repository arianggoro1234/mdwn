#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function mongodb_menu() {
  local options=(
    "Back to Main Menu"
    "Install MongoDB"
    "Start MongoDB Service"
    "Stop MongoDB Service"
    "Restart MongoDB Service"
    "Enable MongoDB on Boot"
    "Check MongoDB Status"
    "Login to MongoDB Shell"
    "Show MongoDB Config"
    "Show MongoDB Version"
    "Show MongoDB Help (man)"
    "Backup MongoDB Database"
    "Restore MongoDB Database"
    "Show Running MongoDB Processes"
    "Flush MongoDB Databases"
    "Show MongoDB Collections"
    "Create MongoDB User"
    "Drop MongoDB User"
  )

  PS3="Choose a MongoDB management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo apt update
        sudo apt install -y mongodb
        echo "✅ MongoDB installed"
        ;;
      3)
        sudo systemctl start mongodb
        echo "✅ MongoDB started"
        ;;
      4)
        sudo systemctl stop mongodb
        echo "✅ MongoDB stopped"
        ;;
      5)
        sudo systemctl restart mongodb
        echo "✅ MongoDB restarted"
        ;;
      6)
        sudo systemctl enable mongodb
        echo "✅ MongoDB enabled on boot"
        ;;
      7)
        sudo systemctl status mongodb
        ;;
      8)
        mongo
        ;;
      9)
        sudo cat /etc/mongodb.conf
        ;;
      10)
        mongo --version
        ;;
      11)
        man mongo | less
        ;;
      12)
        read -rp "Enter backup file name: " outfile
        mongodump --out "${outfile}"
        echo "✅ MongoDB database backed up to ${outfile}"
        ;;
      13)
        read -rp "Enter backup file to restore: " infile
        mongorestore "${infile}"
        echo "✅ MongoDB database restored from ${infile}"
        ;;
      14)
        ps aux | pgrep mongod
        ;;
      15)
        mongo --eval "db.adminCommand({flushRouterConfig: 1})"
        echo "✅ MongoDB databases flushed"
        ;;
      16)
        read -rp "Enter database name: " dbname
        mongo "${dbname}" --eval "db.getCollectionNames()"
        ;;
      17)
        read -rp "Enter username for new MongoDB user: " username
        read -rp "Enter password for new MongoDB user: " password
        mongo --eval "db.createUser({user: '${username}', pwd: '${password}', roles: [{role: 'readWrite', db: 'admin'}]})"
        echo "✅ MongoDB user ${username} created"
        ;;
      18)
        read -rp "Enter username to drop MongoDB user: " username
        mongo --eval "db.dropUser('${username}')"
        echo "✅ MongoDB user ${username} dropped"
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

mongodb_menu
