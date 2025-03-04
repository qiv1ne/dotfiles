# Gentoo installation 

## Gentoo setup

Mainly I use holy Handbook and here I will only explain why I maid this chooses and not different. 

### File system 

I use XFS without any encryption or LLVM. I tried many file systems and didn't see the real difference in performance(maybe because I don't have any big data transfer processes), I can admit that BTRFS is really nice with it snapshots, but I don't use BTRFS because it's really easy to break(I many times broke it with suddenly power off of my PC).

Also I try installing ZFS but it too complicated. Maybe I will give it another try when I will have time for it. 

I think LUKS is a little bit overhead for me, I don't contain really confident information on my system(yeah, this is stupid point of view). Also I don't want to encrypt my drive for have possibility to backup information if I fucked up my system or I will suddenly decide to reinstall my system.

### Init system

I use systemd. I know systemd is bad and Openrc fits better in Unix philosophy, but systemd is more wildly used in production and that's all. 

### Kernel

I use the ⁸binary distribution kernel because I'm too lazy to configure kernel by myself. But sometime, I hope, I find the will to use modprobe-db to configure kernel. 

### Bootloader 

Grub. Because I need to dual boot with windows(for shitty 3rd country college). Some day I will change it. 

