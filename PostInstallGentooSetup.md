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
## Pipewire
installed by default on kde
all good, just install alsa-utils and change mic boost in alsamixer

## Bluetooth

```
add `bluetooth` USE flag in /etc/portage/make.conf
```
```
emerge --ask --changed-use --deep @world
```
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


## zsh
```
emerge --ask app-shells/zsh
```
```
emerge --ask app-shells/zsh-completions
```


Enable `zsh-completion` USE flag in /etc/portage/make.conf

```
echo "autoload -U compinit promptinit" >> ~/.zshrc && echo "compinit" >> ~/.zshrc && echo "promptinit; prompt gentoo" >> ~/.zshrc
```
```
chsh -s /bin/zsh
```
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
```
emerge app-shells/starship
```
```
cd ~ && git clone https://github.com/Cirqach/dotfiles &&  cp -r ~/dotfiles/.oh-my-zsh ~/ && cp ~/dotfiles/.zshrc ~/ && cp ~/dotfiles/.zshrc.pre-oh-my-zsh ~/ 
```
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

## 
