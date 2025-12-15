# PowerShell Script to Push KCSE Paper Images Incrementally
# This script commits and pushes each year folder separately to avoid GitHub's 2GB limit

# Set error action preference
$ErrorActionPreference = "Stop"

# Get the script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "KCSE Paper Images - Incremental Push" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Define the years to process
$years = @(
    "2010", "2011", "2012", "2015", "2016", "2017", 
    "2018", "2019", "2020", "2021", "2022", "2023", "2024"
)

# First, commit the base files (README, .gitignore)
Write-Host "[Step 1/2] Committing base files..." -ForegroundColor Yellow
try {
    git add README.md .gitignore PUSH_SCRIPTS_GUIDE.md *.ps1
    git commit -m "Initial commit: Add README and helper scripts"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Base files committed successfully" -ForegroundColor Green
        
        # Push base files
        Write-Host "  Pushing base files to remote..." -ForegroundColor Gray
        git push -u origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Base files pushed successfully" -ForegroundColor Green
        } else {
            Write-Host "✗ Failed to push base files" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "ℹ No changes to base files or already committed" -ForegroundColor Gray
    }
}
catch {
    Write-Host "ℹ Base files already committed or no changes" -ForegroundColor Gray
}

Write-Host ""

# Process each year folder
$totalYears = $years.Count
$currentYear = 0

Write-Host "[Step 2/2] Processing year folders..." -ForegroundColor Yellow
Write-Host ""

foreach ($year in $years) {
    $currentYear++
    $yearPath = "$year"
    
    # Check if year folder exists
    if (-Not (Test-Path $yearPath)) {
        Write-Host "[$currentYear/$totalYears] WARNING: Skipping $year - folder not found" -ForegroundColor Yellow
        continue
    }
    
    Write-Host "[$currentYear/$totalYears] Processing: $year" -ForegroundColor Cyan
    Write-Host "  Adding files..." -ForegroundColor Gray
    
    # Add the year folder
    git add $yearPath
    
    # Check if there are changes to commit
    $status = git status --porcelain
    if ($status) {
        Write-Host "  Committing..." -ForegroundColor Gray
        
        # Commit the year folder
        $commitMessage = "Add $year exam papers"
        git commit -m $commitMessage
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Pushing to GitHub..." -ForegroundColor Gray
            
            # Push to remote
            git push origin main
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  SUCCESS: $year pushed successfully" -ForegroundColor Green
            } else {
                Write-Host "  ERROR: Failed to push $year" -ForegroundColor Red
                Write-Host "  You may need to resolve this manually" -ForegroundColor Yellow
                
                # Ask user if they want to continue
                $continue = Read-Host "  Continue with next year? (Y/N)"
                if ($continue -ne "Y" -and $continue -ne "y") {
                    exit 1
                }
            }
        } else {
            Write-Host "  ERROR: Failed to commit $year" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "  INFO: No changes to commit for $year (already committed)" -ForegroundColor Gray
    }
    
    Write-Host ""
    
    # Small delay to avoid overwhelming GitHub
    Start-Sleep -Seconds 2
}

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "SUCCESS: All year folders processed!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  Total years processed: $totalYears" -ForegroundColor White
Write-Host "  Repository: github.com/jamesthegreati/paper_images" -ForegroundColor White
Write-Host ""
Write-Host "Verify the upload at:" -ForegroundColor Yellow
Write-Host "  https://github.com/jamesthegreati/paper_images" -ForegroundColor Cyan
Write-Host ""
