#!/bin/bash

# Ensure ~/.bashrc exists
if [ ! -f "$HOME/.bashrc" ]; then
  touch "$HOME/.bashrc"
  echo "🆕 Created new .bashrc file."
fi

# Add alias only if it doesn't already exist
if ! grep -Fxq "alias mdwn='~/mdwn/./start.sh'" "$HOME/.bashrc"; then
  echo "alias mdwn='~/mdwn/./start.sh'" >> "$HOME/.bashrc"
  echo "✅ Alias 'mdwn' added to .bashrc"
else
  echo "ℹ️ Alias 'mdwn' already exists in .bashrc"
fi

# Apply changes
# shellcheck source=/home/username/.bashrc
# Replace 'username' below with the actual username if known
# OR just use a directive to ignore this check:
# shellcheck disable=SC1090
# shellcheck disable=SC1091
source "$HOME/.bashrc"
