#!/bin/sh

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
  echo -e "\033[34m⬇️ Installing Homebrew...\033[0m"
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
else
  echo -e "\033[32m✅ Homebrew is already installed\033[0m"
fi

if brew list node &> /dev/null; then
  echo -e "\033[32m✅ Node is installed via Homebrew\033[0m"
else
  echo -e "\033[34m⬇️ Installing Node with Homebrew...\033[0m"
  brew install node
fi

if [ ! -e ~/.zshrc ]; then
  ln -s "$(pwd)/_zshrc" ~/.zshrc
  echo -e "\033[32m✅ ~/.zshrc symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.zshrc already exists\033[0m"
fi

if [ ! -e ~/.gitignore_global ]; then
  ln -s "$(pwd)/_gitignore_global" ~/.gitignore_global
  echo -e "\033[32m✅ ~/.gitignore_global symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.gitignore_global already exists\033[0m"
fi

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

[ ! -d ~/.local/share/nvim ] && mkdir -p ~/.local/share/nvim
if [ ! -e ~/.local/share/nvim/venv ]; then
  ln -s "$(pwd)/venvs/nvim" ~/.local/share/nvim/venv/nvim
  echo -e "\033[32m✅ ~/.local/share/nvim/venv/nvim symlink created\033[0m"
else
  echo -e "\033[33mℹ️ ~/.local/share/nvim/venv/nvim already exists\033[0m"
fi
