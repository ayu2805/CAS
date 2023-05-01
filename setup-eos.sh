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

sudo pacman -Syu --needed - < tpkg
echo "QT_QPA_PLATFORMTHEME=qt6ct" | sudo tee /etc/environment

yay -Syu --needed systemd-numlockontty
sudo systemctl enable numLockOnTty

read -r -p "Do you want to install cinnamon as well as xfce? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    sudo pacman -Syu - < cinxfce
    yay -S mint-artwork
    sudo sed -i '/^#greeter-session=/s/^#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf
    sudo systemctl enable lightdm
fi

echo "#########################"
echo "#### Install themes. ####"
echo "#########################"

yay -Syu kvantum-theme-materia materia-gtk-theme
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
