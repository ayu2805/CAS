#!/bin/sh

if [ "$(id -u)" = 0 ]; then
    echo "######################################################################"
    echo "This script should NOT be run as root user as it may create unexpected"
    echo " problems and you may have to reinstall Arch. So run this script as a"
    echo "  normal user. You will be asked for a sudo password when necessary"
    echo "######################################################################"
    exit 1
fi

echo "####################################################"
echo "## Install & Update packages (Cinnamon and XFCE). ##"
echo "####################################################"

rm -rf yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..

sudo pacman -Sy --needed reflector
echo -e "--save /etc/pacman.d/mirrorlist\n--protocol https\n--country India\n--latest 5\n--sort rate" | sudo tee /etc/xdg/reflector/reflector.conf > /dev/null
#Change location as per your need(from "India" to anywhere else)
sudo systemctl enable --now reflector
sudo pacman -Syu --needed - < tpkg

line="QT_QPA_PLATFORMTHEME=qt6ct"
file="/etc/environment"
if ! sudo grep -qF "$line" "$file"; then
    echo "$line" | sudo tee -a "$file" > /dev/null
fi

sudo pacman -Syu --needed - < cinxfce
sudo sed -i 's/^#greeter-setup-script=/greeter-setup-script=\/usr\/bin\/numlockx\ on/' /etc/lightdm/lightdm.conf
sudo systemctl enable lightdm

echo "#########################"
echo "#### Install themes. ####"
echo "#########################"

yay -S --needed kvantum-theme-materia materia-gtk-theme
if [ -d /usr/share/icons/Fluent ]; then
    echo "Fluent Icon Theme is already installed."; else
    git clone https://github.com/vinceliuice/Fluent-icon-theme.git
    cd Fluent-icon-theme
    sudo ./install.sh -r
    cd ..
fi

gsettings set org.cinnamon.desktop.interface gtk-theme "Materia-dark-compact" && gsettings set org.cinnamon.theme name "Materia-dark-compact" && gsettings set org.cinnamon.desktop.interface icon-theme "Fluent-dark"

xfconf-query -c xsettings -p /Net/ThemeName -s "Materia-dark-compact" && xfconf-query -c xfwm4 -p /general/theme -s "Materia-dark-compact" && xfconf-query -c xsettings -p /Net/IconThemeName -s "Fluent-dark"

echo -e "[greeter]\ntheme-name = Materia-dark-compact\nicon-theme-name = Fluent-dark\nhide-user-image = true\nindicators = ~clock;~spacer;~session;~a11y;~power" | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null

echo "################################################"
echo "Done! You can manually delete this folder later!"
echo "############# Reboot is recomended #############"
echo "################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
