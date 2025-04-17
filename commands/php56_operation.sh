#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php56_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 5.6 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 5.6 (CLI)"
    "Set Apache to Use PHP 5.6"
    "Install Additional PHP 5.6 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 5.6 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y apache2 curl
        sudo apt-get install -y php5.6 libapache2-mod-php5.6 libapache2-mod-auth-openidc \
          php5.6-bcmath php5.6-cli php5.6-curl php5.6-mbstring php5.6-gd php5.6-mysql \
          php5.6-json php5.6-ldap php5.6-memcached php5.6-tidy php5.6-intl php5.6-xmlrpc \
          php5.6-soap php5.6-uploadprogress php5.6-zip php5.6-dev php5.6-common \
          php5.6-xml php5.6-pgsql php-pear build-essential
        echo "✅ PHP 5.6 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php5.6
        echo "✅ PHP CLI switched to PHP 5.6"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php5.6
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 5.6"
        ;;
      6)
        read -rp "Enter PHP 5.6 extension name (e.g., imagick): " ext
        sudo apt install -y "php5.6-$ext"
        echo "✅ Extension php5.6-$ext installed"
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

php56_menu
