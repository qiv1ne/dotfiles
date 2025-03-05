# Dotfiles installation

Full installation 
```
curl -fsSL "" | sh
```

## i3
Install dependencies
```
sudo emerge --newuse i3 i3lock-color i3bar rofi picom i3status xwallpaper 
```

Copy dotfiles

```
cp -r ./dotfiles/i3 ~/.config/
cp -r ./dotfiles/rofi ~/.config/
cp -r ./dotfiles/.wallpaper ~/
```

## Neovim

Install dependencies 
```
sudo emerge --newuse go rg neovim
```

## 