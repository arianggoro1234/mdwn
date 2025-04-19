#!/bin/bash

function power_operations_menu() {
  local options=(
    "Back to btop Menu"
    "Reboot System"
    "Shutdown System"
    "Suspend System"
    "Log Out Current User"
    "Lock Screen"
  )

  PS3="Choose a power operation: "
  select opt in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        echo -e "Rebooting system..."
        sudo reboot
        ;;
      3)
        echo -e "Shutting down system..."
        sudo shutdown -h now
        ;;
      4)
        if command -v systemctl &> /dev/null; then
          echo -e "Suspending system..."
          sudo systemctl suspend
        else
          echo -e "Suspend not supported on this system."
        fi
        ;;
      5)
        if command -v gnome-session-quit &> /dev/null; then
          gnome-session-quit --logout --no-prompt
        else
          echo -e "Logout not supported on this system."
        fi
        ;;
      6)
        if command -v gnome-screensaver-command &> /dev/null; then
          gnome-screensaver-command -l
        elif command -v loginctl &> /dev/null; then
          loginctl lock-session
        else
          echo -e "Lock screen not supported on this system."
        fi
        ;;
      *)
        echo -e "Invalid option"
        ;;
    esac
  done
}

power_operations_menu