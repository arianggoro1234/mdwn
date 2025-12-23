#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php83_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 8.3 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 8.3 (CLI)"
    "Set Apache to Use PHP 8.3"
    "Install Additional PHP 8.3 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 8.3 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        # Note: php-json is included in core since 8.0, so distinct package might not be needed, but keeping pattern
        # Removing php8.3-json if it causes issues, but most PPAs provide it as virtual or meta.
        # Safe to try installing the common set.
        sudo apt-get install -y php8.3 libapache2-mod-php8.3 libapache2-mod-auth-openidc \
          php8.3-bcmath php8.3-cli php8.3-curl php8.3-mbstring php8.3-gd php8.3-mysql \
          php8.3-ldap php8.3-memcached php8.3-tidy php8.3-intl php8.3-xmlrpc \
          php8.3-soap php8.3-uploadprogress php8.3-zip php8.3-dev php8.3-common \
          php8.3-xml php8.3-pgsql php8.3-readline php8.3-opcache php8.3-imap \
          php8.3-enchant php8.3-gmp php8.3-snmp php8.3-sybase php8.3-xsl
        echo "✅ PHP 8.3 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php8.3
        echo "✅ PHP CLI switched to PHP 8.3"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php8.3
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 8.3"
        ;;
      6)
        read -rp "Enter PHP 8.3 extension name (e.g., imagick): " ext
        sudo apt install -y "php8.3-$ext"
        echo "✅ Extension php8.3-$ext installed"
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

php83_menu
