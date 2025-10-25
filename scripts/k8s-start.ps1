# ============================================
# Start Minikube Cluster
# ============================================

Write-Host "🚀 Starting Minikube cluster..." -ForegroundColor Cyan
Write-Host ""

# Check if Minikube is already running
$status = minikube status 2>&1
if ($status -match "Running") {
    Write-Host "✅ Minikube is already running!" -ForegroundColor Green
    Write-Host ""
    minikube status
    Write-Host ""
    Write-Host "To redeploy, run: .\k8s-deploy.ps1" -ForegroundColor Cyan
    exit 0
}

# Start Minikube
Write-Host "⏳ Starting Minikube (this may take a few minutes)..." -ForegroundColor Yellow
minikube start --driver=docker --cpus=2 --memory=4096 --disk-size=20g

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Minikube started successfully!" -ForegroundColor Green
    Write-Host ""
    
    # Enable addons
    Write-Host "📦 Enabling useful addons..." -ForegroundColor Cyan
    minikube addons enable metrics-server
    minikube addons enable dashboard
    minikube addons enable ingress
    
    Write-Host ""
    Write-Host "✅ Addons enabled:" -ForegroundColor Green
    Write-Host "   • metrics-server (for kubectl top)" -ForegroundColor White
    Write-Host "   • dashboard (Web UI)" -ForegroundColor White
    Write-Host "   • ingress (NGINX Ingress Controller)" -ForegroundColor White
    
    Write-Host ""
    Write-Host "📊 Cluster Info:" -ForegroundColor Cyan
    kubectl cluster-info
    
    Write-Host ""
    Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
    Write-Host "   1. Build Docker image:  docker build -t calculator-service:latest ." -ForegroundColor Yellow
    Write-Host "   2. Deploy to K8s:       .\k8s-deploy.ps1" -ForegroundColor Yellow
    Write-Host "   3. Open dashboard:      minikube dashboard" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ Failed to start Minikube!" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Troubleshooting:" -ForegroundColor Yellow
    Write-Host "   1. Make sure Docker Desktop is running" -ForegroundColor White
    Write-Host "   2. Try: minikube delete (to clean up)" -ForegroundColor White
    Write-Host "   3. Then run this script again" -ForegroundColor White
    Write-Host ""
    exit 1
}
