# ============================================
# Clean Up Kubernetes Resources
# ============================================

Write-Host "🧹 Kubernetes Cleanup Menu" -ForegroundColor Cyan
Write-Host ""
Write-Host "What would you like to clean up?" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. Delete calculator namespace (removes all app resources)" -ForegroundColor White
Write-Host "  2. Stop Minikube (keeps cluster, stops it)" -ForegroundColor White
Write-Host "  3. Delete Minikube cluster (removes everything)" -ForegroundColor White
Write-Host "  4. Cancel" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "🗑️  Deleting calculator namespace..." -ForegroundColor Yellow
        kubectl delete namespace calculator
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Calculator namespace deleted!" -ForegroundColor Green
            Write-Host "   All pods, services, and deployments removed." -ForegroundColor Gray
        } else {
            Write-Host "❌ Failed to delete namespace" -ForegroundColor Red
        }
    }
    
    "2" {
        Write-Host ""
        Write-Host "⏸️  Stopping Minikube..." -ForegroundColor Yellow
        minikube stop
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Minikube stopped!" -ForegroundColor Green
            Write-Host "   Run .\k8s-start.ps1 to start it again." -ForegroundColor Gray
        } else {
            Write-Host "❌ Failed to stop Minikube" -ForegroundColor Red
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "⚠️  WARNING: This will delete the entire Minikube cluster!" -ForegroundColor Red
        Write-Host "   All data will be lost." -ForegroundColor Yellow
        $confirm = Read-Host "Are you sure? (yes/no)"
        
        if ($confirm -eq "yes") {
            Write-Host ""
            Write-Host "🗑️  Deleting Minikube cluster..." -ForegroundColor Yellow
            minikube delete
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Minikube cluster deleted!" -ForegroundColor Green
                Write-Host "   Run .\k8s-start.ps1 to create a new cluster." -ForegroundColor Gray
            } else {
                Write-Host "❌ Failed to delete cluster" -ForegroundColor Red
            }
        } else {
            Write-Host "   Cancelled." -ForegroundColor Gray
        }
    }
    
    "4" {
        Write-Host ""
        Write-Host "   Cancelled." -ForegroundColor Gray
    }
    
    default {
        Write-Host ""
        Write-Host "❌ Invalid choice!" -ForegroundColor Red
    }
}

Write-Host ""
