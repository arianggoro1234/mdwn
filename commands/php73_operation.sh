#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php73_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 7.3 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 7.3 (CLI)"
    "Set Apache to Use PHP 7.3"
    "Install Additional PHP 7.3 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 7.3 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        sudo apt-get install -y php7.3 libapache2-mod-php7.3 libapache2-mod-auth-openidc \
          php7.3-bcmath php7.3-cli php7.3-curl php7.3-mbstring php7.3-gd php7.3-mysql \
          php7.3-json php7.3-ldap php7.3-memcached php7.3-tidy php7.3-intl php7.3-xmlrpc \
          php7.3-soap php7.3-uploadprogress php7.3-zip php7.3-dev php7.3-common \
          php7.3-xml php7.3-pgsql
        echo "✅ PHP 7.3 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php7.3
        echo "✅ PHP CLI switched to PHP 7.3"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php7.3
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 7.3"
        ;;
      6)
        read -rp "Enter PHP 7.3 extension name (e.g., imagick): " ext
        sudo apt install -y "php7.3-$ext"
        echo "✅ Extension php7.3-$ext installed"
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

php73_menu
