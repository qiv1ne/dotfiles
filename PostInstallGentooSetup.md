# Setup after clean install
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
nvim /etc/sudoers
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
