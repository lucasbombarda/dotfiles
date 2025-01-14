#!/bin/env bash

# Update all installed packages and distro
echo "Updating all installed packages and distro"
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y

# Install common packages
sudo apt install git curl build-essential dkms perl wget -y
sudo apt install make default-libmysqlclient-dev libssl-dev -y
sudo apt install -y zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev xz-utils libffi-dev liblzma-dev

# Remove unused packages
echo "Removing unused packages"
sudo apt clean
sudo apt autoremove -y

# Install flatpak
echo "Installing flatpak"
sudo apt install flatpak -y

# Install zsh, oh-my-zsh, and plugins
echo "Installing zsh, oh-my-zsh, and plugins"
sudo apt install zsh -y
chsh -s /bin/zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install Stow
echo "Installing Stow"
sudo apt install stow -y

# Install tmux
echo "Installing tmux"
sudo apt install tmux -y

# Install ripgrep
echo "Installing ripgrep"
sudo apt install ripgrep -y

# Install thefuck
echo "Installing thefuck"
sudo apt install thefuck -y

# Install NeoVim
echo "Installing NeoVim"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
sudo mv squashfs-root / && sudo ln -s /squashfs-root/AppRun /usr/bin/nvim
rm nvim.appimage
sudo rm -rf /usr/bin/vim
sudo ln -s /usr/bin/nvim /usr/bin/vim

# Install Compilers and Interpreters
echo "Installing compilers and interpreters"
echo "Installing C/C++ (GCC)"
sudo apt install gcc g++ -y

echo "Installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Installing latest Node.js LTS with nvm"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install node --lts

echo "Installing Bun"
curl -fsSL https://bun.sh/install | bash

echo "Installing Python 3.11 with deadsnakes"
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install python3.11 python3.11-dev python3.11-venv python3.11-full -y

echo "Installing Go"
go_version=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
wget https://golang.org/dl/$go_version.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $go_version.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
rm $go_version.linux-amd64.tar.gz

echo -e "\n\n\n------------------ COMPLETE ------------------"
echo "Ready to run Stow, you can now run \"stow .\" inside the dotfiles directory to symlink the dotfiles"
