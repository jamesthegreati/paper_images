# PowerShell Script to Reset Repository and Prepare for Incremental Push
# This script undoes the large commit and prepares for year-by-year pushing

$ErrorActionPreference = "Stop"

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Preparing for Incremental Push" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[Step 1/3] Checking current git status..." -ForegroundColor Yellow
git status

Write-Host ""
Write-Host "[Step 2/3] Resetting to clean state..." -ForegroundColor Yellow
Write-Host "  This will unstage all files but keep them in your working directory" -ForegroundColor Gray

# Reset the last commit if it exists but keep files
git reset --soft HEAD~1 2>$null

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Last commit reset successfully" -ForegroundColor Green
} else {
    Write-Host "ℹ No commit to reset (this is fine)" -ForegroundColor Gray
}

# Unstage all files
git reset

Write-Host "✓ All files unstaged" -ForegroundColor Green
Write-Host ""

Write-Host "[Step 3/3] Current status:" -ForegroundColor Yellow
git status --short

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✓ Repository prepared!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next step:" -ForegroundColor Yellow
Write-Host "  Run: .\push_incremental.ps1" -ForegroundColor Cyan
Write-Host ""
