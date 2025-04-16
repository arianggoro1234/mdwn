#!/bin/bash

# shellcheck source=./lib/alacarte.sh
source "$(dirname "$0")/lib/alacarte.sh"

check_update(){
  cd ~/mdwn/ || exit
  echo "Checking for updates..."
  git pull
  cd ~ || exit
  chmod -R u+x mdwn
}

check_update