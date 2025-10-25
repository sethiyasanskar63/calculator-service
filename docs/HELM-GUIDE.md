# Helm - The Kubernetes Package Manager

## 🎯 What is Helm?

**Helm** is a tool that helps you manage Kubernetes applications. It packages all your K8s YAML files into reusable "charts".

### Without Helm (Manual) ❌
```powershell
# You have to manage multiple YAML files manually
kubectl apply -f deployment.yml
kubectl apply -f service.yml
kubectl apply -f configmap.yml
kubectl apply -f secret.yml
kubectl apply -f ingress.yml
kubectl apply -f persistentvolume.yml

# And update them one by one
kubectl set image deployment/app app=myapp:v2
kubectl set env deployment/app DB_HOST=newhost
```

### With Helm (Package Manager) ✅
```powershell
# Install entire application with one command
helm install my-calculator ./calculator-chart

# Upgrade with new values
helm upgrade my-calculator ./calculator-chart --set image.tag=v2

# Rollback if something breaks
helm rollback my-calculator

# Uninstall everything
helm uninstall my-calculator
```

---

## 🏗️ Where Helm Fits in the Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    YOUR MACHINE                         │
│                                                         │
│  Developer writes code                                  │
│         ↓                                               │
│  Dockerfile (build image)                               │
│         ↓                                               │
│  Push to Docker Hub/Registry                            │
│         ↓                                               │
│  ┌──────────────────────────────────────────┐          │
│  │  HELM CHART (Package of K8s configs)     │          │
│  │  ├── Chart.yaml (metadata)               │          │
│  │  ├── values.yaml (configuration)         │          │
│  │  └── templates/                          │          │
│  │      ├── deployment.yaml                 │          │
│  │      ├── service.yaml                    │          │
│  │      ├── ingress.yaml                    │          │
│  │      └── configmap.yaml                  │          │
│  └──────────────────────────────────────────┘          │
│         │                                               │
│         │ helm install                                  │
│         ↓                                               │
│  ┌──────────────────────────────────────────┐          │
│  │      KUBERNETES CLUSTER                   │          │
│  │  ┌────────────────────────────────────┐  │          │
│  │  │  Deployed Application              │  │          │
│  │  │  • Deployment (3 replicas)         │  │          │
│  │  │  • Service (load balancer)         │  │          │
│  │  │  • Ingress (routing)               │  │          │
│  │  │  • ConfigMap (configuration)       │  │          │
│  │  └────────────────────────────────────┘  │          │
│  └──────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────┘
```

---

## 📦 Helm Chart Structure

Think of a Helm Chart as a **blueprint** for your application:

```
calculator-chart/
├── Chart.yaml           # Chart metadata (name, version)
├── values.yaml          # Default configuration values
├── charts/              # Dependent charts (like dependencies)
└── templates/           # Kubernetes YAML templates
    ├── deployment.yaml  # How to run your app
    ├── service.yaml     # How to expose your app
    ├── ingress.yaml     # How to route traffic
    ├── configmap.yaml   # Configuration data
    ├── secret.yaml      # Sensitive data
    └── _helpers.tpl     # Template helpers
```

---

## 🎨 Real Example: Your Calculator Service

Let me create a Helm chart for your calculator service:

### 1. Chart.yaml (Metadata)
```yaml
apiVersion: v2
name: calculator-service
description: A Helm chart for Calculator microservice
type: application
version: 1.0.0        # Chart version
appVersion: "1.0.0"   # Application version
```

### 2. values.yaml (Configuration)
```yaml
# Default values for calculator-service
# This is a YAML-formatted file.

replicaCount: 3

image:
  repository: yourusername/calculator-service
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80
  targetPort: 8080

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: calculator.local
      paths:
        - path: /
          pathType: Prefix

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

env:
  - name: SPRING_PROFILES_ACTIVE
    value: "prod"
```

### 3. templates/deployment.yaml (Template)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "calculator-service.fullname" . }}
  labels:
    {{- include "calculator-service.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "calculator-service.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "calculator-service.selectorLabels" . | nindent 8 }}
    spec:
      containers:
      - name: calculator
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - containerPort: {{ .Values.service.targetPort }}
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
        env:
          {{- toYaml .Values.env | nindent 12 }}
```

**Notice**: The `{{ .Values.xxx }}` parts are **variables** that get replaced with values from `values.yaml`!

---

## 🎯 Why Use Helm?

### 1. **Reusability**
```powershell
# Deploy to DEV environment
helm install calc-dev ./calculator-chart -f values-dev.yaml

# Deploy to STAGING environment
helm install calc-staging ./calculator-chart -f values-staging.yaml

# Deploy to PRODUCTION environment
helm install calc-prod ./calculator-chart -f values-prod.yaml
```

Same chart, different configurations!

### 2. **Versioning & Rollback**
```powershell
# Upgrade to v2
helm upgrade my-calculator ./calculator-chart --set image.tag=v2

# Oh no! v2 has a bug! Rollback to v1
helm rollback my-calculator 1

# See all releases
helm history my-calculator
```

### 3. **Templating**
```yaml
# Instead of repeating this in every file:
name: calculator-service
labels:
  app: calculator-service
  version: v1

# Use templates:
name: {{ .Release.Name }}
labels:
  {{- include "calculator.labels" . | nindent 4 }}
```

### 4. **Dependency Management**
```yaml
# Chart.yaml
dependencies:
  - name: postgresql
    version: 12.1.0
    repository: https://charts.bitnami.com/bitnami
  - name: redis
    version: 17.3.0
    repository: https://charts.bitnami.com/bitnami
```

Install your app + database + cache with one command!

---

## 🔄 Complete Deployment Flow

### Traditional Kubernetes (Manual)
```
1. Write deployment.yaml
2. Write service.yaml
3. Write ingress.yaml
4. Write configmap.yaml
5. kubectl apply -f deployment.yaml
6. kubectl apply -f service.yaml
7. kubectl apply -f ingress.yaml
8. kubectl apply -f configmap.yaml
9. To update: Edit files manually, reapply
10. To rollback: Keep old files, reapply manually
```

### With Helm
```
1. Create Helm chart (once)
2. helm install my-app ./chart
3. To update: helm upgrade my-app ./chart --set newValue=x
4. To rollback: helm rollback my-app
5. To uninstall: helm uninstall my-app
```

---

## 🛠️ Helm Commands Cheat Sheet

```powershell
# Install Helm (Windows)
choco install kubernetes-helm

# Or using script
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Create a new chart
helm create calculator-chart

# Install chart
helm install my-calculator ./calculator-chart

# Install with custom values
helm install my-calculator ./calculator-chart -f custom-values.yaml

# Or override specific values
helm install my-calculator ./calculator-chart --set replicaCount=5

# List installed releases
helm list

# Get release status
helm status my-calculator

# Upgrade release
helm upgrade my-calculator ./calculator-chart

# Rollback to previous version
helm rollback my-calculator

# Rollback to specific revision
helm rollback my-calculator 2

# See release history
helm history my-calculator

# Uninstall release
helm uninstall my-calculator

# Dry run (see what would be deployed without actually deploying)
helm install my-calculator ./calculator-chart --dry-run --debug

# Package chart for distribution
helm package ./calculator-chart

# Search for charts in repositories
helm search repo nginx

# Add chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update repositories
helm repo update

# Show chart values
helm show values bitnami/postgresql
```

---

## 📊 Helm vs Plain Kubernetes

| Task | Plain Kubernetes | Helm |
|------|-----------------|------|
| **Deploy** | `kubectl apply -f *.yaml` | `helm install myapp ./chart` |
| **Update** | Edit YAML, `kubectl apply` | `helm upgrade myapp ./chart` |
| **Rollback** | Keep old files manually | `helm rollback myapp` |
| **Uninstall** | `kubectl delete -f *.yaml` | `helm uninstall myapp` |
| **Multiple Envs** | Maintain separate YAML files | Use different `values.yaml` |
| **Versioning** | Manual (git) | Built-in |
| **Dependencies** | Manual | Automatic |

---

## 🏢 Real-World Example

### Scenario: E-commerce Microservices

Without Helm:
```
frontend/
  ├── deployment.yaml
  ├── service.yaml
  ├── ingress.yaml
  └── configmap.yaml
api-gateway/
  ├── deployment.yaml
  ├── service.yaml
  └── configmap.yaml
product-service/
  ├── deployment.yaml
  ├── service.yaml
  └── configmap.yaml
user-service/
  ├── deployment.yaml
  ├── service.yaml
  └── configmap.yaml
...
(50+ YAML files to manage!)
```

With Helm:
```
ecommerce-chart/
  ├── Chart.yaml
  ├── values.yaml
  └── templates/
      └── (all templates)

# Deploy everything:
helm install ecommerce ./ecommerce-chart

# Update product service:
helm upgrade ecommerce ./ecommerce-chart --set productService.replicas=10
```

---

## 🎯 Where Helm Fits in Your Journey

### Your Current Stack:
```
Code → Docker → Kubernetes → Deploy manually
```

### With Helm Added:
```
Code → Docker → Helm Chart → Deploy with `helm install`
```

### Complete DevOps Pipeline:
```
Code → Git → CI/CD Pipeline → Build Docker → Package Helm Chart → Deploy to K8s
```

---

## 💡 Popular Helm Charts (Ready to Use!)

```powershell
# Add Bitnami repository (trusted charts)
helm repo add bitnami https://charts.bitnami.com/bitnami

# Install PostgreSQL
helm install my-postgres bitnami/postgresql

# Install Redis
helm install my-redis bitnami/redis

# Install NGINX Ingress Controller
helm install nginx-ingress ingress-nginx/ingress-nginx

# Install Prometheus (monitoring)
helm install prometheus prometheus-community/prometheus

# Install Grafana (dashboards)
helm install grafana grafana/grafana
```

You don't have to write YAML files for these! Just install and configure.

---

## 🆚 Comparison Table

### Deployment Tools Comparison

| Tool | What It Does | When to Use |
|------|-------------|-------------|
| **kubectl** | Raw K8s CLI | Simple deployments, learning |
| **Helm** | Package manager | Production, multiple environments |
| **Kustomize** | YAML overlay tool | Template-free customization |
| **ArgoCD** | GitOps CD tool | Automated deployments from Git |
| **Terraform** | Infrastructure as Code | Multi-cloud, infrastructure provisioning |

---

## 🚀 Getting Started with Helm

Let me create a complete Helm chart for your calculator service:
