#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php80_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 8.0 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 8.0 (CLI)"
    "Set Apache to Use PHP 8.0"
    "Install Additional PHP 8.0 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 8.0 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        sudo apt-get install -y php8.0 libapache2-mod-php8.0 libapache2-mod-auth-openidc \
          php8.0-bcmath php8.0-cli php8.0-curl php8.0-mbstring php8.0-gd php8.0-mysql \
          php8.0-json php8.0-ldap php8.0-memcached php8.0-tidy php8.0-intl php8.0-soap \
          php8.0-uploadprogress php8.0-zip php8.0-dev php8.0-common php8.0-xml php8.0-pgsql
        echo "✅ PHP 8.0 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php8.0
        echo "✅ PHP CLI switched to PHP 8.0"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php8.0
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 8.0"
        ;;
      6)
        read -rp "Enter PHP 8.0 extension name (e.g., imagick): " ext
        sudo apt install -y "php8.0-$ext"
        echo "✅ Extension php8.0-$ext installed"
        ;;
      7)
        php -m | less
        ;;
      8)
        php -v
        ;;
      9)
        php -i | less
        ;;
      10)
        sudo systemctl restart apache2
        echo "✅ Apache restarted"
        ;;
      *)
        echo -e "${red}Invalid option${reset}"
        ;;
    esac
  done
}

php80_menu
