
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
# TODO: change after install
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
```
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=key exchange key/" -keyout KEK.key -out KEK.crt -days 3650 -nodes -sha256
```
```
openssl req -new -x509 -newkey rsa:2048 -subj "/CN=kernel signing key/" -keyout db.key -out db.crt -days 3650 -nodes -sha256
```
```
chmod -v 400 *.key
UUID=#(uuidgen)
```
```
cert-to-efi-sig-list -g $UUID PK.crt PK.esl
sign-efi-sig-list -k PK.key -c PK.crt PK PK.esl PK.auth
```
```
cert-to-efi-sig-list -g $UUID KEK.crt KEK.esl
sign-efi-sig-list -a -k PK.key -c PK.crt KEK KEK.esl KEK.auth
```
```
cert-to-efi-sig-list -g $UUID db.crt db.esl
```
```
sign-efi-sig-list -a -k KEK.key -c KEK.crt db db.esl db.auth
```
```
sign-efi-sig-list -k KEK.key -c KEK.crt dbx dbx.esl dbx.auth
```
```
sign-efi-sig-list -k KEK.key -c KEK.crt dbc old_dbx.esl old_dbx.auth
```
```
openssl x509 -outform DER -in PK.crt -out PK.cer
```
```
openssl x509 -outform DER -in KEK.crt -out KEK.cer
```
```
openssl x509 -outform DER -in db.crt -out db.cer
```
```
cat old_KEK.esl KEK.esl > compound_KEK.esl
```
```
cat old_db.esl db.esl > compound_db.esl
```
```
sign-efi-sig-list -k PK.key -c PK.crt KEK compound_KEK.esl compound_KEK.auth
```
```
sign-efi-sig-list -k KEK.key -c KEK.crt db compound_db.esl compound_db.auth

```
Now we need to reboot system and turn on secure boot

When you login command
```
efi-readvar
```
should say that variables has no entries
```
efi-updatevar -e -f compound_db.esl db
```
```
efi-updatevar -e -f compound_KEK.esl KEK
```
```
efi-updatevar -f PK.auth PK
```

Now when you `efi-readvar` it should print many signatures and hashes

Now let's check our variables
```
efi-readvar -v PK -o new PK.esl
```
```
efi-readvar -v KEK -o new_KEK.esl
```
```
efi-readvar -v db -o new_db.esl
```
```
efi-readvar -v dbx -o new_dbx.esl
```

Now we will mount pation and sign kernel
```
mount /dev/sda1
```
```
cd /boot/efi
```
```
cd EFI
```
```
cd Boot
```
```
mv bootx64.efi bootx64-unsigned.efi
```
```
sbsign --key /etc/efikeys/db.key --cert /etc/efikeys/db.crt bootx64-unsigned.efi --output bootx64.efi
```
```
cd ../systemd/
```
```
mv systemd-bootx64.efi systemd-bootx64-unsigned.efi
```
```
sbsign --key /etc/efikeys/db.key --cert /etc/efikeys/db.crt --output systemd-bootx64.efi
```
```
cd ../gentoo/
```
```
mv vmlinuz-*.efi vmlinuz-*-unsigned.efi
```
```
cd ../gentoo/
```
```
sbsign --key /etc/efikeys/db.key --cert /etc/efikeys/db.crt vmlinuz-*-unsigned.efi --output vmlinuz-*.efi
```
Now reboot and enable secure boot

To check SecureBoot status use this command
```
mokutil --sb-state
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
passwd -dl root
```
## Disk cleanup
```
rm /stage3-*.tar.*
```
```
emerge --deepclean
```

## Neovim

dependencies
app-emacs/rg dev-libs/tree-sitter dev-lua/luarocks dev-python/pynvim dev-python/tree-sitter media-fonts/fontawesome media-fonts/noto-emoji sys-apps/fd sys-apps/ripgrep neovim

