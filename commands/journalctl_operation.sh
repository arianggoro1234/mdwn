#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function system_journal_menu() {
  local options=(
    "Back to Main Menu"
    "View System Logs"
    "View Logs for Specific Service"
    "Follow Real-Time System Logs"
    "Show Logs for a Specific Time Period"
    "View Boot Logs"
    "View Logs for a Specific Priority"
    "Clear System Journal Logs"
    "Show Kernel Logs"
    "Show Logs for a Specific User"
    "Show Logs for a Specific Unit"
    "Show Logs for a Specific Message"
    "Show System Boot Information"
    "Show Journal Disk Space Usage"
    "Show Journal Configuration"
    "View Journalctl Help (man)"
  )

  PS3="Choose a system journal option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo journalctl | less
        ;;
      3)
        read -rp "Enter service name (e.g., apache2): " service
        sudo journalctl -u "$service" | less
        ;;
      4)
        sudo journalctl -f
        ;;
      5)
        read -rp "Enter start time (e.g., '2025-04-17 10:00:00'): " start_time
        read -rp "Enter end time (e.g., '2025-04-17 12:00:00'): " end_time
        sudo journalctl --since "$start_time" --until "$end_time" | less
        ;;
      6)
        sudo journalctl -b | less
        ;;
      7)
        read -rp "Enter log priority (e.g., 'err', 'warning', 'info'): " priority
        sudo journalctl -p "$priority" | less
        ;;
      8)
        sudo journalctl --vacuum-time=1d
        echo "✅ Journal logs older than 1 day have been cleared."
        ;;
      9)
        sudo journalctl -k | less
        ;;
      10)
        read -rp "Enter username: " username
        sudo journalctl "_UID=$(id -u "$username")" | less
        ;;
      11)
        read -rp "Enter unit name (e.g., apache2.service): " unit
        sudo journalctl -u "$unit" | less
        ;;
      12)
        read -rp "Enter search term (e.g., 'error'): " search_term
        sudo journalctl | grep "$search_term" | less
        ;;
      13)
        sudo journalctl --list-boots | less
        ;;
      14)
        sudo journalctl --disk-usage
        ;;
      15)
        sudo cat /etc/systemd/journald.conf
        ;;
      16)
        man journalctl
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

system_journal_menu
