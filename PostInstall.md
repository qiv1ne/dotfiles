# Post install

1. (Useful packages)[# Packages]
2. (New user)[# User]
3. (Guru overlay)[# Guru]
4. (Change portage to git)[#Portage]
5. (Pipewire)[#Pipewire]
6. (I3 window manager)[#I3]

## Packages 

```
emerge --ask sudo eselect-repository neovim htop app-admin/sudo app-portage/cfg-update media-sound/alsa-utils net-wireless/bluetuith sys-apps/pciutils sys-apps/usbutils app-portage/gentoolkit app-shells/bash-completion
```

##User
Adding new user
```
useradd -m -G wheel,audio,video,usb -s /bin/bash me
passwd me
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
passwd -dl root
su me
cd 
mkdir Downloads Documents 
```

##Guru
Enable guru overlay
```
sudo emerge --newuse app-eselect/eselect-repository
sudo eselect repository enable guru
sudo emerge --sync guru
```

## Portage
Change portage to git instead of rsync
```
sudo eselect repository disable gentoo
sudo eselect repository enable gentoo
sudo rm -r /var/db/repos/gentoo
sudo emaint sync -r gentoo
```

## Pipewire

You need to have pulseaudio USE flag in make.conf
```
echo "media-video/pipewire pipewire-alsa" >> /etc/portage/package.use/pipewire
sudo emerge pipewire pulseaudio wireplumber
sudo usermod -rG audio,pipewire me
systemctl --user disable --now pulseaudio.socket pulseaudio.service
systemctl --user enable --now pipewire-pulse.socket wireplumber.service pipewire.service
```

## I3

```
sudo emerge xorg-server xorg-drivers xterm xclock i3 rofi 
```

Brave browser
```
sudo eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
sudo emerge --sync brave-overlay
sudo emerge www-client/brave-bin::brave-overlay
```

[Z shell](./zsh/zsh.md)

Qemu/KVM with virt-manager
```
sudo echo "app-emulation/qemu opengl alsa gtk keyutils ncurses pipewire plugins spice udev usb usbredir virgl vte zstd" >> /etc/portage/package.use/qemu
sudo echo "app-emulation/libvirt udev qemu virt-network nfs nbd parted policykit pcap numa fuse macvtap vepa" >> /etc/portage/package.use/libvirt
sudo echo "app-emulation/virt-manager gui policykit" >> /etc/portage/package.use/virt-manager
sudo emerge qemu libvirt virt-manager
sudo gpasswd -a me kvm libvirt
sudo systemctl enable --now libvirtd
sudo mkdir -p /etc/polkit-l/localauthority/50-local.d
sudo echo "[Allow group libvirt management permissions]
Identity=unix-group:libvirt
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes" >> /etc/polkit-l/localauthority/50-local.d/org.libvirt.unix.manage.pkla
```

Flatpak
```
emerge --ask sys-apps/flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```
#### Install some apps
```
flatpak install flathub com.discordapp.Discord com.usebottles.bottles org.videolan.VLC com.valvesoftware.Steam net.lutris.Lutris org.qbittorrent.qBittorrent app.zen_browser.zen com.github.Matoking.protontricks com.wps.Office io.dbeaver.DBeaverCommunity io.mpv.Mpv
```

[Power management](./Installing and setup/Power management/powerManagement.md)

Neovim
```
sudo emerge --ask app-emacs/rg dev-libs/tree-sitter dev-lua/luarocks dev-python/pynvim dev-python/tree-sitter media-fonts/fontawesome media-fonts/noto-emoji sys-apps/fd sys-apps/ripgrep neovim
sudo cp -r .config/nvim ~/.config/
```
