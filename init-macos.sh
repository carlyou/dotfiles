#!/bin/sh

# macOS dotfiles installation script
# For Ubuntu/Linux, use init-ubuntu.sh instead

# OS check
if [ "$(uname)" != "Darwin" ]; then
  echo -e "\033[31m❌ Error: This script is for macOS only.\033[0m"
  echo -e "\033[33m💡 For Ubuntu/Linux, use: ./init-ubuntu.sh\033[0m"
  exit 1
fi

echo -e "\033[34m🍎 Starting macOS dotfiles installation...\033[0m"

# zsh
if ! command -v zsh &> /dev/null; then
  echo -e "\033[34m⬇️ Installing zsh...\033[0m"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo -e "\033[32m✅ zsh is already installed\033[0m"
fi

# brew
if ! command -v brew &> /dev/null; then
  echo -e "\033[34m⬇️ Installing Homebrew...\033[0m"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo -e "\033[32m✅ Homebrew is already installed\033[0m"
fi

# Homebrew packages
packages="
  wezterm
  node
  thefuck
  powerlevel10k
  neovim
  tmux
  tree
  ripgrep
  uv
"

for pkg in $packages; do
  if brew list $pkg &> /dev/null; then
    echo -e "\033[32m✅ $pkg is installed via Homebrew\033[0m"
  else
    echo -e "\033[34m⬇️ Installing $pkg with Homebrew...\033[0m"
    brew install $pkg
  fi
done

# fzf (requires additional setup)
if brew list fzf &> /dev/null; then
  echo -e "\033[32m✅ fzf is installed via Homebrew\033[0m"
else
  echo -e "\033[34m⬇️ Installing fzf with Homebrew...\033[0m"
  brew install fzf
  "$(brew --prefix)/opt/fzf/install" --bin
fi

# zsh-autosuggestions plugin
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
  echo -e "\033[32m✅ zsh-autosuggestions is already installed\033[0m"
else
  echo -e "\033[34m⬇️ Installing zsh-autosuggestions...\033[0m"
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
fi

# file: ~/.zshrc
if [ ! -e ~/.zshrc ]; then
  ln -s "$(pwd)/_zshrc" ~/.zshrc
  echo -e "\033[32m✅ ~/.zshrc symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.zshrc already exists\033[0m"
fi

# file: ~/.gitignore_global
if [ ! -e ~/.gitignore_global ]; then
  ln -s "$(pwd)/_gitignore_global" ~/.gitignore_global
  echo -e "\033[32m✅ ~/.gitignore_global symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.gitignore_global already exists\033[0m"
fi

# file: ~/.config/...
folders="neovide nvim p10k tmux wezterm zathura"

[ ! -d ~/.config ] && mkdir ~/.config
for folder in $folders; do
  if [ ! -e ~/.config/$folder ]; then
    ln -s "$(pwd)/_config/$folder" ~/.config/$folder
    echo -e "\033[32m✅ ~/.config/$folder symlink created\033[0m"
  else
    echo -e "\033[33mℹ️ ~/.config/$folder already exists\033[0m"
  fi
done

# file: ~/.local/share/nvim/venv/nvim
[ ! -d ~/.local/share/nvim ] && mkdir -p ~/.local/share/nvim
if [ ! -e ~/.local/share/nvim/venv ]; then
  ln -s "$(pwd)/_venvs/nvim" ~/.local/share/nvim/venv/nvim
  echo -e "\033[32m✅ ~/.local/share/nvim/venv/nvim symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.local/share/nvim/venv/nvim already exists\033[0m"
fi

[ ! -d ~/.local/share/venvs ] && mkdir -p ~/.local/share/venvs
if [ ! -e ~/.local/share/venvs/default ]; then
  uv sync --project "$(pwd)/_venvs/default" > /dev/null 2>&1
  ln -s "$(pwd)/_venvs/default/.venv" ~/.local/share/venvs/default
  echo -e "\033[32m✅ ~/.local/share/venvs/default symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.local/share/venvs/default already exists\033[0m"
fi
