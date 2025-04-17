#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function view_logs_menu() {
  # Mendapatkan daftar file log di /var/log dan subfoldernya
  IFS=$'\n' read -d '' -r -a log_files_array < <(find /var/log -type f)

  # Menyimpan log file dalam array untuk referensi lebih lanjut
  local options=(
    "Back to Main Menu"
    "View Log Files"
    "Tail -f Log File"
  )

  PS3="Choose an option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        # Menampilkan daftar file log yang ditemukan
        echo "Available Log Files:"
        select log in "${log_files_array[@]}"; do
          if [[ -n "$log" ]]; then
            echo "You selected: $log"
            break
          else
            echo -e "${red}Invalid selection. Please try again.${reset}"
          fi
        done
        ;;
      3)
        # Menampilkan daftar file log yang ditemukan
        echo "Available Log Files to Tail -f:"
        select log in "${log_files_array[@]}"; do
          if [[ -n "$log" ]]; then
            echo "You selected: $log"
            tail -f "$log"
            break
          else
            echo -e "${red}Invalid selection. Please try again.${reset}"
          fi
        done
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

view_logs_menu
