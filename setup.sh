#!/bin/sh

if [ "$(id -u)" = 0 ]; then
    echo "######################################################################"
    echo "This script should NOT be run as root user as it may create unexpected"
    echo " problems and you may have to reinstall Arch. So run this script as a"
    echo "  normal user. You will be asked for a sudo password when necessary"
    echo "######################################################################"
    exit 1
fi

sudo pacman -Sy --needed --noconfirm pacman-contrib
if [ "$(pactree -r yay)" ]; then
    echo "Yay is already installed"
else
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
fi

if [ -d /usr/share/icons/Fluent ]; then
    echo "Fluent Icon Theme is already installed."; else
    git clone https://github.com/vinceliuice/Fluent-icon-theme.git
    cd Fluent-icon-theme
    sudo ./install.sh -r
    cd ..
fi

sudo pacman -Sy --needed --noconfirm reflector
echo -e "--save /etc/pacman.d/mirrorlist\n--protocol https\n--country India\n--latest 5\n--sort rate" | sudo tee /etc/xdg/reflector/reflector.conf > /dev/null
#Change location as per your need(from "India" to anywhere else)
sudo systemctl enable --now reflector
sudo pacman -Syu --needed --noconfirm - < tpkg

line="QT_QPA_PLATFORMTHEME=qt6ct"
file="/etc/environment"
if ! sudo grep -qF "$line" "$file"; then
    echo "$line" | sudo tee -a "$file" > /dev/null
fi

#echo "Installing Cinnamon..."
#sudo pacman -Syu --needed --noconfirm - < cin
#gsettings set org.cinnamon.desktop.interface gtk-theme "Materia-dark-compact" && gsettings set org.cinnamon.theme name "Materia-dark-compact" && gsettings set org.cinnamon.desktop.interface icon-theme "Fluent-dark"
sudo sed -i 's/^#greeter-setup-script=/greeter-setup-script=\/usr\/bin\/numlockx\ on/' /etc/lightdm/lightdm.conf
#sudo systemctl enable lightdm
echo -e "[greeter]\ntheme-name = Materia-dark-compact\nicon-theme-name = Fluent-dark\nhide-user-image = true\nindicators = ~clock;~spacer;~session;~a11y;~power" | sudo tee /etc/lightdm/lightdm-gtk-greeter.conf > /dev/null

#sudo pacman -Syu --needed --noconfirm - < g
#gsettings set org.gnome.desktop.interface icon-theme "Fluent-dark"
#sudo systemctl enable gdm

echo "################################################"
echo "Done! You can manually delete this folder later!"
echo "############# Reboot is recomended #############"
echo "################################################"

read -r -p "Do you want to reboot now? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    reboot
fi
