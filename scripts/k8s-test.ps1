# ============================================
# Test Kubernetes Deployment
# ============================================

Write-Host "🧪 Testing Calculator Service on Kubernetes..." -ForegroundColor Cyan
Write-Host ""

# Check if namespace exists
$namespaceExists = kubectl get namespace calculator 2>&1
if ($namespaceExists -match "NotFound") {
    Write-Host "❌ Calculator namespace not found!" -ForegroundColor Red
    Write-Host "   Run: .\k8s-deploy.ps1 first" -ForegroundColor Yellow
    exit 1
}

# Check pod status
Write-Host "1️⃣  Checking pod status..." -ForegroundColor Green
kubectl get pods -n calculator
Write-Host ""

$podStatus = kubectl get pods -n calculator -o json | ConvertFrom-Json
$runningPods = $podStatus.items | Where-Object { $_.status.phase -eq "Running" }

if ($runningPods.Count -eq 0) {
    Write-Host "❌ No running pods found!" -ForegroundColor Red
    Write-Host "   Check logs with: kubectl logs -l app=calculator-service -n calculator" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found $($runningPods.Count) running pod(s)" -ForegroundColor Green
Write-Host ""

# Start port forwarding in background
Write-Host "2️⃣  Setting up port forwarding..." -ForegroundColor Green
$portForwardJob = Start-Job -ScriptBlock {
    kubectl port-forward -n calculator service/calculator-service 8080:80
}

# Wait for port to be ready
Start-Sleep -Seconds 3
Write-Host "   ✅ Port forwarding active on http://localhost:8080" -ForegroundColor Green
Write-Host ""

# Test endpoints
Write-Host "3️⃣  Testing API endpoints..." -ForegroundColor Green
Write-Host ""

function Test-Endpoint {
    param($Method, $Endpoint, $Body = $null)
    
    try {
        if ($Body) {
            $response = Invoke-RestMethod -Uri "http://localhost:8080$Endpoint" -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        } else {
            $response = Invoke-RestMethod -Uri "http://localhost:8080$Endpoint" -Method $Method
        }
        Write-Host "   ✅ $Method $Endpoint" -ForegroundColor Green
        Write-Host "      Response: $($response | ConvertTo-Json -Compress)" -ForegroundColor Gray
        return $true
    } catch {
        Write-Host "   ❌ $Method $Endpoint" -ForegroundColor Red
        Write-Host "      Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Health check
$healthOk = Test-Endpoint "GET" "/actuator/health"
Write-Host ""

# Test addition
$addOk = Test-Endpoint "POST" "/api/add" @{ a = 10; b = 5 }
Write-Host ""

# Test subtraction
$subOk = Test-Endpoint "POST" "/api/subtract" @{ a = 10; b = 5 }
Write-Host ""

# Test multiplication
$mulOk = Test-Endpoint "POST" "/api/multiply" @{ a = 10; b = 5 }
Write-Host ""

# Test division
$divOk = Test-Endpoint "POST" "/api/divide" @{ a = 10; b = 5 }
Write-Host ""

# Clean up port forwarding
Stop-Job -Job $portForwardJob
Remove-Job -Job $portForwardJob

# Summary
Write-Host "📊 Test Summary:" -ForegroundColor Cyan
Write-Host "   Health Check:   $(if ($healthOk) { '✅' } else { '❌' })" -ForegroundColor White
Write-Host "   Addition:       $(if ($addOk) { '✅' } else { '❌' })" -ForegroundColor White
Write-Host "   Subtraction:    $(if ($subOk) { '✅' } else { '❌' })" -ForegroundColor White
Write-Host "   Multiplication: $(if ($mulOk) { '✅' } else { '❌' })" -ForegroundColor White
Write-Host "   Division:       $(if ($divOk) { '✅' } else { '❌' })" -ForegroundColor White
Write-Host ""

if ($healthOk -and $addOk -and $subOk -and $mulOk -and $divOk) {
    Write-Host "🎉 All tests passed! Your Kubernetes deployment is working!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Some tests failed. Check the logs:" -ForegroundColor Yellow
    Write-Host "   kubectl logs -l app=calculator-service -n calculator" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "   • View dashboard:  minikube dashboard" -ForegroundColor Yellow
Write-Host "   • Scale up:        kubectl scale deployment calculator-service --replicas=5 -n calculator" -ForegroundColor Yellow
Write-Host "   • View metrics:    kubectl top pods -n calculator" -ForegroundColor Yellow
Write-Host "   • Access service:  minikube service calculator-service -n calculator" -ForegroundColor Yellow
Write-Host ""
