#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$HOME/.local/share/nvim/venv"  # XDG-compliant location

echo "Setting up Neovim Python environment..."

# Install uv if not present
if ! command -v uv &> /dev/null; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Create venv using uv
echo "Creating virtual environment at $VENV_DIR..."
cd "$DOTFILES_DIR"
uv venv "$VENV_DIR" --python 3.11
uv pip install --python "$VENV_DIR" -r pyproject.toml

echo "✓ Neovim Python environment ready at $VENV_DIR"
