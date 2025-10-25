# ============================================
# Deploy Calculator Service to Oracle Kubernetes (OKE)
# ============================================

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment = 'dev',
    
    [Parameter(Mandatory=$false)]
    [switch]$UseHelm
)

Write-Host "🚀 Deploying Calculator Service to OKE ($Environment)..." -ForegroundColor Cyan
Write-Host ""

# Check if kubectl is configured
Write-Host "1️⃣  Checking kubectl configuration..." -ForegroundColor Green
$context = kubectl config current-context 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ kubectl is not configured!" -ForegroundColor Red
    Write-Host "   Follow: docs/ORACLE-CLOUD-KUBERNETES-GUIDE.md" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✅ Current context: $context" -ForegroundColor Green
Write-Host ""

# Verify cluster connection
Write-Host "2️⃣  Verifying cluster connection..." -ForegroundColor Green
$nodes = kubectl get nodes 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "   ❌ Cannot connect to cluster!" -ForegroundColor Red
    Write-Host "   Check OCI config and kubectl setup" -ForegroundColor Yellow
    exit 1
}
Write-Host "   ✅ Connected to OKE cluster" -ForegroundColor Green
Write-Host ""

if ($UseHelm) {
    # Deploy using Helm
    Write-Host "3️⃣  Deploying with Helm ($Environment)..." -ForegroundColor Green
    
    # Check if Helm is installed
    $helmVersion = helm version --short 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ❌ Helm is not installed!" -ForegroundColor Red
        Write-Host "   Install from: https://helm.sh/docs/intro/install/" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "   ✅ Helm version: $helmVersion" -ForegroundColor Green
    
    # Deploy or upgrade
    $releaseName = "calculator-$Environment"
    $valuesFile = "config/helm-chart/calculator-service/values-$Environment.yaml"
    
    Write-Host "   Deploying release: $releaseName" -ForegroundColor Yellow
    Write-Host "   Using values: $valuesFile" -ForegroundColor Yellow
    
    helm upgrade --install $releaseName ./config/helm-chart/calculator-service `
        --values $valuesFile `
        --namespace calculator `
        --create-namespace `
        --wait `
        --timeout 5m
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ❌ Helm deployment failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "   ✅ Helm deployment successful" -ForegroundColor Green
    Write-Host ""
    
} else {
    # Deploy using kubectl and manifests
    Write-Host "3️⃣  Creating namespace..." -ForegroundColor Green
    kubectl apply -f config/k8s/namespace.yaml
    Write-Host ""
    
    Write-Host "4️⃣  Applying ConfigMap..." -ForegroundColor Green
    kubectl apply -f config/k8s/configmap.yaml -n calculator
    Write-Host ""
    
    Write-Host "5️⃣  Creating OCI Registry secret..." -ForegroundColor Green
    Write-Host "   (Make sure you've set up GitHub secrets first)" -ForegroundColor Yellow
    
    # Note: In production, this should be done via GitHub Actions
    # For manual deployment, you need to create the secret:
    # kubectl create secret docker-registry oci-registry-secret \
    #   --docker-server=<region>.ocir.io \
    #   --docker-username='<tenancy-namespace>/<oci-username>' \
    #   --docker-password='<oci-auth-token>' \
    #   -n calculator
    
    Write-Host ""
    
    Write-Host "6️⃣  Deploying application..." -ForegroundColor Green
    kubectl apply -f config/k8s/deployment-oracle.yaml -n calculator
    Write-Host ""
    
    # Wait for deployment
    Write-Host "7️⃣  Waiting for pods to be ready..." -ForegroundColor Green
    kubectl wait --for=condition=ready pod -l app=calculator-service -n calculator --timeout=300s
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ⚠️  Pods are taking longer than expected..." -ForegroundColor Yellow
        Write-Host "   Check status with: kubectl get pods -n calculator" -ForegroundColor Cyan
    } else {
        Write-Host "   ✅ All pods are ready!" -ForegroundColor Green
    }
    Write-Host ""
    
    # Apply Ingress if production
    if ($Environment -eq 'prod' -or $Environment -eq 'staging') {
        Write-Host "8️⃣  Applying Ingress..." -ForegroundColor Green
        kubectl apply -f config/k8s/ingress-prod.yaml -n calculator
        Write-Host ""
    }
}

# Show deployment status
Write-Host "📊 Deployment Status:" -ForegroundColor Cyan
Write-Host ""
kubectl get all -n calculator
Write-Host ""

# Show ingress if exists
$ingress = kubectl get ingress -n calculator 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "🌐 Ingress Configuration:" -ForegroundColor Cyan
    kubectl get ingress -n calculator
    Write-Host ""
}

Write-Host "✅ Deployment Complete!" -ForegroundColor Green
Write-Host ""

Write-Host "🎯 Useful Commands:" -ForegroundColor Cyan
Write-Host "   View logs:      kubectl logs -f -l app=calculator-service -n calculator" -ForegroundColor White
Write-Host "   View pods:      kubectl get pods -n calculator -o wide" -ForegroundColor White
Write-Host "   Describe pod:   kubectl describe pod <pod-name> -n calculator" -ForegroundColor White
Write-Host "   Port forward:   kubectl port-forward -n calculator service/calculator-service 8080:80" -ForegroundColor White
Write-Host "   Events:         kubectl get events -n calculator --sort-by='.lastTimestamp'" -ForegroundColor White
Write-Host ""

if ($UseHelm) {
    Write-Host "📦 Helm Commands:" -ForegroundColor Cyan
    Write-Host "   Status:         helm status $releaseName -n calculator" -ForegroundColor White
    Write-Host "   Uninstall:      helm uninstall $releaseName -n calculator" -ForegroundColor White
    Write-Host "   List releases:  helm list -n calculator" -ForegroundColor White
    Write-Host ""
}
