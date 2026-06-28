#!/usr/bin/env bash

set -e -u

user="liveuser"

# Create live user
useradd -m -G wheel,power,storage,audio,video,optical,network,rfkill -s /bin/bash "$user"

# Set passwords
echo "$user:xiaoyangos" | chpasswd
echo "root:xiaoyangos" | chpasswd

# Configure sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers.d/10-wheel
chmod 440 /etc/sudoers.d/10-wheel

# Enable services
systemctl enable NetworkManager.service
systemctl enable sddm.service
systemctl enable bluetooth.service
systemctl enable cups.service
systemctl enable systemd-resolved.service
systemctl enable acpid.service
systemctl enable tlp.service
systemctl enable thermald.service
systemctl enable fstrim.timer

# Localization
locale-gen

# Set timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# Generate initramfs
mkinitcpio -p linux

# Desktop shortcuts for installer
mkdir -p /home/"$user"/Desktop
cp /usr/local/bin/xiaoyangos-welcome.desktop /home/"$user"/Desktop/
chown -R "$user":"$user" /home/"$user"/Desktop

# Set default shell
chsh -s /bin/bash "$user"

echo "XiaoyangOS customization complete!"
