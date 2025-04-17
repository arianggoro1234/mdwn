#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

function php82_menu() {
  local options=(
    "Back to Main Menu"
    "Install PHP 8.2 and Modules"
    "Enable Apache Rewrite and SSL"
    "Switch to PHP 8.2 (CLI)"
    "Set Apache to Use PHP 8.2"
    "Install Additional PHP 8.2 Extension"
    "List Installed PHP Modules"
    "Show PHP Version"
    "Show PHP Info (CLI)"
    "Restart Apache"
  )

  PS3="Choose a PHP 8.2 management option: "
  select _ in "${options[@]}"; do
    case $REPLY in
      1) break ;;
      2)
        sudo add-apt-repository -y ppa:ondrej/php
        sudo apt update -y
        sudo apt-get install -y postgresql postgresql-contrib apache2 curl
        sudo apt-get install -y php8.2 libapache2-mod-php8.2 libapache2-mod-auth-openidc \
          php8.2-bcmath php8.2-cli php8.2-curl php8.2-mbstring php8.2-gd php8.2-mysql \
          php8.2-json php8.2-ldap php8.2-memcached php8.2-tidy php8.2-intl php8.2-soap \
          php8.2-uploadprogress php8.2-zip php8.2-dev php8.2-common php8.2-xml php8.2-pgsql \
          php8.2-readline php8.2-opcache php8.2-imap php8.2-sqlite3 php8.2-gmp
        echo "✅ PHP 8.2 and related packages installed"
        ;;
      3)
        sudo a2enmod rewrite
        sudo a2enmod ssl
        sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
        echo "✅ Apache modules enabled and config updated"
        sudo systemctl restart apache2
        ;;
      4)
        sudo update-alternatives --set php /usr/bin/php8.2
        echo "✅ PHP CLI switched to PHP 8.2"
        ;;
      5)
        sudo a2dismod php*
        sudo a2enmod php8.2
        sudo systemctl restart apache2
        echo "✅ Apache is now using PHP 8.2"
        ;;
      6)
        read -rp "Enter PHP 8.2 extension name (e.g., imagick): " ext
        sudo apt install -y "php8.2-$ext"
        echo "✅ Extension php8.2-$ext installed"
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

php82_menu
