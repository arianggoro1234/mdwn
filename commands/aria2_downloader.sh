#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function install_aria2() {
    if ! command -v aria2c &> /dev/null; then
        echo -e "${yellow}⏳ aria2 is not installed. Installing aria2 now...${reset}"
        sudo apt update -y
        sudo apt-get install -y aria2
        if ! command -v aria2c &> /dev/null; then
            echo -e "${red}❌ Failed to install aria2. Please ensure you have an internet connection and sudo privileges.${reset}"
            read -rp "🔙 Press Enter to return..."
            return 1
        fi
        echo -e "${green}✅ aria2 successfully installed!${reset}"
    fi
    return 0
}

function aria2_menu() {
    clear
    echo -e "${green}🚀 ===== ARIA2 DOWNLOADER ===== 🚀${reset}"
    
    install_aria2 || return
    
    # Ensure Downloads directory exists
    local dl_dir="$HOME/Downloads"
    mkdir -p "$dl_dir"

    echo -e "\n🔗 Please enter the URL of the file you want to download:"
    read -rp "URL: " url

    if [[ -z "$url" ]]; then
        echo -e "${red}❌ URL cannot be empty!${reset}"
        read -rp "🔙 Press Enter to return..."
        return
    fi

    echo -e "\n${yellow}💡 --- Recommended Number of Connections (Threads) ---${reset}"
    echo "🐢 1. Slow Internet / Low Spec PC     : 2 - 4"
    echo "⚡ 2. Fast Internet / Mid Spec PC     : 8 - 16"
    echo "🚀 3. Super Fast Internet / High Spec : 16 - 32"
    echo "---------------------------------------------------"
    read -rp "⌨️  Enter the number of connections [Default: 4]: " threads

    # Set default to 4 if empty or not a number
    if [[ -z "$threads" ]] || ! [[ "$threads" =~ ^[0-9]+$ ]]; then
        threads=4
    fi

    echo -e "\n${green}📋 Download Summary:${reset}"
    echo "🌐 URL         : $url"
    echo "📁 Location    : $dl_dir"
    echo "🔀 Connections : $threads"
    echo "🔄 Resume      : Active (Automatic)"
    echo -e "💻 Command     : aria2c -c -x $threads -s $threads -d \"$dl_dir\" \"$url\"\n"

    read -rp "❓ Are you sure you want to start the download? [Y/n]: " confirm
    confirm=${confirm:-Y}

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        echo -e "\n${yellow}⬇️  Starting download...${reset}"
        # Execute aria2 command
        aria2c -c -x "$threads" -s "$threads" -d "$dl_dir" "$url"
        local status=$?

        if [ $status -eq 0 ]; then
            echo -e "\n${green}✅ Download successfully completed! 🎉${reset}"
        else
            echo -e "\n${red}⚠️  Download stopped or an error occurred (Error code: $status). You can resume it later.${reset}"
        fi
    else
        echo -e "\n${yellow}❌ Download cancelled by user.${reset}"
    fi

    read -rp "🔙 Press Enter to return to the main menu..."
}

aria2_menu
