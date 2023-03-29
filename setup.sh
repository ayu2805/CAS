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

sudo pacman -Syu --needed - < xfce

read -r -p "Do you want to install yay? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    
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

echo "#####################"
echo "## System cleanup. ##"
echo "#####################"

sudo pacman -Rns $(pacman -Qtdq) --noconfirm
yay -Sc --noconfirm

echo "################################################"
echo "Done! You can manually delete this folder later!"
echo "############# Reboot is recomended #############"
echo "################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
