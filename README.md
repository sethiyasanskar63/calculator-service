# Calculator Microservice

A production-ready Spring Boot microservice for basic arithmetic operations.

## 🎯 Learning Journey

This project is part of a **6-phase microservices learning journey**:

- ✅ **Phase 1:** Docker & Containerization
- 🚀 **Phase 2:** Kubernetes (IN PROGRESS)
- ⏸️ **Phase 3:** Second Microservice
- ⏸️ **Phase 4:** Spring Cloud Gateway
- ⏸️ **Phase 5:** Service Discovery
- ⏸️ **Phase 6:** Monitoring & Tracing

📖 **See:** `PROGRESS.md` for detailed tracking  
📚 **Current:** `PHASE2-KUBERNETES-TUTORIAL.md`

---

## 🌐 Live Demo

- **API**: https://calculator-service-production.up.railway.app
- **Swagger UI**: https://calculator-service-production.up.railway.app/swagger-ui.html

---

## 🛠️ Tech Stack

- **Java 21** (Eclipse Temurin)
- **Spring Boot 3.4.0**
- **Maven** (build tool)
- **Docker** (containerization)
- **Kubernetes** (orchestration) 🆕
- **Railway** (hosting)
- **GitHub Actions** (CI/CD)

---

## 📡 API Usage

### Health Check
```bash
curl https://calculator-service-production.up.railway.app/api/calculator/health
```

### Calculate
```bash
curl -X POST https://calculator-service-production.up.railway.app/api/calculator/calculate \
  -H "Content-Type: application/json" \
  -d "{
    \"number1\": 10,
    \"number2\": 5,
    \"operation\": \"+\"
  }"
```

**Operations**: `+`, `-`, `*`, `/`

---

## 💻 Local Development

### Prerequisites
- Java 21
- Maven 3.8+

### Run Locally
```bash
# Build
./mvnw clean package

# Run
./mvnw spring-boot:run

# Test
./mvnw test
```

Application runs at: `http://localhost:8080`

---

## 🐋 Docker

```bash
# Build
docker build -t calculator-service .

# Run
docker run -p 8080:8080 calculator-service

# Or use Docker Compose
docker-compose up
```

---

## ☸️ Kubernetes (Phase 2) 🆕

### Quick Start (All-in-One)
```powershell
# Automated setup (runs all 4 steps)
.\quickstart.ps1
```

### Manual Steps
```powershell
# 1. Setup (installs kubectl, minikube)
.\scripts\k8s-setup.ps1

# 2. Start Minikube cluster
.\scripts\k8s-start.ps1

# 3. Deploy to Kubernetes
.\scripts\k8s-deploy.ps1

# 4. Test deployment
.\scripts\k8s-test.ps1
```

### Access Your Service
```powershell
# Method 1: Port forward
kubectl port-forward -n calculator service/calculator-service 8080:80

# Method 2: Get Minikube URL
minikube service calculator-service -n calculator --url

# Method 3: Dashboard
minikube dashboard
```

### Scale Your App
```powershell
# Scale to 5 replicas
kubectl scale deployment calculator-service --replicas=5 -n calculator

# View pods
kubectl get pods -n calculator
```

### Cleanup
```powershell
.\scripts\k8s-cleanup.ps1
```

📚 **Full Tutorial:** `docs/PHASE2-KUBERNETES-TUTORIAL.md`  
📋 **Quick Reference:** `docs/PHASE2-QUICK-REFERENCE.md`

---

## 🧪 Testing

Run all tests with PowerShell:
```powershell
.\scripts\test-deployment.ps1
```

---

## 🚀 CI/CD Pipeline

Pipeline includes:
- ✅ Build & Test (Java 21)
- ✅ Docker Build & Push
- ✅ Security Scan (OWASP)
- ✅ Auto-deploy to Railway

---

## 📁 Project Structure

```
.
├── src/                         # Source code
│   ├── main/java/              # Application code
│   └── test/java/              # Tests
│
├── config/                      # Configuration files
│   ├── k8s/                    # Kubernetes manifests
│   │   ├── deployment.yaml     # App deployment
│   │   ├── namespace.yaml      # Isolated environment
│   │   ├── configmap.yaml      # Configuration
│   │   └── ingress.yaml        # HTTP routing
│   ├── helm-chart/             # Helm charts
│   ├── Dockerfile              # Docker configuration
│   ├── docker-compose.yml      # Multi-container setup
│   └── .dockerignore           # Docker ignore rules
│
├── scripts/                     # Automation scripts
│   ├── k8s-setup.ps1           # Setup kubectl & Minikube
│   ├── k8s-start.ps1           # Start Minikube cluster
│   ├── k8s-deploy.ps1          # Deploy to Kubernetes
│   ├── k8s-test.ps1            # Test deployment
│   ├── k8s-cleanup.ps1         # Cleanup resources
│   ├── test-deployment.ps1     # Test Docker deployment
│   └── check-status.ps1        # Check service status
│
├── docs/                        # Documentation
│   ├── PHASE2-KUBERNETES-TUTORIAL.md
│   ├── PHASE2-QUICK-REFERENCE.md
│   ├── PHASE2-SETUP-COMPLETE.md
│   ├── PROGRESS.md
│   ├── MICROSERVICES-ARCHITECTURE.md
│   ├── HELM-GUIDE.md
│   ├── K8S-LOCAL-GUIDE.md
│   ├── SPRING-CLOUD-GATEWAY-GUIDE.md
│   └── SPRING-VS-K8S-CHEATSHEET.md
│
├── .github/                     # GitHub configuration
│   └── workflows/              # CI/CD pipelines
│       └── ci-cd.yml
│
├── pom.xml                      # Maven dependencies
└── README.md                    # This file
```

---

## 📚 Documentation

- **Architecture:** `docs/MICROSERVICES-ARCHITECTURE.md`
- **Kubernetes Tutorial:** `docs/PHASE2-KUBERNETES-TUTORIAL.md` 🆕
- **Quick Reference:** `docs/PHASE2-QUICK-REFERENCE.md` 🆕
- **Progress Tracker:** `docs/PROGRESS.md` 🆕
- **Helm Guide:** `docs/HELM-GUIDE.md`
- **Local K8s:** `docs/K8S-LOCAL-GUIDE.md`

---

## 🎓 Learning Resources

This project demonstrates:
- ✅ RESTful API design
- ✅ Spring Boot best practices
- ✅ Docker containerization
- ✅ Docker Compose orchestration
- 🚀 Kubernetes deployment (Phase 2)
- 🚀 Scaling & load balancing
- 🚀 Zero-downtime updates
- ⏸️ Microservices architecture (Phases 3-6)

---

## 📝 License

MIT
