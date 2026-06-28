# XiaoyangOS - Push to GitHub and trigger ISO build
# Usage:
#   .\push-to-github.ps1 -Token "ghp_xxxx" -Repo "yourname/xiaoyangos"
#
# Or set env var: $env:GH_TOKEN = "ghp_xxxx"

param(
    [string]$Token = $env:GH_TOKEN,
    [string]$Repo = ""
)

$ErrorActionPreference = "Stop"
$repoDir = Split-Path -Parent $PSScriptRoot

if (-not $Token) {
    Write-Host "Need a GitHub Personal Access Token (classic, with repo scope)." -ForegroundColor Red
    Write-Host "Create one at: https://github.com/settings/tokens" -ForegroundColor Cyan
    $Token = Read-Host -Prompt "Enter your GitHub token"
    if (-not $Token) { exit 1 }
}

if (-not $Repo) {
    $username = "your-username"
    try {
        $api = Invoke-RestMethod -Uri "https://api.github.com/user" -Headers @{Authorization = "token $Token"} -UseBasicParsing
        $username = $api.login
        Write-Host "Logged in as: $username" -ForegroundColor Green
    } catch {
        Write-Host "Could not verify token. Using 'your-username'" -ForegroundColor Yellow
    }
    $Repo = "$username/xiaoyangos"
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Pushing XiaoyangOS to GitHub" -ForegroundColor Cyan
Write-Host "  Repo: $Repo" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Set-Location $repoDir

# Create GitHub repo
Write-Host "[1/3] Creating GitHub repository..." -ForegroundColor Yellow
$body = @{name = "xiaoyangos"; description = "XiaoyangOS - Custom Arch Linux distribution with KDE Plasma"} | ConvertTo-Json
try {
    $result = Invoke-RestMethod -Uri "https://api.github.com/user/repos" -Method Post -Body $body -Headers @{Authorization = "token $Token"} -ContentType "application/json" -UseBasicParsing
    Write-Host "  Repo created: $($result.html_url)" -ForegroundColor Green
} catch {
    if ($_ -match "already exists") {
        Write-Host "  Repo already exists, continuing..." -ForegroundColor Yellow
    } else {
        Write-Host "  Error: $_" -ForegroundColor Red
        exit 1
    }
}

# Set up remote
Write-Host "[2/3] Setting up git remote..." -ForegroundColor Yellow
$remoteUrl = "https://$Token@github.com/$Repo.git"
git remote remove origin 2>$null
git remote add origin $remoteUrl

# Push
Write-Host "[3/3] Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin master

Write-Host "" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Push complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Build ISO automatically via GitHub Actions:"
Write-Host "  1. Go to: https://github.com/$Repo/actions"
Write-Host "  2. Click 'Build XiaoyangOS ISO' workflow"
Write-Host "  3. Click 'Run workflow' -> 'Run workflow'"
Write-Host "  4. Wait ~15 minutes for the build"
Write-Host "  5. Download the ISO from the workflow artifacts"
Write-Host ""
Write-Host "Or push a new commit to trigger the build automatically."
Write-Host ""
