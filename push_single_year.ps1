# PowerShell Script to Push a Specific Year Folder
# Usage: .\push_single_year.ps1 2024

param(
    [Parameter(Mandatory=$true)]
    [string]$Year
)

$ErrorActionPreference = "Stop"

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Push Single Year: $Year" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if year folder exists
if (-Not (Test-Path $Year)) {
    Write-Host "ERROR: Folder '$Year' not found!" -ForegroundColor Red
    exit 1
}

Write-Host "Adding $Year folder..." -ForegroundColor Yellow
git add $Year

Write-Host "Committing $Year..." -ForegroundColor Yellow
git commit -m "Add $Year exam papers"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Pushing $Year to GitHub..." -ForegroundColor Yellow
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "SUCCESS: $Year pushed successfully!" -ForegroundColor Green
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "ERROR: Failed to push $Year" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "INFO: No changes to commit (already committed?)" -ForegroundColor Gray
}
