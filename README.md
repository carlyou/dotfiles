# dotfiles

- .vimrc (deprecated)
- .zshrc
- .config/nvim
- .config/p10k
- .config/tmux
- .config/wezterm
- .config/zathura

# Installation

Choose the appropriate init script for your environment:

## macOS
```bash
./init-macos.sh
```

## Ubuntu/Linux

**With GUI apps (Desktop/Workstation)**
```bash
./init-ubuntu.sh
```
Includes: WezTerm, Neovide, Rust toolchain

**Server/Headless (No GUI)**
```bash
./init-ubuntu-server.sh
```
Minimal installation without GUI applications

# Dependencies

- Zsh: [Oh My Zsh](https://ohmyz.sh/)
- Terminal Emulator: [Wezterm](https://wezterm.org/index.html)
- Fuzzy Finder: [fzf](https://github.com/junegunn/fzf)
- Shell Prompt: [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Nerd font: [Monaco Nerf Font](https://github.com/thep0y/monaco-nerd-font)
- [homebrew-zathura](https://github.com/homebrew-zathura/homebrew-zathura)
