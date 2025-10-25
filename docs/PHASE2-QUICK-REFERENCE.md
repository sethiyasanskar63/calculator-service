# 🎯 Phase 2 - Quick Reference Card

## 🚀 Getting Started (4 Steps)

```powershell
# 1. Setup (installs kubectl, minikube)
.\k8s-setup.ps1

# 2. Start cluster
.\k8s-start.ps1

# 3. Deploy app
.\k8s-deploy.ps1

# 4. Test it
.\k8s-test.ps1
```

---

## 📁 Files Created

```
k8s/
├── deployment.yaml    - Defines app deployment (3 replicas)
├── namespace.yaml     - Creates isolated environment
├── configmap.yaml     - Configuration data
└── ingress.yaml       - HTTP routing

Scripts:
├── k8s-setup.ps1      - Install tools
├── k8s-start.ps1      - Start Minikube
├── k8s-deploy.ps1     - Deploy to K8s
├── k8s-test.ps1       - Test deployment
└── k8s-cleanup.ps1    - Clean up resources
```

---

## ⚡ Most Used Commands

### Viewing
```powershell
kubectl get pods -n calculator           # List pods
kubectl get all -n calculator            # List everything
kubectl logs -f <pod-name> -n calculator # Follow logs
kubectl describe pod <pod-name> -n calculator
```

### Accessing
```powershell
# Method 1: Port forward
kubectl port-forward -n calculator service/calculator-service 8080:80

# Method 2: Minikube URL
minikube service calculator-service -n calculator --url
```

### Scaling
```powershell
kubectl scale deployment calculator-service --replicas=5 -n calculator
```

### Updates
```powershell
# Build new image
& minikube docker-env | Invoke-Expression
docker build -t calculator-service:v2 .

# Deploy update
kubectl set image deployment/calculator-service calculator-app=calculator-service:v2 -n calculator

# Rollback if needed
kubectl rollout undo deployment/calculator-service -n calculator
```

### Debugging
```powershell
kubectl logs <pod-name> -n calculator              # View logs
kubectl exec -it <pod-name> -n calculator -- /bin/sh  # Shell into pod
kubectl top pods -n calculator                     # Resource usage
kubectl get events -n calculator                   # Recent events
```

### Cleanup
```powershell
.\k8s-cleanup.ps1                     # Interactive cleanup
kubectl delete namespace calculator   # Delete everything
minikube stop                         # Stop cluster
minikube delete                       # Delete cluster
```

---

## 🎓 6 Core Concepts

| Concept | What | Think of it as |
|---------|------|----------------|
| **Pod** | Smallest unit | Single container instance |
| **Deployment** | Manages Pods | Ensures X replicas running |
| **Service** | Load balancer | Routes traffic to Pods |
| **Namespace** | Virtual cluster | Folder for resources |
| **ConfigMap** | Configuration | .env file |
| **Ingress** | HTTP router | Reverse proxy |

---

## 🏗️ Your Architecture

```
Service (LoadBalancer)
    ↓
  ┌─┴─┬─┬─┐
  │   │ │ │  (Distributes traffic)
  ↓   ↓ ↓ ↓
Pod1 Pod2 Pod3
 │    │    │
 └────┴────┘
   Managed by Deployment
```

---

## 🐛 Common Issues

### Pods not starting?
```powershell
kubectl describe pod <pod-name> -n calculator
# Look for errors in Events section
```

### Can't access service?
```powershell
# Use port-forward as fallback
kubectl port-forward -n calculator service/calculator-service 8080:80
```

### Minikube won't start?
```powershell
minikube delete   # Clean slate
minikube start    # Try again
```

---

## 📊 Test Your Service

```powershell
# 1. Port forward
kubectl port-forward -n calculator service/calculator-service 8080:80

# 2. Test in another terminal
curl http://localhost:8080/actuator/health
curl -X POST http://localhost:8080/api/add -H "Content-Type: application/json" -d '{"a":5,"b":3}'
```

---

## ✅ Phase 2 Checklist

- [ ] Installed kubectl and Minikube
- [ ] Started Minikube cluster
- [ ] Deployed calculator to K8s
- [ ] Scaled deployment
- [ ] Viewed logs
- [ ] Accessed via port-forward
- [ ] Performed rolling update
- [ ] Tested auto-healing (delete pod)
- [ ] Viewed Kubernetes dashboard
- [ ] Understand 6 core concepts

**All done?** → Move to Phase 3! 🚀

---

## 🎯 Next: Phase 3

Create a second microservice:
```
✅ calculator-service  (You have this!)
🆕 user-service        (Next!)
```

Both running in Kubernetes together! 💪
