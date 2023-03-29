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

cd Downloads
git clone https://github.com/vinceliuice/Fluent-icon-theme.git
cd Fluent-icon-theme
sudo ./install.sh -r
