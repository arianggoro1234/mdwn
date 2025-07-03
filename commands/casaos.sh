#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function casaos_menu() {
  local options=(
    "Back to Main Menu"
    "Install CasaOS"
    "Update CasaOS"
    "Start CasaOS Services"
    "Stop CasaOS Services"
    "Restart CasaOS Services"
    "Check CasaOS Status"
    "Enable CasaOS on Boot"
    "Show CasaOS Version"
    "Uninstall CasaOS"
    "Open CasaOS in Browser"
  )

  PS3="Choose a CasaOS management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        curl -fsSL https://get.casaos.io | sudo bash
        echo "✅ CasaOS installed"
        ;;
      3)
        casaos-cli update
        echo "✅ CasaOS updated"
        ;;
      4)
        sudo systemctl start casaos-* 
        echo "✅ CasaOS services started"
        ;;
      5)
        sudo systemctl stop casaos-* 
        echo "✅ CasaOS services stopped"
        ;;
      6)
        sudo systemctl restart casaos-* 
        echo "✅ CasaOS services restarted"
        ;;
      7)
        systemctl status casaos-* 
        ;;
      8)
        sudo systemctl enable casaos-* 
        echo "✅ CasaOS enabled on boot"
        ;;
      9)
        casaos-cli version
        ;;
      10)
        sudo bash -c "apt remove -y casaos && rm -rf /etc/casaos /var/lib/casaos /opt/casaos"
        echo "✅ CasaOS uninstalled"
        ;;
      11)
        if command -v xdg-open >/dev/null; then
          xdg-open http://localhost:port
        elif command -v open >/dev/null; then
          open http://localhost:port
        else
          echo "🌐 Please open http://localhost:port in your browser manually."
        fi
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

casaos_menu
