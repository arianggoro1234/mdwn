#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function redis_menu() {
  local options=(
    "Back to Main Menu"
    "Install Redis"
    "Start Redis Service"
    "Stop Redis Service"
    "Restart Redis Service"
    "Enable Redis on Boot"
    "Check Redis Status"
    "Login to Redis CLI"
    "Show Redis Config"
    "Flush All Databases"
    "List Redis Databases"
    "Set Key in Redis"
    "Get Key from Redis"
    "Delete Key from Redis"
    "Backup Redis Database"
    "Restore Redis Database"
    "Show Redis Version"
    "Show Redis Help (man)"
  )

  PS3="Choose a Redis management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo apt update
        sudo apt install -y redis-server
        echo "✅ Redis installed"
        ;;
      3)
        sudo systemctl start redis
        echo "✅ Redis started"
        ;;
      4)
        sudo systemctl stop redis
        echo "✅ Redis stopped"
        ;;
      5)
        sudo systemctl restart redis
        echo "✅ Redis restarted"
        ;;
      6)
        sudo systemctl enable redis
        echo "✅ Redis enabled on boot"
        ;;
      7)
        sudo systemctl status redis
        ;;
      8)
        redis-cli
        ;;
      9)
        sudo cat /etc/redis/redis.conf
        ;;
      10)
        redis-cli flushall
        echo "✅ All Redis databases flushed"
        ;;
      11)
        redis-cli info keyspace
        ;;
      12)
        read -rp "Enter key name: " key
        read -rp "Enter value: " value
        redis-cli set "${key}" "${value}"
        echo "✅ Key ${key} set to ${value}"
        ;;
      13)
        read -rp "Enter key name: " key
        redis-cli get "${key}"
        ;;
      14)
        read -rp "Enter key name: " key
        redis-cli del "${key}"
        echo "✅ Key ${key} deleted"
        ;;
      15)
        read -rp "Enter backup file name: " outfile
        sudo redis-cli save
        sudo cp /var/lib/redis/dump.rdb "${outfile}"
        echo "✅ Redis database backed up to ${outfile}"
        ;;
      16)
        read -rp "Enter backup file to restore: " infile
        sudo cp "${infile}" /var/lib/redis/dump.rdb
        sudo systemctl restart redis
        echo "✅ Redis database restored from ${infile}"
        ;;
      17)
        redis-server --version
        ;;
      18)
        man redis-server | less
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

redis_menu
