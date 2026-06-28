#!/bin/bash
# XiaoyangOS - Build script to run inside WSL
# Save this to WSL and run it

set -e -u

echo "========================================"
echo "  XiaoyangOS WSL Build Script"
echo "========================================"

# Step 1: Extract bootstrap if needed
if [ ! -d /tmp/root.x86_64 ]; then
    echo "[1/5] Extracting Arch Linux bootstrap..."
    mkdir -p /tmp/root.x86_64
    cp /mnt/d/chengxu/xiaoyangos/archlive/packages.x86_64 /tmp/
    echo "Bootstrap not found. Please extract it first."
    exit 1
fi

# Step 2: Mount and chroot
echo "[2/5] Setting up chroot environment..."
cd /tmp/root.x86_64/
mount --bind /proc proc/ 2>/dev/null || true
mount --bind /sys sys/ 2>/dev/null || true
mount --bind /dev dev/ 2>/dev/null || true
mount --bind /dev/pts dev/pts/ 2>/dev/null || true
cp -L /etc/resolv.conf etc/

# Step 3: Initialize pacman
echo "[3/5] Initializing pacman..."
chroot . /usr/bin/pacman-key --init
chroot . /usr/bin/pacman-key --populate archlinux

# Step 4: Install archiso
echo "[4/5] Installing archiso..."
chroot . /usr/bin/pacman -Syu --noconfirm archiso

# Step 5: Build ISO
echo "[5/5] Building XiaoyangOS ISO..."
echo "WARNING: This step requires the archlive directory to be accessible."
echo "Copy it to /tmp first: cp -r /mnt/d/chengxu/xiaoyangos/archlive /tmp/"
echo "Then run the build."

echo ""
echo "Setup complete! Now to build:"
echo "  cp -r /mnt/d/chengxu/xiaoyangos/archlive /tmp/"
echo "  cd /tmp/root.x86_64/"
echo "  chroot . mkarchiso -v -w /tmp/work -o /tmp/out /tmp/archlive"
