# ============================================
# Quick Start - Phase 2: Kubernetes
# ============================================
# This is a convenience wrapper that calls
# the scripts in the correct order

Write-Host "🚀 Phase 2: Kubernetes Quick Start" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will run all setup steps in order:" -ForegroundColor Yellow
Write-Host "  1. Setup (install kubectl, minikube)" -ForegroundColor White
Write-Host "  2. Start Minikube cluster" -ForegroundColor White
Write-Host "  3. Deploy calculator service" -ForegroundColor White
Write-Host "  4. Test deployment" -ForegroundColor White
Write-Host ""

$confirm = Read-Host "Continue? (yes/no)"
if ($confirm -ne "yes") {
    Write-Host "Cancelled." -ForegroundColor Gray
    exit 0
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "STEP 1/4: Setup" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
& .\scripts\k8s-setup.ps1

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Setup failed! Please fix errors and try again." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "STEP 2/4: Start Minikube" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
& .\scripts\k8s-start.ps1

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Minikube start failed! Please fix errors and try again." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "STEP 3/4: Deploy Application" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
& .\scripts\k8s-deploy.ps1

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ Deployment failed! Check logs above." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "STEP 4/4: Test Deployment" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan
& .\scripts\k8s-test.ps1

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Green
Write-Host "🎉 PHASE 2 QUICK START COMPLETE!" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Green
Write-Host ""
Write-Host "✅ Your calculator service is now running in Kubernetes!" -ForegroundColor Green
Write-Host ""
Write-Host "📚 Next steps:" -ForegroundColor Cyan
Write-Host "  • Read the tutorial: docs/PHASE2-KUBERNETES-TUTORIAL.md" -ForegroundColor Yellow
Write-Host "  • Try scaling: kubectl scale deployment calculator-service --replicas=5 -n calculator" -ForegroundColor Yellow
Write-Host "  • Open dashboard: minikube dashboard" -ForegroundColor Yellow
Write-Host ""
