# Gentoo plan

Use [genkernel](https://wiki.gentoo.org/wiki/Genkernel) instead of distribution kernel and highly customize it

[wayland](https://wiki.gentoo.org/wiki/Wayland) with [hyprland](https://wiki.gentoo.org/wiki/Hyprland)

https://www.reddit.com/r/Gentoo/comments/150r74m/guide_hyprland_nvidia_extremely_minimal_gentoo/

power modes: [cpu](https://github.com/AdnanHodzic/auto-cpufreq) + [tlp for battery](https://wiki.gentoo.org/wiki/Power_management/Guide)

[zram](https://wiki.gentoo.org/wiki/Zram) instead of swapq

for configuring buttons using [xev](https://packages.gentoo.org/packages/x11-apps/xev), [forum](https://forums.gentoo.org/viewtopic-p-6909782.html)

add disk encryption 


## Useful packages

emerge --ask --quiet --verbose usbutils dosfstools pciutils gentoolkit

## Config

https://wiki.gentoo.org/wiki/Cfg-update

## GURU

https://wiki.gentoo.org/wiki/Eselect/Repository

    eselect repository enable guru

## Zsh

https://wiki.gentoo.org/wiki/Zsh

### oh-my-zsh

https://github.com/ohmyzsh/ohmyzsh

Plugins

https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md

https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md

https://github.com/romkatv/powerlevel10k


## Display-manager

https://wiki.gentoo.org/wiki/Display_manager

https://wiki.gentoo.org/wiki/SDDM

## Wifi

https://wiki.gentoo.org/wiki/Wi-Fi

### wpa_supplicant

https://wiki.gentoo.org/wiki/Wpa_supplicant

### Connecting

https://wiki.gentoo.org/wiki/Handbook:AMD64/Networking/Wireless

## Use-flag-issue

https://forums.gentoo.org/viewtopic-t-1089708-start-0.html

## fonts

https://forums.gentoo.org/viewtopic-p-7048980.html

https://forums.gentoo.org/viewtopic-t-1114772-start-0.html

## vmbox

https://wiki.gentoo.org/wiki/VirtualBox






https://www.atlassian.com/git/tutorials/dotfiles

[Terminal emulator - hyprland]

[Editor - neovim](https://wiki.gentoo.org/wiki/Neovim)

[Task manager - btop](https://wiki.gentoo.org/wiki/Btop)
 
[App launcher - rofi](https://packages.gentoo.org/packages/x11-misc/rofi)

[Notification manager - Dunst](https://wiki.gentoo.org/wiki/Dunst) 
 
[Clipboard manager - [cliphist](https://gpo.zugaina.org/gui-apps/cliphist) + https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/  

[Panel - waybar](https://wiki.gentoo.org/wiki/Waybar)

[Music - mpv](https://wiki.gentoo.org/wiki/Mpv) + https://github.com/yurihs/waybar-media
  
[Wallpaper manager - feh](https://wiki.gentoo.org/wiki/Feh)

[Wifi - wpa_supplicant](https://wiki.gentoo.org/wiki/Wpa_supplicant)  

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


## Fonts

    sudo cp -r .fonts/* /use/share/fonts/


## Installing dependencies for other stuff


Neovim 0.9.2+
Nerd font

    neovim git npm python curl wget unzip tar gzip cargo go


