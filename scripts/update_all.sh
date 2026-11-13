#!/usr/bin/env bash
set -euo pipefail

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

if command -v dnf &>/dev/null; then
    PM="dnf"
elif command -v apt-get &>/dev/null; then
    PM="apt"
else
    echo "Unsupported package manager." >&2
    exit 1
fi

echo "Updating Go"
if [ "$PM" = "dnf" ]; then
    sudo dnf upgrade -y golang
else
    sudo apt update && sudo apt install -y --only-upgrade golang-go
fi

echo "Updating Rust"
"$HOME/.cargo/bin/rustup" update

echo "Updating uv"
"$HOME/.local/bin/uv" self update
"$HOME/.local/bin/uv" tool upgrade --all

echo "Updating Bun"
"$HOME/.bun/bin/bun" upgrade --stable

echo "Updating zoxide"
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "Updating Starship"
sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes

echo "Updating NeoVim"
(
    cd "$TEMP_DIR"
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    ./nvim-linux-x86_64.appimage --appimage-extract
    sudo rm -rf /squashfs-root
    sudo mv squashfs-root /squashfs-root
)

echo "Updating NVM"
export NVM_DIR="$HOME/.nvm"
git -C "$NVM_DIR" fetch --tags
git -C "$NVM_DIR" checkout "$(git -C "$NVM_DIR" describe --abbrev=0 --tags --match "v[0-9]*" "$(git -C "$NVM_DIR" rev-list --tags --max-count=1)")"

echo "Updating oh-my-zsh"
ZSH="$HOME/.oh-my-zsh" zsh "$HOME/.oh-my-zsh/tools/upgrade.sh"

echo "Updating zsh plugins"
git -C "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" pull
git -C "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" pull
