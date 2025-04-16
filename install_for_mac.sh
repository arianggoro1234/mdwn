#!/bin/bash

# Ensure ~/.zshrc exists
if [ ! -f "$HOME/.zshrc" ]; then
  touch "$HOME/.zshrc"
  echo "🆕 Created new .zshrc file."
fi

# Add alias only if it doesn't already exist
if ! grep -Fxq "alias mdwn='~/mdwn/./start.sh'" "$HOME/.zshrc"; then
  echo "alias mdwn='~/mdwn/./start.sh'" >> "$HOME/.zshrc"
  echo "✅ Alias 'mdwn' added to .zshrc"
else
  echo "ℹ️ Alias 'mdwn' already exists in .zshrc"
fi

# Apply changes
# shellcheck source=/home/username/.zshrc
# Replace 'username' below with the actual username if known
# OR just use a directive to ignore this check:
# shellcheck disable=SC1090
# shellcheck disable=SC1091
source "$HOME/.zshrc"
