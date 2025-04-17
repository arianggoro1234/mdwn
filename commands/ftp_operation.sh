#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function ftp_menu() {
  local options=(
    "Back to Main Menu"
    "Start FTP Session"
    "Login to FTP Server"
    "List Files on FTP Server"
    "Change Directory on FTP Server"
    "Upload a File to FTP Server"
    "Download a File from FTP Server"
    "Delete a File on FTP Server"
    "Rename a File on FTP Server"
    "Create Directory on FTP Server"
    "Remove Directory on FTP Server"
    "Display Current FTP Working Directory"
    "Show FTP Help (man)"
  )

  PS3="Choose an FTP operation: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        read -rp "Enter FTP server address: " server
        ftp "${server}"
        ;;
      3)
        read -rp "Enter FTP server address: " server
        read -rp "Enter username: " username
        read -rsp "Enter password: " password
        echo
        ftp -n "${server}" <<EOF
user ${username} ${password}
EOF
        ;;
      4)
        read -rp "Enter FTP server address: " server
        ftp "${server}" <<EOF
ls
EOF
        ;;
      5)
        read -rp "Enter FTP server address: " server
        read -rp "Enter directory to change to: " directory
        ftp "${server}" <<EOF
cd ${directory}
EOF
        ;;
      6)
        read -rp "Enter FTP server address: " server
        read -rp "Enter local file to upload: " local_file
        read -rp "Enter remote file path: " remote_file
        ftp "${server}" <<EOF
put ${local_file} ${remote_file}
EOF
        ;;
      7)
        read -rp "Enter FTP server address: " server
        read -rp "Enter remote file to download: " remote_file
        read -rp "Enter local file path: " local_file
        ftp "${server}" <<EOF
get ${remote_file} ${local_file}
EOF
        ;;
      8)
        read -rp "Enter FTP server address: " server
        read -rp "Enter remote file to delete: " remote_file
        ftp "${server}" <<EOF
delete ${remote_file}
EOF
        ;;
      9)
        read -rp "Enter FTP server address: " server
        read -rp "Enter current file name: " current_name
        read -rp "Enter new file name: " new_name
        ftp "${server}" <<EOF
rename ${current_name} ${new_name}
EOF
        ;;
      10)
        read -rp "Enter FTP server address: " server
        read -rp "Enter directory to create: " directory
        ftp "${server}" <<EOF
mkdir ${directory}
EOF
        ;;
      11)
        read -rp "Enter FTP server address: " server
        read -rp "Enter directory to remove: " directory
        ftp "${server}" <<EOF
rmdir ${directory}
EOF
        ;;
      12)
        read -rp "Enter FTP server address: " server
        ftp "${server}" <<EOF
pwd
EOF
        ;;
      13)
        man ftp
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

ftp_menu
