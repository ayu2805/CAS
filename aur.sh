#!/bin/sh

read -r -p "Do you want to install yay? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    yay -Syu systemd-numlockontty
    sudo systemctl enable numLockOnTty
fi

read -r -p "Do you want to install VS Code(from AUR)? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    yay -Syu visual-studio-code-bin
fi

read -r -p "Do you want to install VS Code(from AUR)? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    yay -Syu onlyoffice-bin
fi
