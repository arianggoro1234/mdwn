#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php84_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 8.4 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 8.4 (CLI)"
    "Set Apache to Use PHP 8.4"
    "Install Additional PHP 8.4 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 8.4 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        # Note: php-json is included in core.
        sudo apt-get install -y php8.4 libapache2-mod-php8.4 libapache2-mod-auth-openidc \
          php8.4-bcmath php8.4-cli php8.4-curl php8.4-mbstring php8.4-gd php8.4-mysql \
          php8.4-ldap php8.4-memcached php8.4-tidy php8.4-intl php8.4-xmlrpc \
          php8.4-soap php8.4-uploadprogress php8.4-zip php8.4-dev php8.4-common \
          php8.4-xml php8.4-pgsql php8.4-readline php8.4-opcache php8.4-imap \
          php8.4-enchant php8.4-gmp php8.4-snmp php8.4-sybase php8.4-xsl
        echo "✅ PHP 8.4 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php8.4
        echo "✅ PHP CLI switched to PHP 8.4"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php8.4
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 8.4"
        ;;
      6)
        read -rp "Enter PHP 8.4 extension name (e.g., imagick): " ext
        sudo apt install -y "php8.4-$ext"
        echo "✅ Extension php8.4-$ext installed"
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

php84_menu
