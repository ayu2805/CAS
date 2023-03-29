#!/bin/sh

if [ "$(id -u)" = 0 ]; then
    echo "##################################################################"
    echo "This script MUST NOT be run as root user since it can arouse unpredicted"
    echo "problems and you may have to reinstall arch. So run this script as a"
    echo "normal user. You will be asked for a sudo password when necessary"
    echo "##################################################################"
    exit 1
fi

echo "#########################"
echo "## Install packages. ##"
echo "#########################"

sudo pacman -S --needed - < xfce

echo "#########################"
echo "## Install Icon theme. ##"
echo "#########################"

git clone https://github.com/vinceliuice/Fluent-icon-theme.git
cd Fluent-icon-theme
sudo ./install.sh -r
cd ..

echo "#####################"
echo "## System cleanup. ##"
echo "#####################"

rm -r Fluent-icon-theme --noconfirm
sudo pacman -Rns $(pacman -Qtdq) --noconfirm
yay -Sc --noconfirm

echo "################################################"
echo "Done! You can manually delete this folder later!"
echo "################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi