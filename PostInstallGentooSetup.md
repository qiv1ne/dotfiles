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
## Cups
```
sudo echo "net-print/cups zeroconf" >> /etc/portage/package.use/cups
```
```
sudo emerge --ask net-print/cups
```
```
emerge --ask net-print/cups-meta
```
```
sudo echo "net-print/hplip hpijs
net-print/hplip scanner
net-print/hplip X
net-print/hplip python" >> /etc/portage/package.use/hplip
```
```
sudo emerge net-print/hplip
```
```
gpasswd -a username lp
```
```
rc-service cupsd start
```
```
rc-update add cupsd default
```
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
## Bluetooth
```
emerge --ask --noreplace net-wireless/bluez
```
```
rc-service bluetooth start
```
```
rc-update add bluetooth default
```

## Qemu
```
sudo echo" virgl usbredir gtk policykit spice" emerge --ask --quiet --verbose --tree virt-manager qemu xf86-video-qxl app-emulation/spice spice-gtk spice-protocol net-firewall/iptables
```
```
gpasswd -a me kvm
```
```
gpasswd -a me libvirt
```
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
eselect repository enable steam-overlay
```
```
emerge --sync
```
```
sudo bash -c 'echo "x11-libs/libX11  abi_x86_32
x11-libs/libXau  abi_x86_32
x11-libs/libxcb  abi_x86_32
x11-libs/libXdmcp  abi_x86_32
virtual/opengl  abi_x86_32
media-libs/mesa  abi_x86_32
dev-libs/expat  abi_x86_32
media-libs/libglvnd  abi_x86_32
sys-libs/zlib  abi_x86_32
x11-libs/libdrm  abi_x86_32
x11-libs/libxshmfence  abi_x86_32
x11-libs/libXext  abi_x86_32
x11-libs/libXxf86vm  abi_x86_32
x11-libs/libXfixes  abi_x86_32
app-arch/zstd  abi_x86_32
sys-devel/llvm  abi_x86_32
x11-libs/libXrandr  abi_x86_32
x11-libs/libXrender  abi_x86_32
dev-libs/libffi  abi_x86_32
sys-libs/ncurses  abi_x86_32
dev-libs/libxml2  abi_x86_32
dev-libs/icu  abi_x86_32
sys-libs/gpm  abi_x86_32
virtual/libelf  abi_x86_32
dev-libs/elfutils  abi_x86_32
app-arch/bzip2  abi_x86_32
dev-libs/nspr  abi_x86_32
dev-libs/nss  abi_x86_32
net-libs/libndp  abi_x86_32
x11-libs/extest abi_x86_32
dev-libs/libevdev abi_x86_32
dev-libs/wayland abi_x86_32
virtual/rust abi_x86_32
dev-lang/rust-bin abi_x86_32
x11-libs/libpciaccess abi_x86_32
sys-devel/clang abi_x86_32
media-libs/fontconfig abi_x86_32
sys-libs/libudev-compat abi_x86_32
media-libs/libpulse abi_x86_32
media-libs/libsndfile abi_x86_32
net-libs/libasyncns abi_x86_32
sys-apps/dbus abi_x86_32
dev-libs/glib abi_x86_32
dev-libs/libpcre2 abi_x86_32
sys-apps/util-linux abi_x86_32
media-libs/flac abi_x86_32
media-libs/libogg abi_x86_32
media-libs/libvorbis abi_x86_32
media-libs/opus abi_x86_32
media-sound/lame abi_x86_32
media-sound/mpg123-base abi_x86_32
media-libs/freetype abi_x86_32
media-libs/libpng abi_x86_32
virtual/libintl abi_x86_32
virtual/libudev abi_x86_32
sys-apps/systemd-utils abi_x86_32
sys-libs/libcap abi_x86_32
sys-libs/pam abi_x86_32
virtual/libiconv abi_x86_32
x11-libs/xcb-util-keysyms abi_x86_32" >> /etc/portage/package.use/steam'
```
```
sudo bash -c 'echo "sys-libs/ncurses -gpm" >> /etc/portage/package.use/ncurses'
```
```
emerge --ask --changed-use --deep @world
```
```
mkdir /etc/portage/package.accept_keywords && echo "*/*::steam-overlay
games-util/game-device-udev-rules
sys-libs/libudev-compat" >> /etc/portage/package.accept_keywords/steam
```
```
mkdir /etc/portage/package.license && echo "games-util/steam-launcher ValveSteamLicense" >> /etc/portage/package.license/steam
```
```
emerge --ask games-util/steam-launcher
```

## Brave
```
emerge --ask app-eselect/eselect-repository dev-vcs/git
```
```
eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
```
```
emerge --sync brave-overlay
```
```
emerge --ask www-client/brave-bin::brave-overlay
```


## NeoVim

```
sudo USE="npm" emerge --ask app-editors/neovim sys-apps/ripgrep sys-apps/fd dev-libs/tree-sitter net-libs/nodejs dev-python/pynvim luarocks php composer julia golangci-lint
```
```
sudo npm install -g neovim
```
```
sudo npm install live-server
```
