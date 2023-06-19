cd ~/.config
rm -rf Kvantum
rm -rf qt5ct
rm -rf qt6ct
rm -rf vlc
cd ~/CAS
cp -a Kvantum ~/.config
cp -a qt5ct ~/.config
cp -a qt6ct ~/.config
if [ "$(pactree -r vlc)" ]; then
    cp -a vlc ~/.config
else
    echo "Vlc is not instaled so theming is skipped"
fi

echo "QT application is themed"
