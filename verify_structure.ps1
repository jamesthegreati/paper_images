# PowerShell Script to Verify Repository Structure
# This script checks the folder structure and estimates sizes

$ErrorActionPreference = "Continue"

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KCSE Paper Images - Repository Analysis" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Define the years
$years = @(
    "2010", "2011", "2012", "2015", "2016", "2017", 
    "2018", "2019", "2020", "2021", "2022", "2023", "2024"
)

Write-Host "Year Folder Size Analysis:" -ForegroundColor Yellow
Write-Host ""

$totalSize = 0
$totalFiles = 0

foreach ($year in $years) {
    if (Test-Path $year) {
        $files = Get-ChildItem -Path $year -Recurse -File
        $size = ($files | Measure-Object -Property Length -Sum).Sum
        $fileCount = $files.Count
        
        $totalSize += $size
        $totalFiles += $fileCount
        
        $sizeMB = [math]::Round($size / 1MB, 2)
        
        $sizeColor = "Green"
        if ($sizeMB -gt 100) { $sizeColor = "Yellow" }
        if ($sizeMB -gt 500) { $sizeColor = "Red" }
        
        Write-Host ("  {0,-6} - {1,8} MB  ({2,5} files)" -f $year, $sizeMB, $fileCount) -ForegroundColor $sizeColor
    } else {
        Write-Host ("  {0,-6} - Not found" -f $year) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
$totalSizeMB = [math]::Round($totalSize / 1MB, 2)
$totalSizeGB = [math]::Round($totalSize / 1GB, 2)

Write-Host "Total Size: $totalSizeMB MB ($totalSizeGB GB)" -ForegroundColor Yellow
Write-Host "Total Files: $totalFiles" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($totalSizeGB -gt 2) {
    Write-Host "⚠ Repository exceeds 2GB - incremental push REQUIRED" -ForegroundColor Red
} else {
    Write-Host "✓ Repository under 2GB - can push all at once" -ForegroundColor Green
}

Write-Host ""
Write-Host "GitHub Limits:" -ForegroundColor Yellow
Write-Host "  - Single push limit: 2 GB" -ForegroundColor Gray
Write-Host "  - Single file limit: 100 MB" -ForegroundColor Gray
Write-Host "  - Recommended file size: < 50 MB" -ForegroundColor Gray
Write-Host ""

# Check for large files
Write-Host "Checking for files > 50 MB..." -ForegroundColor Yellow
$largeFiles = Get-ChildItem -Recurse -File | Where-Object { $_.Length -gt 50MB }

if ($largeFiles) {
    Write-Host ""
    Write-Host "⚠ Large files found:" -ForegroundColor Red
    foreach ($file in $largeFiles) {
        $sizeMB = [math]::Round($file.Length / 1MB, 2)
        Write-Host ("  - {0} ({1} MB)" -f $file.FullName, $sizeMB) -ForegroundColor Yellow
    }
    Write-Host ""
    Write-Host "Consider using Git LFS for files > 100 MB" -ForegroundColor Yellow
} else {
    Write-Host "✓ No files exceed 50 MB" -ForegroundColor Green
}

Write-Host ""
