# Gentoo plan

Use [genkernel](https://wiki.gentoo.org/wiki/Genkernel) instead of distribution kernel and highly customize it

[efibootmgr]() instead of grub

[wayland](https://wiki.gentoo.org/wiki/Wayland) with [hyprland](https://wiki.gentoo.org/wiki/Hyprland)

https://www.reddit.com/r/Gentoo/comments/150r74m/guide_hyprland_nvidia_extremely_minimal_gentoo/

power modes: [cpu](https://github.com/AdnanHodzic/auto-cpufreq) + [tlp for battery](https://wiki.gentoo.org/wiki/Power_management/Guide)

[zram](https://wiki.gentoo.org/wiki/Zram) instead of swapq

for configuring buttons using [xev](https://packages.gentoo.org/packages/x11-apps/xev), [forum](https://forums.gentoo.org/viewtopic-p-6909782.html)

add disk encryption 

delete root user for security 

 [Installing with Handbook](https://wiki.gentoo.org/wiki/Handbook:AMD64)

## Necessary packages

git sudo

## Useful packages

emerge --ask --quiet --verbose usbutils dosfstools pciutils gentoolkit

## Adding new user

    useradd -m username
    usermod -aG wheel,audio,video
    emerge sudo
    nvim /etc/sudoers
uncomment ***%wheel All=(All) All***
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

# Full install steps

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
mkfs.{vfat/ext2} /dev/{efi/boot}
```
### Mounting the root partition
```
mkdir --parents /mnt/gentoo
mkdir --parents /mnt/gentoo/efi
mount /dev/sda3 /mnt/gentoo
```
## Installing base system

    cd /mnt/gentoo

### Syncing time 

    date
    chronyd -q
if date is wrong than set it manualy with this pattern **{month}{day}{hours}{minutes}{year}**, for example to set the date to October 3rd, 13:16 in the year 2021:

    
    date 100313162021 

### Downloading stage file

    links https://www.gentoo.org/downloads/mirrors/
    tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

### Setting compile options
    nano /mnt/gentoo/etc/portage/make.conf
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
    mount --rbind /sys /mnt/gentoo/sys
    mount --make-rslave /mnt/gentoo/sys
    mount --rbind /dev /mnt/gentoo/dev
    mount --make-rslave /mnt/gentoo/dev
    mount --bind /run /mnt/gentoo/run
    mount --make-slave /mnt/gentoo/run
```
### Entering the new environment
```
    chroot /mnt/gentoo /bin/bash
    source /etc/profile
    export PS1="(chroot) ${PS1}"
```
### Preparing for a bootloader
>[!note]
>for bios system `mount /dev/sda1 /boot`
```
    mkdir /efi
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
    mirrorselect -i -o >> /etc/portage/make.conf
```
### Updating the Gentoo ebuild repository
```
    emerge --sync
```
### add C flags
```
    emerge --ask --oneshot app-portage/cpuid2cpuflags
    cpuid2cpuflags
    echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
```
### Choosing the right profile
```
    eselect profile list
    eselect profile set 2
```
### Configuring the USE variable
```
    emerge --info | grep ^USE
```
use flags: "wayland -kde -libreoffice pipewire qt5 gtk bluetooth"

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
    emerge --ask --depclean
```
## Timezone
```
    ls -l /usr/share/zoneinfo/Europe/Moscow
    echo "Europe/Moscow" > /etc/timezone
    emerge --config sys-libs/timezone-data
```
## Configure locales
```
    nano /etc/locale.gen
```
for add english and russian locales:
```
    en_US ISO-8859-1
    en_US.UTF-8 UTF-8
    ru_RU.UTF-8 UTF-8
    ru_RU ISO-8859-1
```
setting locales
```
locale-gen
eselect locale list
eselect locale set 2
```

## Kernel
### Installing firmware and microcode
>[!note]
> Microcode for AMD processor installed in linux-firmware
```
emerge --ask sys-kernel/linux-firmware sys-firmware/intel-microcode
```
###  Installing genkernel
```
mkdir /etc/portage/package.license
echo "sys-kernel/linux-firmware @BINARY-REDISTRIBUTABLE" >> /etc/portage/package.license
emerge --ask sys-kernel/genkernel
```
for installing all kernel for all supported software ```genkernel --mountboot --install all```
