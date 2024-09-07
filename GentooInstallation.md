
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
# Secure boot
set USE flag `secureboot` in /etc/portage/make.conf

for creating keys and usingn secure boot need this packages:
```
emerge  app-crypt/efitools app-crypt/sbsigntools dev-libs/openssl
```
Backup keys for restore it in bad case
```
mkdir -p -v /etc/efikeys && cd /etc/efikeys && chmod 700 /etc/efikeys
```
```
efi-readvar -v PK -o old_PK.esl && efi-readvar -v KEK -o old_KEK.esl && efi-readvar -v db -o old_db.esl  && efi-readvar -v dbx -o old_dbx.esl
```
To create keyfiles protected with openssl
```
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=platform key/" -keyout PK.key -out PK.crt -days 3650 -nodes -sha256
```
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=key exchange key/" -keyout KEK.key -out KEK.crt -days 3650 -nodes -sha256
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=kernel signing key/" -keyout db.key -out db.crt -days 3650 -nodes -sha256
Creating new Signature List
```
for key_type in PK KEK db dbx; do cert-to-efi-sig-list -g $(< uuid.txt) ${key_type}.crt ${key_type}.esl; done
```
cd ..
Copying the signature lists
cp custom_config/*.esl .
Copying the Platform Key
cp custom_config/PK.esl .

Signing Signature List

```
sign-efi-sig-list -k custom_config/PK.key -c custom_config/PK.crt PK PK.esl PK.auth
```

Key Exchange Keys
sign-efi-sig-list -k custom_config/PK.key -c custom_config/PK.crt KEK KEK.esl KEK.auth

Signature Databases
for db_type in db dbx; do sign-efi-sig-list -k custom_config/KEK.key -c custom_config/KEK.crt $db_type ${db_type}.esl ${db_type}.auth ; done
Installing the Key Exchange Key
efi-updatevar -e -f KEK.esl KEK
Installing the Database Keys
for db_type in db dbx; do sudo efi-updatevar -e -f ${db_type}.esl $db_type; done
Installing the Platform Key
efi-updatevar -f PK.auth PK

## Kernel
### Distribution kernel
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
USE="tkip" emerge --ask net-wireless/iw net-wireless/wpa_supplicant
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
## Additional software
```
udev sudo 
```

## Finalazind and reboot
```
exit && umount /dev/mapper/root && cryptsetup luksClose root &&
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
