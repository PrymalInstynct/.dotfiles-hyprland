#!/bin/bash
set -e

# Configuration
EXTENSIONS=(
rocketseat.theme-omni
esbenp.prettier-vscode
dbaeumer.vscode-eslint
golang.go
ms-vscode.cmake-tools
HashiCorp.terraform
britesnow.vscode-toggle-quotes
mitchdenny.ecdc
ms-kubernetes-tools.vscode-kubernetes-tools
oderwat.indent-rainbow
redhat.ansible
signageos.signageos-vscode-sops
usernamehw.errorlens
fcrespo82.markdown-table-formatter
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode-remote.remote-containers
)

# Colors
BLUE='\033[1;34m'
NC='\033[0m'

read -p "System username: " USER_NAME
read -p "Git Username: " GIT_NAME
read -p "Git Email: " GIT_EMAIL

# The script begins here.
pac() {
  pacman -Syu --noconfirm --needed $1
}

# Utilities
echo -e "\n${BLUE}###Installing Base Packages###${NC}\n"
pac "base-devel sudo vim nano git cmake imv networkmanager linux-headers noto-fonts-emoji openssh neofetch bashtop bat stow zsh wget wl-clipboard otf-font-awesome podman buildah skopeo cni-plugins fuse-overlayfs slirp4netns man-db man-pages"
pac "bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse blueberry pavucontrol"

# Paru, fonts and other AUR tools
echo -e "\n${BLUE}###Installing Paru###${NC}\n"
git clone https://aur.archlinux.org/paru.git
chown -R $USER_NAME paru
sudo --user=$USER_NAME sh -c "cd /paru && makepkg -si"

echo -e "\n${BLUE}###Installing AUR Packages###${NC}\n"
sudo --user=$USER_NAME sh -c "paru -S --noconfirm --needed ly ttf-iosevka ttf-meslo visual-studio-code-bin brave-bin kitty discord ffmpeg ffmpegthumbnailer thunar thunar-archive-plugin tumbler oh-my-zsh-git spotify direnv sops age tldr python-i3ipc"

# Sway & desktop tools
echo -e "\n${BLUE}###Installing Sway###${NC}\n"
pac "sway waybar swaylock-effects-git swayidle swaybg slurp grim xorg-xwayland wofi dmenu"

# Environment
echo "LIBSEAT_BACKEND=seatd" > /etc/environment

# Services
echo -e "\n${BLUE}###Enabling Network Manager###${NC}\n"
systemctl enable NetworkManager.service
echo -e "\n${BLUE}###Enabling Seatd###${NC}\n"
systemctl enable seatd.service
echo -e "\n${BLUE}###Enabling ly Desktop Manager###${NC}\n"
systemctl enable ly.service
echo -e "\n${BLUE}###Enabling sshd###${NC}\n"
systemctl enable sshd.service

# Zsh + Oh My Zsh
echo -e "\n${BLUE}###Configuring ZSH###${NC}\n"
export RUNZSH=no
sudo --user=$USER_NAME sh -c "ln -s /usr/share/oh-my-zsh /home/$USER_NAME/.oh-my-zsh"
git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
sudo --user=$USER_NAME sh -c "chsh -s $(which zsh)"

# Dotfiles symlink farm
echo -e "\n${BLUE}###Configuring DotFiles###${NC}\n"
cd /home/$USER_NAME/.dotfiles
mkdir -p /home/$USER_NAME/.config
mkdir -p /home/$USER_NAME/.images
stow --adopt -vt /home/$USER_NAME/.config .config
stow --adopt -vt /home/$USER_NAME/.images .images
stow --adopt -vt /home/$USER_NAME zsh


echo -e "\n${BLUE}###Installing Start-up Scritps###${NC}\n"
cp sway-toolwait /usr/local/bin
cp sway-start-apps /usr/local/bin

chown -R $USER_NAME /home/$USER_NAME

# VSCode extensions
echo -e "\n${BLUE}###Configuring VSCode###${NC}\n"
for i in ${EXTENSIONS[@]}; do
  sudo --user=$USER_NAME sh -c "code --force --install-extension $i"
done

# Git
echo -e "\n${BLUE}###Configuring Git###${NC}\n"
git config --global user.name $GIT_NAME
git config --global user.email $GIT_EMAIL

# Cleaning up and rebooting
rm -rf /install.sh

echo "Script has finished. Please reboot your PC using 'reboot' command."
exit
