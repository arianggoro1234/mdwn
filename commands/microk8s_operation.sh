#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function microk8s_menu() {
    local options=(
      "Back to Main Menu"
      "Install MicroK8s"
      "Uninstall MicroK8s"
      "Start MicroK8s"
      "Stop MicroK8s"
      "Status MicroK8s"
      "Enable Ingress"
      "Enable DNS"
      "Enable Dashboard"
      "Enable Registry"
      "Enable Storage"
      "Enable Metallb"
      "Disable Ingress"
      "Disable DNS"
      "Disable Dashboard"
      "Disable Registry"
      "Disable Storage"
      "Disable Metallb"
      "Check MicroK8s Add-ons"
      "Open Dashboard Proxy"
      "MicroK8s kubectl get all --all-namespaces"
      "MicroK8s kubectl cluster-info"
      "MicroK8s kubectl get nodes"
      "MicroK8s kubectl logs pod"
      "MicroK8s config"
      "MicroK8s reset"
      "MicroK8s refresh-cert"
      "MicroK8s update"
      "MicroK8s Show kubectl get po -n kube-system"
      "MicroK8s inspect"
      "MicroK8s enable modul common"
      "Show MicroK8s help"
    )
    PS3="Choose a MicroK8s command: "
    select _ in "${options[@]}"; do
        case $REPLY in
            1) break;;
            2) sudo snap install microk8s --classic && sudo usermod -a -G microk8s "$USER" && sudo chown -f -R "$USER" ~/.kube && echo "✅ Installed MicroK8s";;
            3) sudo snap remove microk8s && echo "🗑️ MicroK8s removed";;
            4) microk8s start;;
            5) microk8s stop;;
            6) microk8s status --wait-ready;;
            7) microk8s enable ingress;;
            8) microk8s enable dns;;
            9) microk8s enable dashboard;;
            10) microk8s enable registry;;
            11) microk8s enable storage;;
            12)
                read -rp "IP range (e.g., 192.168.1.240-192.168.1.250): " ip_range
                microk8s enable metallb:"$ip_range"
                ;;
            13) microk8s disable ingress;;
            14) microk8s disable dns;;
            15) microk8s disable dashboard;;
            16) microk8s disable registry;;
            17) microk8s disable storage;;
            18) microk8s disable metallb;;
            19) microk8s status --format short;;
            20) microk8s dashboard-proxy;;
            21) microk8s kubectl get all --all-namespaces;;
            22) microk8s kubectl cluster-info;;
            23) microk8s kubectl get nodes;;
            24)
                read -rp "Pod name: " pod
                microk8s kubectl logs "$pod"
                ;;
            25) microk8s config;;
            26) microk8s reset;;
            27) microk8s refresh-certs;;
            28) microk8s update;;
            29) microk8s kubectl get po -n kube-system;;
            30) microk8s inspect;;
            31) 
                microk8s enable dashboard
                microk8s enable dns
                microk8s enable registry
                microk8s enable istio
                microk8s enable hostpath-storage
                microk8s enable ingress
                microk8s enable metrics-server;;
            32) microk8s --help | less;;
            *) echo -e "${red}Invalid option${reset}";;
        esac
    done
}

microk8s_menu
