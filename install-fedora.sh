#!/bin/bash

set -eu

sudo dnf update -y

# build utils and dependencies
sudo dnf install -y @c-development openssl-devel

# console utils
sudo dnf install -y stow \
    git tig \
    eza fd-find fzf ripgrep tmux zoxide \
    fastfetch \
    btop htop \
    bat nano jq \
    pipx \
    postgresql \
    zsh

# gui DNF apps
sudo dnf install -y alacritty firefox solaar

# enable RPM Fusion
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# install HEIF/HEIC libs to see iPhone photos
sudo dnf install -y heif-pixbuf-loader libheif-tools libheif-freeworld 

# fetch tools not present in fedora repos
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "$HOME/.local/share/fnm" ]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell
fi

# apply dotfiles
echo "Applying dotfiles"
stow zsh \
    alacritty \
    ghostty \
    fastfetch

sudo rm /etc/dnf/dnf.conf
sudo stow -t / dnf

# change shell
if [ ! "$SHELL" == "/usr/bin/zsh" ]; then
    echo "Changing shell to ZSH"
    chsh -s /usr/bin/zsh
fi

# set icons
sudo dnf install gnome-tweaks papirus-icon-theme
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'

# set fonts

# nerd fonts
echo "Installing Nerd fonts"
rm -rf /tmp/fonts
mkdir /tmp/fonts
mkdir -p "$HOME/.local/share/fonts"


if [ ! -f "$HOME/.local/share/fonts/FiraCodeNerdFont-Regular.ttf" ]; then
    echo "Fetching FiraCode..." && wget -q --directory-prefix=/tmp/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
else
    echo "FiraCode already installed..."
fi
if [ ! -f "$HOME/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    echo "Fetching JetBrainsMono..." && wget -q --directory-prefix=/tmp/fonts https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
else
    echo "JetBrainsMono already installed..."
fi
if [ ! -z "$( ls -A '/tmp/fonts' )" ]; then
    echo "Unpacking fonts..."
    unzip -q -o "/tmp/fonts/*.zip" -d "/tmp/fonts"
    mv -f -t "$HOME/.local/share/fonts" /tmp/fonts/*.ttf
    echo "Rebuilding font cache..."
    fc-cache
fi

gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 13'

# set window minimize,maximize,close in window decoratins
gsettings set org.gnome.desktop.wm.preferences button-layout 'icon:minimize,maximize,close'

# install flatpaks
sh ./install-flatpaks.sh

# gnome extensions
sh ./install-gnome-extensions.sh

# install additional apps outside of fedora repos
echo "Installing tools outside default DNF or Flatpak repos"

# ghostty
sudo dnf copr enable pgdev/ghostty -y
sudo dnf install ghostty -y

# VS Code
if ! command -v code -v 2>&1 >/dev/null; then
    echo "Installing VS Code"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    dnf check-update
    sudo dnf install code -y
else
    echo "VS Code is already installed"
fi

# Tailscale
if ! command -v tailscale --version 2>&1 >/dev/null; then
    sudo dnf config-manager addrepo --overwrite --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
    sudo dnf install tailscale -y
    sudo systemctl enable --now tailscaled
    sudo tailscale up
else
    echo "Tailscale is already installed"
fi

# Zed.dev
if ! command -v zed --version 2>&1 >/dev/null; then
    curl -f https://zed.dev/install.sh | sh
else
    echo "Zed is already installed"
fi

# Rust
if ! command -v rustup --version 2>&1 >/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust is already installed"
fi

# 1Password
if ! command -v 1password --version 2>&1 >/dev/null; then
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install 1password -y --skip-unavailable # Asahi not supported yet
    if ! command -v 1password --version 2>&1 >/dev/null; then
        echo "1Password could not be installed, install it manually https://support.1password.com/install-linux/#other-distributions-or-arm-targz"
    fi
else
    echo "1Password is already installed"
fi

echo "Done"
