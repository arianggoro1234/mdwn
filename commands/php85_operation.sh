#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php85_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 8.5 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 8.5 (CLI)"
    "Set Apache to Use PHP 8.5"
    "Install Additional PHP 8.5 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 8.5 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        # Note: php-json is included in core.
        sudo apt-get install -y php8.5 libapache2-mod-php8.5 libapache2-mod-auth-openidc \
          php8.5-bcmath php8.5-cli php8.5-curl php8.5-mbstring php8.5-gd php8.5-mysql \
          php8.5-ldap php8.5-memcached php8.5-tidy php8.5-intl php8.5-xmlrpc \
          php8.5-soap php8.5-uploadprogress php8.5-zip php8.5-dev php8.5-common \
          php8.5-xml php8.5-pgsql php8.5-readline php8.5-opcache php8.5-imap \
          php8.5-enchant php8.5-gmp php8.5-snmp php8.5-sybase php8.5-xsl
        echo "✅ PHP 8.5 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php8.5
        echo "✅ PHP CLI switched to PHP 8.5"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php8.5
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 8.5"
        ;;
      6)
        read -rp "Enter PHP 8.5 extension name (e.g., imagick): " ext
        sudo apt install -y "php8.5-$ext"
        echo "✅ Extension php8.5-$ext installed"
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

php85_menu
