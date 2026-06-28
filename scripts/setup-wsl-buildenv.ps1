# XiaoyangOS - WSL Build Environment Setup Script
# Run this in PowerShell as Administrator

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  XiaoyangOS WSL Build Environment Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544'
if (-not $isAdmin) {
    Write-Host "Error: Please run as Administrator!" -ForegroundColor Red
    exit 1
}

# Step 1: Enable WSL if not already
Write-Host "[1/5] Enabling WSL feature..." -ForegroundColor Yellow
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Step 2: Install Ubuntu WSL
Write-Host "[2/5] Installing Ubuntu WSL..." -ForegroundColor Yellow
wsl --install -d Ubuntu

Write-Host ""
Write-Host "Waiting for WSL setup to complete..." -ForegroundColor Yellow
Write-Host "Please complete the Ubuntu setup (create username/password) when the window opens."
Write-Host "After setup is complete, return here and press any key to continue."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Step 3: Install required packages in WSL
Write-Host "[3/5] Installing build dependencies in WSL..." -ForegroundColor Yellow

wsl -d Ubuntu -- bash -c @"
    sudo apt update
    sudo apt install -y pacman-package-manager archiso wget curl git
    echo "Dependencies installed."
"@

# Step 4: Create build script for WSL
Write-Host "[4/5] Creating build script..." -ForegroundColor Yellow

$buildScript = @'
#!/usr/bin/env bash
# XiaoyangOS - Cross-build script for WSL/Ubuntu

set -e -u

XIAOYANGOS_DIR="/mnt/d/chengxu/xiaoyangos"
WORK_DIR="${HOME}/xiaoyangos-work"
OUT_DIR="${XIAOYANGOS_DIR}/out"

echo "XiaoyangOS Cross-Build for WSL"
echo ""

# Check archiso
if ! command -v mkarchiso &>/dev/null; then
    # Try to install archiso via pacman
    if command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm archiso
    else
        echo "Error: archiso is required. Install it first."
        echo "On Arch: pacman -S archiso"
        exit 1
    fi
fi

# Build
sudo mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${XIAOYANGOS_DIR}/archlive"

echo ""
echo "Build Complete!"
echo "ISO located at: ${OUT_DIR}/"
'@

$buildScript | Out-File -FilePath "$env:TEMP\build-xiaoyangos.sh" -Encoding ASCII

# Copy to WSL
wsl -d Ubuntu -- cp "/mnt/c/Users/$env:USERNAME/AppData/Local/Temp/build-xiaoyangos.sh" ~/build-xiaoyangos.sh
wsl -d Ubuntu -- chmod +x ~/build-xiaoyangos.sh

# Step 5: Summary
Write-Host "[5/5] Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "To build XiaoyangOS:"
Write-Host "  1. Open WSL: wsl -d Ubuntu"
Write-Host "  2. Run: ./build-xiaoyangos.sh"
Write-Host ""
Write-Host "Or manually:"
Write-Host "  wsl -d Ubuntu -- ~/build-xiaoyangos.sh"
Write-Host ""
Write-Host "The ISO will be output to: D:\chengxu\xiaoyangos\out\"
