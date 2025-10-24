# Quick deployment script for Windows/PowerShell
# Deploys to GitHub which triggers CI/CD and Render deployment

Write-Host "🚀 Deploying Calculator Service" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Check if git is initialized
if (-Not (Test-Path .git)) {
    Write-Host "❌ Error: Not a git repository" -ForegroundColor Red
    Write-Host "Run: git init" -ForegroundColor Yellow
    exit 1
}

# Check if remote is set
try {
    $remote = git remote get-url origin 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "No remote"
    }
} catch {
    Write-Host "⚠️  No git remote found" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Please add your GitHub repository:" -ForegroundColor Cyan
    Write-Host "  git remote add origin https://github.com/YOUR_USERNAME/calculator-service.git" -ForegroundColor White
    Write-Host ""
    exit 1
}

# Check for uncommitted changes
Write-Host "📝 Checking for uncommitted changes..." -ForegroundColor Cyan
$status = git status --porcelain
if ($status) {
    Write-Host "Found uncommitted changes. Committing..." -ForegroundColor Yellow
    git add .
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Deploy: $timestamp"
} else {
    Write-Host "✅ No uncommitted changes" -ForegroundColor Green
}

# Push to GitHub
Write-Host ""
Write-Host "📤 Pushing to GitHub..." -ForegroundColor Cyan
git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Code pushed to GitHub!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. GitHub Actions will build and test your code" -ForegroundColor White
    Write-Host "2. Docker image will be pushed to Docker Hub" -ForegroundColor White
    Write-Host "3. Render.com will auto-deploy the new version" -ForegroundColor White
    Write-Host ""
    
    # Extract repo URL
    $repoUrl = git remote get-url origin
    $repoPath = $repoUrl -replace '.*github.com[:/]', '' -replace '.git$', ''
    
    Write-Host "Check status:" -ForegroundColor Cyan
    Write-Host "  GitHub Actions: https://github.com/$repoPath/actions" -ForegroundColor Yellow
    Write-Host "  Render Dashboard: https://dashboard.render.com" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Push failed. Please check your GitHub credentials." -ForegroundColor Red
    Write-Host ""
}
