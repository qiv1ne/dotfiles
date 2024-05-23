## 
## Brave
```
emerge --ask app-eselect/eselect-repository dev-vcs/git
```
```
eselect repository add brave-overlay git https://gitlab.com/jason.oliveira/brave-overlay.git
emerge --sync brave-overlay
emerge --ask www-client/brave-bin::brave-overlay
