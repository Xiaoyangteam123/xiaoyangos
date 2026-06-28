#!/usr/bin/env bash
# XiaoyangOS - ISO Build Script
# Requires: archiso (pacman -S archiso)
#
# Usage:
#   sudo ./build.sh          - Build ISO
#   sudo ./build.sh clean    - Clean build directory

set -e -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORK_DIR="${SCRIPT_DIR}/work"
OUT_DIR="${SCRIPT_DIR}/out"
PROFILE_DIR="${SCRIPT_DIR}/archlive"
ISO_NAME="xiaoyangos-$(date +%Y.%m.%d)-x86_64"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "  ╔═══════════════════════════════════════╗"
echo "  ║        XiaoyangOS Build System        ║"
echo "  ╚═══════════════════════════════════════╝"
echo -e "${NC}"

# Check root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Please run as root (sudo)${NC}"
    exit 1
fi

# Check archiso
if ! command -v mkarchiso &>/dev/null; then
    echo -e "${RED}Error: archiso is not installed.${NC}"
    echo -e "Install it with: pacman -S archiso"
    exit 1
fi

# Clean
if [ "${1:-}" = "clean" ]; then
    echo -e "${GREEN}Cleaning build directories...${NC}"
    rm -rf "${WORK_DIR}" "${OUT_DIR}"
    echo "Done."
    exit 0
fi

# Setup directories
mkdir -p "${WORK_DIR}" "${OUT_DIR}"

# Build ISO
echo -e "${GREEN}Building XiaoyangOS ISO...${NC}"
echo -e "Profile: ${PROFILE_DIR}"
echo -e "Output:  ${OUT_DIR}/${ISO_NAME}.iso"
echo ""

mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${PROFILE_DIR}"

# Rename ISO
if [ -f "${OUT_DIR}/xiaoyangos-*.iso" ]; then
    mv "${OUT_DIR}"/xiaoyangos-*.iso "${OUT_DIR}/${ISO_NAME}.iso" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Build Complete!${NC}"
echo -e "${GREEN}  ISO: ${OUT_DIR}/${ISO_NAME}.iso${NC}"
echo -e "${GREEN}========================================${NC}"
