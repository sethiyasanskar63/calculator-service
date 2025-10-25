# Kubernetes Manifests

This folder contains all Kubernetes YAML files for deploying the calculator service.

## 📁 Files

### `namespace.yaml`
Creates an isolated environment called `calculator` for all resources.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: calculator
```

**Purpose:** Keeps your app separate from other apps in the cluster.

---

### `configmap.yaml`
Stores configuration data (like environment variables).

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: calculator-config
data:
  log-level: "INFO"
  feature.advanced-math: "true"
```

**Purpose:** Externalize configuration from code.  
**Usage:** Mount as environment variables or files in pods.

---

### `deployment.yaml`
Defines how to run your application.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: calculator-service
spec:
  replicas: 3  # Run 3 copies
  template:
    spec:
      containers:
      - name: calculator-app
        image: calculator-service:latest
        ports:
        - containerPort: 8080
```

**Purpose:** Ensures 3 pods are always running.  
**Features:**
- Auto-healing (recreates crashed pods)
- Rolling updates (zero downtime)
- Resource limits (CPU, memory)
- Health checks (liveness, readiness probes)

---

### `service.yaml` (Included in deployment.yaml)
Provides a stable network endpoint.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: calculator-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
```

**Purpose:** Load balancer that routes traffic to pods.  
**Type:** LoadBalancer (Minikube provides external access)

---

### `ingress.yaml`
HTTP routing (advanced).

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: calculator-ingress
spec:
  rules:
  - host: calculator.local
    http:
      paths:
      - path: /
        backend:
          service:
            name: calculator-service
            port:
              number: 80
```

**Purpose:** Routes external HTTP traffic to services.  
**Requires:** NGINX Ingress Controller (enabled via `minikube addons enable ingress`)

---

## 🚀 Deployment Order

Deploy in this order:

```powershell
# 1. Namespace (creates isolated environment)
kubectl apply -f namespace.yaml

# 2. ConfigMap (provides configuration)
kubectl apply -f configmap.yaml -n calculator

# 3. Deployment (creates pods and service)
kubectl apply -f deployment.yaml -n calculator

# 4. Ingress (optional, for HTTP routing)
kubectl apply -f ingress.yaml -n calculator
```

**Or use the script:**
```powershell
.\k8s-deploy.ps1
```

---

## 🔍 Viewing Resources

```powershell
# See everything
kubectl get all -n calculator

# See specific resources
kubectl get pods -n calculator
kubectl get deployments -n calculator
kubectl get services -n calculator
kubectl get configmaps -n calculator
kubectl get ingress -n calculator
```

---

## 📝 Editing Resources

### Method 1: Edit YAML file, then apply
```powershell
# Edit deployment.yaml (e.g., change replicas from 3 to 5)
# Then:
kubectl apply -f deployment.yaml -n calculator
```

### Method 2: Edit directly in K8s
```powershell
kubectl edit deployment calculator-service -n calculator
```

### Method 3: Use kubectl commands
```powershell
# Scale
kubectl scale deployment calculator-service --replicas=5 -n calculator

# Update image
kubectl set image deployment/calculator-service calculator-app=calculator-service:v2 -n calculator
```

---

## 🗑️ Deleting Resources

```powershell
# Delete specific resource
kubectl delete -f deployment.yaml -n calculator

# Delete entire namespace (removes everything)
kubectl delete namespace calculator

# Or use the cleanup script
.\k8s-cleanup.ps1
```

---

## 🎯 Common Operations

### Scale Up/Down
```powershell
kubectl scale deployment calculator-service --replicas=5 -n calculator
```

### Rolling Update
```powershell
# Build new image first
docker build -t calculator-service:v2 .

# Update deployment
kubectl set image deployment/calculator-service calculator-app=calculator-service:v2 -n calculator

# Watch rollout
kubectl rollout status deployment/calculator-service -n calculator
```

### Rollback
```powershell
kubectl rollout undo deployment/calculator-service -n calculator
```

### View Logs
```powershell
# All pods
kubectl logs -l app=calculator-service -n calculator

# Specific pod
kubectl logs <pod-name> -n calculator

# Follow logs
kubectl logs -f <pod-name> -n calculator
```

### Debugging
```powershell
# Detailed info
kubectl describe pod <pod-name> -n calculator

# Shell into pod
kubectl exec -it <pod-name> -n calculator -- /bin/sh

# View events
kubectl get events -n calculator
```

---

## 🏗️ Architecture

```
┌────────────────────────────────────────┐
│  Namespace: calculator                 │
│                                        │
│  ┌──────────────────────────────────┐ │
│  │  Ingress: calculator-ingress     │ │
│  │  (Optional HTTP routing)         │ │
│  └────────────┬─────────────────────┘ │
│               │                        │
│  ┌────────────┴─────────────────────┐ │
│  │  Service: calculator-service     │ │
│  │  Type: LoadBalancer              │ │
│  │  Port: 80 → 8080                 │ │
│  └────┬─────────┬─────────┬─────────┘ │
│       │         │         │            │
│  ┌────┴──┐ ┌───┴───┐ ┌───┴───┐       │
│  │ Pod 1 │ │ Pod 2 │ │ Pod 3 │       │
│  │       │ │       │ │       │       │
│  │ :8080 │ │ :8080 │ │ :8080 │       │
│  └───────┘ └───────┘ └───────┘       │
│       ↑         ↑         ↑           │
│       └─────────┴─────────┘           │
│     Deployment: calculator-service    │
│     (Manages 3 replicas)              │
│                                        │
│  ConfigMap: calculator-config         │
│  (Mounted as env vars)                │
└────────────────────────────────────────┘
```

---

## 📚 Learn More

- **Deployments**: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- **Services**: https://kubernetes.io/docs/concepts/services-networking/service/
- **ConfigMaps**: https://kubernetes.io/docs/concepts/configuration/configmap/
- **Ingress**: https://kubernetes.io/docs/concepts/services-networking/ingress/

---

## ✅ Checklist

Before deploying, make sure:
- [ ] Minikube is running (`minikube status`)
- [ ] Docker image is built (`docker images | grep calculator-service`)
- [ ] kubectl is configured (`kubectl cluster-info`)

After deploying:
- [ ] Pods are running (`kubectl get pods -n calculator`)
- [ ] Service has endpoint (`kubectl get svc -n calculator`)
- [ ] App is accessible (port-forward or Minikube service)

---

**Created for Phase 2: Learn Kubernetes** 🚀
