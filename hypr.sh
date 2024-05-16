#!/bin/sh
curl -L https://raw.githubusercontent.com/hyprwm/Hyprland/3229862dd4cbfa93638a4d16ed86ec2fda5d38a6/example/hyprland.conf -o /home/$username/.config/hypr/hyprland.conf
echo "exec-once=dbus-launch gentoo-pipewire-launcher & hyprpaper" >> /home/$username/.config/hypr/hyprland.conf
echo "exec-once=/home/$username/.config/hypr/portalstart" >> /home/$username/.config/hypr/hyprland.conf
echo "misc {
disable_hyprland_logo=1
disable_splash_rendering=1
}

env = QT_SCREEN_SCALE_FACTORS,1;1
env = WLR_NO_HARDWARE_CURSORS,1
env = GBM_BACKEND,nvidia-drm
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = _JAVA_AWT_WM_NONREPARENTING,1
env = ANV_QUEUE_THREAD_DISABLE,1
env = QT_QPA_PLATFORM,wayland
env = CLUTTER_BACKEND,wayland
env = SDL_VIDEODRIVER,wayland
env = XDG_SESSION_TYPE,wayland
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_DESKTOP,Hyprland
env = MOZ_ENABLE_WAYLAND,1
env = MOZ_DBUS_REMOTE,1" >> /home/$username/.config/hypr/hyprland.conf
echo "#\!/bin/bash
sleep 1
killall xdg-desktop-portal-hyprland
killall xdg-desktop-portal-wlr
killall xdg-desktop-portal
/usr/libexec/xdg-desktop-portal-hyprland &
sleep 2
/usr/libexec/xdg-desktop-portal &" > /home/$username/.config/hypr/portalstart
echo "#\!/bin/sh
cd ~
export XDG_RUNTIME_DIR=\"/tmp/hyprland\"
mkdir -p \$XDG_RUNTIME_DIR
chmod 0700 \$XDG_RUNTIME_DIR
exec dbus-launch --exit-with-session Hyprland" >> /home/$username/.config/hypr/start.sh
chmod +x /home/$username/.config/hypr/portalstart
chmod +x /home/$username/.config/hypr/start.sh
mkdir -p /etc/modules-load.d
echo "nvidia
nvidia_modeset
nvidia_uvm
nvidia_drm" > /etc/modules-load.d/video.conf
