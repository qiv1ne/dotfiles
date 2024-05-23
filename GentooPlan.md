# Gentoo plan

power modes: [cpu](https://github.com/AdnanHodzic/auto-cpufreq) + [tlp for battery](https://wiki.gentoo.org/wiki/Power_management/Guide)

[zram](https://wiki.gentoo.org/wiki/Zram) instead of swapq

for configuring buttons using [xev](https://packages.gentoo.org/packages/x11-apps/xev), [forum](https://forums.gentoo.org/viewtopic-p-6909782.html)

add disk encryption 


## Useful packages

emerge --ask --quiet --verbose usbutils dosfstools pciutils gentoolkit

## Zsh

https://wiki.gentoo.org/wiki/Zsh

### oh-my-zsh

https://github.com/ohmyzsh/ohmyzsh

Plugins

https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md

https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md

https://github.com/romkatv/powerlevel10k



[Terminal - kitty]()

[Editor - neovim](https://wiki.gentoo.org/wiki/Neovim)

[Task manager - btop](https://wiki.gentoo.org/wiki/Btop)
 
[App launcher - fuzzel](https://codeberg.org/dnkl/fuzzel)

[Shell - zsh](https://wiki.gentoo.org/wiki/Zsh)

#### Bloatware 
[Network management - dhcpcd_ui](https://wiki.gentoo.org/wiki/Dhcpcd-ui)  

[File manager - dolphin](https://wiki.gentoo.org/wiki/Dolphin)  

[Torrent client - qbittorrent](https://wiki.gentoo.org/wiki/QBittorrent)  

[Archive manager - ark](https://packages.gentoo.org/packages/kde-apps/ark)  

Web browser - [qutebrowser](https://wiki.gentoo.org/wiki/Qutebrowser) + [brave](https://wiki.gentoo.org/wiki/Brave)  

[Audio - audacity](https://wiki.gentoo.org/wiki/Audacity)  

[Video player - vlc](https://wiki.gentoo.org/wiki/VLC)
 
[Disk manager - GParted](https://wiki.gentoo.org/wiki/User:Maffblaster/Drafts/Gparted) 

Virual machine - KVM + [QEMU](https://wiki.gentoo.org/wiki/QEMU) + [Virt-Manager](https://wiki.gentoo.org/wiki/Virt-manager)

Games - [Lutris]() + [Steam]()

Browser - [Brave]() + [Tor]()

[Fonts](#)

## Fonts

    sudo cp -r .fonts/* /use/share/fonts/


## Installing dependencies for other stuff


Neovim 0.9.2+
Nerd font

    neovim git npm python curl wget unzip tar gzip cargo go



 
## Fuzzel
```
emerge -avt gui-apps/fuzzel
```

## mpv + https://github.com/yurihs/waybar-media

## zsh

## dhcpcd_ui

## dolphin 

## qbittorrent

## ark

## audacity

## vlc

## GParted

## KVM + QEMU + Virt-Manager

## Lutris + Steam

## Brave + Tor

