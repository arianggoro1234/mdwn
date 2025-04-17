#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php70_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 7.0 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 7.0 (CLI)"
    "Set Apache to Use PHP 7.0"
    "Install Additional PHP 7.0 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 7.0 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        sudo apt-get install -y php7.0 libapache2-mod-php7.0 libapache2-mod-auth-openidc \
          php7.0-bcmath php7.0-cli php7.0-curl php7.0-mbstring php7.0-gd php7.0-mysql \
          php7.0-json php7.0-ldap php7.0-memcached php7.0-tidy php7.0-intl php7.0-xmlrpc \
          php7.0-soap php7.0-uploadprogress php7.0-zip php7.0-dev php7.0-common \
          php7.0-xml php7.0-pgsql
        echo "✅ PHP 7.0 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php7.0
        echo "✅ PHP CLI switched to PHP 7.0"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php7.0
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 7.0"
        ;;
      6)
        read -rp "Enter PHP 7.0 extension name (e.g., imagick): " ext
        sudo apt install -y "php7.0-$ext"
        echo "✅ Extension php7.0-$ext installed"
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

php70_menu
