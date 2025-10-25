# ============================================
# Deploy Calculator Service to Kubernetes
# ============================================

Write-Host "🚀 Deploying Calculator Service to Kubernetes..." -ForegroundColor Cyan
Write-Host ""

# Check if Minikube is running
Write-Host "1️⃣  Checking Minikube status..." -ForegroundColor Green
$status = minikube status 2>&1
if ($status -notmatch "Running") {
    Write-Host "   ❌ Minikube is not running!" -ForegroundColor Red
    Write-Host "   Run: .\k8s-start.ps1 first" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✅ Minikube is running" -ForegroundColor Green
Write-Host ""

# Build Docker image in Minikube's Docker daemon
Write-Host "2️⃣  Building Docker image in Minikube..." -ForegroundColor Green
Write-Host "   (This uses Minikube's Docker daemon)" -ForegroundColor Gray

# Point shell to Minikube's Docker daemon
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Build the image
Write-Host "   Building image..." -ForegroundColor Yellow
docker build -t calculator-service:latest .

if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ Docker build failed!" -ForegroundColor Red
    exit 1
}
Write-Host "   ✅ Image built successfully" -ForegroundColor Green
Write-Host ""

# Create namespace
Write-Host "3️⃣  Creating namespace..." -ForegroundColor Green
kubectl apply -f config/k8s/namespace.yaml
Write-Host ""

# Apply ConfigMap
Write-Host "4️⃣  Applying ConfigMap..." -ForegroundColor Green
kubectl apply -f config/k8s/configmap.yaml -n calculator
Write-Host ""

# Deploy application
Write-Host "5️⃣  Deploying application..." -ForegroundColor Green
kubectl apply -f config/k8s/deployment.yaml -n calculator
Write-Host ""

# Wait for deployment to be ready
Write-Host "6️⃣  Waiting for pods to be ready..." -ForegroundColor Green
kubectl wait --for=condition=ready pod -l app=calculator-service -n calculator --timeout=120s

if ($LASTEXITCODE -ne 0) {
    Write-Host "   ⚠️  Pods are taking longer than expected..." -ForegroundColor Yellow
    Write-Host "   Check status with: kubectl get pods -n calculator" -ForegroundColor Cyan
} else {
    Write-Host "   ✅ All pods are ready!" -ForegroundColor Green
}
Write-Host ""

# Apply Ingress (optional, for advanced routing)
Write-Host "7️⃣  Applying Ingress (optional)..." -ForegroundColor Green
kubectl apply -f config/k8s/ingress.yaml -n calculator
Write-Host ""

# Show deployment status
Write-Host "📊 Deployment Status:" -ForegroundColor Cyan
Write-Host ""
kubectl get all -n calculator

Write-Host ""
Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host ""

# Get service URL
Write-Host "🌐 Accessing your service:" -ForegroundColor Cyan
Write-Host ""
Write-Host "   Option 1 - Get Service URL:" -ForegroundColor Yellow
Write-Host "   minikube service calculator-service -n calculator --url" -ForegroundColor White
Write-Host ""
Write-Host "   Option 2 - Port Forward:" -ForegroundColor Yellow
Write-Host "   kubectl port-forward -n calculator service/calculator-service 8080:80" -ForegroundColor White
Write-Host "   Then visit: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "   Option 3 - Minikube Tunnel (requires admin):" -ForegroundColor Yellow
Write-Host "   minikube tunnel" -ForegroundColor White
Write-Host "   Then get external IP: kubectl get svc -n calculator" -ForegroundColor White
Write-Host ""

Write-Host "🎯 Useful Commands:" -ForegroundColor Cyan
Write-Host "   View logs:      kubectl logs -f -l app=calculator-service -n calculator" -ForegroundColor White
Write-Host "   View pods:      kubectl get pods -n calculator" -ForegroundColor White
Write-Host "   Scale up:       kubectl scale deployment calculator-service --replicas=5 -n calculator" -ForegroundColor White
Write-Host "   Dashboard:      minikube dashboard" -ForegroundColor White
Write-Host "   Delete all:     kubectl delete namespace calculator" -ForegroundColor White
Write-Host ""
