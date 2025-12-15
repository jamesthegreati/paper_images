# Incremental Push Scripts - Usage Guide

## Problem
Your repository exceeds GitHub's 2GB single push limit. The error was:
```
remote: fatal: pack exceeds maximum allowed size (2.00 GiB)
error: remote unpack failed: index-pack failed
```

## Solution
Use the provided PowerShell scripts to push your repository year by year instead of all at once.

---

## Scripts Provided

### 1. `verify_structure.ps1`
**Purpose:** Analyze your repository structure and identify potential issues.

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File verify_structure.ps1
```

**What it does:**
- Shows size of each year folder
- Calculates total repository size
- Identifies files larger than 50MB
- Warns if repository exceeds 2GB

---

### 2. `reset_and_prepare.ps1`
**Purpose:** Reset your failed commit and prepare for incremental push.

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File reset_and_prepare.ps1
```

**What it does:**
- Undoes the last commit (keeps your files)
- Unstages all files
- Shows you the clean status

**⚠️ Run this ONCE before starting the incremental push**

---

### 3. `push_incremental.ps1` ⭐ **MAIN SCRIPT**
**Purpose:** Push your repository to GitHub year by year.

**Usage:**
```powershell
powershell -ExecutionPolicy Bypass -File push_incremental.ps1
```

**What it does:**
1. Commits and pushes README.md and .gitignore first
2. For each year folder (2010-2024):
   - Adds the year folder
   - Creates a commit
   - Pushes to GitHub
   - Waits 2 seconds before next year
3. Shows progress with colored output

**Expected behavior:**
- Each year will be committed and pushed separately
- You'll see progress for each year
- Total time: ~5-10 minutes depending on your internet speed

---

## Step-by-Step Instructions

### First Time Setup

1. **Verify your repository structure:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File verify_structure.ps1
   ```

2. **Reset the failed commit:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File reset_and_prepare.ps1
   ```

3. **Push incrementally:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File push_incremental.ps1
   ```

4. **Wait for completion and verify on GitHub:**
   Visit: https://github.com/jamesthegreati/paper_images

---

## Using Git Bash

If you prefer Git Bash, you can run:

```bash
# Verify
powershell.exe -ExecutionPolicy Bypass -File verify_structure.ps1

# Reset
powershell.exe -ExecutionPolicy Bypass -File reset_and_prepare.ps1

# Push incrementally
powershell.exe -ExecutionPolicy Bypass -File push_incremental.ps1
```

---

## Troubleshooting

### Error: "Execution Policy" error
**Solution:** Use `-ExecutionPolicy Bypass` flag as shown above.

### Error: "remote rejected"
**Cause:** Network issue or GitHub rate limiting.
**Solution:** Wait a few minutes and re-run `push_incremental.ps1`. It will skip already-pushed years.

### Error: "failed to push some refs"
**Cause:** Conflict with remote branch.
**Solution:**
```bash
git pull origin main --rebase
powershell -ExecutionPolicy Bypass -File push_incremental.ps1
```

### Want to start over?
```bash
# Delete remote commits (CAREFUL!)
git push origin main --force

# Or create a new branch
git checkout -b incremental-upload
powershell -ExecutionPolicy Bypass -File push_incremental.ps1
```

---

## What Gets Pushed

The script pushes folders in this order:
1. README.md, .gitignore (base files)
2. 2010 exam papers
3. 2011 exam papers
4. 2012 exam papers
5. 2015 exam papers
6. 2016 exam papers
7. 2017 exam papers
8. 2018 exam papers
9. 2019 exam papers
10. 2020 exam papers
11. 2021 exam papers
12. 2022 exam papers
13. 2023 exam papers
14. 2024 exam papers

Each as a separate commit.

---

## After Successful Push

Once all years are pushed successfully:

1. **Verify on GitHub:**
   - Go to https://github.com/jamesthegreati/paper_images
   - Check that all year folders are visible
   - Verify commit history shows separate commits for each year

2. **Optional: Clean up scripts:**
   ```bash
   # You can delete these helper scripts if you want
   git rm *.ps1
   git rm PUSH_SCRIPTS_GUIDE.md
   git commit -m "Remove helper scripts"
   git push origin main
   ```

---

## Estimated Time

- Verification: 30 seconds
- Reset: 5 seconds
- Incremental push: 5-15 minutes (depends on upload speed)

**Total: ~10-20 minutes**

---

## GitHub Repository Link

Your repository: **https://github.com/jamesthegreati/paper_images**

---

*Created: December 14, 2025*  
*Scripts location: `c:\Users\henry\Desktop\kcseApp\paper_images\`*
