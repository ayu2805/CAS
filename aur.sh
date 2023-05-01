#!/bin/sh

read -r -p "Do you want to install VS Code(from AUR)? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    yay -Syu visual-studio-code-bin
fi

read -r -p "Do you want to install Onlyoffice(from AUR)? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    yay -Syu onlyoffice-bin
fi
