## It's my Gentoo linux post install setup

Purpose of this guide is to install software for my needs and get dotfiles for software I use.

### Post install

First of all. Install some VERY usefull packages
```
emerge sudo usbutils pciutils gentoolkit udev cfg-update eselect-repository vim btop
```

Install new user
```
useradd -m -G wheel,audio,video,usb -s /bin/bash me
passwd me
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
passwd -dl root
su me
```


Enable guru overlay
```
sudo emerge --newuse app-eselect/eselect-repository
sudo eselect repository enable guru
sudo emerge --sync guru
```

Change portage to git instead of rsync
```
sudo eselect repository disable gentoo
sudo eselect repository enable gentoo
sudo rm -r /var/db/repos/gentoo
sudo emaint sync -r gentoo
```

KDE Plasma and Pipewire
```
echo "media-video/pipewire pipewire-alsa" >> /etc/portage/package.use/pipewire
echo "kde-plasma/plasma-meta display-manager networkmanager sddm smart wallpapers" >> /etc/portage/package.use/plasma
sudo emerge plasma-meta pipewire pulseaudio wireplumber sys-auth/rtkit
sudo usermod -rG audio,pipewire larry
systemctl --user disable --now pulseaudio.socket pulseaudio.service
systemctl --user enable --now pipewire-pulse.socket wireplumber.service
systemctl --user enable --now pipewire.service
```

Brave browser
```
sudo eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
sudo emerge --sync brave-overlay
sudo emerge www-client/brave-bin::brave-overlay
```

Z shell
```
sudo emerge --ask app-shells/zsh app-shells/zsh-completions
sudo cp -r zsh/.* ~/
```

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

Power management
```
sudo emerge --ask sys-power/thermald cpupower sys-power/tlp powertop
systemctl enable --now tlp thermald powertop
```

Neovim
```
sudo emerge --ask app-emacs/rg dev-libs/tree-sitter dev-lua/luarocks dev-python/pynvim dev-python/tree-sitter media-fonts/fontawesome media-fonts/noto-emoji sys-apps/fd sys-apps/ripgrep neovim
sudo cp -r .config/nvim ~/.config/
```
