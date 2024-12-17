#!/usr/bin/bash

# Update all installed packages
sudo apt update
sudo apt upgrade -y

# Update distro
sudo apt dist-upgrade -y

# flatpak
sudo flatpak update -y

# Remove unused packages
sudo apt clean
sudo apt autoremove -y

$HOME/.cargo/bin/rustup update
$HOME/.bun/bin/bun update --stable

