## Zsh

https://wiki.gentoo.org/wiki/Zsh

### oh-my-zsh

https://github.com/ohmyzsh/ohmyzsh

Plugins

https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md

https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md

https://github.com/romkatv/powerlevel10k

## 
## Brave
```
emerge --ask app-eselect/eselect-repository dev-vcs/git
```
```
eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
emerge --sync brave-overlay
emerge --ask www-client/brave-bin::brave-overlay
