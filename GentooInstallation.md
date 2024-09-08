
>[!note]
>if Wi-Fi then use net-setup for connecting

## Preparing disks
change partions with cfdisk utility.
```
cfdisk /dev/{device}
```
My volumes:
    1. boot/efi
    2. swap
    3. root
### LUKS
I use --sector-size=2048 because I use SSD, on NVME I want --sector-size=4096
```
cryptsetup luksFormat --sector-size=2048 --key-size=1024 /dev/sda3
```
Create strong passphrase

Open and map the LUKS device
```
cryptsetup luksOpen /dev/sda3 root
```
Now we can check our new LUKS device
```
cryptsetup status root
```
Device is available at /dev/mapper/root. Just use /dev/mapper/root for the device.

I will use btrfs
```
mkfs.btrfs /dev/mapper/root
```
```
mount /dev/mapper/root /mnt/gentoo
```
Creating and mounting swap
```
mkswap /dev/sda2
swapon /dev/sda2
```
Creating btrfs subvolume for home directory
```
btrfs subvolume create /mnt/gentoo/home
```
I will use btrfs for boot/efi pation
```
mkfs.btrfs /dev/sda1 -f
```

Cd into mounted drive
```
cd /mnt/gentoo
```
Sync time
```
chronyd -q
```
Open terminal browser and download stage3 file from ru mirror
```
links https://www.gentoo.org/downloads/mirrors/
```
Unzip stage3
```
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```
Change make.conf like mine. Need to set:
    1. ACCEPT_LICENSE
    2. VIDEO_CARD
    3. USE
    4. MAKEOPTS
    5. -march flag

```
vim /mnt/gentoo/etc/portage/make.conf
```

[My make.conf](dotfiles/portage/make.conf)

Copying resolv.conf for connect to internet working
```
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
```
Mounting the necessary filesystems
```
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run
```
Entering the new environment
```
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(chroot) ${PS1}"
```
### Preparing for a bootloader
Mounting boot/efi partion
```
mount /dev/sda1 (/efi or /boot) --mkdir
```
### Updating the portage tree
```
emerge-webrsync
```
[!note]
> Mirror select need for select best mirrors for gentoo repos
> It's not need if you alredy define it in make.conf
Selecting mirrors
```
emerge --ask --verbose --oneshot app-portage/mirrorselect && mirrorselect -i -o >> /etc/portage/make.conf
```
### Updating the Gentoo ebuild repository
```
emerge --sync --quiet
```
### Choosing the right profile
```
eselect profile list | less
```
```
eselect profile set 28
```
### add C flags
```
emerge --ask --oneshot app-portage/cpuid2cpuflags
```
```
echo "*/* $(cpuid2cpuflags)" > /etc/portage/package.use/00cpu-flags
```
    
## Update @world set

```
emerge --ask --verbose --update --deep --newuse @world
```
```
emerge --ask --depclean
```
## Timezone
For OpenRC 
```
echo "Europe/Moscow" > /etc/timezone
```
```
emerge --config sys-libs/timezone-data
```
For systemd
```
ln -sf ../usr/share/zoneinfo/Europe/Brussels /etc/localtime
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
```
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
```
## Installing firmware and microcode
```
emerge --ask sys-kernel/linux-firmware sys-firmware/intel-microcode
```
For newer firmware mayby need to install sof-firmware
```
emerge --ask sys-firmware/sof-firmware
```
# Kernel
## Distribution kernel
```
echo "sys-kernel/installkernel dracut" >>  /etc/portage/package.use/installkernel
```
I prefer binnary package cause of i dont change any settings in kernel and compile time not necessary
```
emerge --ask sys-kernel/gentoo-kernel-bin
```
```
emerge --depclean
```
```
emerge --ask sys-kernel/installkernel
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

I use this params for volumes:

1. For btrfs: btrfs,noatime,defaults,autodefrag,compress-force=zstd:1
# Networking

### Hostname
[!note]
> for systemd use
> ``` hostnamectl hostname tux ```
```
echo {name} > /etc/hostname
```

### IP
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
### Init and boot configuration
```
systemd-machine-id-setup
```
```
systemd-firstboot --prompt
```
```
systemctl preset-all --preset-mode=enable-only
```
### [Other configuration](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/System)
## Tools
### Loggin daemon
[!note]
> for systemd not needed
```
emerge --ask app-admin/sysklogd
```
```
rc-update add sysklogd default
```
### Cron daemon
[!note]
> for systemd not needed
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
[!note]
> for systemd use
> ``` systemctl enable sshd ```
```
rc-update add sshd default
```
### Time synchronization
[!note]
> systemd
> ``` systemctl enable systemd-timesyncd.service ```
```
emerge --ask net-misc/chrony
```
```
rc-update add chronyd default
```
### File system tools
```
emerge --ask sys-block/io-scheduler-udev-rules sys-fs/xfsprogs 	sys-fs/e2fsprogs 	sys-fs/dosfstools 	sys-fs/btrfs-progs 	sys-fs/zfs 	sys-fs/jfsutils ntfs3g
```
### Networking tools
#### Ethernet
```
emerge --ask net-dialup/ppp
```
#### Wi-Fi
```
echo "net-wireless/wpa_supplicant tkip" >> /etc/portage/package.use/wpa_supplicant
```
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
Use this option if you want to use EFI
```
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
```
```
emerge --ask --verbose sys-boot/grub
```
[!note]
> for bios
> ``` grub-install --target=i386-pc /dev/sda ```
```
grub-install --target=x86_64-efi --efi-directory=/efi --removable
```
```
grub-mkconfig -o /boot/grub/grub.cfg
```
## Installing de/wm
If using open-rc than do this steps
```
emerge elogind
```
```
rc-update add elogind boot
```
```
gpasswd -a root video
```
## Install some usefull packages
```
emerge sudo udev pciutils usbutils cfg-update gentoolkit eselect-repository
```
# Adding new user
```
useradd -m -G wheel,audio,video,usb -s /bin/bash me
```
```
passwd me
```
```
vim /etc/sudoers
```
## Reboot
```
exit && umount /dev/mapper/root && cryptsetup luksClose root && cd && umount -l /mnt/gentoo/dev{/shm,/pts,} &&  umount -R /mnt/gentoo && reboot
```

# Post install


## Disable root login
```
sudo passwd -dl root
```
## Disk cleanup
```
sudo rm /stage3-*.tar.*
```
```
sudo emerge --deepclean
```

## Installing other software

```
sudo emerge --ask --quiet --verbose --tree kitty btop dolphin qbittorrent ark vlc gparted
```
## Bluetooth
Set global USE flag "bluetooth" in make.conf
```
emerge --ask --noreplace net-wireless/bluez
```
[!note]
> for systemd
> ``` sudo systemctl enable bluetooth && sudo systemctl start bluetooth ```
```
rc-service bluetooth start
```
```
rc-update add bluetooth default
```
## Fonts
```
sudo mv ./dotfiles/fonts ~/.fonts && sudo mv ./dotfiles/fonts ~/.local/share/
```
## Guru
```
emerge --ask  app-eselect/eselect-repository
```
```
eselect repository enable guru
```
```
emerge --sync guru
```
## Neovim

dependencies
```
sudo emerge --ask app-emacs/rg dev-libs/tree-sitter dev-lua/luarocks dev-python/pynvim dev-python/tree-sitter media-fonts/fontawesome media-fonts/noto-emoji sys-apps/fd sys-apps/ripgrep neovim
```
```
sudo mv -r ./dotfiles/software/dots/soft/nvim ~/.config/
```

## Browsers

### Brave
```
sudo eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
```
```
sudo emerge --sync brave-overlay
```
```
sudo emerge --ask www-client/brave-bin::brave-overlay
```

### Zen browser
Install [flatpak](#Flatpak)
download Zen flatpak realese and install https://zen-browser.app/download

### Qutebrowser
```
sudo echo "www-client/qutebrowser adblock" >> /etc/portage/package.use/qutebrowser
```
```
sudo emerge --ask www-client/qutebrowser
```

### Tor
```
sudo eselect repository enable torbrowser
```
```
sudo emerge --sync torbrowser
```
```
sudo emerge --ask www-client/torbrowser-launcher
```

## Flatpak

```
emerge --ask sys-apps/flatpak
```

Flatseal let you change application permissions
```
sudo flatpak install com.github.tchx84.Flatseal
```

## Zswap

Write this line in /etc/default/grub
```
GRUB_CMDLINE_LINUX="zswap.enabled=1 zswap.compressor=lz4"
```

## Zsh

```
sudo emerge --ask app-shells/zsh
```
```
sudo emerge --ask app-shells/zsh-completions app-shells/gentoo-zsh-completions 
```
```
sudo mv ./dotfiles/software/dots/shells/zsh ~/
```
## Qemu/KVM with virt-manager

Set use flags for qemu and rebuild it
```
sudo echo "app-emulation/qemu opengl alsa gtk keyutils ncurses pipewire plugins spice udev usb usbredir virgl vte zstd" >> /etc/portage/package.use/qemu && sudo emerge qemu
```
Set use flags for libvirt and rebuild it
```
sudo echo "app-emulation/libvirt udev qemu virt-network nfs nbd parted policykit pcap numa fuse macvtap vepa" >> /etc/portage/package.use/libvirt && sudo emerge libvirt
```
Set use flags for virt-manager and rebuild it
```
sudo echo "app-emulation/virt-manager gui policykit" >> /etc/portage/package.use/virt-manager && sudo emerge virt-manager
```
```
gpasswd -a me kvm && gpasswd -a me libvirt
```
[!note]
> for systemd 
> ```sudo systemctl enable libvirtd && sudo systemctl start libvirtd ```
```
rc-update add libvirtd default
```
```
mkdir -p /etc/polkit-l/localauthority/50-local.d
```
```
echo "[Allow group libvirt management permissions]
Identity=unix-group:libvirt
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes" >> /etc/polkit-l/localauthority/50-local.d/org.libvirt.unix.manage.pkla
```
```
reboot
```
## Steam

```
sudo emerge --ask games-util/game-device-udev-rules
```
```
sudo flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
```
sudo flatpak install flathub com.valvesoftware.Steam
```
```
sudo flatpak run com.valvesoftware.Steam
```
## Discord
```
sudo flatpak install flathub com.discordapp.Discord
```
## Lutris
```
emerge --ask games-util/lutris
```
```
echo "#Lutris multilib dependencies
media-libs/vulkan-loader abi_x86_32
media-libs/vulkan-layers abi_x86_32
media-libs/freetype abi_x86_32
media-libs/libpng abi_x86_32
net-libs/gnutls abi_x86_32
media-libs/libsdl2 abi_x86_32" >> /etc/portage/package.use/lutris
```
```
emerge --ask --changed-use --deep @world
```

## Bottles
```
flatpak install flathub com.usebottles.bottles
```

## Power managment
```
sudo emerge --ask sys-power/thermald cpupower
```
```
systemctl enable thermald
```
```
emerge --ask sys-power/tlp
```
```
systemctl enable --now tlp
```
```
sudo eselect repository enable gentoo-zh && sudo emerge --sync gentoo-zh
```
```
sudo emerge tlpui
```
