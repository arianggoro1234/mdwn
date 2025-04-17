#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php81_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 8.1 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 8.1 (CLI)"
    "Set Apache to Use PHP 8.1"
    "Install Additional PHP 8.1 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 8.1 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        sudo apt-get install -y php8.1 libapache2-mod-php8.1 libapache2-mod-auth-openidc \
          php8.1-bcmath php8.1-cli php8.1-curl php8.1-mbstring php8.1-gd php8.1-mysql \
          php8.1-json php8.1-ldap php8.1-memcached php8.1-tidy php8.1-intl php8.1-xmlrpc \
          php8.1-soap php8.1-uploadprogress php8.1-zip php8.1-dev php8.1-common \
          php8.1-xml php8.1-pgsql php8.1-readline php8.1-opcache php8.1-imap \
          php8.1-enchant php8.1-gmp php8.1-snmp php8.1-sybase php8.1-xsl
        echo "✅ PHP 8.1 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php8.1
        echo "✅ PHP CLI switched to PHP 8.1"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php8.1
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 8.1"
        ;;
      6)
        read -rp "Enter PHP 8.1 extension name (e.g., imagick): " ext
        sudo apt install -y "php8.1-$ext"
        echo "✅ Extension php8.1-$ext installed"
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

php81_menu
