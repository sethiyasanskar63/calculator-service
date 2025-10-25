# Quick status check script
# Shows the status of your latest CI/CD run

Write-Host "`n🔍 Checking CI/CD Status...`n" -ForegroundColor Cyan

# Check if we're in a git repo
if (-Not (Test-Path .git)) {
    Write-Host "❌ Not a git repository" -ForegroundColor Red
    exit 1
}

# Get latest commit info
Write-Host "📝 Latest Commit:" -ForegroundColor Yellow
git log -1 --pretty=format:"%h - %s (%cr)" --abbrev-commit
Write-Host "`n"

# Get repo info
$remote = git remote get-url origin
$repoPath = $remote -replace '.*github.com[:/]', '' -replace '.git$', ''

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Gray

Write-Host "🔗 Quick Links:" -ForegroundColor Green
Write-Host ""

# GitHub Actions
$actionsUrl = "https://github.com/$repoPath/actions"
Write-Host "  GitHub Actions (CI/CD Status):" -ForegroundColor Cyan
Write-Host "  $actionsUrl" -ForegroundColor White
Write-Host ""

# Latest workflow run
$latestRunUrl = "https://github.com/$repoPath/actions/workflows/ci-cd.yml"
Write-Host "  Latest Workflow Runs:" -ForegroundColor Cyan
Write-Host "  $latestRunUrl" -ForegroundColor White
Write-Host ""

# Commits
$commitsUrl = "https://github.com/$repoPath/commits/main"
Write-Host "  Commit History:" -ForegroundColor Cyan
Write-Host "  $commitsUrl" -ForegroundColor White
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n" -ForegroundColor Gray

Write-Host "💡 What to Look For:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  ✅ Green checkmark = All jobs passed" -ForegroundColor Green
Write-Host "  🟡 Yellow circle = Job in progress" -ForegroundColor Yellow
Write-Host "  ❌ Red X = Job failed" -ForegroundColor Red
Write-Host ""
Write-Host "  Jobs in the pipeline:" -ForegroundColor Cyan
Write-Host "  1. Build and Test (compiles code, runs 14 tests)" -ForegroundColor White
Write-Host "  2. Docker Build & Push (creates image)" -ForegroundColor White
Write-Host "  3. Security Scan (checks for vulnerabilities)" -ForegroundColor White
Write-Host ""

# Ask if user wants to open browser
Write-Host "Would you like to open GitHub Actions in browser? (Y/N): " -ForegroundColor Cyan -NoNewline
$response = Read-Host

if ($response -eq 'Y' -or $response -eq 'y') {
    Write-Host "`nOpening browser...`n" -ForegroundColor Green
    Start-Process $actionsUrl
} else {
    Write-Host "`nYou can manually visit: $actionsUrl`n" -ForegroundColor White
}
