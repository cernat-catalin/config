## Install the drivers
```bash
sudo pacman -S dfu-util
sudo cp 98-kiibohd.rules /etc/udev/rules.d
sudo udevadm control --reload-rules
sudo udevadm trigger
```

## Download the IC Configurator
```bash
[AppImage](https://github.com/kiibohd/configurator/releases/download/v1.0.2/kiibohd-configurator-1.0.2-linux-x86_64.AppImage)

chmod +x kiibohd-configurator-1.0.2-linux-x86_64.AppImage
./kiibohd-configurator-1.0.2-linux-x86_64.AppImage
```
