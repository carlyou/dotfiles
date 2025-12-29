#!/bin/bash

# Ubuntu/Debian init script for dotfiles
# Includes GUI applications (wezterm, neovide)
# For server/headless Ubuntu, use init-ubuntu-server.sh
# For macOS, use init-macos.sh instead

set -e  # Exit on error

# OS check
if [ "$(uname)" != "Linux" ]; then
  echo -e "\033[31m❌ Error: This script is for Ubuntu/Linux only.\033[0m"
  echo -e "\033[33m💡 For macOS, use: ./init-macos.sh\033[0m"
  exit 1
fi

echo -e "\033[34m🐧 Starting Ubuntu dotfiles installation (with GUI apps)...\033[0m"

# Run server/headless setup first
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/init-ubuntu-server.sh" ]; then
  echo -e "\033[34m📦 Running base setup (init-ubuntu-server.sh)...\033[0m"
  bash "$SCRIPT_DIR/init-ubuntu-server.sh"
else
  echo -e "\033[31m❌ Error: init-ubuntu-server.sh not found!\033[0m"
  exit 1
fi

echo ""
echo -e "\033[34m🖥️  Installing GUI applications...\033[0m"

# Install WezTerm (GUI terminal)
if command -v wezterm &> /dev/null; then
  echo -e "\033[32m✅ WezTerm is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing WezTerm...\033[0m"
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt update || true
  sudo apt install -y wezterm
fi

# Install Rust (required for neovide)
if command -v cargo &> /dev/null; then
  echo -e "\033[32m✅ Rust/Cargo is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing Rust...\033[0m"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# Install Neovide (GUI for Neovim)
if command -v neovide &> /dev/null; then
  echo -e "\033[32m✅ Neovide is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing Neovide dependencies...\033[0m"
  sudo apt install -y cmake pkg-config libfontconfig-dev libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3

  # Ensure cargo is in PATH
  export PATH="$HOME/.cargo/bin:$PATH"

  echo -e "\033[34m⬇️ Installing Neovide (this may take a few minutes)...\033[0m"
  cargo install --git https://github.com/neovide/neovide
fi

# Add GUI config directory symlinks
echo -e "\033[34m🔗 Creating GUI config symlinks...\033[0m"

gui_folders="neovide wezterm"

[ ! -d ~/.config ] && mkdir -p ~/.config
for folder in $gui_folders; do
  if [ ! -e ~/.config/$folder ] || [ -L ~/.config/$folder ]; then
    ln -sfn "$SCRIPT_DIR/_config/$folder" ~/.config/$folder
    echo -e "\033[32m✅ ~/.config/$folder symlink created\033[0m"
  else
    echo -e "\033[33m⚠️  ~/.config/$folder already exists (not a symlink, skipping)\033[0m"
  fi
done

echo -e "\033[32m"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Ubuntu dotfiles installation complete!"
echo "   (with GUI applications)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "GUI apps installed:"
echo "  • WezTerm - Modern GPU-accelerated terminal"
echo "  • Neovide - GUI for Neovim"
echo ""
echo "For next steps and additional notes, see the output above."
echo "\033[0m"
