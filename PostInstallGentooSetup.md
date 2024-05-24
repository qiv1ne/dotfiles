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
## Pulseaudio
```

emerge sys-auth/pambase
```
```

getfacl /dev/snd/controlC0 | grep -Eo "user:.+:" | cut -d: -f2
<me>
```
```

emerge --ask media-plugins/alsa-plugins
```
```

echo "default_driver=pulse" >> /etc/libao.conf
```
```
echo "drivers = pulse" >> /etc/openal/alsoft.conf
```
```
mkdir -p /etc/portage/profile
```
```
echo "-system-wide" >> /etc/portage/profile/use.mask
```
```
echo "media-sound/pulseaudio system-wide" >> /etc/portage/package.use
```
```
emerge --ask --oneshot pulseaudio
```
```
echo "load-module module-native-protocol-tcp auth-ip-acl=1.2.3.0/24" >> /etc/pulse/system.pa && echo "load-module module-alsa-sink" >> /etc/pulse/system.pa
```
```
echo "PULSEAUDIO_SHOULD_NOT_GO_SYSTEMWIDE=1" >> /etc/conf.d/pulseaudio
```
```
rc-update add pulseaudio default
```
```
rc-service pulseaudio start
```
```
pacmd load-module module-tunnel-sink server=1.2.3.4
```
```
echo "load-module module-tunnel-sink server=1.2.3.4" >> /etc/pulse/default.pa
```


## Bluetooth

## zsh

## 
