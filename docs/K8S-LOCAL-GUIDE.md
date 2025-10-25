# Local Kubernetes Cluster Setup Guide

## 🚀 Quick Start (3 Steps)

### Step 1: Install Tools (Run as Administrator)
```powershell
.\setup-local-k8s.ps1
```
**Installs:** kubectl, minikube, chocolatey

### Step 2: Start Cluster
```powershell
.\start-minikube.ps1
```
**Creates:** Local Kubernetes cluster with 2 CPUs, 4GB RAM

### Step 3: Deploy Your App
```powershell
.\deploy-to-k8s.ps1
```
**Deploys:** Calculator service with 2 replicas

---

## 📋 Manual Installation (If scripts don't work)

### Option A: Using Chocolatey
```powershell
# Run PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
choco install kubernetes-cli -y
choco install minikube -y

# Close and reopen PowerShell
```

### Option B: Manual Download
1. **kubectl**: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
2. **minikube**: https://minikube.sigs.k8s.io/docs/start/

---

## 🎮 Essential Commands

### Cluster Management
```powershell
# Start cluster
minikube start

# Stop cluster (preserves state)
minikube stop

# Delete cluster (removes everything)
minikube delete

# Check status
minikube status

# SSH into cluster
minikube ssh

# Open Kubernetes dashboard
minikube dashboard
```

### Deployment Commands
```powershell
# Deploy application
kubectl apply -f k8s-deployment.yml

# Check deployments
kubectl get deployments

# Check pods
kubectl get pods

# Check services
kubectl get services

# Get all resources
kubectl get all

# Watch pods in real-time
kubectl get pods --watch
```

### Debugging Commands
```powershell
# View pod logs
kubectl logs <pod-name>

# Follow logs (like tail -f)
kubectl logs -f <pod-name>

# Logs from all pods with label
kubectl logs -l app=calculator-service

# Describe pod (detailed info)
kubectl describe pod <pod-name>

# Execute command in pod
kubectl exec -it <pod-name> -- /bin/sh

# Port forward to local machine
kubectl port-forward service/calculator-service 8080:80
```

### Scaling & Updates
```powershell
# Scale deployment
kubectl scale deployment calculator-service --replicas=5

# Update image
kubectl set image deployment/calculator-service calculator-app=calculator-service:v2

# Rollback deployment
kubectl rollout undo deployment/calculator-service

# Check rollout status
kubectl rollout status deployment/calculator-service
```

### Cleanup
```powershell
# Delete deployment
kubectl delete deployment calculator-service

# Delete service
kubectl delete service calculator-service

# Delete everything from file
kubectl delete -f k8s-deployment.yml

# Delete all pods with label
kubectl delete pods -l app=calculator-service
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────┐
│         YOUR WINDOWS MACHINE                    │
│                                                 │
│  ┌───────────────────────────────────────────┐ │
│  │      DOCKER DESKTOP                       │ │
│  │                                           │ │
│  │  ┌─────────────────────────────────────┐ │ │
│  │  │   MINIKUBE (Virtual Machine)        │ │ │
│  │  │                                     │ │ │
│  │  │  ┌───────────────────────────────┐ │ │ │
│  │  │  │  KUBERNETES CLUSTER           │ │ │ │
│  │  │  │                               │ │ │ │
│  │  │  │  Master Node (Control Plane)  │ │ │ │
│  │  │  │  Worker Node (Your Pods)      │ │ │ │
│  │  │  │                               │ │ │ │
│  │  │  │  Pod 1: calculator-service    │ │ │ │
│  │  │  │  Pod 2: calculator-service    │ │ │ │
│  │  │  └───────────────────────────────┘ │ │ │
│  │  └─────────────────────────────────────┘ │ │
│  └───────────────────────────────────────────┘ │
│                                                 │
│  kubectl CLI ──────┐                            │
│  (Your commands)   └─> Talks to cluster         │
└─────────────────────────────────────────────────┘
```

---

## 🎯 Common Workflows

### Deploy New Version
```powershell
# 1. Build new image
minikube docker-env | Invoke-Expression
docker build -t calculator-service:v2 .

# 2. Update deployment
kubectl set image deployment/calculator-service calculator-app=calculator-service:v2

# 3. Check rollout
kubectl rollout status deployment/calculator-service
```

### Test Locally
```powershell
# Option 1: Port forward
kubectl port-forward service/calculator-service 8080:80
# Access at: http://localhost:8080

# Option 2: Minikube service
minikube service calculator-service --url
# Returns URL like: http://192.168.49.2:30001
```

### Monitor Resources
```powershell
# Enable metrics server
minikube addons enable metrics-server

# View resource usage
kubectl top nodes
kubectl top pods

# Watch events
kubectl get events --sort-by='.lastTimestamp'
```

---

## 🔧 Troubleshooting

### Minikube won't start
```powershell
# Delete and recreate
minikube delete
minikube start --driver=docker

# Check Docker is running
docker ps

# Check driver
minikube start --driver=docker --alsologtostderr
```

### Pods stuck in Pending
```powershell
# Check events
kubectl describe pod <pod-name>

# Check node resources
kubectl top nodes
```

### Can't access service
```powershell
# Check service exists
kubectl get services

# Check pods are running
kubectl get pods

# Use port-forward instead
kubectl port-forward service/calculator-service 8080:80
```

### Image pull errors
```powershell
# Make sure to build in Minikube's Docker
minikube docker-env | Invoke-Expression
docker build -t calculator-service:local .

# Use imagePullPolicy: Never in deployment
```

---

## 🎓 Learning Resources

### Official Docs
- **Kubernetes**: https://kubernetes.io/docs/home/
- **Minikube**: https://minikube.sigs.k8s.io/docs/
- **kubectl**: https://kubernetes.io/docs/reference/kubectl/

### Interactive Tutorials
- **Kubernetes Basics**: https://kubernetes.io/docs/tutorials/kubernetes-basics/
- **Play with Kubernetes**: https://labs.play-with-k8s.com/

### Cheat Sheets
- **kubectl**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

---

## 📊 Resource Requirements

### Minimum
- **RAM**: 2GB for Minikube + 2GB for Docker Desktop
- **CPU**: 2 cores
- **Disk**: 20GB free space

### Recommended
- **RAM**: 8GB+ (4GB for Minikube)
- **CPU**: 4+ cores
- **Disk**: 40GB+ free space

---

## 🆚 Alternative Tools

### Docker Desktop Kubernetes
```powershell
# Enable in Docker Desktop settings
# Settings → Kubernetes → Enable Kubernetes
# No additional installation needed!
```

### Kind (Kubernetes in Docker)
```powershell
# Install
choco install kind -y

# Create cluster
kind create cluster --name calculator-cluster

# Load image
kind load docker-image calculator-service:local --name calculator-cluster
```

### K3d (K3s in Docker)
```powershell
# Install
choco install k3d -y

# Create cluster
k3d cluster create calculator-cluster

# Import image
k3d image import calculator-service:local -c calculator-cluster
```

---

## ✅ Next Steps

1. **Install**: Run `setup-local-k8s.ps1`
2. **Start**: Run `start-minikube.ps1`
3. **Deploy**: Run `deploy-to-k8s.ps1`
4. **Learn**: Experiment with kubectl commands
5. **Monitor**: Open `minikube dashboard`

Happy Kubernetes learning! 🚀
