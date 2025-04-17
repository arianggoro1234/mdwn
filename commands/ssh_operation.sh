#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function ssh_menu() {
  local options=(
    "Back to Main Menu"
    "Generate SSH Key (id_rsa)"
    "Generate SSH Key with a Custom Filename"
    "View SSH Config"
    "Copy SSH Public Key to Remote Host"
    "SSH into Remote Host"
    "SSH with Local Port Forwarding"
    "SSH with Remote Port Forwarding"
    "SSH with Dynamic Port Forwarding (SOCKS Proxy)"
    "Check SSH Connection"
    "Show SSH Manual (man)"
  )

  PS3="Choose an SSH management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        read -rp "Enter passphrase for the new SSH key (or leave empty for no passphrase): " passphrase
        ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/id_rsa" -N "${passphrase}"
        echo "✅ SSH key id_rsa generated successfully"
        ;;
      3)
        read -rp "Enter custom filename for SSH key: " filename
        read -rp "Enter passphrase for the new SSH key (or leave empty for no passphrase): " passphrase
        ssh-keygen -t rsa -b 4096 -f "$HOME/.ssh/$filename" -N "${passphrase}"
        echo "✅ SSH key $filename generated successfully"
        ;;
      4)
        cat "$HOME/.ssh/config"
        ;;
      5)
        read -rp "Enter remote host address: " host
        read -rp "Enter username for the remote host: " user
        ssh-copy-id "${user}@${host}"
        echo "✅ SSH public key copied to remote host"
        ;;
      6)
        read -rp "Enter remote host address: " host
        read -rp "Enter username for the remote host: " user
        echo -e "Attempting SSH connection to ${user}@${host}. Please confirm."
        read -rp "Are you sure you want to continue? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
          if ssh "${user}@${host}"; then
            echo "✅ SSH connection successful."
          else
            echo "❌ SSH connection failed."
          fi
        else
          echo "❌ SSH connection aborted."
        fi
        ;;
      7)
        read -rp "Enter remote host address: " host
        read -rp "Enter local port to forward: " local_port
        read -rp "Enter remote port to forward: " remote_port
        echo -e "Starting SSH with local port forwarding: ${local_port} -> ${remote_port} on ${host}. Please confirm."
        read -rp "Are you sure you want to continue? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
          if ssh -L "${local_port}:localhost:${remote_port}" "${host}"; then
            echo "✅ SSH with local port forwarding successful."
          else
            echo "❌ SSH with local port forwarding failed."
          fi
        else
          echo "❌ SSH with local port forwarding aborted."
        fi
        ;;
      8)
        read -rp "Enter remote host address: " host
        read -rp "Enter local port to forward: " local_port
        read -rp "Enter remote port to forward: " remote_port
        echo -e "Starting SSH with remote port forwarding: ${local_port} -> ${remote_port} on ${host}. Please confirm."
        read -rp "Are you sure you want to continue? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
          if ssh -R "${remote_port}:localhost:${local_port}" "${host}"; then
            echo "✅ SSH with remote port forwarding successful."
          else
            echo "❌ SSH with remote port forwarding failed."
          fi
        else
          echo "❌ SSH with remote port forwarding aborted."
        fi
        ;;
      9)
        read -rp "Enter remote host address: " host
        read -rp "Enter SOCKS proxy port: " socks_port
        echo -e "Starting SSH with dynamic port forwarding (SOCKS proxy) on ${socks_port}. Please confirm."
        read -rp "Are you sure you want to continue? (y/n): " confirm
        if [[ "$confirm" == "y" ]]; then
          if ssh -D "${socks_port}" "${host}"; then
            echo "✅ SSH with dynamic port forwarding successful."
          else
            echo "❌ SSH with dynamic port forwarding failed."
          fi
        else
          echo "❌ SSH with dynamic port forwarding aborted."
        fi
        ;;
      10)
        read -rp "Enter remote host address: " host
        read -rp "Enter username for the remote host: " user
        if ssh -T "${user}@${host}" exit; then
          echo "✅ SSH connection successful."
        else
          echo "❌ SSH connection failed."
        fi
        ;;
      11)
        man ssh
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

ssh_menu
