# Post install
## Must have packages 

```
emerge --ask sudo eselect-repository neovim htop app-admin/sudo app-portage/cfg-update media-sound/alsa-utils net-wireless/bluetuith sys-apps/pciutils sys-apps/usbutils app-portage/gentoolkit app-shells/bash-completion
```

## Adding new user

```
useradd -m -G wheel,audio,video,usb -s /bin/bash me
passwd me
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
passwd -dl root
su me
cd 
mkdir Downloads Documents 
```

## Guru overlay

```
sudo emerge --newuse app-eselect/eselect-repository
sudo eselect repository enable guru
sudo emerge --sync guru
```

## Portage to git
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


## Zsh

## Virtualization 

I use Qemu/KVM with virt-manager for virtualization 
```
sudo echo "app-emulation/qemu opengl alsa gtk keyutils ncurses pipewire plugins spice udev usb usbredir virgl vte zstd" >> /etc/portage/package.use/qemu
sudo echo "app-emulation/libvirt udev qemu virt-network nfs nbd parted policykit pcap numa fuse macvtap vepa" >> /etc/portage/package.use/libvirt
sudo echo "app-emulation/virt-manager gui policykit" >> /etc/portage/package.use/virt-manager
sudo emerge qemu libvirt virt-manager
sudo mkdir -p /etc/polkit-l/localauthority/50-local.d
sudo echo "[Allow group libvirt management permissions]
Identity=unix-group:libvirt
Action=org.libvirt.unix.manage
ResultAny=yes
ResultInactive=yes
ResultActive=yes" >> /etc/polkit-l/localauthority/50-local.d/org.libvirt.unix.manage.pkla
sudo gpasswd -a me kvm libvirt
sudo systemctl enable --now libvirtd
```

## Flatpak with flathub
```
emerge --ask sys-apps/flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

### Install Zen browser(main browser)

```
sudo Flatpak install app.zen_browser.zen
```

#### Install some bloatware 
```
flatpak install flathub com.discordapp.Discord com.usebottles.bottles org.videolan.VLC com.valvesoftware.Steam net.lutris.Lutris   com.github.Matoking.protontricks com.wps.Office io.dbeaver.DBeaverCommunity
```

#### Brave browser(second browser)
```
sudo eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
sudo emerge --sync brave-overlay
sudo emerge www-client/brave-bin::brave-overlay
```

### Power management 

```
sudo emerge --ask --newuse sys-power/cpupower sys-power/powertop sys-power/thermald sys-power/tlp
sudo systemctl enable --now thermald tlp
sudo tlp start
```

Now unplug your AC adapter and calibrate powertop:
```
sudo powertop --calibrate
sudo powertop --auto-tune
```

### *Neovim*
```
sudo emerge --ask app-emacs/rg dev-libs/tree-sitter dev-lua/luarocks media-fonts/fontawesome media-fonts/noto-emoji sys-apps/fd sys-apps/ripgrep neovim
```
