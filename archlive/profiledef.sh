#!/usr/bin/env bash
# vim: set sw=4 et:

set -e -u

iso_name="xiaoyangos"
iso_label="XIAOYANG_$(date +%Y%m)"
iso_publisher="XiaoyangOS Project"
iso_application="XiaoyangOS Live/Rescue CD"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.grub')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="erofs"
airootfs_image_tool_options=('-zlz4hc,12' -E ztailpacking)
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/usr/local/bin/xiaoyangos-welcome"]="0:0:755"
)
