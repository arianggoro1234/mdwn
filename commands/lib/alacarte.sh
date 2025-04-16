#!/bin/bash

# Exported color variables
export red='\033[0;31m'
export green='\033[0;32m'
export yellow='\033[0;33m'
export reset='\033[0m'


# Define functions first, then export them
print_line() {
    echo -e "${green}=============================================${reset}\n"
}
export -f print_line

print_start() {
    echo -e "${yellow}============= START ===============${reset}"
}
export -f print_start

print_end() {
    echo -e "${yellow}============== END ================${reset}\n"
}
export -f print_end

# Exported function: Execute command
execute_cmd() {
    local command=$1
    print_start
    echo -e "Executing => ${green}$command${reset}"
    print_line
    eval "$command"
    print_end
    read -rp "Press Enter to return to menu..."
}
export -f execute_cmd