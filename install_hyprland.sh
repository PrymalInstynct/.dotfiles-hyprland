#!/bin/bash
set -e

# Configuration
VSCODE_EXTENSIONS=(
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

# Base Packages
echo -e "\n${BLUE}###Installing Base Packages###${NC}\n"
pac "base-devel sudo git cmake imv linux-headers openssh stow bind"

# Audio Utilities
echo -e "\n${BLUE}###Installing Audio Utilities###${NC}\n"
pac "bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse blueberry pavucontrol pamixer playerctl"

# Paru,
echo -e "\n${BLUE}###Installing Paru###${NC}\n"
git clone https://aur.archlinux.org/paru.git
chown -R $USER_NAME paru
sudo --user=$USER_NAME sh -c "cd /paru && makepkg -si"

echo -e "\n${BLUE}###Installing CLI Packages (PARU)###${NC}\n"
sudo --user=$USER_NAME sh -c "paru -S --noconfirm --needed direnv sops age python-i3ipc pico joe vim neovim tree neofetch btop bat wget curl man-db man-pages tldr zip unzip unrar p7zip wl-clipboard python-requests jq progress rsync"

# Hyprland
echo -e "\n${BLUE}###Installing Hyprland (PARU)###${NC}\n"
sudo --user=$USER_NAME sh -c "paru -S --noconfirm --needed hyprland waybar-hyprland-git hyprpaper hyprpicker-git xdg-desktop-portal-hyprland swaylock-effects swayidle wofi wlogout sddm-git sddm-theme-astronaut mako polkit-gnome"

echo -e "\n${BLUE}###Installing Desktop Packages (PARU)###${NC}\n"
sudo --user=$USER_NAME sh -c "paru -S --noconfirm --needed kitty starship visual-studio-code-bin brave-bin discord spotify ffmpeg ffmpegthumbnailer gvfs thunar thunar-archive-plugin tumbler viewnior swappy grim slurp brightnessctl xdg-user-dirs"

# Theme
echo -e "\n${BLUE}###Installing Themes (PARU)###${NC}\n"
sudo --user=$USER_NAME sh -c "paru -S --noconfirm --needed lxappearance xfce4-settings dracula-gtk-theme dracula-icons-git"

# Fonts
echo -e "\n${BLUE}###Installing Fonts (PARU)###${NC}\n"
sudo --user=$USER_NAME sh -c "paru -S --noconfirm --needed noto-fonts-emoji otf-font-awesome ttf-iosevka ttf-meslo ttf-jetbrains-mono-nerd"

# Environment
echo "LIBSEAT_BACKEND=seatd" >> /etc/environment
echo "EDITOR=nvim" >> etc/environment

# Services
echo -e "\n${BLUE}###Enabling Networkd###${NC}\n"
systemctl enable systemd-networkd.service
echo -e "\n${BLUE}###Enabling Resolved###${NC}\n"
systemctl enable systemd-resolved.service
echo -e "\n${BLUE}###Enabling DHCP###${NC}\n"
systemctl enable dhcpcd.service
echo -e "\n${BLUE}###Enabling Seatd###${NC}\n"
systemctl enable seatd.service
echo -e "\n${BLUE}###Enabling SSH###${NC}\n"
systemctl enable sshd.service

# Dotfiles symlink farm
echo -e "\n${BLUE}###Configuring ${USER_NAME}'s Settings###${NC}\n"
sudo --user=$USER_NAME sh -c "xdg-user-dirs-update"
cd /home/$USER_NAME/.dotfiles
mkdir -p /home/$USER_NAME/.config
mkdir -p /home/$USER_NAME/.images
stow --adopt -vt /home/$USER_NAME/.config .config
cp .images/* /home/$USER_NAME/.images/
cp starship_root.toml /root/.config/starship/toml
cp ../.bashrc /home/$USER_NAME/
cp ../.bash_profile /home/$USER_NAME/
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME

echo -e "\n${BLUE}###Configuring Root User Settings###${NC}\n"
cp starship_root.toml /root/.config/starship/toml
cp ../.bashrc /root/
cp ../.bash_profile /root/

# VSCode VSCODE_EXTENSIONS
echo -e "\n${BLUE}###Configuring VSCode###${NC}\n"
for i in ${VSCODE_EXTENSIONS[@]}; do
  sudo --user=$USER_NAME sh -c "code --force --install-extension $i"
done

# Git
echo -e "\n${BLUE}###Configuring Git###${NC}\n"
sudo --user=$USER_NAME sh -c "git config --global init.defaultbranch main"
sudo --user=$USER_NAME sh -c "git config --global user.name $GIT_NAME"
sudo --user=$USER_NAME sh -c "git config --global user.email $GIT_EMAIL"

echo -e "\n${BLUE}***The script has completed successfully.***\n\n***Please reboot your computer using the 'reboot' command.***${NC}"
exit