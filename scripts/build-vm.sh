#!/usr/bin/env bash
# XiaoyangOS - VM/Container Build Script
# This script builds XiaoyangOS ISO inside a Docker/OCI container
#
# Prerequisites: docker or podman
#
# Usage:
#   ./build-vm.sh              # Build with docker
#   ./build-vm.sh --podman     # Build with podman

set -e -u

BUILDER=${1:-docker}
if [ "$BUILDER" = "--podman" ]; then
    BUILDER="podman"
fi

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${SCRIPT_DIR}/out"
WORK_DIR="${SCRIPT_DIR}/work"

echo "========================================"
echo "  XiaoyangOS Container Build"
echo "  Builder: ${BUILDER}"
echo "========================================"

mkdir -p "${OUT_DIR}" "${WORK_DIR}"

# Build the ISO inside archlinux container
${BUILDER} run --privileged --rm \
    -v "${SCRIPT_DIR}/archlive:/archlive:ro" \
    -v "${OUT_DIR}:/out" \
    -v "${WORK_DIR}:/work" \
    archlinux:latest \
    bash -c "
        pacman -Syu --noconfirm archiso
        mkarchiso -v -w /work -o /out /archlive
    "

echo ""
echo "Build Complete!"
echo "ISO: ${OUT_DIR}/"
ls -lh "${OUT_DIR}"/*.iso 2>/dev/null || echo "(no ISO found)"
