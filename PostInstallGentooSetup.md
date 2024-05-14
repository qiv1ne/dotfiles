# Setup after clean install
## Adding new user
```
useradd -m -G users,wheel,audio -s /bin/bash me
```
```
passwd me
```
```
emerge --ask sudo
```
```
nvim /etc/sudoers
```
uncomment wanted line

## Disable root login
```
passwd -dl root
```
## Disk cleanup
```
rm /stage3-*.tar.*
```
