#!/usr/bin/env bash
set -euo pipefail

# Create a temporary directory to store files that we plan to remove.
TEMP_DIR="$(mktemp -d)"
echo "Created temporary directory: $TEMP_DIR"
echo "All to-be-deleted files will be moved here first."

######################################
# Update system packages
######################################
echo "Updating all installed packages and distro"
sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y

######################################
# Install common packages
######################################
sudo apt install -y git curl build-essential dkms perl wget
sudo apt install -y make default-libmysqlclient-dev libssl-dev
sudo apt install -y zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    llvm libncurses5-dev libncursesw5-dev xz-utils libffi-dev liblzma-dev

######################################
# Remove unused packages
######################################
echo "Removing unused packages"
sudo apt clean
sudo apt autoremove -y

######################################
# Install flatpak
######################################
echo "Installing flatpak"
sudo apt install -y flatpak

######################################
# Install Stow
######################################
echo "Installing Stow"
sudo apt install -y stow

######################################
# Install tmux
######################################
echo "Installing tmux"
sudo apt install -y tmux

######################################
# Install ripgrep
######################################
echo "Installing ripgrep"
sudo apt install -y ripgrep

######################################
# Install zoxide
######################################
echo "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
sudo apt install fzf

######################################
# Install NeoVim
######################################
echo "Installing NeoVim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage

./nvim-linux-x86_64.appimage --appimage-extract
sudo mv squashfs-root / && sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

sudo mv nvim-linux-x86_64.appimage "$TEMP_DIR" 2>/dev/null || true
sudo mv /usr/bin/vim "$TEMP_DIR" 2>/dev/null || true

sudo ln -s /usr/bin/nvim /usr/bin/vim

######################################
# C/C++ (GCC)
######################################
echo "Installing C/C++ (GCC)"
sudo apt install -y gcc g++

######################################
# Rust
######################################
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
echo "Activating cargo"

######################################
# Bun
######################################
echo "Installing Bun"
curl -fsSL https://bun.sh/install | bash

######################################
# Python 3.11
######################################
echo "Installing Python 3.11"
sudo apt install -y python3.11 python3.11-dev python3.11-venv

######################################
# Lua 5.1.5
######################################
echo "Installing Lua 5.1.5"
curl -L -R -O https://www.lua.org/ftp/lua-5.1.5.tar.gz
tar zxf lua-5.1.5.tar.gz
cd lua-5.1.5
sudo make linux install
cd ..

sudo mv lua-5.1.5.tar.gz "$TEMP_DIR" 2>/dev/null || true
sudo mv lua-5.1.5 "$TEMP_DIR" 2>/dev/null || true

######################################
# Go
######################################
echo "Installing Go"
go_version="$(curl -s https://go.dev/VERSION?m=text | head -n 1)"
wget "https://go.dev/dl/${go_version}.linux-amd64.tar.gz"

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "${go_version}.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin"

sudo mv "${go_version}.linux-amd64.tar.gz" "$TEMP_DIR" 2>/dev/null || true

######################################
# Install zsh, oh-my-zsh, and plugins
######################################
echo "Installing zsh, oh-my-zsh, and plugins"
sudo apt install -y zsh
chsh -s /bin/zsh

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unnattended

# Spaceship theme
git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt" --depth=1
ln -s "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship-prompt/spaceship.zsh-theme" \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/spaceship.zsh-theme"

# ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

mv "$HOME/.zshrc" "$TEMP_DIR" 2>/dev/null || true

######################################
# Cleanup
######################################
echo "Now removing the temporary directory and its contents:"
sudo rm -rf "$TEMP_DIR"
echo "Temporary directory removed."

echo -e "\n\n\n------------------ COMPLETE ------------------"
echo "Ready to run 'stow .' inside the dotfiles directory to symlink the dotfiles."

