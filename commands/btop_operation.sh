#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function btop_menu() {
  local options=(
    "Back to Main Menu"
    "Launch btop"
    "View btop Help (man)"
    "Show btop System Information"
    "Show btop CPU Information"
    "Show btop Memory Information"
    "Show btop Network Information"
    "Show btop Disk Information"
    "Show btop Process List"
    "Show btop Services"
    "Show btop Config File"
  )

  PS3="Choose an option for btop: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        btop
        ;;
      3)
        man btop
        ;;
      4)
        btop -i
        ;;
      5)
        btop -c
        ;;
      6)
        btop -m
        ;;
      7)
        btop -n
        ;;
      8)
        btop -d
        ;;
      9)
        btop -p
        ;;
      10)
        btop -s
        ;;
      11)
        cat ~/.config/btop/btop.conf
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

btop_menu
