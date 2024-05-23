
>[!note]
>if WiFi then use net-setup for connecting


## Preparing disks
change partions with cfdisk utility
```
cfdisk /dev/{device}
```
### formating disk
```
mkfs.btrfs /dev/{root}
```
```
mkfs.{vfat/ext2} /dev/{efi/boot}
```
### Mounting the root partition
```
mkdir --parents /mnt/gentoo
```
```
mkdir --parents /mnt/gentoo/efi
```
```
mount /dev/sda3 /mnt/gentoo
```
## Installing base system
```
cd /mnt/gentoo
```

### Syncing time 
```
date
```
```
chronyd -q
```
if date is wrong than set it manualy with this pattern **{month}{day}{hours}{minutes}{year}**, for example to set the date to October 3rd, 13:16 in the year 2021:

```    
date 100313162021 
```
### Downloading stage file
```
links https://www.gentoo.org/downloads/mirrors/
```
```
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```

### Setting compile options
```
nano /mnt/gentoo/etc/portage/make.conf
```
write **-march=native**
set **MAKEOPTS="-j4 -l5"**
j = min(RAM/2GB, threads)
l = number of threads returned by **nproc**

## Chrooting

### Copy DNS info
```
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
```
### Mounting the necessary filesystems
```
mount --types proc /proc /mnt/gentoo/proc
```
```
mount --rbind /sys /mnt/gentoo/sys
```
```
mount --make-rslave /mnt/gentoo/sys
```
```
mount --rbind /dev /mnt/gentoo/dev
```
```
mount --make-rslave /mnt/gentoo/dev
```
```
mount --bind /run /mnt/gentoo/run
```
```
mount --make-slave /mnt/gentoo/run
```
### Entering the new environment
```
chroot /mnt/gentoo /bin/bash
```
```
source /etc/profile
```
```
export PS1="(chroot) ${PS1}"
```
### Preparing for a bootloader
>[!note]
>for bios system `mount /dev/sda1 /boot`
```
mkdir /efi
```
```
mount /dev/sda1 /efi
```
## Configuring Portage

### Installing a Gentoo ebuild repository snapshot from the web 
```
emerge-webrsync
```
### Selecting mirrors
```
emerge --ask --verbose --oneshot app-portage/mirrorselect
```
```
mirrorselect -i -o >> /etc/portage/make.conf
```
### Updating the Gentoo ebuild repository
```
emerge --sync
```
### add C flags
```
emerge --ask --oneshot app-portage/cpuid2cpuflags
```
```
cpuid2cpuflags
```
```
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
```
### Choosing the right profile
```
eselect profile list
```
```
eselect profile set 2
```
### Configuring the USE variable
```
emerge --info | grep ^USE
```
use flags: "grub dbus sddm gtk pulseaudio gtk3 display-manager kde -libreoffice -gnome bluetooth"

### Set videocard drivers
```
VIDEO_CARDS="nvidia intel"
```
 1. For nvidia: **nvidia**
 2. For amd: **amdgpu radeonsi**
 3. For intel: **intel**

### Set accept license
```
ACCEPT_LICENSE="*"
```
    
## Update @world set

```
emerge --ask --verbose --update --deep --newuse @world
```
```
emerge --ask --depclean
```
## Timezone
```
ls -l /usr/share/zoneinfo/Europe/Moscow
```
```
echo "Europe/Moscow" > /etc/timezone
```
```
emerge --config sys-libs/timezone-data
```
## Configure locales
```
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
```
```
locale-gen
```
```
eselect locale list
```
```
eselect locale set 2
```

## Installing firmware and microcode
```
emerge --ask sys-kernel/linux-firmware sys-firmware/intel-microcode nvidia-drivers
```

## Distribution kernel
```
echo "sys-kernel/installkernel dracut" >>  /etc/portage/package.use/installkernel
```
```
emerge --ask sys-kernel/gentoo-kernel
```
```
emerge --depclean
```
```
emerge --ask sys-kernel/installkernel
```
```
emerge --ask sys-kernel/gentoo-sources
```

### Select kernel
```
eselect kernel list
```
```
eselect kernel set 1
```


## Writing fstab
```
blkid
```
```
vim /etc/fstab
```
write by [example](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/System)

## Networking

### Hostname
```
echo {name} > /etc/hostname
```
### Network
```
emerge --ask net-misc/dhcpcd
```
```
rc-update add dhcpcd default
```
```
rc-service dhcpcd start
```
## System information
### Root password
```
passwd
```
### [Other configuration](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/System)
## Tools
### Loggin daemon
```
emerge --ask app-admin/sysklogd
```
```
rc-update add sysklogd default
```
### Cron daemon
```
emerge --ask sys-process/cronie
```
```
rc-update add cronie default
```
### File indexing
```
emerge --ask sys-apps/mlocate
```
### SSH
```
rc-update add sshd default
```
### Time synchronization
```
emerge --ask net-misc/chrony
```
```
rc-update add chronyd default
```
### File system tools
```
emerge --ask sys-block/io-scheduler-udev-rules 	sys-fs/xfsprogs sys-fs/e2fsprogs 	sys-fs/dosfstools	sys-fs/btrfs-progs ntfs-3g
```
### Networking tools
#### Ethernet
```
emerge --ask net-dialup/ppp
```
#### WiFi
```
emerge --ask net-wireless/iw net-wireless/wpa_supplicant
```
## Bootloader
### GRUB
```
echo "sys-kernel/installkernel grub" >> /etc/portage/package.use/installkernel
```
```
emerge --ask sys-kernel/installkernel
```
```
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
```
```
emerge --ask --verbose sys-boot/grub
```
```
grub-install --target=x86_64-efi --efi-directory=/efi --removable
```
```
grub-mkconfig -o /boot/grub/grub.cfg
```
## Installing DE[KDE]
```
USE="smart" emerge --ask --verbose --quiet kde-plasma/plasma-desktop display-manager-init xrandr sddm kde-plasma/sddm-kcm xorg-drivers x11-base/xorg-server kde-plasma/kdeplasma-addons kde-apps/kwalletmanager kde-apps/dolphin x11-misc/sddm kde-plasma/systemsettings kde-plasma/kscreen alacritty
```
```
rc-update add elogind boot
```
```
echo "CHECKVT=7" > /etc/conf.d/display-manager && echo 'DISPLAYMANAGER="sddm"' >> /etc/conf.d/display-manager
```
```
rc-update add display-manager default
```
```
gpasswd -a root video
```
```
usermod -a -G video sddm
```
```
rc-service display-manager start
```
```
rc-service elogind start
```
## Rebooting
```
exit
```
```
cd
```
```
umount -l /mnt/gentoo/dev{/shm,/pts,}
```
```
umount -R /mnt/gentoo
```
```
reboot
```
