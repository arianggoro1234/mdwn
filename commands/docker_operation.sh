#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

# Docker Submenu
function docker_menu() {
    local options=(
      "Back to Main Menu"
      "Install Docker (via apt)"
      "Uninstall Docker"
      "Start Docker service"
      "Stop Docker service"
      "Restart Docker service"
      "Enable Docker on boot"
      "Disable Docker on boot"
      "Check Docker service status"
      "Reload Docker daemon"
      "Run container (docker run)"
      "List containers (docker ps)"
      "List all containers (docker ps -a)"
      "Stop container"
      "Start container"
      "Remove container"
      "Pull image"
      "List images"
      "Remove image"
      "Show system info (docker info)"
      "Show disk usage (docker system df)"
      "Prune unused objects"
      "Build image from Dockerfile"
      "View container logs"
      "Execute command in container"
      "List volumes"
      "Create volume"
      "Remove volume"
      "List networks"
      "Create network"
      "Remove network"
      "Show help (docker --help)"
    )
    PS3="Choose a Docker command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2)
                echo "Installing Docker..."
                sudo apt update && \
                sudo apt install -y apt-transport-https ca-certificates curl software-properties-common && \
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
                echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
                sudo apt update && \
                sudo apt install -y docker-ce
                ;;
            3) sudo apt remove -y docker-ce docker-ce-cli containerd.io;;
            4) sudo systemctl start docker;;
            5) sudo systemctl stop docker;;
            6) sudo systemctl restart docker;;
            7) sudo systemctl enable docker;;
            8) sudo systemctl disable docker;;
            9) sudo systemctl status docker;;
            10) sudo systemctl daemon-reexec;;
            11)
                read -rp "Image name: " img
                read -rp "Container name (optional): " cname
                docker run -it --name "$cname" "$img"
                ;;
            12) docker ps;;
            13) docker ps -a;;
            14)
                read -rp "Container ID or name to stop: " cid
                docker stop "$cid"
                ;;
            15)
                read -rp "Container ID or name to start: " cid
                docker start "$cid"
                ;;
            16)
                read -rp "Container ID or name to remove: " cid
                docker rm "$cid"
                ;;
            17)
                read -rp "Image to pull (e.g. ubuntu:latest): " img
                docker pull "$img"
                ;;
            18) docker images;;
            19)
                read -rp "Image ID or name to remove: " img
                docker rmi "$img"
                ;;
            20) docker info;;
            21) docker system df;;
            22) docker system prune -f;;
            23)
                read -rp "Path to Dockerfile directory: " path
                read -rp "Tag for image: " tag
                docker build -t "$tag" "$path"
                ;;
            24)
                read -rp "Container ID or name for logs: " cid
                docker logs "$cid"
                ;;
            25)
                read -rp "Container ID or name: " cid
                read -rp "Command to execute: " cmd
                docker exec -it "$cid" "$cmd"
                ;;
            26) docker volume ls;;
            27)
                read -rp "Volume name to create: " vname
                docker volume create "$vname"
                ;;
            28)
                read -rp "Volume name to remove: " vname
                docker volume rm "$vname"
                ;;
            29) docker network ls;;
            30)
                read -rp "Network name to create: " nname
                docker network create "$nname"
                ;;
            31)
                read -rp "Network name to remove: " nname
                docker network rm "$nname"
                ;;
            32) docker --help;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

docker_menu
