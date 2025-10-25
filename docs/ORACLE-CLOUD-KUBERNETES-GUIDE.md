# 🚀 Oracle Cloud Kubernetes (OKE) Deployment Guide

## 📋 Overview
This guide walks you through deploying your calculator microservice to Oracle Cloud's **Always Free Kubernetes cluster**.

**What you'll learn:**
- Setting up Oracle Cloud Infrastructure (OCI)
- Creating a free Kubernetes cluster
- Deploying your app to production
- Accessing via public URL

**Time required:** 45-60 minutes
**Cost:** $0 (Always Free tier)

---

## 🎯 Step 1: Oracle Cloud Account Setup

### 1.1 Sign Up
1. Visit: https://www.oracle.com/cloud/free/
2. Click **"Start for Free"**
3. Fill in:
   - Email
   - Country
   - First/Last Name
4. Choose **"Free Tier Account"** (NOT upgrade to paid)
5. Verify email
6. Add credit card (for verification only - **never charged on Always Free**)

### 1.2 Verify Account
- Check email for verification link
- Set home region (pick closest: US East, US West, Europe, Asia)
  - **⚠️ IMPORTANT:** Can't change later!
- Complete profile

### 1.3 Access Console
- Login: https://cloud.oracle.com/
- You'll see OCI Console dashboard

---

## 🛠️ Step 2: Install Oracle Cloud CLI

### 2.1 Install OCI CLI (Windows)

```powershell
# Download and install
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.ps1" -OutFile install.ps1
.\install.ps1 -AcceptAllDefaults

# Verify installation
oci --version
```

**Expected output:** `3.x.x`

### 2.2 Configure OCI CLI

```powershell
# Start configuration wizard
oci setup config

# You'll be asked:
# 1. Config location: Press Enter (default)
# 2. User OCID: Copy from OCI Console
# 3. Tenancy OCID: Copy from OCI Console
# 4. Region: Enter your home region (e.g., us-ashburn-1)
# 5. Generate new API key: Y
```

**Where to find OCIDs:**
1. In OCI Console, click profile icon (top-right)
2. Click **"User Settings"**
3. Copy **User OCID**
4. Click **"Tenancy"** link
5. Copy **Tenancy OCID**

### 2.3 Upload API Key
After running `oci setup config`, you'll have:
- Private key: `~/.oci/oci_api_key.pem`
- Public key: `~/.oci/oci_api_key_public.pem`

**Upload public key:**
1. In OCI Console → User Settings
2. Scroll to **"API Keys"**
3. Click **"Add API Key"**
4. Paste contents of `oci_api_key_public.pem`

### 2.4 Test Connection

```powershell
# List compute instances (should be empty)
oci compute instance list --compartment-id <your-compartment-ocid>
```

---

## ☁️ Step 3: Create Kubernetes Cluster (FREE!)

### Option A: Using OCI Console (Easier for first time)

#### 3.1 Create VCN (Virtual Cloud Network)
1. In OCI Console → **Networking** → **Virtual Cloud Networks**
2. Click **"Start VCN Wizard"**
3. Select **"Create VCN with Internet Connectivity"**
4. Name: `calculator-vcn`
5. VCN CIDR: `10.0.0.0/16`
6. Public Subnet: `10.0.0.0/24`
7. Private Subnet: `10.0.1.0/24`
8. Click **"Next"** → **"Create"**

#### 3.2 Create OKE Cluster
1. In OCI Console → **Developer Services** → **Kubernetes Clusters (OKE)**
2. Click **"Create Cluster"**
3. Choose **"Quick Create"** (easier setup)

**Configuration:**
- **Name:** `calculator-cluster`
- **Kubernetes version:** Latest (e.g., v1.29)
- **Choose visibility type:** Public endpoint
- **Shape:** VM.Standard.A1.Flex (ARM - Always Free!)
- **Node count:** 2 nodes
- **OCPUs per node:** 1
- **Memory per node:** 6 GB
- **VCN:** Select `calculator-vcn` created earlier

4. Click **"Next"** → **"Create Cluster"**
5. Wait ~10-15 minutes for cluster to be created

**💡 Tip:** Cluster status will change from "Creating" → "Active"

---

### Option B: Using CLI (Advanced)

```powershell
# Set variables
$COMPARTMENT_ID = "<your-compartment-ocid>"
$VCN_ID = "<your-vcn-ocid>"

# Create node pool
oci ce node-pool create `
  --cluster-id <cluster-ocid> `
  --name calculator-node-pool `
  --node-shape VM.Standard.A1.Flex `
  --node-shape-config '{"ocpus":1,"memoryInGBs":6}' `
  --size 2
```

---

## 🔧 Step 4: Configure kubectl

### 4.1 Get Kubeconfig
1. In OCI Console → Your cluster
2. Click **"Access Cluster"**
3. Copy the `oci ce cluster create-kubeconfig` command
4. Run it in PowerShell:

```powershell
# Example (your values will differ):
oci ce cluster create-kubeconfig `
  --cluster-id ocid1.cluster.oc1.iad.aaaa... `
  --file $HOME\.kube\config-oci `
  --region us-ashburn-1
```

### 4.2 Merge with existing config

```powershell
# Set KUBECONFIG to use OCI cluster
$env:KUBECONFIG = "$HOME\.kube\config;$HOME\.kube\config-oci"

# Verify connection
kubectl cluster-info

# List contexts
kubectl config get-contexts

# Switch to OCI cluster
kubectl config use-context <oci-context-name>
```

### 4.3 Test cluster

```powershell
# Get nodes
kubectl get nodes

# Expected output:
# NAME          STATUS   ROLES   AGE   VERSION
# 10.0.10.2     Ready    node    5m    v1.29.1
# 10.0.10.3     Ready    node    5m    v1.29.1
```

---

## 📦 Step 5: Push Docker Image to Oracle Container Registry

### 5.1 Create Container Repository
1. In OCI Console → **Developer Services** → **Container Registry**
2. Click **"Create Repository"**
3. Name: `calculator-service`
4. Access: **Public** (easier for now)
5. Click **"Create"**

### 5.2 Login to Registry

```powershell
# Get your region's registry URL (e.g., iad.ocir.io for Ashburn)
$REGION = "iad"  # Change to your region
$TENANCY_NAMESPACE = "<your-tenancy-namespace>"  # Find in Container Registry page

# Login (use Auth Token, not password)
docker login $REGION.ocir.io -u "$TENANCY_NAMESPACE/<your-username>"
# Password: Generate Auth Token in OCI Console → User Settings → Auth Tokens
```

### 5.3 Tag and Push Image

```powershell
# Tag image
docker tag calculator-service:latest `
  $REGION.ocir.io/$TENANCY_NAMESPACE/calculator-service:latest

# Push to OCI Registry
docker push $REGION.ocir.io/$TENANCY_NAMESPACE/calculator-service:latest
```

---

## 🚀 Step 6: Deploy to Oracle Kubernetes

### 6.1 Update deployment.yaml

Create `config/k8s/deployment-oracle.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: calculator-service
  namespace: calculator
spec:
  replicas: 2
  selector:
    matchLabels:
      app: calculator-service
  template:
    metadata:
      labels:
        app: calculator-service
    spec:
      containers:
      - name: calculator-app
        # Use OCI Container Registry
        image: iad.ocir.io/YOUR_TENANCY/calculator-service:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /actuator/health/liveness
            port: 8080
          initialDelaySeconds: 60
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: calculator-service
  namespace: calculator
spec:
  type: LoadBalancer
  selector:
    app: calculator-service
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
```

### 6.2 Deploy!

```powershell
# Create namespace
kubectl apply -f config/k8s/namespace.yaml

# Create configmap
kubectl apply -f config/k8s/configmap.yaml

# Deploy app
kubectl apply -f config/k8s/deployment-oracle.yaml

# Watch pods start
kubectl get pods -n calculator -w
```

### 6.3 Get Public IP

```powershell
# Wait for LoadBalancer to get external IP (takes 2-3 minutes)
kubectl get service -n calculator -w

# Expected output:
# NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP      PORT(S)
# calculator-service   LoadBalancer   10.96.x.x      XXX.XXX.XXX.XXX  80:3xxxx/TCP
```

---

## 🌐 Step 7: Access Your App

### 7.1 Test Endpoints

```powershell
$PUBLIC_IP = "<external-ip-from-above>"

# Health check
Invoke-RestMethod -Uri "http://$PUBLIC_IP/actuator/health"

# Calculate
$body = @{num1=10; num2=5; operation="add"} | ConvertTo-Json
Invoke-RestMethod -Uri "http://$PUBLIC_IP/api/calculate" -Method Post -Body $body -ContentType "application/json"
```

### 7.2 Access Swagger UI
Open in browser: `http://<external-ip>/swagger-ui/index.html`

---

## 🔒 Step 8: (Optional) Setup Domain & SSL

### 8.1 Point Domain to IP
In your DNS provider (Namecheap, GoDaddy, etc.):
```
A Record: calculator.yourdomain.com → <external-ip>
```

### 8.2 Install Cert-Manager

```powershell
# Install cert-manager (for free Let's Encrypt SSL)
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml

# Install nginx ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

### 8.3 Apply Ingress

```powershell
# Edit config/k8s/ingress-prod.yaml with your domain
# Then apply:
kubectl apply -f config/k8s/ingress-prod.yaml
```

---

## 📊 Step 9: Monitoring & Management

### 9.1 View Logs

```powershell
# All pods
kubectl logs -n calculator -l app=calculator-service

# Specific pod
kubectl logs -n calculator <pod-name>

# Follow logs
kubectl logs -n calculator <pod-name> -f
```

### 9.2 Scale Up/Down

```powershell
# Scale to 3 replicas
kubectl scale deployment calculator-service -n calculator --replicas=3

# Scale to 1 replica
kubectl scale deployment calculator-service -n calculator --replicas=1
```

### 9.3 Update Application

```powershell
# Build new image
docker build -t calculator-service:v2 -f config/Dockerfile .

# Tag for OCI
docker tag calculator-service:v2 iad.ocir.io/$TENANCY/calculator-service:v2

# Push
docker push iad.ocir.io/$TENANCY/calculator-service:v2

# Update deployment
kubectl set image deployment/calculator-service -n calculator `
  calculator-app=iad.ocir.io/$TENANCY/calculator-service:v2

# Watch rollout
kubectl rollout status deployment/calculator-service -n calculator
```

---

## 🛑 Step 10: Cleanup (if needed)

### Delete Everything

```powershell
# Delete app
kubectl delete namespace calculator

# Delete cluster (in OCI Console → OKE → Delete Cluster)

# Delete VCN (in OCI Console → Networking → VCN → Delete)
```

---

## 💰 Cost Breakdown (Always Free!)

| Resource | Free Tier | Your Usage | Cost |
|----------|-----------|------------|------|
| Compute (ARM) | 4 OCPUs, 24GB RAM | 2 OCPUs, 12GB RAM | **$0** |
| Block Storage | 200 GB | ~20 GB | **$0** |
| Load Balancer | 1 instance | 1 instance | **$0** |
| Outbound Transfer | 10 TB/month | <1 GB/month | **$0** |
| **TOTAL** | | | **$0/month** |

---

## ❓ Troubleshooting

### Issue: Pods stuck in "Pending"
```powershell
kubectl describe pod <pod-name> -n calculator
# Check events for "Insufficient CPU/Memory"
# Solution: Reduce resource requests in deployment.yaml
```

### Issue: Can't pull image
```powershell
# Create image pull secret
kubectl create secret docker-registry ocirsecret `
  --docker-server=iad.ocir.io `
  --docker-username="$TENANCY_NAMESPACE/<username>" `
  --docker-password="<auth-token>" `
  -n calculator

# Add to deployment:
# spec:
#   imagePullSecrets:
#   - name: ocirsecret
```

### Issue: LoadBalancer stuck on "Pending"
- Wait 5-10 minutes (OCI takes time)
- Check OCI Console → Networking → Load Balancers
- Verify security lists allow traffic on port 80

---

## 🎯 Next Steps

1. ✅ App running on Oracle Cloud!
2. Setup CI/CD to auto-deploy on git push
3. Add monitoring (Prometheus + Grafana)
4. Configure autoscaling
5. Build second microservice (Phase 3!)

---

## 📚 Resources

- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
- [OCI Documentation](https://docs.oracle.com/en-us/iaas/Content/home.htm)
- [OKE Documentation](https://docs.oracle.com/en-us/iaas/Content/ContEng/home.htm)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)

---

**🎉 Congratulations!** You now have a production-ready Kubernetes cluster running your app - completely FREE! 🚀
