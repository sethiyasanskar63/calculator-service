# ============================================
# Kubernetes Phase 2 - Setup Script
# ============================================

Write-Host "🚀 Setting up Kubernetes environment..." -ForegroundColor Cyan
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Warning: Not running as Administrator" -ForegroundColor Yellow
    Write-Host "Some installations may require Administrator privileges" -ForegroundColor Yellow
    Write-Host ""
}

# Function to check if a command exists
function Test-Command {
    param($Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# ============================================
# Step 1: Check Docker
# ============================================
Write-Host "1️⃣  Checking Docker..." -ForegroundColor Green
if (Test-Command docker) {
    $dockerVersion = docker --version
    Write-Host "   ✅ Docker installed: $dockerVersion" -ForegroundColor Green
    
    # Check if Docker is running
    try {
        docker ps | Out-Null
        Write-Host "   ✅ Docker is running" -ForegroundColor Green
    } catch {
        Write-Host "   ❌ Docker is not running! Please start Docker Desktop" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "   ❌ Docker not found! Please install Docker Desktop first" -ForegroundColor Red
    Write-Host "   Download: https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

Write-Host ""

# ============================================
# Step 2: Check/Install kubectl
# ============================================
Write-Host "2️⃣  Checking kubectl..." -ForegroundColor Green
if (Test-Command kubectl) {
    $kubectlVersion = kubectl version --client --short 2>$null
    Write-Host "   ✅ kubectl installed: $kubectlVersion" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  kubectl not found. Installing..." -ForegroundColor Yellow
    
    # Check if chocolatey is available
    if (Test-Command choco) {
        choco install kubernetes-cli -y
        Write-Host "   ✅ kubectl installed via Chocolatey" -ForegroundColor Green
    } else {
        Write-Host "   📥 Downloading kubectl..." -ForegroundColor Yellow
        $kubectlUrl = "https://dl.k8s.io/release/v1.28.0/bin/windows/amd64/kubectl.exe"
        $kubectlPath = "$env:USERPROFILE\kubectl.exe"
        
        try {
            Invoke-WebRequest -Uri $kubectlUrl -OutFile $kubectlPath
            Write-Host "   ✅ kubectl downloaded to $kubectlPath" -ForegroundColor Green
            Write-Host "   ℹ️  Add $env:USERPROFILE to your PATH to use kubectl globally" -ForegroundColor Yellow
        } catch {
            Write-Host "   ❌ Failed to download kubectl" -ForegroundColor Red
            Write-Host "   Manual install: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/" -ForegroundColor Yellow
        }
    }
}

Write-Host ""

# ============================================
# Step 3: Check/Install Minikube
# ============================================
Write-Host "3️⃣  Checking Minikube..." -ForegroundColor Green
if (Test-Command minikube) {
    $minikubeVersion = minikube version --short
    Write-Host "   ✅ Minikube installed: $minikubeVersion" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Minikube not found. Installing..." -ForegroundColor Yellow
    
    if (Test-Command choco) {
        choco install minikube -y
        Write-Host "   ✅ Minikube installed via Chocolatey" -ForegroundColor Green
    } else {
        Write-Host "   📥 Please install Minikube manually" -ForegroundColor Yellow
        Write-Host "   Download: https://minikube.sigs.k8s.io/docs/start/" -ForegroundColor Yellow
    }
}

Write-Host ""

# ============================================
# Step 4: Check if Minikube is running
# ============================================
Write-Host "4️⃣  Checking Minikube status..." -ForegroundColor Green
$minikubeStatus = minikube status 2>&1

if ($minikubeStatus -match "Running") {
    Write-Host "   ✅ Minikube is already running" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Minikube is not running" -ForegroundColor Yellow
    Write-Host "   Run: .\k8s-start.ps1 to start Minikube" -ForegroundColor Cyan
}

Write-Host ""

# ============================================
# Summary
# ============================================
Write-Host "📋 Setup Summary:" -ForegroundColor Cyan
Write-Host "   Docker:    $(if (Test-Command docker) { '✅' } else { '❌' })" -ForegroundColor White
Write-Host "   kubectl:   $(if (Test-Command kubectl) { '✅' } else { '❌' })" -ForegroundColor White
Write-Host "   Minikube:  $(if (Test-Command minikube) { '✅' } else { '❌' })" -ForegroundColor White

Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Start Minikube:  .\k8s-start.ps1" -ForegroundColor Yellow
Write-Host "   2. Deploy app:      .\k8s-deploy.ps1" -ForegroundColor Yellow
Write-Host "   3. Test app:        .\k8s-test.ps1" -ForegroundColor Yellow
Write-Host ""
