## Adding new user
```
useradd -m -G wheel,audio,video,usb,cdrom -s /bin/bash me
```
```
passwd me
```
```
emerge --ask sudo
```

```
vim /etc/sudoers
```
uncomment wanted line

## Disable root login
```
passwd -dl root
```
## Configuring multi monitor
```
xrandr | grep -w connected
```
write scirpt by example: https://wiki.gentoo.org/wiki/SDDM

## Disk cleanup
```
rm /stage3-*.tar.*
```
```
emerge --deepclean
```
## Add guru gentoo overlay
```
emerge --ask  app-eselect/eselect-repository
```
```
eselect repository enable guru
```
```
emerge --sync guru
```
## Pipewire
installed by default on kde


## Bluetooth

add `bluetooth` USE flag in /etc/portage/make.conf
emerge --ask --changed-use --deep @world
emerge --ask --noreplace net-wireless/bluez
rc-service bluetooth start
rc-update add bluetooth default

## zsh

## 
