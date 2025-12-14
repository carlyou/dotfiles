#!/bin/bash

# Ubuntu/Debian init script for dotfiles (headless/SSH setup)
# Skips GUI applications (wezterm, neovide, zathura, alfred)
# For macOS, use init-macos.sh instead

set -e  # Exit on error

# OS check
if [ "$(uname)" != "Linux" ]; then
  echo -e "\033[31m❌ Error: This script is for Ubuntu/Linux only.\033[0m"
  echo -e "\033[33m💡 For macOS, use: ./init-macos.sh\033[0m"
  exit 1
fi

echo -e "\033[34m🐧 Starting Ubuntu dotfiles installation...\033[0m"

# Update package list
echo -e "\033[34m⬇️ Updating apt package list...\033[0m"
sudo apt update

# Install essential packages
packages=(
  "zsh"
  "git"
  "curl"
  "tmux"
  "tree"
  "ripgrep"
  "fzf"
  "neovim"
  "python3-pip"
  "python3-venv"
  "build-essential"  # For building native extensions
)

for pkg in "${packages[@]}"; do
  if dpkg -l | grep -qw "$pkg"; then
    echo -e "\033[32m✅ $pkg is already installed\033[0m"
  else
    echo -e "\033[34m⬇️ Installing $pkg...\033[0m"
    sudo apt install -y "$pkg"
  fi
done

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo -e "\033[34m⬇️ Installing Oh My Zsh...\033[0m"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo -e "\033[32m✅ Oh My Zsh is already installed\033[0m"
fi

# Install zsh-autosuggestions plugin
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  echo -e "\033[32m✅ zsh-autosuggestions is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing zsh-autosuggestions...\033[0m"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
fi

# Install Powerlevel10k theme
if [ -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]; then
  echo -e "\033[32m✅ Powerlevel10k is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing Powerlevel10k...\033[0m"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
fi

# Install thefuck
if command -v thefuck &> /dev/null; then
  echo -e "\033[32m✅ thefuck is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing thefuck...\033[0m"
  pip3 install --user thefuck
fi

# Install uv (Python package manager)
if command -v uv &> /dev/null; then
  echo -e "\033[32m✅ uv is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing uv...\033[0m"
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Install NVM (Node Version Manager) - optional but in your zshrc
if [ -d "$HOME/.nvm" ]; then
  echo -e "\033[32m✅ NVM is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing NVM...\033[0m"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  echo -e "\033[34m⬇️ Installing Node.js LTS...\033[0m"
  nvm install --lts
fi

# Symlink configuration files
echo -e "\033[34m🔗 Creating symlinks...\033[0m"

# file: ~/.zshrc
if [ ! -e ~/.zshrc ] || [ -L ~/.zshrc ]; then
  ln -sf "$(pwd)/_zshrc" ~/.zshrc
  echo -e "\033[32m✅ ~/.zshrc symlink created\033[0m"
else
  echo -e "\033[33m⚠️  ~/.zshrc already exists (not a symlink, skipping)\033[0m"
fi

# file: ~/.gitignore_global
if [ ! -e ~/.gitignore_global ] || [ -L ~/.gitignore_global ]; then
  ln -sf "$(pwd)/_gitignore_global" ~/.gitignore_global
  echo -e "\033[32m✅ ~/.gitignore_global symlink created\033[0m"
else
  echo -e "\033[33m⚠️  ~/.gitignore_global already exists (not a symlink, skipping)\033[0m"
fi

# config directories (skip GUI apps)
folders="nvim p10k tmux"

[ ! -d ~/.config ] && mkdir -p ~/.config
for folder in $folders; do
  if [ ! -e ~/.config/$folder ] || [ -L ~/.config/$folder ]; then
    ln -sf "$(pwd)/_config/$folder" ~/.config/$folder
    echo -e "\033[32m✅ ~/.config/$folder symlink created\033[0m"
  else
    echo -e "\033[33m⚠️  ~/.config/$folder already exists (not a symlink, skipping)\033[0m"
  fi
done

# Python virtual environments
echo -e "\033[34m🐍 Setting up Python virtual environments...\033[0m"

# Ensure uv is in PATH for this session
export PATH="$HOME/.local/bin:$PATH"

# nvim venv
[ ! -d ~/.local/share/nvim ] && mkdir -p ~/.local/share/nvim
if [ ! -e ~/.local/share/nvim/venv ]; then
  ln -sf "$(pwd)/_venvs/nvim" ~/.local/share/nvim/venv
  echo -e "\033[32m✅ ~/.local/share/nvim/venv symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.local/share/nvim/venv already exists\033[0m"
fi

# default venv
[ ! -d ~/.local/share/venvs ] && mkdir -p ~/.local/share/venvs
if [ ! -e ~/.local/share/venvs/default ]; then
  echo -e "\033[34m⬇️ Creating default Python venv...\033[0m"
  uv sync --project "$(pwd)/_venvs/default" > /dev/null 2>&1
  ln -sf "$(pwd)/_venvs/default/.venv" ~/.local/share/venvs/default
  echo -e "\033[32m✅ ~/.local/share/venvs/default symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.local/share/venvs/default already exists\033[0m"
fi

# Set zsh as default shell (with confirmation)
if [ "$SHELL" != "$(which zsh)" ]; then
  echo ""
  echo -e "\033[33m🐚 Your current shell is: $SHELL\033[0m"
  read -p "Do you want to change your default shell to zsh? (y/n): " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\033[34m⬇️ Changing default shell to zsh...\033[0m"
    chsh -s "$(which zsh)"
    echo -e "\033[32m✅ Default shell changed to zsh (logout/login to apply)\033[0m"
  else
    echo -e "\033[33mℹ️  Keeping current shell. You can run 'chsh -s \$(which zsh)' later to change it.\033[0m"
  fi
else
  echo -e "\033[32m✅ zsh is already the default shell\033[0m"
fi

echo -e "\033[32m"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ Ubuntu dotfiles installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. Logout and login (or run: exec zsh)"
echo "  2. Configure Powerlevel10k: p10k configure"
echo "  3. Install tmux plugins: tmux, then Ctrl+b I"
echo "  4. Open nvim to auto-install plugins"
echo ""
echo "Notes:"
echo "  • GUI apps skipped (wezterm, neovide, zathura)"
echo "  • Use tmux for clipboard via OSC 52 over SSH"
echo "  • Node.js available via nvm"
echo "  • Python default venv auto-activates in zsh"
echo "\033[0m"
