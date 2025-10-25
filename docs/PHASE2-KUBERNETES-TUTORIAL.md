# 🎓 Phase 2: Learn Kubernetes - Hands-On Tutorial

## 📚 What You'll Learn

By the end of this phase, you will:
1. ✅ Understand Kubernetes core concepts (Pods, Deployments, Services)
2. ✅ Deploy your calculator service to a local K8s cluster
3. ✅ Scale applications up and down
4. ✅ Perform rolling updates
5. ✅ Monitor and debug applications
6. ✅ Understand ConfigMaps and Namespaces

---

## 🚀 Quick Start (3 Commands)

```powershell
# 1. Setup tools (kubectl, minikube)
.\k8s-setup.ps1

# 2. Start Minikube cluster
.\k8s-start.ps1

# 3. Deploy calculator service
.\k8s-deploy.ps1

# 4. Test it works
.\k8s-test.ps1
```

**That's it!** You now have Kubernetes running! 🎉

---

## 📖 Understanding What Just Happened

### Step 1: The Setup (k8s-setup.ps1)
```
Installed:
  ✅ kubectl    - Command-line tool to talk to Kubernetes
  ✅ minikube   - Local Kubernetes cluster on your laptop
```

### Step 2: The Cluster (k8s-start.ps1)
```
Created:
  ┌─────────────────────────────┐
  │    MINIKUBE CLUSTER         │
  │  ┌───────────────────────┐  │
  │  │   Master Node         │  │  (Controls everything)
  │  └───────────────────────┘  │
  │  ┌───────────────────────┐  │
  │  │   Worker Node         │  │  (Runs your apps)
  │  └───────────────────────┘  │
  └─────────────────────────────┘
```

### Step 3: The Deployment (k8s-deploy.ps1)
```
Created in Kubernetes:

1. Namespace: calculator
   └─ Isolated environment for your app

2. ConfigMap: calculator-config
   └─ Configuration data (like environment variables)

3. Deployment: calculator-service
   └─ Manages 3 identical Pods running your app
   
4. Service: calculator-service
   └─ Load balancer that routes traffic to pods

5. Ingress: calculator-ingress
   └─ Entry point for external traffic
```

---

## 🧩 Kubernetes Concepts Explained

### 1. Pod
**What**: Smallest deployable unit in K8s  
**Contains**: 1 or more containers  
**Think of it**: A single instance of your app

```yaml
# One Pod = One calculator-service container
Pod: calculator-service-abc123
  └─ Container: calculator-app (running on port 8080)
```

### 2. Deployment
**What**: Manages multiple identical Pods  
**Does**: Ensures desired number of replicas are running  
**Think of it**: Pod manager

```yaml
Deployment: calculator-service
  ├─ Pod 1: calculator-service-abc123
  ├─ Pod 2: calculator-service-def456
  └─ Pod 3: calculator-service-ghi789
```

**If Pod 2 crashes**, Deployment automatically creates a new one!

### 3. Service
**What**: Load balancer for Pods  
**Does**: Provides stable IP/DNS, routes traffic  
**Think of it**: Internal load balancer

```yaml
Service: calculator-service
  └─ Routes traffic to any healthy Pod
     (Round-robin: Pod1 → Pod2 → Pod3 → Pod1...)
```

### 4. Namespace
**What**: Virtual cluster within cluster  
**Does**: Isolates resources  
**Think of it**: Folder for organizing resources

```yaml
Namespaces:
  ├─ default        (K8s default)
  ├─ kube-system    (K8s internals)
  └─ calculator     (Your app)
```

### 5. ConfigMap
**What**: Configuration data  
**Does**: Stores key-value pairs  
**Think of it**: .env file for Kubernetes

```yaml
ConfigMap: calculator-config
  └─ Data:
     ├─ log-level: INFO
     └─ feature.advanced-math: true
```

### 6. Ingress
**What**: HTTP(S) router  
**Does**: Routes external traffic to services  
**Think of it**: Reverse proxy

```yaml
Ingress: calculator-ingress
  └─ Rule: calculator.local → calculator-service
```

---

## 🔍 Hands-On Exercises

### Exercise 1: View Your Resources

```powershell
# See all resources
kubectl get all -n calculator

# Output:
# NAME                                     READY   STATUS    RESTARTS   AGE
# pod/calculator-service-abc123            1/1     Running   0          5m
# pod/calculator-service-def456            1/1     Running   0          5m
# pod/calculator-service-ghi789            1/1     Running   0          5m
# 
# NAME                         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
# service/calculator-service   LoadBalancer   10.96.100.50    <pending>     80:30001/TCP   5m
# 
# NAME                                 READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/calculator-service   3/3     3            3           5m
```

**Understand the output:**
- **3 Pods** running (replicas: 3)
- **1 Service** load balancing between them
- **1 Deployment** managing the Pods

---

### Exercise 2: Scale Your Application

**Scale UP to 5 replicas:**
```powershell
kubectl scale deployment calculator-service --replicas=5 -n calculator

# Watch it happen
kubectl get pods -n calculator --watch
```

**What happens:**
1. Kubernetes creates 2 more Pods
2. Waits for them to be Ready
3. Service automatically includes them in load balancing

**Scale DOWN to 1 replica:**
```powershell
kubectl scale deployment calculator-service --replicas=1 -n calculator
```

**What happens:**
1. Kubernetes gracefully stops 4 Pods
2. Keeps 1 running
3. Service routes all traffic to the remaining Pod

**Lesson**: Scaling is instant! No app changes needed.

---

### Exercise 3: See Logs

**From all Pods:**
```powershell
kubectl logs -l app=calculator-service -n calculator
```

**From a specific Pod:**
```powershell
# Get pod name first
kubectl get pods -n calculator

# Then view logs
kubectl logs calculator-service-abc123 -n calculator

# Follow logs (like tail -f)
kubectl logs -f calculator-service-abc123 -n calculator
```

---

### Exercise 4: Describe Resources

**Get detailed info:**
```powershell
# Describe a pod
kubectl describe pod calculator-service-abc123 -n calculator

# Describe the deployment
kubectl describe deployment calculator-service -n calculator

# Describe the service
kubectl describe service calculator-service -n calculator
```

**What you'll see:**
- Events (pod started, container created, etc.)
- Resource limits (CPU, memory)
- Health checks (liveness, readiness probes)
- Labels and selectors

---

### Exercise 5: Access Your App

**Method 1: Port Forward (Easiest)**
```powershell
kubectl port-forward -n calculator service/calculator-service 8080:80

# In another terminal or browser:
curl http://localhost:8080/actuator/health
```

**Method 2: Minikube Service**
```powershell
minikube service calculator-service -n calculator

# Opens browser automatically!
```

**Method 3: Get Service URL**
```powershell
minikube service calculator-service -n calculator --url

# Returns: http://192.168.49.2:30001
# Copy this URL and test it
```

---

### Exercise 6: Update Your App

**Build new version:**
```powershell
# Make a change to your code, then:
& minikube docker-env | Invoke-Expression
docker build -t calculator-service:v2 .
```

**Deploy the update:**
```powershell
kubectl set image deployment/calculator-service calculator-app=calculator-service:v2 -n calculator

# Watch the rolling update
kubectl rollout status deployment/calculator-service -n calculator
```

**What happens:**
1. K8s creates new Pods with v2
2. Waits for them to be Ready
3. Terminates old Pods
4. **Zero downtime!** 🎉

**Rollback if needed:**
```powershell
kubectl rollout undo deployment/calculator-service -n calculator
```

---

### Exercise 7: Check Health

**View health probes:**
```powershell
kubectl describe pod <pod-name> -n calculator | Select-String -Pattern "Liveness|Readiness"
```

**Simulate pod failure:**
```powershell
# Delete a pod
kubectl delete pod <pod-name> -n calculator

# Watch Deployment recreate it
kubectl get pods -n calculator --watch
```

**Lesson**: Kubernetes auto-heals! If a Pod dies, Deployment creates a new one.

---

### Exercise 8: Resource Usage

**Enable metrics:**
```powershell
minikube addons enable metrics-server

# Wait 30 seconds, then:
kubectl top nodes
kubectl top pods -n calculator
```

**Output:**
```
NAME                          CPU(cores)   MEMORY(bytes)
calculator-service-abc123     50m          256Mi
calculator-service-def456     45m          250Mi
calculator-service-ghi789     48m          255Mi
```

---

### Exercise 9: Exec into a Pod

**Get a shell inside a running Pod:**
```powershell
kubectl exec -it calculator-service-abc123 -n calculator -- /bin/sh

# Inside the pod:
# ls
# ps aux
# curl localhost:8080/actuator/health
# exit
```

---

### Exercise 10: View Events

**See what's happening:**
```powershell
kubectl get events -n calculator --sort-by='.lastTimestamp'
```

**Output:**
```
5m    Normal   Scheduled    Pod    Successfully assigned calculator/calculator-service-abc123
5m    Normal   Pulling      Pod    Pulling image "calculator-service:latest"
5m    Normal   Pulled       Pod    Successfully pulled image
5m    Normal   Created      Pod    Created container calculator-app
5m    Normal   Started      Pod    Started container calculator-app
```

---

## 🎯 Common Commands Cheat Sheet

### Viewing Resources
```powershell
kubectl get pods -n calculator                   # List pods
kubectl get deployments -n calculator            # List deployments
kubectl get services -n calculator               # List services
kubectl get all -n calculator                    # List everything
kubectl get pods --all-namespaces                # All namespaces
kubectl get pods -n calculator --watch           # Watch changes
```

### Describing Resources
```powershell
kubectl describe pod <pod-name> -n calculator
kubectl describe deployment calculator-service -n calculator
kubectl describe service calculator-service -n calculator
```

### Logs
```powershell
kubectl logs <pod-name> -n calculator                    # View logs
kubectl logs -f <pod-name> -n calculator                 # Follow logs
kubectl logs -l app=calculator-service -n calculator     # Logs from all pods
kubectl logs --previous <pod-name> -n calculator         # Previous container logs
```

### Scaling
```powershell
kubectl scale deployment calculator-service --replicas=5 -n calculator
kubectl autoscale deployment calculator-service --min=2 --max=10 --cpu-percent=80 -n calculator
```

### Updates
```powershell
kubectl set image deployment/calculator-service calculator-app=calculator-service:v2 -n calculator
kubectl rollout status deployment/calculator-service -n calculator
kubectl rollout history deployment/calculator-service -n calculator
kubectl rollout undo deployment/calculator-service -n calculator
```

### Debugging
```powershell
kubectl exec -it <pod-name> -n calculator -- /bin/sh    # Shell into pod
kubectl port-forward <pod-name> 8080:8080 -n calculator # Port forward
kubectl top pods -n calculator                          # Resource usage
kubectl get events -n calculator                        # Events
```

### Cleanup
```powershell
kubectl delete pod <pod-name> -n calculator              # Delete pod
kubectl delete deployment calculator-service -n calculator
kubectl delete service calculator-service -n calculator
kubectl delete namespace calculator                      # Delete everything
```

---

## 🐛 Troubleshooting

### Pod stuck in Pending
```powershell
kubectl describe pod <pod-name> -n calculator
# Look for: "Insufficient cpu" or "Insufficient memory"
# Solution: Reduce replicas or increase Minikube resources
```

### Pod CrashLoopBackOff
```powershell
kubectl logs <pod-name> -n calculator
kubectl logs --previous <pod-name> -n calculator
# Look for application errors in logs
```

### Can't access service
```powershell
# Check pods are running
kubectl get pods -n calculator

# Check service exists
kubectl get service -n calculator

# Use port-forward instead
kubectl port-forward -n calculator service/calculator-service 8080:80
```

### Image pull errors
```powershell
# Make sure to build in Minikube's Docker
& minikube docker-env | Invoke-Expression
docker build -t calculator-service:latest .

# Check imagePullPolicy is "Never" in deployment.yaml
```

---

## 📊 Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│               YOUR LAPTOP (Windows)                     │
│                                                         │
│  ┌───────────────────────────────────────────────────┐ │
│  │  MINIKUBE CLUSTER                                 │ │
│  │                                                   │ │
│  │  ┌─────────────────────────────────────────────┐ │ │
│  │  │  Namespace: calculator                      │ │ │
│  │  │                                             │ │ │
│  │  │  ┌────────────────────────────────────┐    │ │ │
│  │  │  │  Service: calculator-service       │    │ │ │
│  │  │  │  (Load Balancer)                   │    │ │ │
│  │  │  │  Port: 80                          │    │ │ │
│  │  │  └─────┬──────────────┬──────────┬────┘    │ │ │
│  │  │        │              │          │         │ │ │
│  │  │  ┌─────┴───┐    ┌─────┴───┐  ┌──┴──────┐  │ │ │
│  │  │  │  Pod 1  │    │  Pod 2  │  │  Pod 3  │  │ │ │
│  │  │  │         │    │         │  │         │  │ │ │
│  │  │  │ App:8080│    │ App:8080│  │ App:8080│  │ │ │
│  │  │  └─────────┘    └─────────┘  └─────────┘  │ │ │
│  │  │                                            │ │ │
│  │  │  Deployment: calculator-service            │ │ │
│  │  │  └─ Ensures 3 replicas are running         │ │ │
│  │  └─────────────────────────────────────────────┘ │ │
│  └───────────────────────────────────────────────────┘ │
│                                                         │
│  kubectl ────────┐                                      │
│  (You run commands) └──> Talks to Minikube cluster      │
└─────────────────────────────────────────────────────────┘

Traffic Flow:
  Browser → Minikube Service (LoadBalancer)
         → Service (Internal LB)
         → One of 3 Pods (Round-robin)
         → Container port 8080
         → Your app responds
```

---

## 🎓 Key Learnings

### 1. Declarative Configuration
You describe **what you want** (YAML), K8s makes it happen.
```yaml
# You say: "I want 3 replicas"
replicas: 3

# Kubernetes ensures 3 are always running
```

### 2. Self-Healing
K8s automatically replaces failed Pods.
```
Pod 2 crashes → Deployment detects → Creates new Pod 4
```

### 3. Load Balancing
Service distributes traffic evenly.
```
Request 1 → Pod 1
Request 2 → Pod 2
Request 3 → Pod 3
Request 4 → Pod 1 (round-robin)
```

### 4. Rolling Updates
Update with zero downtime.
```
Old Pods: [v1, v1, v1]
Update:   [v1, v1, v2]  ← Create new pod
         [v1, v2, v2]  ← Terminate old, create new
         [v2, v2, v2]  ← Done!
```

### 5. Scalability
Scale with one command.
```powershell
kubectl scale deployment calculator-service --replicas=100 -n calculator
# Done! 🚀
```

---

## 🏆 Phase 2 Complete Checklist

Mark these off as you complete them:

- [ ] Install kubectl and Minikube
- [ ] Start Minikube cluster
- [ ] Deploy calculator service
- [ ] View pods, deployments, services
- [ ] Scale application (up and down)
- [ ] View logs from pods
- [ ] Access service via port-forward
- [ ] Access service via Minikube service
- [ ] Update application (rolling update)
- [ ] Rollback an update
- [ ] Delete a pod and watch it recreate
- [ ] View resource usage (kubectl top)
- [ ] Exec into a pod
- [ ] View Kubernetes dashboard
- [ ] Understand all 6 core concepts

---

## 🎯 Next Phase Preview

**Phase 3: Create 2nd Microservice (User Service)**

You'll create:
```
calculator-service (Port 8080)  ← You have this!
user-service (Port 8081)        ← Next!
```

Then both will run in Kubernetes:
```
Namespace: microservices
  ├─ calculator-service (3 replicas)
  └─ user-service (2 replicas)
```

Ready to move to Phase 3? 🚀

---

## 📚 Additional Resources

### Official Docs
- **Kubernetes Basics**: https://kubernetes.io/docs/tutorials/kubernetes-basics/
- **kubectl Cheat Sheet**: https://kubernetes.io/docs/reference/kubectl/cheatsheet/
- **Minikube Docs**: https://minikube.sigs.k8s.io/docs/

### Interactive Learning
- **Play with Kubernetes**: https://labs.play-with-k8s.com/
- **Katacoda K8s**: https://www.katacoda.com/courses/kubernetes

### Videos
- **Kubernetes in 5 Minutes**: https://www.youtube.com/watch?v=PH-2FfFD2PU
- **Complete K8s Course**: https://www.youtube.com/watch?v=X48VuDVv0do

---

**Happy Learning! You're crushing it! 💪🎉**
