# Power management

Installing necessary packages on Gentoo linux:

```
sudo emerge --ask --newuse sys-power/cpupower sys-power/powertop sys-power/thermald sys-power/tlp sys-process/btop
```

Start services:
```
sudo systemctl enable --now thermald tlp
sudo tlp start
```

Now unplug your AC adapter and calibrate powertop:
```
sudo powertop --calibrate
sudo powertop --auto-tune
```
