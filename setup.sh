#!/bin/sh

if [ "$(id -u)" = 0 ]; then
    echo "######################################################################"
    echo "This script should NOT be run as root user as it may create unexpected"
    echo " problems and you may have to reinstall Arch. So run this script as a"
    echo "  normal user. You will be asked for a sudo password when necessary"
    echo "######################################################################"
    exit 1
fi

echo "################################"
echo "## Install & Update packages. ##"
echo "################################"

sudo pacman -Syu --needed - < ttpkg
sudo systemctl enable firewalld.service
echo "QT_QPA_PLATFORMTHEME=qt6ct" | sudo tee /etc/environment

read -r -p "Do you want to install xfce? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo pacman -Syu --needed - < xfce
fi

read -r -p "Do you want to install yay? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    yay -Syu systemd-numlockontty
    sudo systemctl enable numLockOnTty
    
    read -r -p "Do you want to install VS Code(from AUR)? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    yay -S visual-studio-code-bin
    fi
fi

echo "#########################"
echo "## Install Icon theme. ##"
echo "#########################"

git clone https://github.com/vinceliuice/Fluent-icon-theme.git
cd Fluent-icon-theme
sudo ./install.sh -r

echo "################################################"
echo "Done! You can manually delete this folder later!"
echo "############# Reboot is recomended #############"
echo "################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
