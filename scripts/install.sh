#!/usr/bin/env bash
set -euo pipefail

# Create a temporary directory to store files that we plan to remove.
TEMP_DIR="$(mktemp -d)"
echo "Created temporary directory: $TEMP_DIR"
echo "All to-be-deleted files will be moved here first."

######################################
# 1. Update system packages
######################################
echo "Updating all installed packages and distro"
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y

######################################
# 2. Install common packages
######################################
sudo apt install -y git curl build-essential dkms perl wget
sudo apt install -y make default-libmysqlclient-dev libssl-dev
sudo apt install -y zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    llvm libncurses5-dev libncursesw5-dev xz-utils libffi-dev liblzma-dev

######################################
# 3. Remove unused packages
######################################
echo "Removing unused packages"
sudo apt clean
sudo apt autoremove -y

######################################
# 4. Install flatpak
######################################
echo "Installing flatpak"
sudo apt install -y flatpak


######################################
# 6. Install Stow
######################################
echo "Installing Stow"
sudo apt install -y stow

######################################
# 7. Install tmux
######################################
echo "Installing tmux"
sudo apt install -y tmux

######################################
# 8. Install ripgrep
######################################
echo "Installing ripgrep"
sudo apt install -y ripgrep

######################################
# 9. Install thefuck
######################################
echo "Installing thefuck"
sudo apt install -y thefuck

######################################
# 10. Install zoxide
######################################
echo "Installing zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

######################################
# 11. Install NeoVim
######################################
echo "Installing NeoVim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage

./nvim.appimage --appimage-extract
sudo mv squashfs-root / && sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

# Move old files to $TEMP_DIR instead of deleting them immediately:
sudo mv nvim.appimage "$TEMP_DIR" 2>/dev/null || true
sudo mv /usr/bin/vim "$TEMP_DIR" 2>/dev/null || true

# Replace vim with nvim symlink
sudo ln -s /usr/bin/nvim /usr/bin/vim

######################################
# 12. Install Compilers and Interpreters
######################################
echo "Installing C/C++ (GCC)"
sudo apt install -y gcc g++

######################################
# 12a. Rust
######################################
echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

######################################
# 12b. Node.js LTS + Angular CLI (via NVM)
######################################
echo "Installing latest Node.js LTS with nvm and Angular CLI"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
# Activate NVM right away (might differ based on your shell)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts
npm install -g @angular/cli

######################################
# 12c. Bun
######################################
echo "Installing Bun"
curl -fsSL https://bun.sh/install | bash

######################################
# 12d. Python 3.11 with deadsnakes
######################################
echo "Installing Python 3.11 with deadsnakes"
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install -y python3.11 python3.11-dev python3.11-venv

######################################
# 12e. Lua 5.1.5
######################################
echo "Installing Lua 5.1.5"
curl -L -R -O https://www.lua.org/ftp/lua-5.1.5.tar.gz
tar zxf lua-5.1.5.tar.gz
cd lua-5.1.5
make linux test
cd ..

# Move the source and archive to temp instead of deleting
mv lua-5.1.5.tar.gz "$TEMP_DIR" 2>/dev/null || true
rm -rf lua-5.1.5

######################################
# 12f. Go
######################################
echo "Installing Go"
go_version="$(curl -s https://go.dev/VERSION?m=text | head -n 1)"
wget "https://golang.org/dl/${go_version}.linux-amd64.tar.gz"

# Remove old go in /usr/local and extract the new one
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "${go_version}.linux-amd64.tar.gz"
export PATH="$PATH:/usr/local/go/bin"

# Move the downloaded archive to temp instead of deleting
mv "${go_version}.linux-amd64.tar.gz" "$TEMP_DIR" 2>/dev/null || true

######################################
# 5. Install zsh, oh-my-zsh, and plugins
######################################
echo "Installing zsh, oh-my-zsh, and plugins"
sudo apt install -y zsh
sudo sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Spaceship theme
git clone https://github.com/spaceship-prompt/spaceship-prompt.git \
    "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
    sudo ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" \
        "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

######################################
# 13. Cleanup (final)
######################################
echo -e "\n\n\n------------------ COMPLETE ------------------"
echo "Ready to run 'stow .' inside the dotfiles directory to symlink the dotfiles."

echo "Now removing the temporary directory and its contents:"
sudo rm -rf "$TEMP_DIR"
echo "Temporary directory removed."

